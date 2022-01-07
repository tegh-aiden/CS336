-- Triggers, Procedures and Events for CS336 AuctionSite Project.
USE AuctionSite;

-- Triggers and Procedures for bid validation and automatic bidding.
-- 1 Trigger for bid validation.
-- 2 Procedures for automatic bidding.

-- Trigger for bid validation, setting options and sending message to other bidders before a new bid is placed.
DROP TRIGGER IF EXISTS NewBid;
DELIMITER //
CREATE TRIGGER NewBid 
BEFORE INSERT ON PlacesBid
    FOR EACH ROW
BEGIN

    -- Declare local variables to store query results for future use.

    DECLARE shb_bid_value DECIMAL(20, 2) DEFAULT 0;

    DECLARE seller_bid BOOLEAN DEFAULT TRUE;
    DECLARE closed_auction BOOLEAN DEFAULT TRUE;    
    DECLARE auction_bid_increment DECIMAL(20, 2) DEFAULT 0;  

    -- Find the auction bid increment set by the seller.

    SELECT a.minimum_bid_increment,
           IFNULL(a.seller_login_id = NEW.bidder_login_id, TRUE),
           IFNULL(CURRENT_TIMESTAMP >= a.closing_date_time, TRUE)
    INTO auction_bid_increment,
         seller_bid,
         closed_auction
    FROM AuctionSellsBuys a
    WHERE a.auction_id = NEW.auction_id;

    -- Find the highest bid value in bid history for the given auction id.

    SELECT MAX(p.bid_value)
    INTO shb_bid_value
    FROM PlacesBid p
    WHERE p.auction_id = NEW.auction_id;

    -- Check if bid value is valid and Auction is open if not send error.

    IF (NEW.bid_value < (shb_bid_value + auction_bid_increment) 
        OR closed_auction
        OR seller_bid)
    THEN
        BEGIN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Illegal Bid';
        END;
    
    -- Check if bidder has Options set if not INSERT in SetOptions.

    ELSEIF (NOT EXISTS (SELECT * 
                        FROM SetOptions s
                        WHERE s.auction_id = NEW.auction_id
                              AND s.bidder_login_id = NEW.bidder_login_id))
    THEN
        INSERT INTO SetOptions (bidder_login_id, auction_id)
        VALUES (NEW.bidder_login_id, NEW.auction_id);
    END IF;

    -- Send messages to all other bidder login ids.

    INSERT INTO GetsMessage (user_login_id, message_type, message_text)
    SELECT DISTINCT ob.bidder_login_id, 
                    'bid', 
                    CONCAT('A higher bid has been placed on auction - ', NEW.auction_id)
    FROM PlacesBid ob
    WHERE ob.bidder_login_id <> NEW.bidder_login_id
          AND ob.auction_id = NEW.auction_id;

    -- Send messages to all AutoBidder login ids.

    INSERT INTO GetsMessage (user_login_id, message_type, message_text)
    SELECT DISTINCT os.bidder_login_id, 
                    'autobid', 
                    CONCAT('A bid exceeding your AutoBidding upper limit has been placed on auction - ', NEW.auction_id)
    FROM SetOptions os
    WHERE os.bidder_login_id <> NEW.bidder_login_id
          AND os.auction_id = NEW.auction_id
          AND os.auto_bidding = TRUE
          AND os.upper_limit < auction_bid_increment + NEW.bid_value;    
END; //
DELIMITER ; 



