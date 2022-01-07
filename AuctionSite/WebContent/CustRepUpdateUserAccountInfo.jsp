<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="stylesAuctionSite.css">
	<meta http-equiv="Refresh" content="0; LoginRegistration.jsp">
	<title>Update User Account Information</title>
</head>
<body>	

	<% 
	if (session == null || session.getAttribute("username") == null) {
		System.out.println("session null or username null");
		response.sendRedirect("HomePageRedirect.jsp");
		return;
	}else if (!"customer_rep".equals(session.getAttribute("role"))) {
		System.out.println("account role not equal to cust_rep");
		response.sendRedirect("HomePageRedirect.jsp");
		return;
	} else{
		
	}
	
	try {

		System.out.println("trying connection");
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		System.out.println("connection successful");
		
		//Get parameters from the HTML form at the Login.jsp
		String uname = request.getParameter("uname");
		String password = request.getParameter("password");
		String fname = request.getParameter("fname");
		String lname = request.getParameter("lname");
		String email = request.getParameter("email");
		
		String select = "SELECT first_name, last_name, email, password FROM Account WHERE login_id = ? AND permissions_class = 'user'";
		
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(select);
		ps.setString(1,uname);
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			fname = (fname == null || fname.isEmpty()) ? rs.getString(1) : fname;
			lname = (lname == null || lname.isEmpty()) ? rs.getString(2) : lname;
			email = (email == null || email.isEmpty()) ? rs.getString(3) : email;
			password = (password == null || password.isEmpty()) ? rs.getString(4) : password;
		}
		else {
			response.sendRedirect("CustRepEditUserAccountInfo.jsp");
			return;
		}
		
		fname = fname.substring(0, 1).toUpperCase() + fname.substring(1);
		lname = lname.substring(0, 1).toUpperCase() + lname.substring(1);
		email = email.toLowerCase();
		
		System.out.println("Parameter intake complete");

		String update = "UPDATE account SET " +
				"password = ?, " +
				"email = ?, " +
				"first_name = ?, " +
				"last_name = ? " +
				"where login_id = ?";
				
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		ps = con.prepareStatement(update);
		System.out.println("prepare statement successful");

		//Add parameters of the query. Start with 1, the 0-parameter is the SELECT statement itself
		ps.setString(1, password);
		ps.setString(2, email);
		ps.setString(3, fname);
		ps.setString(4, lname);
		ps.setString(5, uname);
		System.out.println("set Strings all good");
		
		//Run the query against the DB
		int wasSuccess = 354;
		wasSuccess = ps.executeUpdate();
		
		System.out.println(wasSuccess);
		
		if(wasSuccess != 0){
			System.out.println("was successful");
		} else{
			System.out.println("NOT sucessful");			
		}
		

		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		ps.close();
		con.close();
		System.out.println("redirecting to Cust rep edit user account info page");
		response.sendRedirect("CustRepEditUserAccountInfo.jsp");
		return;
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>

</body>
</html>