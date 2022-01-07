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
	else if (!"user".equals(session.getAttribute("role"))) {
		response.sendRedirect("HomePageRedirect.jsp");
		return;
	}

	try {
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		//Get parameters from the HTML form at the Login.jsp
		String wish_id = request.getParameter("wish_id");
		if (wish_id == null) {
			response.sendRedirect("HomePageRedirect.jsp");
			return;
		}

		String brand = "";
		String age_group = "";
		String color = "";
		String season = "";
		String gender = "";
		String material = "";
		String category = "";
		
		String[] categoryInfo = new String[]{"",""};
		String[] categoryInfoTitle = new String[]{"",""};
		
		String selectWishInfo = "SELECT brand, age_group, color, season, gender, material, category from AlertForWishApparel WHERE wish_id = ? AND user_login_id = ?";
		
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(selectWishInfo);

		ps.setString(1, wish_id);
		ps.setString(2, (String) session.getAttribute("username"));
		//Run the query against the DB
		ResultSet rs = ps.executeQuery();
		
		if (rs.next()) {
			brand = rs.getString(1) == null ? "Any" : (rs.getString(1).substring(0, 1).toUpperCase() + rs.getString(1).substring(1).toLowerCase());
			age_group = rs.getString(2) == null ? "Any" : (rs.getString(2).substring(0, 1).toUpperCase() + rs.getString(2).substring(1).toLowerCase());
			color = rs.getString(3) == null ? "Any" : (rs.getString(3).substring(0, 1).toUpperCase() + rs.getString(3).substring(1).toLowerCase());
			season = rs.getString(4) == null ? "Any" : (rs.getString(4).substring(0, 1).toUpperCase() + rs.getString(4).substring(1).toLowerCase());
			gender = rs.getString(5) == null ? "Any" : rs.getString(5);
			material = rs.getString(6) == null ? "Any" : (rs.getString(6).substring(0, 1).toUpperCase() + rs.getString(6).substring(1).toLowerCase());
			category = rs.getString(7) == null ? "Any" : (rs.getString(7).substring(0, 1).toUpperCase() + rs.getString(7).substring(1).toLowerCase());
		}
		
		if (!category.equals("Any")) {
			category = category.substring(0,1).toUpperCase() + category.substring(1);
			String selectCategoryInfo = "SELECT * FROM WishApparel" + category + " WHERE wish_id = ? AND user_login_id = ?";
			ps = con.prepareStatement(selectCategoryInfo);
			ps.setString(1, wish_id);
			ps.setString(2, (String) session.getAttribute("username"));
			rs = ps.executeQuery();
			
			if (rs.next()) {
				categoryInfo[0] = rs.getString(3) == null ? "Any" : rs.getString(3);
				categoryInfo[1] = rs.getString(4) == null ? "Any" : (rs.getString(4).substring(0, 1).toUpperCase() + rs.getString(4).substring(1).toLowerCase());
			}
			else {
				response.sendRedirect("HomePageRedirect.jsp");
				return;
			}
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
%>
<html>
<head>
	<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="stylesAuctionSite.css">
	<title>My Alert - <%= wish_id %></title>
</head>
<body>
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
	<h1 class="message">Alert - <%= wish_id %></h1>
	<table id="info">		
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
<% 
		if (!category.equals("Any")) {
%>				
		<tr>
			<td><%= categoryInfoTitle[0] + ":" %></td>
			<td><%= categoryInfo[0] %></td>
		</tr>
		<tr>
			<td><%= categoryInfoTitle[1] + ":" %></td>
			<td><%= categoryInfo[1] %></td>
		</tr>
<%
		}
%>
		<tr>
			<td colspan="2">
				<form method="post" action="DeleteAlert.jsp">
					<input type="hidden" name="wish_id" value="<%= wish_id %>">
					<input type="submit" value="Delete this Alert" title="Deletes this Alert">
				</form>	
			</td>
		</tr>
	</table>		
<%		
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		rs.close();
		ps.close();			
		con.close();
	} catch (Exception ex) {
		out.print(ex);
	}
%> 
</body>
</html>