-- Procedure for placing Auto Bid.
DROP PROCEDURE IF EXISTS PlaceAutoBid;
DELIMITER //
CREATE PROCEDURE PlaceAutoBid (IN auto_bid_auction_id INT)
autobidding: BEGIN    

    -- Declare local variables to store query results for future use.

    DECLARE shb_login_id VARCHAR(30) DEFAULT NULL;
    DECLARE shb_bid_value DECIMAL(20, 2) DEFAULT 0;

    DECLARE hab_login_id VARCHAR(30) DEFAULT NULL;
    DECLARE hab_bid_value DECIMAL(20, 2) DEFAULT 0;
    
    DECLARE hup_bid_increment DECIMAL(20, 2) DEFAULT 0;
    DECLARE hup_upper_limit DECIMAL(20, 2) DEFAULT 0;

    DECLARE shup_upper_limit DECIMAL(20, 2) DEFAULT 0;

    DECLARE auction_bid_increment DECIMAL(20, 2) DEFAULT 0;  

    -- Find the auction bid increment set by the seller.

    SELECT a.minimum_bid_increment
    INTO auction_bid_increment
    FROM AuctionSellsBuys a
    WHERE a.auction_id = auto_bid_auction_id;
    
    -- Find the highest bidder and highest bid value in bid history for the given auction id.

    SELECT p.bidder_login_id, 
           p.bid_value
    INTO shb_login_id,
         shb_bid_value
    FROM PlacesBid p
    WHERE p.auction_id = auto_bid_auction_id
    ORDER BY p.bid_value DESC
    LIMIT 1;

    -- Find the highest upper limit and corresponding AutoBidder and auto bid increment amongst all AutoBidders for the given auction id.

    SELECT s.bidder_login_id,
           s.auto_bidding_increment,
           s.upper_limit
    INTO hab_login_id,
         hup_bid_increment,
         hup_upper_limit
    FROM SetOptions s
    WHERE s.auction_id = auto_bid_auction_id
          AND IFNULL(s.bidder_login_id <> shb_login_id, TRUE)
          AND s.auto_bidding = TRUE
          AND s.upper_limit >= auction_bid_increment + shb_bid_value
    ORDER BY s.upper_limit DESC
    LIMIT 1;

    -- Find the second highest upper limit and corresponding AutoBidder amongst all AutoBidders for the given auction id.

    SELECT s.upper_limit
    INTO shup_upper_limit
    FROM SetOptions s
    WHERE s.auction_id = auto_bid_auction_id
          AND IFNULL(s.bidder_login_id <> shb_login_id, TRUE)
          AND s.bidder_login_id <> hab_login_id
          AND s.auto_bidding = TRUE
          AND s.upper_limit >= auction_bid_increment + shb_bid_value              
    ORDER BY s.upper_limit DESC
    LIMIT 1;

    -- Set the new highest bid value based on whether the second highest upper limit is zero (atmost 1 valid bidder left)
    -- or not.
                                  
    IF (shup_upper_limit = 0)
    THEN
        SET hab_bid_value := IF(shb_bid_value + hup_bid_increment <= hup_upper_limit, shb_bid_value + hup_bid_increment, hup_upper_limit);
    ELSE
        SET hab_bid_value := IF(shup_upper_limit + hup_bid_increment <= hup_upper_limit, shup_upper_limit + hup_bid_increment, hup_upper_limit);
    END IF;

    -- Check that the above found AutoBidder login id with the highest new auto bid value is not NULL
    -- and that the Auction is open if so then for the above found AutoBidder login id with the highest new auto bid value
    -- insert a new bid.
    
    IF (hab_login_id IS NOT NULL
        AND CURRENT_TIMESTAMP < (SELECT a.closing_date_time
                                 FROM AuctionSellsBuys a
                                 WHERE a.auction_id = auto_bid_auction_id)
        AND hab_bid_value >= auction_bid_increment + shb_bid_value)
    THEN
        INSERT INTO PlacesBid (bidder_login_id, auction_id, bid_value) 
        VALUES (hab_login_id, auto_bid_auction_id, hab_bid_value);
    END IF;    
END; //
DELIMITER ;



-- Procedure for recursively Auto-Bidding.
DROP PROCEDURE IF EXISTS AutoBid;
DELIMITER //
CREATE PROCEDURE AutoBid (IN auto_bid_auction_id INT)
BEGIN
    -- Declare local variables to store query results for future use.

    DECLARE shb_login_id VARCHAR(30) DEFAULT NULL;
    DECLARE shb_bid_value DECIMAL(20, 2) DEFAULT 0;

    DECLARE ab_count INT DEFAULT 1;

    DECLARE auction_bid_increment DECIMAL(20, 2) DEFAULT 0;  

    -- Find the auction bid increment set by the seller.

    SELECT a.minimum_bid_increment
    INTO auction_bid_increment
    FROM AuctionSellsBuys a
    WHERE a.auction_id = auto_bid_auction_id;

    WHILE ab_count <> 0 DO
    
        -- Call the procedure to perform Auto-Bidding.

        CALL PlaceAutoBid(auto_bid_auction_id);

        -- Call the procedure to remove Auto-Bidding of all bidders who lost bidding race.

        CALL RemoveAutoBidding(auto_bid_auction_id);
        -- Reset ab_count to 0.

        SET ab_count := 0;

        -- Find the highest bidder and highest bid value in bid history for the given auction id.

        SELECT p.bidder_login_id, 
               p.bid_value
        INTO shb_login_id,
             shb_bid_value
        FROM PlacesBid p
        WHERE p.auction_id = auto_bid_auction_id
        ORDER BY p.bid_value DESC
        LIMIT 1;

        -- Find the number of AutoBidders not including the current highest bidder.
    
        SELECT COUNT(s.bidder_login_id)
        INTO ab_count
        FROM SetOptions s
        WHERE s.auction_id = auto_bid_auction_id
              AND IFNULL(s.bidder_login_id <> shb_login_id, TRUE)
              AND s.upper_limit >= auction_bid_increment + shb_bid_value
              AND s.auto_bidding = TRUE;
    END WHILE;  

