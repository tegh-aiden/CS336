<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.format.FormatStyle" %>
<!DOCTYPE html>
<% 
	if (session == null || session.getAttribute("username") == null) {
		response.sendRedirect("LoginRegistration.jsp");
		return;
	}
	try {
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		//Get parameters from the HTML form at the Login.jsp
		boolean refreshNeeded = false;
		String auction_id = "";
		String req_auction_id = request.getParameter("auction_id");
		Integer ss_auction_id = (Integer)(session.getAttribute("auction_id"));
		if (req_auction_id == null && ss_auction_id == null) {
			response.sendRedirect("HomePageRedirect.jsp");
			return;
		}
		else if (req_auction_id != null) {
			auction_id = req_auction_id;
		}
		else {
			auction_id = ss_auction_id.toString();
			refreshNeeded = true;
		}
		session.removeAttribute("auction_id");
		
		String item_id = "";
		String seller_login_id = "";
		String title = "";
		String description = "";
		String posted_date_time = "";
		String closing_date_time = "";
		String minimum_bid_increment = "";
		String buyer_login_id = "";
		String price = "";
		
		String brand = "";
		String age_group = "";
		String color = "";
		String season = "";
		String gender = "";
		String material = "";
		String category = "";
		
		String[] categoryInfo = new String[]{"",""};
		String[] categoryInfoTitle = new String[]{"",""};
		
		String selectAuctionInfo = "SELECT item_id, seller_login_id, title, description, posted_date_time, closing_date_time, minimum_bid_increment, buyer_login_id, price FROM auctionsellsbuys WHERE auction_id = ?";
		
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(selectAuctionInfo);

		ps.setString(1, auction_id);
		//Run the query against the DB
		ResultSet rs = ps.executeQuery();
		
		DateTimeFormatter formatter = DateTimeFormatter.ofLocalizedDateTime(FormatStyle.FULL, FormatStyle.MEDIUM);
		LocalDateTime dateTime; 

		if (rs.next()) {
			item_id = rs.getString(1);
			seller_login_id = rs.getString(2);
			title = rs.getString(3);
			description = rs.getString(4);
			
			dateTime = LocalDateTime.parse(rs.getString(5).replace(" ", "T"));
			posted_date_time = dateTime.format(formatter);
			
			dateTime = LocalDateTime.parse(rs.getString(6).replace(" ", "T"));
			closing_date_time = dateTime.format(formatter);
			minimum_bid_increment = rs.getString(7);
			buyer_login_id = rs.getString(8);			
			price = rs.getString(9);					
		}
		else {
			response.sendRedirect("HomePageRedirect.jsp");
			return;
		}
		
		String selectApparelInfo = "SELECT brand, age_group, color, season, gender, material, category from Apparel WHERE item_id = ?";
		ps = con.prepareStatement(selectApparelInfo);
		ps.setString(1, item_id);
		rs = ps.executeQuery();
		
		if (rs.next()) {
			brand = rs.getString(1);
			age_group = rs.getString(2);
			color = rs.getString(3);
			season = rs.getString(4);
			gender = rs.getString(5);
			material = rs.getString(6);
			category = rs.getString(7);
		}
		
		if (category != null && !category.isEmpty()) {
			category = category.substring(0,1).toUpperCase() + category.substring(1);
			String selectCategoryInfo = "SELECT * FROM " + category + " WHERE item_id = ?";
			ps = con.prepareStatement(selectCategoryInfo);
			ps.setString(1, item_id);
			rs = ps.executeQuery();
			
			if (rs.next()) {
				categoryInfo[0] = rs.getString(2);
				categoryInfo[1] = rs.getString(3);
			}
			else {
				response.sendRedirect("HomePageRedirect.jsp");
				return;
			}
		}
		else {
			response.sendRedirect("HomePageRedirect.jsp");
			return;
		}
		
		if (age_group != null && !age_group.isEmpty()) {
			age_group = age_group.substring(0,1).toUpperCase() + age_group.substring(1);
		}
		else {
			response.sendRedirect("HomePageRedirect.jsp");
			return;
		}
		
		if (season != null && !season.isEmpty()) {
			season = season.substring(0,1).toUpperCase() + season.substring(1);
		}
		else {
			response.sendRedirect("HomePageRedirect.jsp");
			return;
		}
		
		if (gender != null && !gender.isEmpty()) {
			if (gender.equals("M")) {
				gender = "Men | Boys";
			}
			else if (gender.equals("F")) {
				gender = "Female | Girls";
			}
			else {
				gender = "Unisex or Other";
			}
		}
		else {
			response.sendRedirect("HomePageRedirect.jsp");
			return;
		}
		
		
		if (category.equals("Tops")) {
			categoryInfoTitle[0] = "Size";
			categoryInfoTitle[1] = "Sleeve Length";
		}
		else if (category.equals("Bottoms")) {
			categoryInfoTitle[0] = "Waist Size";
			categoryInfoTitle[1] = "Pant Length";			
		}
		else if (category.equals("Footwear")) {
			categoryInfoTitle[0] = "Size";
			categoryInfoTitle[1] = "Type";			
		}
		
		String refresh = "AuctionPage.jsp?auction_id=" + auction_id; 
		int timeToRefresh = refreshNeeded ? 0 : -1;
		
		String biddingDisplay = "block";
		if (LocalDateTime.now().isAfter(dateTime) || seller_login_id ==  null || seller_login_id.equals(session.getAttribute("username")) || !"user".equals(session.getAttribute("role"))) {
			biddingDisplay = "none";
		}
			
		String deleteAuctionDisplay =  "none";
		if ("customer_rep".equals(session.getAttribute("role"))) {
			deleteAuctionDisplay = "initial";
		}
%>
<html>
<head>
	<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta http-equiv="refresh" content="<%= timeToRefresh %>,<%= refresh %>">
	<link rel="stylesheet" href="stylesAuctionSite.css">
	<title><%= title %></title>
</head>
<body onload="changeDisplayedOptions()">
logged in as, <%=(String)(session.getAttribute("username"))%><br>
<%
	String navCode = "";
	if ("user".equals(session.getAttribute("role"))) {
		navCode = "\"NavUser.html\"";
	}else if("customer_rep".equals(session.getAttribute("role"))){
		navCode = "\"NavCustServ.html\"";
	}else{
		//admin
		navCode = "\"NavAdmin.html\"";
	}
	System.out.println(navCode);
%>
<!--Navigation bar-->
		<div id="nav-placeholder">
		
		</div>
		
		<script>
		$(function(){
		  $("#nav-placeholder").load(<%=navCode%>);
		});
		</script>
<!--end of Navigation bar-->
	<h1 class="message"><%= title %></h1>
	<table id="info">
	<%
		if (LocalDateTime.now().isAfter(dateTime)) { 
			if (buyer_login_id != null) {	
	%>
		<tr>
			<td>Buyer:</td>
			<td><a href="UserHomePage.jsp?username=<%= buyer_login_id %>"><%= buyer_login_id %></a></td>
		</tr>
		<tr>
			<td>Sold at Price:</td>
			<td><%= price %></td>
		</tr>
	<%
			}
			else {
	%>
		<tr>
			<td colspan="2">RETRACTED (NOT SOLD)</td>
		</tr>
	<%		
			}
		}
	%>	<tr>
			<td>Description:</td>
			<td><p><%= description %></p></td>
		</tr>
		<tr>
			<td>Started On:</td>
			<td><%= posted_date_time %></td>
		</tr>
		<tr>
	<%
		if(LocalDateTime.now().isBefore(dateTime)) {	
	%>
			<td>Closes On:</td>
	<%
		}
		else {
	%>
			<td>Closed On:</td>			
	<%
		}
	%>
			<td><%= closing_date_time %></td>
		</tr>
		<tr>
			<td>Seller:</td>
			<td><a href="UserHomePage.jsp?username=<%= seller_login_id %>"><%= seller_login_id %></a></td>
		</tr>	
		<tr>
			<td>Category:</td>
			<td><%= category %></td>
		</tr>
		<tr>
			<td>Brand:</td>
			<td><%= brand %></td>
		</tr>
		<tr>
			<td>Season:</td>
			<td><%= season %></td>
		</tr>
		<tr>
			<td>Material:</td>
			<td><%= material %></td>
		</tr>
		<tr>
			<td>Gender:</td>
			<td><%= gender %></td>
		</tr>
		<tr>
			<td>Age Group:</td>
			<td><%= age_group %></td>
		</tr>
		<tr>
			<td>Color:</td>
			<td><%= color %></td>
		</tr>				
		<tr>
			<td><%= categoryInfoTitle[0] + ":" %></td>
			<td><%= categoryInfo[0] %></td>
		</tr>
		<tr>
			<td><%= categoryInfoTitle[1] + ":" %></td>
			<td><%= categoryInfo[1] %></td>
		</tr>
	</table>
	
	<form action="SimilarAuctions.jsp" method="POST">
		<input type = "hidden" name = "item_id" value = "<%= item_id %>" />
		<input type = "hidden" name = "auction_id" value = "<%= auction_id %>" />
		<input type = "hidden" name = "brand" value = "<%= brand %>" />
		<input type = "hidden" name = "age_group" value = "<%= age_group %>" />
		<input type = "hidden" name = "color" value = "<%= color %>" />
		<input type = "hidden" name = "season" value = "<%= season %>" />
		<input type = "hidden" name = "gender" value = "<%= gender %>" />
		<input type = "hidden" name = "material" value = "<%= material %>" />
		<input type = "hidden" name = "category" value = "<%= category %>" />
		<input type = "submit" name = "sim_auct_button" value = "Similar Auctions" />
	</form>
	
	<select id="auction_option_grp" onchange="changeDisplayedOptions()">
		<option value="0" disabled selected>Select Options to Display</option>
		<option value="1" style="display:<%= biddingDisplay %>" >Show Bidding Window</option>
		<option value="2">Show History of Bids</option>
		<option value="3" style="display:<%= deleteAuctionDisplay %>">Delete Auction</option>	
	</select>
	
	<% 
		boolean autoBidding = true;
	    double bidIncrement = 0.01;
		double upperLimit = 0.01;
		boolean isAnonymous = true;
		
		if (biddingDisplay.equals("block")) {
			String selectOptions = "SELECT s.auto_bidding, s.auto_bidding_increment, s.upper_limit, s.is_anonymous FROM SetOptions s WHERE auction_id = ? AND bidder_login_id = ?";
			ps = con.prepareStatement(selectOptions);
			ps.setString(1, auction_id);
			ps.setString(2, (String)(session.getAttribute("username")));
			
			rs = ps.executeQuery();
			if (rs.next()) {
				if (!rs.getBoolean(1)) {
					autoBidding = false;
				}
				
				bidIncrement = rs.getDouble(2);
				upperLimit = rs.getDouble(3);
				
				if (!rs.getBoolean(4)) {
					isAnonymous = false;
				}
			}
		}
	%>
	<div id="bidding">
		<form id="bid_options" class="col" method="post" action="SetBidOptions.jsp">
			<h3 class="message">Set Bidding Options</h3>
			<input id="auto_bidding" type="checkbox" name="auto_bidding" value="true" <% if (autoBidding) { %> checked <% } %> title="Select to enable AutoBidding feature." onchange="autobiddingChange()">
			<label>AutoBidding</label><br>
			<label>Set Bid Increment</label><br>
			<input id="bid_increment" type="number" name="bid_increment" min="0.01" step="0.01" value="<%= bidIncrement %>" <% if (!autoBidding) { %> disabled <% } else { %> required <% } %> placeholder="Enter bid increment for AutoBidding" title="Set a bid increment for AutoBidding (in $).">
			<label>Set Upper Limit</label><br>
			<input id="upper_limit" type="number" name="upper_limit" min="0.01" step="0.01" value="<%= upperLimit %>" <% if (!autoBidding) { %> disabled <% } else { %> required <% } %> placeholder="Enter upper limit for AutoBidding" title="Set an upper limit to AutoBidding (in $).">
			<input type="checkbox" name="is_anonymous" value="true" <% if (isAnonymous) { %> checked <% } %> title="Select to show up as Anonymous to other Bidders.">
			<label>Anonymous to other Bidders</label><br>
			<input type="hidden" name="auction_id" value="<%= auction_id%>">					
			<input type="submit" value="Set Bidding Options" title="Place your bid and set bidding options.">
		</form>
		<form id="place_bid" class="col" method="post" action="PlaceBid.jsp">
			<h3 class="message">Place a Bid</h3>
			<input type="hidden" name="auction_id" value="<%= auction_id%>">	
			<input type="number" name="bid_value" min="0.01" step="0.01" placeholder="Enter amount to Bid" title="Enter your bid value (in $).">
			<input type="submit" value="Place your Bid" title="Place your bid.">
		</form>	
	</div>
	
	<%
		String selectBids = "SELECT p.bidder_login_id, p.bid_value, p.bid_date_time, s.is_anonymous " +
							"FROM placesbid p, setoptions s " +
							"WHERE p.auction_id = s.auction_id AND p.bidder_login_id = s.bidder_login_id AND p.auction_id = ? " +
							"ORDER BY p.bid_value DESC";
		ps = con.prepareStatement(selectBids);
		ps.setInt(1, Integer.parseInt(auction_id));
		rs = ps.executeQuery();
	%>		
	
		
	<div id="bidding_history" class="container">
		<table>
			<tr>
				<th>Bidder</th>
				<th>Bid Value</th>
				<th>Bid Date and Time</th>	
	<%
		int noBidHistoryColSpan = 3;
	
		if ("customer_rep".equals(session.getAttribute("role"))) {
			noBidHistoryColSpan = 4;
	%>
				<th>Delete Bid</th>
	<%
		}
	%>
			</tr>
	<%	
		if (!rs.next()) {
	%>
			<tr>
				<td colspan="<%= noBidHistoryColSpan %>">No Bids Placed Yet!</td>
			</tr>
	<%
		}
		rs.beforeFirst();
		while(rs.next()) {
			dateTime = LocalDateTime.parse(rs.getString(3).replace(" ", "T"));	
			System.out.println("detected tuple; " + rs.getString(1)+ " " + rs.getInt(2) + " " + dateTime + " " + rs.getBoolean(4));		
	%>
			<tr>
	<%		//rs.getBoolean(4) <-- refers to the anon status of the current user However code was looking for autobidding status
			
			if (!rs.getBoolean(4) || ( rs.getString(1).equals(session.getAttribute("username")) 
					|| seller_login_id.equals(session.getAttribute("username")) 
					|| "customer_rep".equals(session.getAttribute("role")))) {
				System.out.println(rs.getString(1));
	%>
				<td><a href="UserHomePage.jsp?username=<%= rs.getString(1) %>"><%= rs.getString(1) %></a></td>
	<%
			}
			else {
				System.out.println("anon");
	%>
				<td>Anonymous Bidder</td>
	<%
			}
	%>
				<td><%= rs.getString(2) %></td>
				<td><%= dateTime.format(formatter) %></td>	
	<%
		if ("customer_rep".equals(session.getAttribute("role"))) {
	%>
				<td>
					<form method="post" action="CustRepDeleteBid.jsp">
						<input type="hidden" name="auction_id" value="<%= auction_id%>">
						<input type="hidden" name="bidder_uname" value="<%= rs.getString(1)%>">
						<input type="hidden" name="bid_value" value="<%= rs.getString(2)%>">
						<input type="submit" value="Delete Bid">
					</form>
				</td>
	<%
		}
	%>				
			</tr>
	<%
		}
	%>
		</table>
	</div>
	
	
	<form id="delete_auction" method="post" action="CustRepDeleteAuction.jsp">
		<h3 class="message">Delete Auction</h3>
		<input type="hidden" name="auction_id" value="<%= auction_id %>">
		<input type="submit" value="Delete this Auction" title="Deletes this Auction">
	</form>		
		
		
<%		
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		rs.close();
		ps.close();			
		con.close();
	} catch (Exception ex) {
		out.print(ex);
	}
%>  	
  	<script>
		function autobiddingChange() {
			var ab = document.getElementById("auto_bidding");
			var bi = document.getElementById("bid_increment");
			var ul =  document.getElementById("upper_limit");
			if (ab.checked) {
				bi.disabled = false;
				bi.required = true;
				ul.disabled = false;
				ul.required = true;
			}
			else {
				bi.disabled = true;		
				bi.required = false;
				ul.disabled = true;		
				ul.required = false;
			}
		}
		
		function changeDisplayedOptions() {
			var g = document.getElementById("auction_option_grp");
			var val = g.value;
			
			var g1 = document.getElementById("bidding");
			var g2 = document.getElementById("bidding_history");
			var g3 = document.getElementById("delete_auction");
			
			g1.style.display = 'none';
			g2.style.display = 'none';
			g3.style.display = 'none';
			
			if (val === '1') {
				g1.style.display = 'block';
			}
			else if (val === '2') {
				g2.style.display = 'table';
			}
			else if (val === '3') {
				g3.style.display = 'block';		
			}
		}
	</script>
</body>
</html>