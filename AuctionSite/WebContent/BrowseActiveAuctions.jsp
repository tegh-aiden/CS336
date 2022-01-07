<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.format.FormatStyle" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
	<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="stylesAuctionSite.css">
<title>Browse Auctions</title>
</head>
<body>
logged in as, <%=(String)(session.getAttribute("username"))%><br>
<%
	if (session == null || session.getAttribute("username") == null) {
		response.sendRedirect("LoginRegistration.jsp");
		return;
	}

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
<br>
	<h1 class="message">Browse Auctions</h1>
	<div  id="search_auction" class="col">
	<h3 class="message">Search</h3>
		<form method="get" action="BrowseActiveAuctions.jsp">
				<label for="sName">Seller name:</label><br>
		  		<input type="text" id="sName" name="sName" value=""><br>
		  		<label for="bName">Buyer name:</label><br>
		  		<input type="text" id="bName" name="bName" value=""><br>
		  		<label for="bid_value">Price</label><br>
				<select name="bid_value" size=1>
					<option value="">Choose a Price</option>
					<option value="1000.00">$1000.00 and under</option>
					<option value="50.00">$50.00 and under</option>
					<option value="30.00">$30.00 and under</option>
				</select>&nbsp;<br> 
				
			<label for="brand">Brand</label>
			<input type="text" list="brands" placeholder="Any" name="brand" minlength="1" maxlength="20">	
			
							
			<label for="color">Color</label>
			<input type="text" list="colors" placeholder="Any" name="color" minlength="1" maxlength="20">

			
			<label for="age_group">Age Group</label>
			<select name="age_group">
				<option value="none" selected>Any</option>
				<option value="newborn">Newborns</option>				
				<option value="kids">Kids</option>
				<option value="teenager">Teenagers</option>
				<option value="20-39">Ages 20-39</option>
				<option value="40-59">Ages 40-59</option>
				<option value="60-80">Ages 60-80</option>
				<option value="80+">Ages 80+</option>
			</select>
			
			<label for="season">Season</label>
			<select name="season">
				<option value="none" selected>Any</option>
				<option value="spring">Spring</option>				
			    <option value="summer">Summer</option>
			    <option value="fall">Fall</option>
			    <option value="winter">Winter</option>
			</select>
			
			<label for="gender">Gender</label>
			<select name="gender">
				<option value="none" selected>Any</option>
				<option value="M">Male</option>				
			    <option value="F">Female</option>
			    <option value="U">Unisex or Other</option>
			</select>
						
			<label for="material">Material</label>
			<input type="text" list="materials" placeholder="Any" name="material" minlength="1" maxlength="20">
			
			<label for="category">Category</label>
			<select name="category" id="apparelCategory" onchange="categoryChange()">
				<option value="none" selected>Any</option>
				<option value="tops">Tops</option>				
			    <option value="bottoms">Bottoms</option>
			    <option value="footwear">Footwear</option>
			</select>
			
			<select id="top_size" class="categories" name="top_size">
				<option value="" selected>Any</option>
				<option value="XS">Extra Small</option>
				<option value="S">Small</option>
				<option value="M">Medium</option>
				<option value="L">Large</option>
				<option value="XL">Extra Large</option>
				<option value="XXL">Extra Extra Large</option>
			</select>
			<input id="top_sleeve_length" class="categories" type="number" inputmode="decimal" name="top_sleeve_length" min="0" max="50" step="0.01" placeholder="Sleeve Length (in inches)" title="Enter the sleeve length.">
			<input id="waist_size" class="categories" type="number" inputmode="decimal" name="waist_size" min="15" max="50" step="0.01" placeholder="Waist Size (in inches)" title="Enter the waist size.">
			<input id="pant_length" class="categories" type="number" inputmode="decimal" name="pant_length" min="5" max="40" step="0.01" placeholder="Pant length (in inches)" title="Enter the pant length.">
			<input id="shoe_size" class="categories" type="number" inputmode="decimal" name="shoe_size" min="3" max="15" step="0.01" placeholder="Shoe Size (in inches)" title="Enter the shoe size.">
			<input id="shoe_type" class="categories" type="text" list="footwearTypes" name="shoe_type" placeholder="Type" minlength="1" maxlength="20">
		
			<h3>Sort by</h3>
			<select name="sort_by" required>
				<option value="" selected>Sort By</option>
				<option value="1">Closing Date (Earliest to Latest)</option>
				<option value="2">Closing Date (Latest to Earliest)</option>				
				<option value="3">Opening Date (Earliest to Latest)</option>
				<option value="4">Opening Date (Latest to Earliest)</option>
				<option value="5">Current Bid (Highest)</option>
				<option value="6">Current Bid (Lowest)</option>
			</select>	
								
				
			<input type="submit" value="Search and Sort">
		</form>	
	</div>	
	
		