END; //
DELIMITER ;




-- Extra Triggers and Procedures related to bids, bid options and auction creation.
-- 1 Trigger to delete options if all bids for the bidder on given auction are deleted.
-- 1 Trigger to set defaults before bid options is created.
-- 1 Trigger to set defaults before bid options is updated.
-- 1 Trigger to set defaults before auction is created.
-- 1 Procedure for removing the Auto-Bidding of a bidder who's upper limit has been reached or exceeded.

-- Trigger to delete options if all bids for the bidder on given auction are deleted.
DROP TRIGGER IF EXISTS DeleteOptions;
DELIMITER //
CREATE TRIGGER DeleteOptions
AFTER DELETE ON PlacesBid
    FOR EACH ROW
BEGIN
    
    -- Check if other bids on this auction placed by this bidder exist
    -- if not delete the this bidder's bid options for this auction.
    
    IF (NOT EXISTS (SELECT *
                    FROM PlacesBid pb
                    WHERE pb.auction_id = OLD.auction_id
                          AND pb.bidder_login_id = OLD.bidder_login_id))
    THEN
        DELETE FROM SetOptions s 
        WHERE s.auction_id = OLD.auction_id
              AND s.bidder_login_id = OLD.bidder_login_id;
    END IF;
END; //
DELIMITER ;



-- Trigger to set defaults before bid options is created
DROP TRIGGER IF EXISTS BidOptionsSetDefaultOnCreation;
DELIMITER //
CREATE TRIGGER BidOptionsSetDefaultOnCreation
BEFORE INSERT ON SetOptions
    FOR EACH ROW
BEGIN

    -- Declare local variable for future use.

    DECLARE default_bid_increment DECIMAL(20, 2) DEFAULT 0;

    -- Check if bidder login id is not that of the seller and is valid.

    IF (NEW.bidder_login_id = (SELECT asb.seller_login_id
                               FROM AuctionSellsBuys asb
                               WHERE asb.auction_id = NEW.auction_id)
        OR 'user' <> (SELECT a.permissions_class
                      FROM Account a
                      WHERE a.login_id = NEW.bidder_login_id))
    THEN
        BEGIN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Illegal Bidder';
        END;
    END IF;    

    -- Find the minimum bid increment of the given auction.
    
    SELECT a.minimum_bid_increment
    INTO default_bid_increment
    FROM AuctionSellsBuys a
    WHERE a.auction_id = NEW.auction_id;

    -- Check if the new auto bidding increment is less than the default bid increment
    -- if so then set the new auto bidding increment as the default bid increment.    

    IF (IFNULL(NEW.auto_bidding_increment, 0) < default_bid_increment OR IFNULL(NEW.auto_bidding = FALSE, TRUE))
    THEN
        SET NEW.auto_bidding_increment := default_bid_increment;
    END IF;
END; //
DELIMITER ;



-- Trigger to set defaults before bid options is updated.
DROP TRIGGER IF EXISTS BidOptionsSetDefaultOnUpdate;
DELIMITER //
CREATE TRIGGER BidOptionsSetDefaultOnUpdate
BEFORE UPDATE ON SetOptions
    FOR EACH ROW
BEGIN
    
    -- Declare local variable for future use.

    DECLARE default_bid_increment DECIMAL(20, 2) DEFAULT 0;

    -- Find the minimum bid increment of the given auction.

    SELECT a.minimum_bid_increment
    INTO default_bid_increment
    FROM AuctionSellsBuys a
    WHERE a.auction_id = NEW.auction_id;

    -- Check if the new auto bidding increment is less than the default bid increment
    -- if so then set the new auto bidding increment as the default bid increment.

    IF (IFNULL(NEW.auto_bidding_increment, OLD.auto_bidding_increment) < default_bid_increment OR IFNULL(NEW.auto_bidding = FALSE, TRUE))
    THEN
        SET NEW.auto_bidding_increment := default_bid_increment;
    END IF;
END; //
DELIMITER ;



