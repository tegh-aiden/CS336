CREATE DATABASE  IF NOT EXISTS `auctionsite` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `auctionsite`;
-- MySQL dump 10.13  Distrib 8.0.20, for Win64 (x86_64)
--
-- Host: localhost    Database: auctionsite
-- ------------------------------------------------------
-- Server version	8.0.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account` (
  `login_id` varchar(30) NOT NULL,
  `password` varchar(20) NOT NULL,
  `email` varchar(50) NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(20) NOT NULL,
  `permissions_class` enum('admin','customer_rep','user') NOT NULL DEFAULT 'user',
  PRIMARY KEY (`login_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
INSERT INTO `account` VALUES ('admin','$Admin2021','administrator@auctionsite.org','Root','Manager','admin'),('CustomerRep1','$1CrepJD','john.doe.1@auctionsite.org','John','Doe','customer_rep'),('CustomerRep2','$2CrepMJ','mary.jane.2@auctionsite.org','Mary','Jane','customer_rep'),('CustomerRep3','$3CrepAS','anne.sue.3@auctionsite.org','Anne','Sue','customer_rep'),('CustomerRep4','$4CrepGG','greg.goon.4@auctionsite.org','Greg','Goon','customer_rep'),('CustomerRep5','$5CrepJB','james.bond.5@auctionsite.org','James','Bond','customer_rep'),('dannydimes0826','@Eli0711','dj8@protonmail.com','Daniel','Jones','user'),('hennybenny','IamBen456%','bennessey@scarletmail.rutgers.edu','Benjamin','Hennessey','user'),('jessjones12','Je$$ica135','jess@yahoo.com','Jessica','Jones','user'),('KingJulius','#TripleDouble30','jr@knicks.com','Julius','Randle','user'),('phil_fry','(Bender3000)','fry@gmail.com','Phillip','Fry','user'),('taiden','(Password123)','xyz@hotmail.com','Tegh','A','user'),('tomh123','Password123)','xyz@hotmail.com','Thomas','H','user');
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `DeleteAuctionOnSellerAccountDelete` BEFORE DELETE ON `account` FOR EACH ROW BEGIN
    
    -- Delete ongoing auctions if the seller account is deleted.

    DELETE FROM AuctionSellsBuys asb
    WHERE asb.seller_login_id = OLD.login_id
          AND asb.closing_date_time > CURRENT_TIMESTAMP();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `alertforwishapparel`
--

