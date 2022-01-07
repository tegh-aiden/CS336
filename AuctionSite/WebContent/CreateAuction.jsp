<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="stylesAuctionSite.css">
	<title>Setup a new Auction</title>
</head>
<body>	
logged in as, <%=(String)(session.getAttribute("username"))%><br>
<!--Navigation bar-->
		<div id="nav-placeholder">
		
		</div>
		
		<script>
		$(function(){
		  $("#nav-placeholder").load("NavUser.html");
		});
		</script>
<!--end of Navigation bar-->
	<% 
		if (session == null || session.getAttribute("username") == null) {
			response.sendRedirect("LoginRegistration.jsp");
			return;
		}
		else if (!("user".equals(session.getAttribute("role")))) {
			response.sendRedirect("HomePageRedirect.jsp");
			return;
		}
	
		
		try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
	
			//Get parameters from the HTML form at the Login.jsp
			String username = (String)(session.getAttribute("username"));
			
			PreparedStatement ps;
			ResultSet rs;
	%>
	<h1 class="message">Sell Your Item: Enter Details</h1>
	<% 
	Integer errorCode = (Integer)session.getAttribute("errorCode");
	if (errorCode != null) { 
		if (errorCode.equals(-1)) {
	%>
	<h3 class="message error">Oops! Auction Setup Failed - Please fill out all fields!</h3>
	<%	
		}
		else if (errorCode.equals(-2)) {
	%>
	<h3 class="message error">Oops! Auction Setup Failed - Please select valid Category!</h3>
	<%	
		}
		else if (errorCode.equals(-3)) {
	%>
	<h3 class="message error">Oops! Auction Setup Failed - Please provide a valid Closing Date and Time!&nbsp;(Beyond Current Date and Time)</h3>
	<%	
		}
		session.removeAttribute("errorCode");
	}
	%>
	<form method="post" action="InsertAuction.jsp">
		<div id="auction_info" class="col">
			<h3 class="message">Auction Details</h3>
			<input type="text" name="auction_title" maxlength="100" placeholder="Auction Title" title="Set a title for the Auction (max. 100 characters)" required>
			<textarea name="description" maxlength="300" placeholder="Item Description" title="Describe your Item." required rows="10"></textarea>
			<input type="datetime-local" name="closing_time" step="600" placeholder="Auction Closing Date and Time" title="Enter closing date and time for the Auction.&#10;Enter in formay YYYY-MM-DD HH:MM" pattern="[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]0" required>
			<input type="number" inputmode="decimal" name="min_bid_increment" min="0" max="" step="0.01" placeholder="Minimum Bid Increment" title="Set the minimum bid increment for the next valid bid." required>
			<input type="number" inputmode="decimal" name="hidden_min" min="0" max="" step="0.01" placeholder="Hidden Minimum Selling Price" title="Set the hidden minimum selling price." required>
		</div>
		
		<div id="apparel_info" class="col">
			<h3 class="message">Apparel Details</h3>
			<input type="text" list="brands" name="brand" placeholder="Brand" minlength="1" maxlength="20" required>
			<select name="age_group">
				<option value="" disabled selected>Select Age Group</option>
				<option value="newborn">Newborns</option>				
				<option value="kids">Kids</option>
				<option value="teenager">Teenagers</option>
				<option value="20-39">Ages 20-39</option>
				<option value="40-59">Ages 40-59</option>
				<option value="60-80">Ages 60-80</option>
				<option value="80+">Ages 80+</option>
			</select>
			<input type="text" list="colors" name="color" placeholder="Color" minlength="1" maxlength="20" required>
			<select name="season" required="required">
				<option value="" disabled selected>Select Season</option>
				<option value="spring">Spring</option>				
			    <option value="summer">Summer</option>
			    <option value="fall">Fall</option>
			    <option value="winter">Winter</option>
			</select>
			<select name="gender" required>
				<option value="" disabled selected>Select Gender</option>
				<option value="M">Male</option>				
			    <option value="F">Female</option>
			    <option value="U">Unisex or Other</option>
			</select>
			<input type="text" list="materials" name="material" placeholder="Material" minlength="1" maxlength="30" required>
			<select name="category" id="apparelCategory" required onchange="categoryChange()">
				<option value="" disabled selected>Select Category</option>
				<option value="tops">Tops</option>				
			    <option value="bottoms">Bottoms</option>
			    <option value="footwear">Footwear</option>
			</select>				
			<select id="top_size" class="categories" name="top_size" required>
				<option value="" disabled selected>Select Size</option>
				<option value="XS">Extra Small</option>
				<option value="S">Small</option>
				<option value="M">Medium</option>
				<option value="L">Large</option>
				<option value="XL">Extra Large</option>
				<option value="XXL">Extra Extra Large</option>
			</select>
			<input id="top_sleeve_length" class="categories" type="number" inputmode="decimal" name="top_sleeve_length" min="0" max="50" step="0.01" placeholder="Sleeve Length (in inches)" title="Enter the sleeve length." required>
			<input id="waist_size" class="categories" type="number" inputmode="decimal" name="waist_size" min="15" max="50" step="0.01" placeholder="Waist Size (in inches)" title="Enter the waist size." required>
			<input id="pant_length" class="categories" type="number" inputmode="decimal" name="pant_length" min="5" max="40" step="0.01" placeholder="Pant length (in inches)" title="Enter the pant length." required>
			<input id="shoe_size" class="categories" type="number" inputmode="decimal" name="shoe_size" min="3" max="15" step="0.01" placeholder="Shoe Size (in inches)" title="Enter the shoe size." required>
			<input id="shoe_type" class="categories" type="text" list="footwearTypes" name="shoe_type" placeholder="Type" minlength="1" maxlength="20" required>
		</div>
						
		<input type="submit" value="Post Auction" title="Creates a new Auction for the given Apparel">
	</form>
		
	<%
			String selectBrands = "SELECT DISTINCT brand FROM Apparel";		
			ps = con.prepareStatement(selectBrands);
			rs = ps.executeQuery();
	%>
	<datalist id="brands">
	<%
			String brand = "";
			while (rs.next()) {
				brand = rs.getString(1);
	%>
			<option value="<%= brand %>">
	<%
			}		
	%>
	</datalist>
	<%
			String selectColors = "SELECT DISTINCT color FROM Apparel";
			ps = con.prepareStatement(selectColors);
			rs = ps.executeQuery();
	%>
	<datalist id="colors">
	<%
			String color = "";
			while (rs.next()) {
				color = rs.getString(1);
	%>
			<option value="<%= color %>">
	<%
			}		
	%>
	</datalist>
	<%
			String selectMaterial = "SELECT DISTINCT material FROM Apparel";
			ps = con.prepareStatement(selectMaterial);
			rs = ps.executeQuery();
	%>
	<datalist id="materials">
	<%
			String material = "";
			while (rs.next()) {
				material = rs.getString(1);
	%>
			<option value="<%= material %>">
	<%
			}		
	%>
	</datalist>
	<%
			String selectFootwearType = "SELECT DISTINCT type FROM Footwear";
			ps = con.prepareStatement(selectFootwearType);
			rs = ps.executeQuery();
	%>
	<datalist id="footwearTypes">
	<%
			String footwearType = "";
			while (rs.next()) {
				footwearType = rs.getString(1);
	%>
			<option value="<%= footwearType %>">
	<%
			}	
		
			rs.close();
			ps.close();			
			con.close();	
		} catch (Exception ex) {
			out.print(ex);
		}
	%>
	</datalist>			
	
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
			c1p1.required = false;
			c1p2.required = false;
			c2p1.required = false;
			c2p2.required = false;
			c3p1.required = false;
			c3p2.required = false;
			
			c1p1.style.visibility = 'visible';
			c1p2.style.visibility = 'visible';
			
			if (val === 'tops') {
				c1p1.style.display = 'inline-block';
				c1p2.style.display = 'inline-block';
				c1p1.required = true;
				c1p2.required = true;					
			}
			else if (val === 'bottoms') {
				c2p1.style.display = 'inline-block';
				c2p2.style.display = 'inline-block';
				c2p1.required = true;
				c2p2.required = true;		
			}
			else if (val === 'footwear') {
				c3p1.style.display = 'inline-block';
				c3p2.style.display = 'inline-block';
				c3p1.required = true;
				c3p2.required = true;		
			}
		}
	</script>		
</body>
</html>