-- Trigger to set defaults before auction is created.
DROP TRIGGER IF EXISTS AuctionSetDefaultOnCreation;
DELIMITER //
CREATE TRIGGER AuctionSetDefaultOnCreation
BEFORE INSERT ON AuctionSellsBuys
    FOR EACH ROW
BEGIN
    
    -- Check if seller login id is valid if not send error.

    IF (NEW.seller_login_id IS NULL
        OR 'user' <> (SELECT a.permissions_class
                      FROM Account a
                      WHERE a.login_id = NEW.seller_login_id))
    THEN
        BEGIN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Illegal Auction -- No Seller';
        END;
    END IF;

    -- If the minimum bid increment is not positive then set it to 0.01.

    IF (IFNULL(NEW.minimum_bid_increment, 0) <= 0)
    THEN
        SET NEW.minimum_bid_increment := 0.01;
    END IF;

    -- If the secret minimum price is not positive then set it to 0.01.

    IF (IFNULL(NEW.secret_minimum_price, 0) <= 0)
    THEN
        SET NEW.secret_minimum_price := 0.01;
    END IF;

    -- Set the buyer login id as NULL.

    SET NEW.buyer_login_id := NULL;

    -- Set the selling price as 0.

    SET NEW.price := 0;  
END; //
DELIMITER ; 



-- Procedure for removing the Auto-Bidding of bidders with their upper limit reached or exceeded.
DROP PROCEDURE IF EXISTS RemoveAutoBidding;
DELIMITER //
CREATE PROCEDURE RemoveAutoBidding (IN auto_bid_auction_id INT)
BEGIN  
    -- Declare local variables to store query results for future use.

    DECLARE shb_login_id VARCHAR(30) DEFAULT NULL;
    DECLARE shb_bid_value DECIMAL(20, 2) DEFAULT 0;
 
    DECLARE auction_bid_increment DECIMAL(20, 2) DEFAULT 0;  

    -- Find the auction bid increment set by the seller.

    SELECT a.minimum_bid_increment
    INTO auction_bid_increment
    FROM AuctionSellsBuys a
    WHERE a.auction_id = auto_bid_auction_id;

    -- Find the highest bidder and highest bid value in bid history for the given auction id.

    SELECT p.bidder_login_id, 
           p.bid_value
    INTO shb_login_id,
         shb_bid_value
    FROM PlacesBid p
    WHERE p.auction_id = auto_bid_auction_id
    ORDER BY p.bid_value DESC
    LIMIT 1; 

    -- Disable Auto-Bidding for all bidders who's upper limit has been reached or exceeded.

    UPDATE SetOptions s
    SET s.auto_bidding = FALSE
    WHERE s.auction_id = auto_bid_auction_id
          AND IFNULL(s.bidder_login_id <> shb_login_id, TRUE)
          AND s.upper_limit < auction_bid_increment + shb_bid_value 
          AND s.auto_bidding = TRUE;
END; //
DELIMITER ; 




-- Triggers for Sending alerts on availability of wish apparels.
-- 4 Triggers after creating new wish apparel.
-- 1 Trigger after creating new auction.

-- Trigger to send message when a new wish apparel (category NULL) is created which matches an ongoing auction.
DROP TRIGGER IF EXISTS MessageOnCreateWishApparel;
DELIMITER //
CREATE TRIGGER MessageOnCreateWishApparel
AFTER INSERT ON AlertForWishApparel
    FOR EACH ROW
BEGIN

    -- Send message to user who created a new wish apparel (category NULL)
    -- if there is a matching ongoing auction.

    IF (NEW.category IS NULL)
    THEN
        INSERT INTO GetsMessage (user_login_id, message_type, message_text)
            SELECT NEW.user_login_id, 
                   'wish', 
                   CONCAT('Your wish apparel is now available on auction - ', na.auction_id)
            FROM (SELECT *
                  FROM AuctionSellsBuys asb
                  JOIN Apparel a USING (item_id)
                  WHERE asb.closing_date_time > CURRENT_TIMESTAMP()
                        AND asb.seller_login_id <> NEW.user_login_id) na
            WHERE IFNULL(NEW.brand = na.brand, TRUE)
                  AND IFNULL(NEW.age_group = na.age_group, TRUE)
                  AND IFNULL(NEW.color = na.color, TRUE)
                  AND IFNULL(NEW.season = na.season, TRUE)
                  AND IFNULL(NEW.gender = na.gender, TRUE)
                  AND IFNULL(NEW.material = na.material, TRUE);   
    END IF; 