DROP TABLE IF EXISTS `alertforwishapparel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alertforwishapparel` (
  `user_login_id` varchar(30) NOT NULL,
  `wish_id` int NOT NULL,
  `brand` varchar(20) DEFAULT NULL,
  `age_group` enum('newborn','kids','teenager','20-39','40-59','60-80','80+') DEFAULT NULL,
  `color` varchar(20) DEFAULT NULL,
  `season` enum('spring','summer','fall','winter') DEFAULT NULL,
  `gender` enum('M','F','U') DEFAULT NULL,
  `material` varchar(30) DEFAULT NULL,
  `category` enum('tops','bottoms','footwear') DEFAULT NULL,
  PRIMARY KEY (`user_login_id`,`wish_id`),
  CONSTRAINT `alertforwishapparel_ibfk_1` FOREIGN KEY (`user_login_id`) REFERENCES `account` (`login_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alertforwishapparel`
--

LOCK TABLES `alertforwishapparel` WRITE;
/*!40000 ALTER TABLE `alertforwishapparel` DISABLE KEYS */;
INSERT INTO `alertforwishapparel` VALUES ('taiden',1,'Nike',NULL,NULL,NULL,'M',NULL,'tops');
/*!40000 ALTER TABLE `alertforwishapparel` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `MessageOnCreateWishApparel` AFTER INSERT ON `alertforwishapparel` FOR EACH ROW BEGIN

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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `apparel`
--

DROP TABLE IF EXISTS `apparel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apparel` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `brand` varchar(20) NOT NULL,
  `age_group` enum('newborn','kids','teenager','20-39','40-59','60-80','80+') NOT NULL,
  `color` varchar(20) NOT NULL,
  `season` enum('spring','summer','fall','winter') NOT NULL,
  `gender` enum('M','F','U') NOT NULL,
  `material` varchar(30) NOT NULL,
  `category` enum('tops','bottoms','footwear') NOT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apparel`
--

LOCK TABLES `apparel` WRITE;
/*!40000 ALTER TABLE `apparel` DISABLE KEYS */;
INSERT INTO `apparel` VALUES (11,'Nike','20-39','Orange','fall','M','Cotton','bottoms'),(12,'Jordan','20-39','Black','summer','M','Leather','footwear'),(13,'Polo','20-39','White','spring','M','Silk','tops'),(14,'Hanes','teenager','Black','summer','U','Cotton','tops'),(15,'Hanes','teenager','Red','summer','U','Cotton','tops'),(16,'Hanes','teenager','Pink','summer','U','Cotton','tops'),(17,'American eagle','teenager','Blue','winter','F','Denim','bottoms'),(18,'American eagle','teenager','Black','winter','F','Denim','bottoms'),(19,'Calvin klein','teenager','Blue','winter','F','Denim','bottoms'),(20,'Hanes','40-59','Black','fall','F','Polyester','bottoms'),(21,'Champion','kids','Black','winter','U','Polyester','bottoms'),(22,'Baby gap','newborn','Blue','spring','U','Denim','bottoms'),(23,'Calvin klein','60-80','Black','fall','M','Leather','footwear'),(24,'Calvin klein','60-80','Black','fall','F','Leather','footwear'),(25,'Nike','20-39','Blue','summer','M','Mesh','tops'),(26,'Nike','20-39','Blue','summer','M','Polyester','bottoms'),(27,'Nike','20-39','White','summer','M','Plastic','footwear'),(28,'Wakandatech','80+','Black','spring','U','Vibranium','tops'),(31,'Nike','20-39','Blue','summer','M','Mesh','tops'),(32,'Nike','20-39','Black','summer','M','Leather','footwear'),(33,'Hanes','20-39','White','fall','M','Cotton','tops'),(34,'American eagle','teenager','White','summer','F','Denim','bottoms'),(35,'Nike','20-39','White','spring','M','Mesh','footwear'),(36,'Polo','40-59','Black','winter','M','Silk','tops'),(37,'Polo','20-39','Blue','winter','U','Cotton','tops'),(38,'Hanes','20-39','White','spring','M','Cotton','tops'),(39,'Uggs','40-59','Black','winter','F','Leather','footwear'),(40,'Champion','20-39','Yellow','summer','U','Plastic','footwear'),(41,'Nike','20-39','Black','summer','M','Mesh','footwear'),(42,'Nike','20-39','Black','summer','M','Vibranium','footwear'),(43,'Uggs','teenager','Black','winter','F','Leather','footwear'),(44,'Nike','20-39','Black','fall','M','Denim','tops'),(45,'Nike','40-59','Red','spring','U','Cotton','tops'),(46,'Nike','teenager','Black','summer','M','Denim','tops'),(47,'Nike','teenager','Black','summer','M','Polyester','tops');
/*!40000 ALTER TABLE `apparel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auctionsellsbuys`
--

DROP TABLE IF EXISTS `auctionsellsbuys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auctionsellsbuys` (
  `auction_id` int NOT NULL AUTO_INCREMENT,
  `seller_login_id` varchar(30) DEFAULT NULL,
  `item_id` int NOT NULL,
  `buyer_login_id` varchar(30) DEFAULT NULL,
  `title` varchar(100) NOT NULL DEFAULT 'Apparel on Auction',
  `description` varchar(300) NOT NULL DEFAULT 'Apparel on Auction',
  `posted_date_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `closing_date_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `secret_minimum_price` decimal(20,2) NOT NULL DEFAULT '0.01',
  `minimum_bid_increment` decimal(20,2) NOT NULL DEFAULT '0.01',
  `price` decimal(20,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`auction_id`),
  KEY `seller_login_id` (`seller_login_id`),
  KEY `item_id` (`item_id`),
  KEY `buyer_login_id` (`buyer_login_id`),
  CONSTRAINT `auctionsellsbuys_ibfk_1` FOREIGN KEY (`seller_login_id`) REFERENCES `account` (`login_id`) ON DELETE SET NULL,
  CONSTRAINT `auctionsellsbuys_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `apparel` (`item_id`) ON DELETE CASCADE,
  CONSTRAINT `auctionsellsbuys_ibfk_3` FOREIGN KEY (`buyer_login_id`) REFERENCES `account` (`login_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auctionsellsbuys`
--

LOCK TABLES `auctionsellsbuys` WRITE;
/*!40000 ALTER TABLE `auctionsellsbuys` DISABLE KEYS */;
INSERT INTO `auctionsellsbuys` VALUES (19,'KingJulius',11,NULL,'Signed shorts','Julius Randle, New York Knicks #30, Game-worn shorts','2021-04-24 11:24:29','2021-05-15 14:00:00',45.00,10.00,0.00),(20,'KingJulius',12,NULL,'Signed Shoes','Julius Randle, New York Knicks #30, Game-worn shoes','2021-04-24 11:25:56','2021-05-29 14:00:00',500.00,50.00,0.00),(21,'KingJulius',13,NULL,'Dress Shirt','Custom-made with Knicks logo','2021-04-24 11:28:54','2021-04-30 11:30:00',85.00,10.00,0.00),(22,'hennybenny',14,NULL,'Plain T-Shirt','Blue T-Shirt','2021-04-24 11:31:10','2021-08-31 08:30:00',10.00,0.50,0.00),(23,'hennybenny',15,NULL,'Plain T-Shirt','Red T-Shirt','2021-04-24 11:32:12','2021-08-31 11:30:00',10.00,0.50,0.00),(24,'hennybenny',16,NULL,'Plain T-Shirt','Pink T-Shirt','2021-04-24 11:33:26','2021-08-31 11:30:00',10.00,0.50,0.00),(25,'hennybenny',17,NULL,'Plain Jeans','Blue Jeans','2021-04-24 11:35:09','2021-05-22 11:40:00',45.00,1.00,0.00),(26,'hennybenny',18,NULL,'Plain Jeans','Black Jeans','2021-04-24 11:36:02','2021-05-24 11:40:00',45.00,1.00,0.00),(27,'hennybenny',19,NULL,'Ripped Jeans','Blue ripped jeans','2021-04-24 11:37:28','2021-05-29 11:40:00',60.00,2.00,0.00),(28,'hennybenny',20,NULL,'Used Pants','Black work pants','2021-04-24 11:39:46','2021-05-01 11:40:00',40.00,1.00,0.00),(29,'hennybenny',21,NULL,'Sweatpants','Black sweatpants','2021-04-24 11:42:31','2021-05-01 02:40:00',30.00,1.00,0.00),(30,'hennybenny',22,NULL,'Jeans for Babies','Jeans for Babies','2021-04-24 11:43:57','2021-05-01 12:00:00',20.00,1.00,0.00),(31,'hennybenny',23,NULL,'Dress Shoes','Black dress shoes','2021-04-24 11:45:40','2021-04-30 11:50:00',50.00,3.00,0.00),(32,'hennybenny',24,NULL,'Black Dress Shoes','Black Dress Shoes','2021-04-24 11:46:39','2021-05-01 11:50:00',50.00,3.00,0.00),(33,'hennybenny',25,NULL,'Signed Jersey','Daniel Jones, New York Giants #8, Signed Game-Worn Jersey','2021-04-24 11:48:56','2021-06-14 11:50:00',100.00,20.00,0.00),(34,'dannydimes0826',26,NULL,'Signed Pants','Signed Game-Worn Pants','2021-04-24 11:51:19','2021-05-08 11:50:00',500.00,10.00,0.00),(35,'dannydimes0826',27,NULL,'Signed Cleats','Signed Cleats, Game-Worn','2021-04-24 11:52:56','2021-04-30 04:50:00',100.00,10.00,0.00),(36,'dannydimes0826',28,NULL,'Super suit','Bullet-Proof','2021-04-24 11:55:08','2021-05-08 17:00:00',2000.00,100.00,0.00),(39,'dannydimes0826',31,NULL,'Signed Shirt','Signed danny dimes shirt','2021-04-24 14:39:20','2021-04-30 14:40:00',100.00,15.00,0.00),(40,'taiden',32,NULL,'New Air Force Ones','Nike Air Force Ones, Black, Size 12, High top basketball sneakers','2021-04-24 17:16:49','2021-05-01 06:00:00',85.00,5.00,0.00),(41,'taiden',33,NULL,'White Crewneck','Plain white shirt','2021-04-24 17:47:36','2021-04-24 17:50:42',30.00,2.00,-1.00),(42,'taiden',34,'phil_fry','White Jeans','New white jeans','2021-04-24 17:53:04','2021-04-24 18:10:42',50.00,3.00,130.00),(43,'taiden',35,'KingJulius','New tennis shoes','Nike tennis shoes, size 8 men, new','2021-04-24 17:54:16','2021-04-24 18:10:42',40.00,5.00,55.00),(44,'taiden',36,'tomh123','Button-Down','Formal dress shirt','2021-04-24 17:55:20','2021-04-24 18:10:42',70.00,2.00,90.00),(45,'taiden',37,'tomh123','Turtleneck Sweater','Made by my grandma','2021-04-24 17:56:29','2021-04-24 18:10:42',23.00,1.00,50.00),(46,'taiden',38,'tomh123','Used Shirt','Dirty but intact','2021-04-24 17:57:44','2021-04-24 18:10:42',5.00,1.00,10.00),(47,'phil_fry',39,'dannydimes0826','Big Boots','Good for kicking','2021-04-24 18:18:27','2021-04-24 18:30:42',100.00,25.00,200.00),(48,'phil_fry',40,'jessjones12','Cheap Sandals','New yellow sandals','2021-04-24 18:19:37','2021-04-24 18:30:42',10.00,2.00,12.00),(49,'phil_fry',40,'dannydimes0826','Cheap Sandals 2','Cheap yellow sandals','2021-04-24 18:22:21','2021-04-24 18:30:42',10.00,1.00,15.00),(50,'phil_fry',40,'tomh123','Cheap Sandals 3','New yellow sandals','2021-04-24 18:23:48','2021-04-24 18:30:42',10.00,1.00,11.00),(51,'hennybenny',33,'dannydimes0826','Plain Shirt','White Shirt','2021-04-24 18:35:29','2021-04-24 18:50:42',20.00,1.00,22.00),(52,'hennybenny',33,'taiden','Plain Shirt','White Shirt','2021-04-24 18:36:14','2021-04-24 18:50:42',20.00,1.00,23.00),(53,'KingJulius',41,'taiden','Signed Air Force 1','Basketball Shoes signed by Julius Randle','2021-04-25 10:30:00','2021-04-25 10:40:42',540.00,10.00,580.00),(54,'KingJulius',42,'taiden','New Nike Air Force 1','New Nike basketball shoes','2021-04-25 10:42:16','2021-04-25 10:50:42',540.00,10.00,580.00),(55,'jessjones12',43,NULL,'New Boots','New Ugg Boots, Black, Women\'s size 8','2021-04-25 10:56:15','2021-04-25 11:10:42',100.00,5.00,-1.00),(56,'KingJulius',44,NULL,'Nike Shirt','Large ','2021-04-25 11:39:33','2021-04-30 11:40:00',100.00,50.00,0.00),(57,'KingJulius',45,NULL,'Nike Shirt 2','Another one','2021-04-25 11:41:12','2021-04-28 02:50:00',1000.00,20.00,0.00),(58,'KingJulius',46,NULL,'Nike Shirt 3','Another one','2021-04-25 12:02:32','2021-04-30 12:00:00',100.00,5.00,0.00),(59,'KingJulius',47,NULL,'Nike Shirt 3','New large nike shirt','2021-04-25 13:36:58','2021-04-30 13:40:00',100.00,5.00,0.00);
/*!40000 ALTER TABLE `auctionsellsbuys` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `AuctionSetDefaultOnCreation` BEFORE INSERT ON `auctionsellsbuys` FOR EACH ROW BEGIN
    
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `MessageOnWishApparelAuctionStart` AFTER INSERT ON `auctionsellsbuys` FOR EACH ROW BEGIN
 
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `MessageOnClosingAuction` AFTER UPDATE ON `auctionsellsbuys` FOR EACH ROW BEGIN

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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `MessageOnDeletingAuction` BEFORE DELETE ON `auctionsellsbuys` FOR EACH ROW BEGIN
 
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `DeleteApparel` AFTER DELETE ON `auctionsellsbuys` FOR EACH ROW BEGIN
    
    -- Check if other auctions selling the same apparel exist
    -- if not delete that apparel.
    
    IF (NOT EXISTS (SELECT *
                    FROM AuctionSellsBuys asb
                    WHERE asb.item_id = OLD.item_id))
    THEN
        DELETE FROM Apparel a WHERE a.item_id = OLD.item_id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `bottoms`
--

DROP TABLE IF EXISTS `bottoms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bottoms` (
  `item_id` int NOT NULL,
  `waist_size` decimal(5,2) NOT NULL,
  `length` decimal(5,2) NOT NULL,
  PRIMARY KEY (`item_id`),
  CONSTRAINT `bottoms_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `apparel` (`item_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bottoms`
--

LOCK TABLES `bottoms` WRITE;
/*!40000 ALTER TABLE `bottoms` DISABLE KEYS */;
INSERT INTO `bottoms` VALUES (11,30.00,20.00),(17,27.00,27.00),(18,25.00,27.00),(19,22.00,22.00),(20,32.00,26.00),(21,28.00,28.00),(22,15.00,15.00),(26,28.00,34.00),(34,26.00,26.00);
/*!40000 ALTER TABLE `bottoms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `footwear`
--

DROP TABLE IF EXISTS `footwear`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `footwear` (
  `item_id` int NOT NULL,
  `size` decimal(5,2) NOT NULL,
  `type` varchar(20) NOT NULL,
  PRIMARY KEY (`item_id`),
  CONSTRAINT `footwear_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `apparel` (`item_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `footwear`
--

LOCK TABLES `footwear` WRITE;
/*!40000 ALTER TABLE `footwear` DISABLE KEYS */;
INSERT INTO `footwear` VALUES (12,15.00,'Sneakers'),(23,10.00,'Dress'),(24,8.00,'Dress'),(27,14.00,'Cleats'),(32,12.00,'Sneakers'),(35,8.00,'Sneakers'),(39,10.00,'Boots'),(40,11.00,'Sandals'),(41,12.00,'Sneakers'),(42,12.00,'Sneakers'),(43,8.00,'Boots');
/*!40000 ALTER TABLE `footwear` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `getsmessage`
--

DROP TABLE IF EXISTS `getsmessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `getsmessage` (
  `message_id` int NOT NULL AUTO_INCREMENT,
  `user_login_id` varchar(30) NOT NULL,
  `view_status` tinyint(1) NOT NULL DEFAULT '0',
  `message_type` enum('autobid','bid','buys','sells','wish') NOT NULL,
  `message_text` varchar(300) NOT NULL,
  `message_date_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_id`,`user_login_id`),
  KEY `user_login_id` (`user_login_id`),
  CONSTRAINT `getsmessage_ibfk_1` FOREIGN KEY (`user_login_id`) REFERENCES `account` (`login_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=509 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `getsmessage`
--

LOCK TABLES `getsmessage` WRITE;
/*!40000 ALTER TABLE `getsmessage` DISABLE KEYS */;
INSERT INTO `getsmessage` VALUES (349,'dannydimes0826',1,'sells','Your apparel placed on auction has been retracted. It was not sold as the bids failed to meet the minimum sale price set. Closed auction - 37','2021-04-24 12:40:21'),(350,'taiden',1,'wish','Your wish apparel is now available on auction - 38','2021-04-24 14:35:09'),(351,'dannydimes0826',1,'sells','Your auction has been deleted. Deleted auction - 38','2021-04-24 14:37:42'),(352,'taiden',1,'wish','Your wish apparel is now available on auction - 39','2021-04-24 14:39:20'),(353,'KingJulius',1,'bid','A higher bid has been placed on auction - 41','2021-04-24 17:49:25'),(354,'taiden',1,'sells','Your apparel placed on auction has been retracted. It was not sold as the bids failed to meet the minimum sale price set. Closed auction - 41','2021-04-24 17:50:42'),(355,'KingJulius',1,'bid','Closed the auction due to the retraction of the apparel placed at auction - 41','2021-04-24 17:50:42'),(356,'phil_fry',1,'bid','Closed the auction due to the retraction of the apparel placed at auction - 41','2021-04-24 17:50:42'),(358,'phil_fry',1,'bid','A higher bid has been placed on auction - 42','2021-04-24 18:03:15'),(359,'KingJulius',1,'bid','A higher bid has been placed on auction - 42','2021-04-24 18:03:15'),(360,'KingJulius',1,'autobid','A bid exceeding your AutoBidding upper limit has been placed on auction - 42','2021-04-24 18:03:15'),(361,'phil_fry',1,'bid','A higher bid has been placed on auction - 43','2021-04-24 18:03:36'),(362,'KingJulius',1,'bid','A higher bid has been placed on auction - 43','2021-04-24 18:03:36'),(363,'phil_fry',1,'bid','A higher bid has been placed on auction - 43','2021-04-24 18:03:49'),(364,'phil_fry',1,'autobid','A bid exceeding your AutoBidding upper limit has been placed on auction - 43','2021-04-24 18:03:49'),(365,'phil_fry',1,'bid','A higher bid has been placed on auction - 46','2021-04-24 18:04:20'),(366,'KingJulius',1,'bid','A higher bid has been placed on auction - 46','2021-04-24 18:04:20'),(367,'phil_fry',1,'bid','A higher bid has been placed on auction - 46','2021-04-24 18:04:20'),(368,'phil_fry',1,'autobid','A bid exceeding your AutoBidding upper limit has been placed on auction - 46','2021-04-24 18:04:20'),(369,'phil_fry',1,'bid','A higher bid has been placed on auction - 44','2021-04-24 18:04:41'),(370,'KingJulius',1,'bid','A higher bid has been placed on auction - 44','2021-04-24 18:04:41'),(371,'phil_fry',1,'bid','A higher bid has been placed on auction - 44','2021-04-24 18:04:41'),(372,'KingJulius',1,'bid','A higher bid has been placed on auction - 44','2021-04-24 18:04:41'),(373,'phil_fry',1,'bid','A higher bid has been placed on auction - 44','2021-04-24 18:04:41'),(374,'KingJulius',1,'bid','A higher bid has been placed on auction - 44','2021-04-24 18:04:41'),(375,'KingJulius',1,'autobid','A bid exceeding your AutoBidding upper limit has been placed on auction - 44','2021-04-24 18:04:41'),(376,'phil_fry',1,'bid','A higher bid has been placed on auction - 45','2021-04-24 18:05:01'),(377,'KingJulius',1,'bid','A higher bid has been placed on auction - 45','2021-04-24 18:05:01'),(378,'phil_fry',1,'bid','A higher bid has been placed on auction - 45','2021-04-24 18:05:16'),(379,'KingJulius',1,'bid','A higher bid has been placed on auction - 45','2021-04-24 18:05:16'),(380,'phil_fry',1,'bid','A higher bid has been placed on auction - 45','2021-04-24 18:05:16'),(381,'KingJulius',1,'bid','A higher bid has been placed on auction - 45','2021-04-24 18:05:16'),(382,'phil_fry',1,'bid','A higher bid has been placed on auction - 45','2021-04-24 18:05:16'),(383,'phil_fry',1,'autobid','A bid exceeding your AutoBidding upper limit has been placed on auction - 45','2021-04-24 18:05:16'),(384,'KingJulius',1,'bid','A higher bid has been placed on auction - 46','2021-04-24 18:06:35'),(385,'phil_fry',1,'bid','A higher bid has been placed on auction - 46','2021-04-24 18:06:35'),(387,'KingJulius',1,'autobid','A bid exceeding your AutoBidding upper limit has been placed on auction - 46','2021-04-24 18:06:35'),(388,'KingJulius',1,'bid','A higher bid has been placed on auction - 45','2021-04-24 18:06:52'),(389,'phil_fry',1,'bid','A higher bid has been placed on auction - 45','2021-04-24 18:06:52'),(391,'KingJulius',1,'autobid','A bid exceeding your AutoBidding upper limit has been placed on auction - 45','2021-04-24 18:06:52'),(392,'KingJulius',1,'bid','A higher bid has been placed on auction - 44','2021-04-24 18:07:31'),(393,'phil_fry',1,'bid','A higher bid has been placed on auction - 44','2021-04-24 18:07:31'),(395,'phil_fry',1,'autobid','A bid exceeding your AutoBidding upper limit has been placed on auction - 44','2021-04-24 18:07:31'),(396,'KingJulius',1,'bid','A higher bid has been placed on auction - 42','2021-04-24 18:08:26'),(397,'phil_fry',1,'bid','A higher bid has been placed on auction - 42','2021-04-24 18:08:26'),(399,'KingJulius',1,'bid','A higher bid has been placed on auction - 42','2021-04-24 18:08:26'),(400,'tomh123',1,'bid','A higher bid has been placed on auction - 42','2021-04-24 18:08:26'),(402,'KingJulius',1,'bid','A higher bid has been placed on auction - 42','2021-04-24 18:08:42'),(403,'phil_fry',1,'bid','A higher bid has been placed on auction - 42','2021-04-24 18:08:42'),(405,'KingJulius',1,'bid','A higher bid has been placed on auction - 42','2021-04-24 18:08:42'),(406,'tomh123',1,'bid','A higher bid has been placed on auction - 42','2021-04-24 18:08:42'),(408,'KingJulius',1,'bid','A higher bid has been placed on auction - 42','2021-04-24 18:08:42'),(409,'phil_fry',1,'bid','A higher bid has been placed on auction - 42','2021-04-24 18:08:42'),(411,'phil_fry',1,'autobid','A bid exceeding your AutoBidding upper limit has been placed on auction - 42','2021-04-24 18:08:42'),(412,'KingJulius',1,'bid','A higher bid has been placed on auction - 42','2021-04-24 18:09:43'),(413,'tomh123',1,'bid','A higher bid has been placed on auction - 42','2021-04-24 18:09:43'),(415,'tomh123',1,'autobid','A bid exceeding your AutoBidding upper limit has been placed on auction - 42','2021-04-24 18:09:43'),(416,'taiden',1,'sells','Your apparel placed on auction has been sold. Successfully closed auction - 42','2021-04-24 18:10:42'),(417,'phil_fry',1,'buys','You have bought the apparel placed at auction - 42','2021-04-24 18:10:42'),(418,'KingJulius',1,'bid','Closed the auction due to the sale of the apparel placed at auction - 42','2021-04-24 18:10:42'),(419,'tomh123',1,'bid','Closed the auction due to the sale of the apparel placed at auction - 42','2021-04-24 18:10:42'),(421,'taiden',1,'sells','Your apparel placed on auction has been sold. Successfully closed auction - 43','2021-04-24 18:10:42'),(422,'KingJulius',1,'buys','You have bought the apparel placed at auction - 43','2021-04-24 18:10:42'),(423,'phil_fry',1,'bid','Closed the auction due to the sale of the apparel placed at auction - 43','2021-04-24 18:10:42'),(424,'taiden',1,'sells','Your apparel placed on auction has been sold. Successfully closed auction - 44','2021-04-24 18:10:42'),(425,'tomh123',1,'buys','You have bought the apparel placed at auction - 44','2021-04-24 18:10:42'),(426,'KingJulius',1,'bid','Closed the auction due to the sale of the apparel placed at auction - 44','2021-04-24 18:10:42'),(427,'phil_fry',1,'bid','Closed the auction due to the sale of the apparel placed at auction - 44','2021-04-24 18:10:42'),(429,'taiden',1,'sells','Your apparel placed on auction has been sold. Successfully closed auction - 45','2021-04-24 18:10:42'),(430,'tomh123',1,'buys','You have bought the apparel placed at auction - 45','2021-04-24 18:10:42'),(431,'KingJulius',1,'bid','Closed the auction due to the sale of the apparel placed at auction - 45','2021-04-24 18:10:42'),(432,'phil_fry',1,'bid','Closed the auction due to the sale of the apparel placed at auction - 45','2021-04-24 18:10:42'),(434,'taiden',1,'sells','Your apparel placed on auction has been sold. Successfully closed auction - 46','2021-04-24 18:10:42'),(435,'tomh123',1,'buys','You have bought the apparel placed at auction - 46','2021-04-24 18:10:42'),(436,'KingJulius',1,'bid','Closed the auction due to the sale of the apparel placed at auction - 46','2021-04-24 18:10:42'),(437,'phil_fry',1,'bid','Closed the auction due to the sale of the apparel placed at auction - 46','2021-04-24 18:10:42'),(439,'jessjones12',1,'bid','A higher bid has been placed on auction - 47','2021-04-24 18:26:33'),(440,'tomh123',1,'bid','A higher bid has been placed on auction - 47','2021-04-24 18:26:33'),(441,'jessjones12',1,'bid','A higher bid has been placed on auction - 47','2021-04-24 18:26:51'),(442,'tomh123',1,'bid','A higher bid has been placed on auction - 47','2021-04-24 18:26:51'),(443,'tomh123',1,'autobid','A bid exceeding your AutoBidding upper limit has been placed on auction - 47','2021-04-24 18:26:51'),(444,'tomh123',1,'bid','A higher bid has been placed on auction - 49','2021-04-24 18:29:05'),(445,'jessjones12',1,'bid','A higher bid has been placed on auction - 47','2021-04-24 18:29:53'),(446,'tomh123',1,'bid','A higher bid has been placed on auction - 47','2021-04-24 18:29:53'),(448,'jessjones12',1,'autobid','A bid exceeding your AutoBidding upper limit has been placed on auction - 47','2021-04-24 18:29:53'),(449,'phil_fry',1,'sells','Your apparel placed on auction has been sold. Successfully closed auction - 47','2021-04-24 18:30:42'),(450,'dannydimes0826',0,'buys','You have bought the apparel placed at auction - 47','2021-04-24 18:30:42'),(451,'jessjones12',1,'bid','Closed the auction due to the sale of the apparel placed at auction - 47','2021-04-24 18:30:42'),(452,'tomh123',1,'bid','Closed the auction due to the sale of the apparel placed at auction - 47','2021-04-24 18:30:42'),(454,'phil_fry',1,'sells','Your apparel placed on auction has been sold. Successfully closed auction - 48','2021-04-24 18:30:42'),(455,'jessjones12',1,'buys','You have bought the apparel placed at auction - 48','2021-04-24 18:30:42'),(456,'phil_fry',1,'sells','Your apparel placed on auction has been sold. Successfully closed auction - 49','2021-04-24 18:30:42'),(457,'dannydimes0826',0,'buys','You have bought the apparel placed at auction - 49','2021-04-24 18:30:42'),(458,'tomh123',1,'bid','Closed the auction due to the sale of the apparel placed at auction - 49','2021-04-24 18:30:42'),(459,'phil_fry',1,'sells','Your apparel placed on auction has been sold. Successfully closed auction - 50','2021-04-24 18:30:42'),(460,'tomh123',1,'buys','You have bought the apparel placed at auction - 50','2021-04-24 18:30:42'),(461,'dannydimes0826',0,'bid','A higher bid has been placed on auction - 52','2021-04-24 18:38:37'),(462,'hennybenny',0,'sells','Your apparel placed on auction has been sold. Successfully closed auction - 51','2021-04-24 18:50:42'),(463,'dannydimes0826',0,'buys','You have bought the apparel placed at auction - 51','2021-04-24 18:50:42'),(464,'hennybenny',0,'sells','Your apparel placed on auction has been sold. Successfully closed auction - 52','2021-04-24 18:50:42'),(465,'taiden',1,'buys','You have bought the apparel placed at auction - 52','2021-04-24 18:50:42'),(466,'dannydimes0826',0,'bid','Closed the auction due to the sale of the apparel placed at auction - 52','2021-04-24 18:50:42'),(467,'KingJulius',1,'sells','Your auction has been deleted. Deleted auction - 17','2021-04-25 10:06:58'),(468,'taiden',1,'bid','Deleted the auction - 17','2021-04-25 10:06:58'),(469,'taiden',1,'bid','A higher bid has been placed on auction - 18','2021-04-25 10:09:12'),(470,'KingJulius',1,'sells','Your auction has been deleted. Deleted auction - 18','2021-04-25 10:18:35'),(471,'taiden',1,'bid','A higher bid has been placed on auction - 53','2021-04-25 10:32:59'),(472,'phil_fry',1,'bid','A higher bid has been placed on auction - 53','2021-04-25 10:32:59'),(473,'KingJulius',1,'sells','Your apparel placed on auction has been sold. Successfully closed auction - 53','2021-04-25 10:40:42'),(474,'taiden',1,'buys','You have bought the apparel placed at auction - 53','2021-04-25 10:40:42'),(475,'phil_fry',1,'bid','Closed the auction due to the sale of the apparel placed at auction - 53','2021-04-25 10:40:42'),(476,'taiden',1,'bid','A higher bid has been placed on auction - 54','2021-04-25 10:44:42'),(477,'phil_fry',1,'bid','A higher bid has been placed on auction - 54','2021-04-25 10:44:42'),(478,'KingJulius',1,'sells','Your apparel placed on auction has been sold. Successfully closed auction - 54','2021-04-25 10:50:42'),(479,'taiden',1,'buys','You have bought the apparel placed at auction - 54','2021-04-25 10:50:42'),(480,'phil_fry',1,'bid','Closed the auction due to the sale of the apparel placed at auction - 54','2021-04-25 10:50:42'),(481,'taiden',1,'bid','A higher bid has been placed on auction - 55','2021-04-25 10:59:00'),(482,'tomh123',1,'bid','A higher bid has been placed on auction - 55','2021-04-25 10:59:00'),(483,'tomh123',1,'autobid','A bid exceeding your AutoBidding upper limit has been placed on auction - 55','2021-04-25 10:59:00'),(484,'jessjones12',1,'sells','Your apparel placed on auction has been retracted. It was not sold as the bids failed to meet the minimum sale price set. Closed auction - 55','2021-04-25 11:10:42'),(485,'taiden',1,'bid','Closed the auction due to the retraction of the apparel placed at auction - 55','2021-04-25 11:10:42'),(486,'tomh123',0,'bid','Closed the auction due to the retraction of the apparel placed at auction - 55','2021-04-25 11:10:42'),(488,'taiden',1,'bid','A higher bid has been placed on auction - 29','2021-04-25 11:29:14'),(489,'phil_fry',1,'wish','Your wish apparel is now available on auction - 39','2021-04-25 11:38:22'),(490,'phil_fry',1,'wish','Your wish apparel is now available on auction - 56','2021-04-25 11:39:33'),(491,'taiden',1,'wish','Your wish apparel is now available on auction - 56','2021-04-25 11:39:33'),(493,'phil_fry',1,'wish','Your wish apparel is now available on auction - 57','2021-04-25 11:41:12'),(494,'phil_fry',1,'bid','A higher bid has been placed on auction - 19','2021-04-25 11:57:20'),(495,'phil_fry',1,'wish','Your wish apparel is now available on auction - 39','2021-04-25 11:58:44'),(496,'phil_fry',1,'wish','Your wish apparel is now available on auction - 56','2021-04-25 11:58:44'),(497,'phil_fry',1,'wish','Your wish apparel is now available on auction - 57','2021-04-25 11:58:44'),(498,'taiden',1,'bid','A higher bid has been placed on auction - 19','2021-04-25 12:00:05'),(499,'phil_fry',1,'bid','A higher bid has been placed on auction - 19','2021-04-25 12:00:05'),(500,'taiden',1,'wish','Your wish apparel is now available on auction - 58','2021-04-25 12:02:32'),(501,'phil_fry',1,'wish','Your wish apparel is now available on auction - 39','2021-04-25 13:35:32'),(502,'phil_fry',1,'wish','Your wish apparel is now available on auction - 56','2021-04-25 13:35:32'),(503,'phil_fry',1,'wish','Your wish apparel is now available on auction - 57','2021-04-25 13:35:32'),(504,'phil_fry',1,'wish','Your wish apparel is now available on auction - 58','2021-04-25 13:35:32'),(508,'taiden',0,'wish','Your wish apparel is now available on auction - 59','2021-04-25 13:36:58');
/*!40000 ALTER TABLE `getsmessage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `placesbid`
--

DROP TABLE IF EXISTS `placesbid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `placesbid` (
  `bidder_login_id` varchar(30) NOT NULL,
  `auction_id` int NOT NULL,
  `bid_value` decimal(20,2) NOT NULL,
  `bid_date_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`bidder_login_id`,`auction_id`,`bid_value`),
  KEY `auction_id` (`auction_id`),
  CONSTRAINT `placesbid_ibfk_1` FOREIGN KEY (`bidder_login_id`) REFERENCES `account` (`login_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `placesbid_ibfk_2` FOREIGN KEY (`auction_id`) REFERENCES `auctionsellsbuys` (`auction_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `placesbid`
--

LOCK TABLES `placesbid` WRITE;
/*!40000 ALTER TABLE `placesbid` DISABLE KEYS */;
INSERT INTO `placesbid` VALUES ('dannydimes0826',47,200.00,'2021-04-24 18:29:53'),('dannydimes0826',49,15.00,'2021-04-24 18:29:05'),('dannydimes0826',51,22.00,'2021-04-24 18:37:45'),('dannydimes0826',52,21.00,'2021-04-24 18:38:08'),('jessjones12',47,25.00,'2021-04-24 18:25:24'),('jessjones12',47,125.00,'2021-04-24 18:26:33'),('jessjones12',47,175.00,'2021-04-24 18:26:51'),('jessjones12',48,12.00,'2021-04-24 18:25:34'),('KingJulius',41,22.00,'2021-04-24 17:48:41'),('KingJulius',42,55.00,'2021-04-24 18:03:15'),('KingJulius',43,40.00,'2021-04-24 18:03:36'),('KingJulius',43,55.00,'2021-04-24 18:03:49'),('KingJulius',44,65.00,'2021-04-24 18:04:41'),('KingJulius',44,73.00,'2021-04-24 18:04:41'),('KingJulius',44,81.00,'2021-04-24 18:04:41'),('KingJulius',45,15.00,'2021-04-24 18:05:01'),('KingJulius',45,18.50,'2021-04-24 18:05:16'),('KingJulius',45,22.00,'2021-04-24 18:05:16'),('KingJulius',45,25.50,'2021-04-24 18:05:16'),('KingJulius',46,2.00,'2021-04-24 18:04:20'),('KingJulius',46,4.00,'2021-04-24 18:04:20'),('phil_fry',19,50.00,'2021-04-25 11:55:02'),('phil_fry',19,70.00,'2021-04-25 12:00:05'),('phil_fry',29,1500.00,'2021-04-25 11:29:14'),('phil_fry',41,25.00,'2021-04-24 17:49:25'),('phil_fry',42,50.00,'2021-04-24 17:59:37'),('phil_fry',42,65.00,'2021-04-24 18:03:15'),('phil_fry',42,85.00,'2021-04-24 18:08:26'),('phil_fry',42,100.00,'2021-04-24 18:08:42'),('phil_fry',42,130.00,'2021-04-24 18:09:43'),('phil_fry',43,20.00,'2021-04-24 18:00:08'),('phil_fry',43,45.00,'2021-04-24 18:03:36'),('phil_fry',44,63.00,'2021-04-24 18:00:43'),('phil_fry',44,71.00,'2021-04-24 18:04:41'),('phil_fry',44,79.00,'2021-04-24 18:04:41'),('phil_fry',44,87.00,'2021-04-24 18:04:41'),('phil_fry',45,1.00,'2021-04-24 18:01:33'),('phil_fry',45,16.00,'2021-04-24 18:05:01'),('phil_fry',45,19.50,'2021-04-24 18:05:16'),('phil_fry',45,23.00,'2021-04-24 18:05:16'),('phil_fry',46,1.00,'2021-04-24 18:02:10'),('phil_fry',46,3.00,'2021-04-24 18:04:20'),('phil_fry',53,530.00,'2021-04-25 10:32:59'),('phil_fry',54,530.00,'2021-04-25 10:44:42'),('taiden',19,60.00,'2021-04-25 11:57:20'),('taiden',19,80.00,'2021-04-25 12:00:05'),('taiden',20,500.00,'2021-04-25 11:21:36'),('taiden',22,20.00,'2021-04-24 12:10:05'),('taiden',25,20.00,'2021-04-24 12:11:56'),('taiden',26,5.00,'2021-04-25 11:21:52'),('taiden',26,40.00,'2021-04-25 11:23:01'),('taiden',29,1200.00,'2021-04-25 11:21:08'),('taiden',29,1400.00,'2021-04-25 11:28:24'),('taiden',32,80.00,'2021-04-25 11:22:15'),('taiden',52,23.00,'2021-04-24 18:38:37'),('taiden',53,500.00,'2021-04-25 10:31:17'),('taiden',53,580.00,'2021-04-25 10:32:59'),('taiden',54,500.00,'2021-04-25 10:43:14'),('taiden',54,580.00,'2021-04-25 10:44:42'),('taiden',55,50.00,'2021-04-25 10:57:10'),('taiden',55,75.00,'2021-04-25 10:59:00'),('tomh123',42,75.00,'2021-04-24 18:08:26'),('tomh123',42,90.00,'2021-04-24 18:08:42'),('tomh123',42,105.00,'2021-04-24 18:08:42'),('tomh123',44,90.00,'2021-04-24 18:07:31'),('tomh123',45,50.00,'2021-04-24 18:06:52'),('tomh123',46,10.00,'2021-04-24 18:06:35'),('tomh123',47,100.00,'2021-04-24 18:26:33'),('tomh123',47,150.00,'2021-04-24 18:26:51'),('tomh123',49,10.00,'2021-04-24 18:27:03'),('tomh123',49,14.00,'2021-04-24 18:27:22'),('tomh123',50,11.00,'2021-04-24 18:27:43'),('tomh123',55,65.00,'2021-04-25 10:59:00');
/*!40000 ALTER TABLE `placesbid` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `NewBid` BEFORE INSERT ON `placesbid` FOR EACH ROW BEGIN

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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `DeleteOptions` AFTER DELETE ON `placesbid` FOR EACH ROW BEGIN
    
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `questionanswer`
--

DROP TABLE IF EXISTS `questionanswer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questionanswer` (
  `user_login_id` varchar(30) DEFAULT NULL,
  `cust_rep_login_id` varchar(30) DEFAULT NULL,
  `question_id` int NOT NULL AUTO_INCREMENT,
  `question` varchar(300) NOT NULL,
  `answer` varchar(300) NOT NULL,
  PRIMARY KEY (`question_id`),
  KEY `user_login_id` (`user_login_id`),
  KEY `cust_rep_login_id` (`cust_rep_login_id`),
  CONSTRAINT `questionanswer_ibfk_1` FOREIGN KEY (`user_login_id`) REFERENCES `account` (`login_id`) ON DELETE SET NULL,
  CONSTRAINT `questionanswer_ibfk_2` FOREIGN KEY (`cust_rep_login_id`) REFERENCES `account` (`login_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questionanswer`
--

LOCK TABLES `questionanswer` WRITE;
/*!40000 ALTER TABLE `questionanswer` DISABLE KEYS */;
INSERT INTO `questionanswer` VALUES ('dannydimes0826','CustomerRep1',10,'What\'s up?','Nm wbu'),('dannydimes0826','CustomerRep1',11,'How do I post an auction?',''),('dannydimes0826',NULL,12,'What types of items are sold on this website?',''),('dannydimes0826',NULL,13,'How do I see my bids?',''),('dannydimes0826','CustomerRep1',14,'Do you accept Bitcoin?','yes'),('dannydimes0826',NULL,15,'Do you accept Litecoin?',''),('dannydimes0826',NULL,16,'Do you accept Dogecoin?',''),(NULL,'CustomerRep5',17,'How are you doing?','I am doing well'),(NULL,'CustomerRep5',18,'What credit cards do you accept?','Mastercard and Visa');
/*!40000 ALTER TABLE `questionanswer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `setoptions`
--

DROP TABLE IF EXISTS `setoptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `setoptions` (
  `bidder_login_id` varchar(30) NOT NULL,
  `auction_id` int NOT NULL,
  `auto_bidding` tinyint(1) NOT NULL DEFAULT '0',
  `auto_bidding_increment` decimal(20,2) NOT NULL DEFAULT '0.00',
  `upper_limit` decimal(20,2) NOT NULL DEFAULT '0.00',
  `is_anonymous` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`bidder_login_id`,`auction_id`),
  KEY `auction_id` (`auction_id`),
  CONSTRAINT `setoptions_ibfk_1` FOREIGN KEY (`bidder_login_id`) REFERENCES `account` (`login_id`) ON DELETE CASCADE,
  CONSTRAINT `setoptions_ibfk_2` FOREIGN KEY (`auction_id`) REFERENCES `auctionsellsbuys` (`auction_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `setoptions`
--

LOCK TABLES `setoptions` WRITE;
/*!40000 ALTER TABLE `setoptions` DISABLE KEYS */;
INSERT INTO `setoptions` VALUES ('dannydimes0826',47,1,25.00,200.00,1),('dannydimes0826',49,1,1.00,20.00,0),('dannydimes0826',51,1,2.00,26.00,0),('dannydimes0826',52,0,1.00,0.00,0),('jessjones12',47,0,25.00,190.00,1),('jessjones12',48,0,2.00,0.00,0),('KingJulius',41,0,2.00,0.00,0),('KingJulius',42,0,3.00,60.00,1),('KingJulius',43,1,10.00,90.00,1),('KingJulius',44,0,2.00,82.00,1),('KingJulius',45,0,1.00,30.00,0),('KingJulius',46,0,1.00,6.00,1),('phil_fry',19,0,10.00,0.00,1),('phil_fry',29,1,100.00,2000.00,1),('phil_fry',41,1,10.00,50.00,0),('phil_fry',42,0,3.00,100.00,0),('phil_fry',43,0,5.00,50.00,1),('phil_fry',44,0,2.00,90.00,0),('phil_fry',45,0,1.00,25.00,1),('phil_fry',46,0,1.00,4.00,1),('phil_fry',53,0,10.00,0.00,0),('phil_fry',54,0,10.00,0.00,1),('taiden',19,1,10.00,100.00,0),('taiden',20,0,50.00,0.00,0),('taiden',22,1,1.00,30.00,1),('taiden',25,1,5.00,40.00,0),('taiden',26,0,1.00,0.00,0),('taiden',29,0,1.00,0.00,0),('taiden',32,0,3.00,0.00,0),('taiden',52,1,3.00,30.00,0),('taiden',53,1,50.00,600.00,0),('taiden',54,1,50.00,600.00,0),('taiden',55,1,10.00,80.00,1),('tomh123',42,0,3.00,125.00,0),('tomh123',43,0,5.00,56.00,1),('tomh123',44,1,6.00,90.00,1),('tomh123',45,1,20.00,5.00,0),('tomh123',46,0,1.00,0.00,0),('tomh123',47,0,25.00,190.00,0),('tomh123',49,0,1.00,0.00,0),('tomh123',50,1,1.00,20.00,0),('tomh123',55,0,5.00,70.00,1);
/*!40000 ALTER TABLE `setoptions` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BidOptionsSetDefaultOnCreation` BEFORE INSERT ON `setoptions` FOR EACH ROW BEGIN

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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BidOptionsSetDefaultOnUpdate` BEFORE UPDATE ON `setoptions` FOR EACH ROW BEGIN
    
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tops`
--

DROP TABLE IF EXISTS `tops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tops` (
  `item_id` int NOT NULL,
  `size_group` enum('XS','S','M','L','XL','XXL') NOT NULL,
  `sleeve_length` decimal(5,2) NOT NULL,
  PRIMARY KEY (`item_id`),
  CONSTRAINT `tops_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `apparel` (`item_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tops`
--

LOCK TABLES `tops` WRITE;
/*!40000 ALTER TABLE `tops` DISABLE KEYS */;
INSERT INTO `tops` VALUES (13,'XL',20.00),(14,'M',20.00),(15,'M',15.00),(16,'M',15.00),(25,'XL',20.00),(28,'L',20.00),(31,'L',15.00),(33,'L',15.00),(36,'L',20.00),(37,'L',20.00),(38,'L',10.00),(44,'L',15.00),(45,'L',20.00),(46,'L',15.00),(47,'L',15.00);
/*!40000 ALTER TABLE `tops` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishapparelbottoms`
--

DROP TABLE IF EXISTS `wishapparelbottoms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishapparelbottoms` (
  `user_login_id` varchar(30) NOT NULL,
  `wish_id` int NOT NULL,
  `waist_size` decimal(5,2) DEFAULT NULL,
  `length` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`user_login_id`,`wish_id`),
  CONSTRAINT `wishapparelbottoms_ibfk_2` FOREIGN KEY (`user_login_id`, `wish_id`) REFERENCES `alertforwishapparel` (`user_login_id`, `wish_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishapparelbottoms`
--

LOCK TABLES `wishapparelbottoms` WRITE;
/*!40000 ALTER TABLE `wishapparelbottoms` DISABLE KEYS */;
/*!40000 ALTER TABLE `wishapparelbottoms` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `MessageOnCreateWishApparelBottoms` AFTER INSERT ON `wishapparelbottoms` FOR EACH ROW BEGIN

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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `wishapparelfootwear`
--

DROP TABLE IF EXISTS `wishapparelfootwear`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishapparelfootwear` (
  `user_login_id` varchar(30) NOT NULL,
  `wish_id` int NOT NULL,
  `size` decimal(5,2) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`user_login_id`,`wish_id`),
  CONSTRAINT `wishapparelfootwear_ibfk_1` FOREIGN KEY (`user_login_id`, `wish_id`) REFERENCES `alertforwishapparel` (`user_login_id`, `wish_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishapparelfootwear`
--

LOCK TABLES `wishapparelfootwear` WRITE;
/*!40000 ALTER TABLE `wishapparelfootwear` DISABLE KEYS */;
/*!40000 ALTER TABLE `wishapparelfootwear` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `MessageOnCreateWishApparelFootwear` AFTER INSERT ON `wishapparelfootwear` FOR EACH ROW BEGIN
 
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `wishappareltops`
--

DROP TABLE IF EXISTS `wishappareltops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishappareltops` (
  `user_login_id` varchar(30) NOT NULL,
  `wish_id` int NOT NULL,
  `size_group` enum('XS','S','M','L','XL','XXL') DEFAULT NULL,
  `sleeve_length` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`user_login_id`,`wish_id`),
  CONSTRAINT `wishappareltops_ibfk_1` FOREIGN KEY (`user_login_id`, `wish_id`) REFERENCES `alertforwishapparel` (`user_login_id`, `wish_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishappareltops`
--

LOCK TABLES `wishappareltops` WRITE;
/*!40000 ALTER TABLE `wishappareltops` DISABLE KEYS */;
INSERT INTO `wishappareltops` VALUES ('taiden',1,'L',NULL);
/*!40000 ALTER TABLE `wishappareltops` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `MessageOnCreateWishApparelTops` AFTER INSERT ON `wishappareltops` FOR EACH ROW BEGIN
 
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'auctionsite'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `CloseAuction` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `CloseAuction` ON SCHEDULE EVERY 1 MINUTE STARTS '2021-04-25 15:02:44' ON COMPLETION PRESERVE ENABLE DO BEGIN
    
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
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'auctionsite'
--
/*!50003 DROP PROCEDURE IF EXISTS `AutoBid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AutoBid`(IN auto_bid_auction_id INT)
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `PlaceAutoBid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `PlaceAutoBid`(IN auto_bid_auction_id INT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RemoveAutoBidding` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `RemoveAutoBidding`(IN auto_bid_auction_id INT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-04-25 15:03:44