<!-- In case we need to have this separate  ---

	<div  id="auction_info" class="col">
	<h3>Sort By</h3>
		<form method="POST" action="BrowseActiveAuctions.jsp">
	
			<select name="sort_by" required>
				<option value="" selected>Sort By</option>
				<option value="1">Closing Date (Earliest to Latest)</option>
				<option value="2">Closing Date (Latest to Earliest)</option>				
				<option value="3">Opening Date (Earliest to Latest)</option>
				<option value="4">Opening Date (Latest to Earliest)</option>
				<option value="5">Current Bid (Highest)</option>
				<option value="6">Current Bid (Lowest)</option>
			</select>	
			
			<input type="submit" value="Sort Auctions">	
		</form>		
	</div>	
-->
<%
	try{
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		String sort_by = "";
		if (request.getParameter("sort_by") != null){
			sort_by = request.getParameter("sort_by");
		}
		
		String brand = "";
		if (request.getParameter("brand") != null){
			brand = request.getParameter("brand");
		}
		
		String age_group = "";
		if (request.getParameter("age_group") != null){
			age_group = request.getParameter("age_group");
		}
		
		String color = "";
		if (request.getParameter("color") != null){
			color = request.getParameter("color");
		}
		
		String season = "";
		if (request.getParameter("season") != null){
			season = request.getParameter("season");
		}
		
		String gender = "";
		if (request.getParameter("gender") != null){
			gender = request.getParameter("gender");
		}
		
		String material = "";
		if (request.getParameter("material") != null){
			material = request.getParameter("material");
		}
		
		String category = "";
		if (request.getParameter("category") != null){
			category = request.getParameter("category");
		}
		
		String waist_size = "";
		if (request.getParameter("waist_size") != null){
			waist_size = request.getParameter("waist_size");
		}
		
		String pant_length = "";
		if (request.getParameter("pant_length") != null){
			pant_length = request.getParameter("pant_length");
		}
		
		String shoe_size = "";
		if (request.getParameter("shoe_size") != null){
			shoe_size = request.getParameter("shoe_size");
		}
		
		String shoe_type = "";
		if (request.getParameter("shoe_type") != null){
			shoe_type = request.getParameter("shoe_type");
		}
		
		String top_size = "";
		if (request.getParameter("top_size") != null){
			top_size = request.getParameter("top_size");
		}
		
		String top_sleeve_length = "";
		if (request.getParameter("top_sleeve_length") != null){
			top_sleeve_length = request.getParameter("top_sleeve_length");
		}		
		
		String selectColors = "SELECT DISTINCT color FROM Apparel";
		PreparedStatement ps = con.prepareStatement(selectColors);
		ResultSet rs = ps.executeQuery();
		%>
		<datalist id="colors">
		<%
		
				String c1 = "";
				while (rs.next()) {
					c1 = rs.getString(1);
		%>
				<option value="<%= c1 %>">
		<%
				}		
		%>
		</datalist>
		<%
		
		String selectBrands = "SELECT DISTINCT brand FROM Apparel";
		PreparedStatement ps_brand = con.prepareStatement(selectBrands);
		ResultSet rs_brand = ps_brand.executeQuery();
		%>
		<datalist id="brands">
		<%
		
		String b1 = "";
		while (rs_brand.next()) {
			b1 = rs_brand.getString(1);
		%>
		<option value="<%= b1 %>">
		<%
		}		
		%>
		</datalist>
		<%
		
		String selectMaterials = "SELECT DISTINCT material FROM Apparel";
		PreparedStatement ps_mats = con.prepareStatement(selectMaterials);
		ResultSet rs_mats = ps_mats.executeQuery();
		%>
		<datalist id="materials">
		<%
		
		String m1 = "";
		while (rs_mats.next()) {
			m1 = rs_mats.getString(1);
		%>
		<option value="<%= m1 %>">
		<%
		}		
		%>
		</datalist>
		<%
		
		
		String extraJoin = "";
		if (category.equals("tops")) {
			extraJoin = "join (select * from tops t where true ";
			
			if(!top_size.equals("")){
				extraJoin += " AND size_group = \'" + top_size + "\'";
			}
			
			if(!top_sleeve_length.equals("")){
				extraJoin += " AND sleeve_length >= \'" + top_sleeve_length + "\'";
			}
			
			extraJoin += ") ta using (item_id) ";
		}
		else if (category.equals("bottoms")) {
			extraJoin = "join (select * from bottoms b where true";
			
			if(!waist_size.equals("")){
				extraJoin += " AND waist_size >= \'" + waist_size + "\'";
			}
			
			if(!pant_length.equals("")){
				extraJoin += " AND length >= \'" + pant_length + "\'";
			}
			
			extraJoin += ") ba using (item_id) ";
		}
		else if (category.equals("footwear")) {
			extraJoin = "join (select * from footwear f where true";
			
			if(!shoe_type.equals("")){
				extraJoin += " AND type = \'" + shoe_type + "\'";
			}
			
			if(!shoe_size.equals("")){
				extraJoin += " AND size >= \'" + shoe_size + "\'";
			}
			
			extraJoin += ") fa using (item_id) ";
		}
		
		String str = "select a.auction_id, a.seller_login_id, p.bidder_login_id, a.title, p.bid_value as bid_value, " +
				     "a.posted_date_time, a.closing_date_time, " +
					 "app.category, app.brand, app.age_group, app.color, app.season, app.gender, app.material " +
				     "from auctionsellsbuys a " +
				     "left join  (select auction_id, max(bid_value) as bid_value " +
					 "from placesbid " +
					 "group by auction_id) b " +
					 "using (auction_id) " +
			         "left join placesbid p using (auction_id, bid_value) " +
					 "left join apparel app " + 
			         "using (item_id) " +
					 extraJoin +
					 "where true ";
		
		String sName = (request.getParameter("sName"));
		if (sName == null) sName = "";
		if (sName.length() != 0){
			str = str + " AND seller_login_id = \'" + sName + "\'";	
			
		}
		
		String bName = request.getParameter("bName");
		if (bName == null) bName = "";
		if (bName.length() != 0){
			str = str + " AND bidder_login_id = \'" + bName + "\'";
		}
		
		String bid_value = request.getParameter("bid_value");
		if (bid_value == null) bid_value = "";
		if (bid_value.length() != 0){
			str = str + " AND bid_value <= " + bid_value;
		}
		
		str = str + " AND closing_date_time > CURRENT_TIMESTAMP()";

		
		
		//location of other sort criteria
		if(request.getParameter("category") != null && !category.equals("none")){
			str = str + " AND category = \'" + category + "\'";
		}
		
		if(request.getParameter("brand") != null && !brand.equals("")){
			str = str + " AND brand = \'" + brand + "\'";
		}
		
		if(request.getParameter("age_group") != null && !age_group.equals("none")){
			str = str + " AND age_group = \'" + age_group + "\'";
		}
		
		if(request.getParameter("color") != null && !color.equals("")){
			str = str + " AND color = \'" + color + "\'";
		}
		
		if(request.getParameter("season") != null && !season.equals("none")){
			str = str + " AND season = \'" + season + "\'";
		}
		
		if(request.getParameter("gender") != null && !gender.equals("none")){
			str = str + " AND gender = \'" + gender + "\'";
		}
		
		if(request.getParameter("material") != null && !material.equals("")){
			str = str + " AND material = \'" + material + "\'";
		}
		

		if(request.getParameter("sort_by") != null){
			if(sort_by.equals("1")){
				str = str + " ORDER BY closing_date_time ASC";
			}
			if(sort_by.equals("2")){
				str = str + " ORDER BY closing_date_time DESC";
			}
			if(sort_by.equals("3")){
				str = str + " ORDER BY posted_date_time ASC";
			}
			if(sort_by.equals("4")){
				str = str + " ORDER BY posted_date_time DESC";
			}
			if(sort_by.equals("5")){
				str = str + " ORDER BY bid_value DESC";
			}
			if(sort_by.equals("6")){
				str = str + " ORDER BY bid_value ASC";
			}
		}
		
		
		System.out.println(str);
		
		//Create a SQL statement
		Statement stmt = con.createStatement();
				
		ResultSet result = stmt.executeQuery(str);
		out.print("&nbsp;");
		out.print("<div id=\"user_search_result\" class=\"container\">");
		out.print("<table>");
		out.print("<tr>");
		
		out.print("<th>");
		out.print("Auction ID");
		out.print("</th>");
		out.print("<th>");
		out.print("Seller");
		out.print("</th>");
		
		out.print("<th>");
		out.print("Highest Bidder");
		out.print("</th>");
		
		out.print("<th>");
		out.print("Title");
		out.print("</th>");
		
		out.print("<th>");
		out.print("Highest Bid");
		out.print("</th>");
		
		out.print("<th>");
		out.print("Posted On");
		out.print("</th>");
		
		out.print("<th>");
		out.print("Closes On");
		out.print("</th>");
		
		out.print("</tr>");
		
		DateTimeFormatter formatter = DateTimeFormatter.ofLocalizedDateTime(FormatStyle.FULL, FormatStyle.MEDIUM);
		LocalDateTime startDateTime, closeDateTime;
		String start_date_time, close_date_time; 
		
		if (!result.next()) {
			out.print("<tr>");
			out.print("<td colspan=\"7\">");
			out.print("No Auction Found");
			out.print("</td>");
			out.print("</tr>");
		}
		else {
		do {
			System.out.println(result.getInt("auction_id"));
			startDateTime = LocalDateTime.parse(result.getString("posted_date_time").replace(" ", "T"));
			start_date_time = startDateTime.format(formatter);
			closeDateTime = LocalDateTime.parse(result.getString("closing_date_time").replace(" ", "T"));
			close_date_time = closeDateTime.format(formatter);
						
			out.print("<tr>");
			
			out.print("<td>");
			out.print("<a href=\"AuctionPage.jsp?auction_id=" + result.getString("auction_id") + "\">");
			out.print(result.getString("auction_id"));
			out.print("</a>");
			out.print("</td>");
			out.print("<td>");
			out.print("<a href=\"UserHomePage.jsp?username=" + result.getString("seller_login_id") + "\">");
			out.print(result.getString("seller_login_id"));
			out.print("</a>");
			out.print("</td>");
			
			out.print("<td>");
			if (result.getString("bidder_login_id") != null) {
				out.print("<a href=\"AuctionPage.jsp?auction_id=" + result.getString("bidder_login_id") + "\">");
				out.print(result.getString("bidder_login_id"));
				out.print("</a>");
			}
			out.print("</td>");
			
			out.print("<td>");
			out.print(result.getString("title"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(result.getFloat("bid_value"));
			out.print("</td>");
			
			out.print("<td>");
			out.print(start_date_time);
			out.print("</td>");
			
			out.print("<td>");
			out.print(close_date_time);
			out.print("</td>");
			
			out.print("</tr>");
		} while (result.next());
		}
		out.print("</table>");
		out.print("</div>");
		
		result.close();
		con.close();
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>
<script>
		function categoryChange() {
			var c = document.getElementById("apparelCategory");
			var val = c.value;
			
			var c1p1 = document.getElementById("top_size");
			var c1p2 = document.getElementById("top_sleeve_length");
			var c2p1 = document.getElementById("waist_size");
			var c2p2 = document.getElementById("pant_length");
			var c3p1 = document.getElementById("shoe_size");
			var c3p2 = document.getElementById("shoe_type");
			c1p1.style.display = 'none';
			c1p2.style.display = 'none';
			c2p1.style.display = 'none';
			c2p2.style.display = 'none';
			c3p1.style.display = 'none';
			c3p2.style.display = 'none';
			
			c1p1.style.visibility = 'visible';
			c1p2.style.visibility = 'visible';
			
			if (val === 'tops') {
				c1p1.style.display = 'inline-block';
				c1p2.style.display = 'inline-block';					
			}
			else if (val === 'bottoms') {
				c2p1.style.display = 'inline-block';
				c2p2.style.display = 'inline-block';
			}
			else if (val === 'footwear') {
				c3p1.style.display = 'inline-block';
				c3p2.style.display = 'inline-block';
			}
		}
	</script>
</body>
</html>