END; //
DELIMITER ;



-- Trigger to send message when a new wish apparel (category 'bottoms') is created which matches an ongoing auction.
DROP TRIGGER IF EXISTS MessageOnCreateWishApparelBottoms;
DELIMITER //
CREATE TRIGGER MessageOnCreateWishApparelBottoms
AFTER INSERT ON WishApparelBottoms
    FOR EACH ROW
BEGIN

    -- Send message to user who created a new wish apparel (category 'bottoms')
    -- if there is a matching ongoing auction.

    INSERT INTO GetsMessage (user_login_id, message_type, message_text)
        SELECT NEW.user_login_id, 
               'wish', 
               CONCAT('Your wish apparel is now available on auction - ', na.auction_id)
        FROM (SELECT * 
              FROM AlertForWishApparel w
              WHERE w.user_login_id = NEW.user_login_id
                    AND w.wish_id = NEW.wish_id) wa,
             (SELECT *
              FROM AuctionSellsBuys asb
              JOIN Apparel a USING (item_id)
              JOIN Bottoms b USING (item_id)
              WHERE asb.closing_date_time > CURRENT_TIMESTAMP()
                    AND asb.seller_login_id <> NEW.user_login_id) na
        WHERE IFNULL(wa.brand = na.brand, TRUE)
              AND IFNULL(wa.age_group = na.age_group, TRUE)
              AND IFNULL(wa.color = na.color, TRUE)
              AND IFNULL(wa.season = na.season, TRUE)
              AND IFNULL(wa.gender = na.gender, TRUE)
              AND IFNULL(wa.material = na.material, TRUE)
              AND IFNULL(NEW.waist_size = na.waist_size, TRUE)
              AND IFNULL(NEW.length = na.length, TRUE);    
END; //
DELIMITER ;



-- Trigger to send message when a new wish apparel (category 'footwear') is created which matches an ongoing auction.
DROP TRIGGER IF EXISTS MessageOnCreateWishApparelFootwear;
DELIMITER //
CREATE TRIGGER MessageOnCreateWishApparelFootwear
AFTER INSERT ON WishApparelFootwear
    FOR EACH ROW
BEGIN
 
    -- Send message to user who created a new wish apparel (category 'footwear')
    -- if there is a matching ongoing auction.

    INSERT INTO GetsMessage (user_login_id, message_type, message_text)
        SELECT NEW.user_login_id, 
               'wish', 
               CONCAT('Your wish apparel is now available on auction - ', na.auction_id)
        FROM (SELECT * 
              FROM AlertForWishApparel w
              WHERE w.user_login_id = NEW.user_login_id
                    AND w.wish_id = NEW.wish_id) wa,
             (SELECT *
              FROM AuctionSellsBuys asb
              JOIN Apparel a USING (item_id)
              JOIN Footwear f USING (item_id)
              WHERE asb.closing_date_time > CURRENT_TIMESTAMP()
                    AND asb.seller_login_id <> NEW.user_login_id) na
        WHERE IFNULL(wa.brand = na.brand, TRUE)
              AND IFNULL(wa.age_group = na.age_group, TRUE)
              AND IFNULL(wa.color = na.color, TRUE)
              AND IFNULL(wa.season = na.season, TRUE)
              AND IFNULL(wa.gender = na.gender, TRUE)
              AND IFNULL(wa.material = na.material, TRUE)
              AND IFNULL(NEW.size = na.size, TRUE)
              AND IFNULL(NEW.type = na.type, TRUE);   
END; //
DELIMITER ;



-- Trigger to send message when a new wish apparel (category 'tops') is created which matches an ongoing auction.
DROP TRIGGER IF EXISTS MessageOnCreateWishApparelTops;
DELIMITER //
CREATE TRIGGER MessageOnCreateWishApparelTops
AFTER INSERT ON WishApparelTops
    FOR EACH ROW
BEGIN
 
    -- Send message to user who created a new wish apparel (category 'tops')
    -- if there is a matching ongoing auction.

    INSERT INTO GetsMessage (user_login_id, message_type, message_text)
        SELECT NEW.user_login_id, 
               'wish', 
               CONCAT('Your wish apparel is now available on auction - ', na.auction_id)
        FROM (SELECT * 
              FROM AlertForWishApparel w
              WHERE w.user_login_id = NEW.user_login_id
                    AND w.wish_id = NEW.wish_id) wa,
             (SELECT *
              FROM AuctionSellsBuys asb
              JOIN Apparel a USING (item_id)
              JOIN Tops t USING (item_id)
              WHERE asb.closing_date_time > CURRENT_TIMESTAMP()
                    AND asb.seller_login_id <> NEW.user_login_id) na
        WHERE IFNULL(wa.brand = na.brand, TRUE)
              AND IFNULL(wa.age_group = na.age_group, TRUE)
              AND IFNULL(wa.color = na.color, TRUE)
              AND IFNULL(wa.season = na.season, TRUE)
              AND IFNULL(wa.gender = na.gender, TRUE)
              AND IFNULL(wa.material = na.material, TRUE)
              AND IFNULL(NEW.size_group = na.size_group, TRUE)
              AND IFNULL(NEW.sleeve_length = na.sleeve_length, TRUE);
END; //
DELIMITER ;



-- Trigger to send message when auction with a wish apparel starts.
DROP TRIGGER IF EXISTS MessageOnWishApparelAuctionStart;
DELIMITER //
CREATE TRIGGER MessageOnWishApparelAuctionStart
AFTER INSERT ON AuctionSellsBuys
    FOR EACH ROW
BEGIN
 
    -- Declare local variables for future use.

    DECLARE new_item_category VARCHAR(20);

    -- Find the category of the item placed on new auction.

    SELECT a.category
    INTO new_item_category
    FROM Apparel a
    WHERE a.item_id = NEW.item_id;

    -- Send message to all users with wish apparel category as bottoms
    -- and with any matching features.

    IF (new_item_category = 'bottoms')
    THEN
        INSERT INTO GetsMessage (user_login_id, message_type, message_text)
        SELECT wa.user_login_id, 
               'wish', 
               CONCAT('Your wish apparel is now available on auction - ', NEW.auction_id)
        FROM (SELECT * 
              FROM AlertForWishApparel w
              JOIN WishApparelBottoms bw USING (user_login_id, wish_id)
              WHERE w.user_login_id <> NEW.seller_login_id) wa,
             (SELECT *
              FROM Apparel a
              JOIN Bottoms b USING (item_id)
              WHERE a.item_id = NEW.item_id) na
        WHERE IFNULL(wa.brand = na.brand, TRUE)
              AND IFNULL(wa.age_group = na.age_group, TRUE)
              AND IFNULL(wa.color = na.color, TRUE)
              AND IFNULL(wa.season = na.season, TRUE)
              AND IFNULL(wa.gender = na.gender, TRUE)
              AND IFNULL(wa.material = na.material, TRUE)
              AND IFNULL(wa.waist_size = na.waist_size, TRUE)
              AND IFNULL(wa.length = na.length, TRUE);

    -- Send message to all users with wish apparel category as footwear
    -- and with any matching features.

    ELSEIF (new_item_category = 'footwear')
    THEN
        INSERT INTO GetsMessage (user_login_id, message_type, message_text)
        SELECT wa.user_login_id, 
               'wish', 
               CONCAT('Your wish apparel is now available on auction - ', NEW.auction_id)
        FROM (SELECT * 
              FROM AlertForWishApparel w
              JOIN WishApparelFootwear fw USING (user_login_id, wish_id)
              WHERE w.user_login_id <> NEW.seller_login_id) wa,
             (SELECT *
              FROM Apparel a
              JOIN Footwear f USING (item_id)
              WHERE a.item_id = NEW.item_id) na
        WHERE IFNULL(wa.brand = na.brand, TRUE)
              AND IFNULL(wa.age_group = na.age_group, TRUE)
              AND IFNULL(wa.color = na.color, TRUE)
              AND IFNULL(wa.season = na.season, TRUE)
              AND IFNULL(wa.gender = na.gender, TRUE)
              AND IFNULL(wa.material = na.material, TRUE)
              AND IFNULL(wa.size = na.size, TRUE)
              AND IFNULL(wa.type = na.type, TRUE);

    -- Send message to all users with wish apparel category as tops
    -- and with any matching features.

    ELSEIF (new_item_category = 'tops')
    THEN
        INSERT INTO GetsMessage (user_login_id, message_type, message_text)
        SELECT wa.user_login_id, 
               'wish', 
               CONCAT('Your wish apparel is now available on auction - ', NEW.auction_id)
        FROM (SELECT * 
              FROM AlertForWishApparel w
              JOIN WishApparelTops tw USING (user_login_id, wish_id)
              WHERE w.user_login_id <> NEW.seller_login_id) wa,
             (SELECT *
              FROM Apparel a
              JOIN Tops t USING (item_id)
              WHERE a.item_id = NEW.item_id) na
        WHERE IFNULL(wa.brand = na.brand, TRUE)
              AND IFNULL(wa.age_group = na.age_group, TRUE)
              AND IFNULL(wa.color = na.color, TRUE)
              AND IFNULL(wa.season = na.season, TRUE)
              AND IFNULL(wa.gender = na.gender, TRUE)
              AND IFNULL(wa.material = na.material, TRUE)
              AND IFNULL(wa.size_group = na.size_group, TRUE)
              AND IFNULL(wa.sleeve_length = na.sleeve_length, TRUE); 
    END IF;

    -- Send message to all users with wish apparel category as NULL
    -- and with any matching features.    

    INSERT INTO GetsMessage (user_login_id, message_type, message_text)
    SELECT wa.user_login_id, 
           'wish', 
           CONCAT('Your wish apparel is now available on auction - ', NEW.auction_id)
    FROM (SELECT * 
          FROM AlertForWishApparel w
          WHERE w.user_login_id <> NEW.seller_login_id
                AND w.category IS NULL) wa,
         (SELECT *
          FROM Apparel a
          WHERE a.item_id = NEW.item_id) na
    WHERE IFNULL(wa.brand = na.brand, TRUE)
          AND IFNULL(wa.age_group = na.age_group, TRUE)
          AND IFNULL(wa.color = na.color, TRUE)
          AND IFNULL(wa.season = na.season, TRUE)
          AND IFNULL(wa.gender = na.gender, TRUE)
          AND IFNULL(wa.material = na.material, TRUE);        
END; //
DELIMITER ; 




-- Triggers to send messages on auction deletion and closing.
-- 1 Trigger to send message on auction deletion.
-- 1 Trigger to send message on auction closing.

-- Trigger to send message when auction is deleted.
DROP TRIGGER IF EXISTS MessageOnDeletingAuction;
DELIMITER //
CREATE TRIGGER MessageOnDeletingAuction
BEFORE DELETE ON AuctionSellsBuys
    FOR EACH ROW
BEGIN
 
    -- Send message only if the auction is open when deletion was performed.

    IF (OLD.closing_date_time > CURRENT_TIMESTAMP()) 
    THEN
        -- Send message to seller if seller login id is not NULL.
    
        IF (OLD.seller_login_id IS NOT NULL)
        THEN    
            INSERT INTO GetsMessage (user_login_id, message_type, message_text)
            VALUES (OLD.seller_login_id, 'sells', CONCAT('Your auction has been deleted. Deleted auction - ', OLD.auction_id));    
        END IF;

        -- Send message to all bidders.
           
        INSERT INTO GetsMessage (user_login_id, message_type, message_text)
        SELECT DISTINCT ob.bidder_login_id, 
                        'bid', 
                        CONCAT('Deleted the auction - ', OLD.auction_id)
        FROM PlacesBid ob
        WHERE ob.auction_id = OLD.auction_id;
    END IF;
END; //
DELIMITER ;



-- Trigger to send messages on Auction closing.
DROP TRIGGER IF EXISTS MessageOnClosingAuction;
DELIMITER //
CREATE TRIGGER MessageOnClosingAuction
AFTER UPDATE ON AuctionSellsBuys
    FOR EACH ROW
BEGIN

    -- Check if the buyer login id is not null and ther price is positive, if so 
    -- send messages to the seller, buyer and bidders about auction closing (due to successful sale).

    IF (NEW.buyer_login_id IS NOT NULL
        AND NEW.price > 0)
    THEN

        -- Send message to seller if seller login id is not NULL.

        IF (NEW.seller_login_id IS NOT NULL)
        THEN    
            INSERT INTO GetsMessage (user_login_id, message_type, message_text)
            VALUES (NEW.seller_login_id, 'sells', CONCAT('Your apparel placed on auction has been sold. Successfully closed auction - ', NEW.auction_id));
        END IF;

        -- Send message to buyer.
        
        INSERT INTO GetsMessage (user_login_id, message_type, message_text)
        VALUES (NEW.buyer_login_id, 'buys', CONCAT('You have bought the apparel placed at auction - ', NEW.auction_id));

        -- Send message to all bidders.
        
        INSERT INTO GetsMessage (user_login_id, message_type, message_text)
        SELECT DISTINCT ob.bidder_login_id, 
                        'bid', 
                        CONCAT('Closed the auction due to the sale of the apparel placed at auction - ', NEW.auction_id)
        FROM PlacesBid ob
        WHERE ob.bidder_login_id <> NEW.buyer_login_id
              AND ob.auction_id = NEW.auction_id;
    
    -- Check if the buyer login id is null and the price is negative, if so 
    -- send messages to the seller and bidders about auction closing (due to retraction).

    ELSEIF (NEW.buyer_login_id IS NULL
            AND NEW.price < 0)
    THEN
       -- Send message to seller if seller login id is not NULL.

        IF (NEW.seller_login_id IS NOT NULL)
        THEN    
            INSERT INTO GetsMessage (user_login_id, message_type, message_text)
            VALUES (NEW.seller_login_id, 'sells', CONCAT('Your apparel placed on auction has been retracted. It was not sold as the bids failed to meet the minimum sale price set. Closed auction - ', NEW.auction_id));
        END IF;

        -- Send message to all bidders.
        
        INSERT INTO GetsMessage (user_login_id, message_type, message_text)
        SELECT DISTINCT ob.bidder_login_id, 
                        'bid', 
                        CONCAT('Closed the auction due to the retraction of the apparel placed at auction - ', NEW.auction_id)
        FROM PlacesBid ob
        WHERE ob.auction_id = NEW.auction_id;
    END IF;
END; //
DELIMITER ;




-- Extra Triggers and Events related to auction deletion and closing.
-- 1 Trigger to delete ongoing auction if seller account is deleted.
-- 1 Trigger to delete apparel if all supporting auctions are deleted.
-- 1 Event to check and close auction.

-- Trigger to delete ongoing auction if seller account is deleted.
DROP TRIGGER IF EXISTS DeleteAuctionOnSellerAccountDelete;
DELIMITER //
CREATE TRIGGER DeleteAuctionOnSellerAccountDelete
BEFORE DELETE ON Account
    FOR EACH ROW
BEGIN
    
    -- Delete ongoing auctions if the seller account is deleted.

    DELETE FROM AuctionSellsBuys asb
    WHERE asb.seller_login_id = OLD.login_id
          AND asb.closing_date_time > CURRENT_TIMESTAMP();
END; //
DELIMITER ;



-- Trigger to delete apparel if all auctions related to it are deleted.
DROP TRIGGER IF EXISTS DeleteApparel;
DELIMITER //
CREATE TRIGGER DeleteApparel
AFTER DELETE ON AuctionSellsBuys
    FOR EACH ROW
BEGIN
    
    -- Check if other auctions selling the same apparel exist
    -- if not delete that apparel.
    
    IF (NOT EXISTS (SELECT *
                    FROM AuctionSellsBuys asb
                    WHERE asb.item_id = OLD.item_id))
    THEN
        DELETE FROM Apparel a WHERE a.item_id = OLD.item_id;
    END IF;
END; //
DELIMITER ;



-- Event for Checking if Auction is closed.
DROP EVENT IF EXISTS CloseAuction;
DELIMITER //
CREATE EVENT CloseAuction
ON SCHEDULE 
    EVERY 1 MINUTE
    STARTS NOW()
    ON COMPLETION PRESERVE 
DO
BEGIN
    
    -- Left join the AuctionSellBuys table with the result table of selecting 
    -- bidder login id, auction id and bid value of the highest bids for each auction
    -- from places bid table and for closed auctions which have buyer login id NULL and price 0
    -- if highest bid value < secret minimum price then select buying price as -1 and buyer as NULL
    -- else select buying price as highest bid value and buyer as highest bidder login id.
    -- Use this table to update buyer login id and price in the AuctionSellsBuys table.

    UPDATE AuctionSellsBuys a,
           (SELECT IF((b.bid_value >= asb.secret_minimum_price), b.bidder_login_id, NULL) AS buyer, 
                   asb.auction_id, 
                   IF(b.bid_value >= asb.secret_minimum_price, b.bid_value, -1) AS buying_price
            FROM AuctionSellsBuys asb
            LEFT JOIN (SELECT pb.auction_id,
                              MAX(pb.bid_value) AS bid_value
                       FROM PlacesBid pb
                       GROUP BY pb.auction_id) mb USING (auction_id)
            LEFT JOIN PlacesBid b USING (auction_id, bid_value)
            WHERE (CURRENT_TIMESTAMP() >= asb.closing_date_time
                  OR  asb.seller_login_id IS NULL)
                  AND asb.buyer_login_id IS NULL
                  AND asb.price = 0.00) p
    SET a.buyer_login_id = p.buyer,
        a.price = p.buying_price,        
        a.closing_date_time = NOW()
    WHERE a.auction_id = p.auction_id;
END; //
DELIMITER ;