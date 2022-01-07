<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeParseException" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
	<link rel="stylesheet" href="stylesAuctionSite.css">
	<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
<title>Browse Questions</title>
</head>



<body>	
logged in as, <%=(String)(session.getAttribute("username"))%><br>
	<!--Navigation bar-->
		<div id="nav-placeholder">
		
		</div>
		
		<script>
		$(function(){
		  $("#nav-placeholder").load("NavCustServ.html");
		});
		</script>
	<!--end of Navigation bar-->
<%
	if (session == null || session.getAttribute("username") == null) {
		response.sendRedirect("LoginRegistration.jsp");
		return;
	}
	else if (!("customer_rep".equals(session.getAttribute("role")))) {
		response.sendRedirect("HomePageRedirect.jsp");
		return;
	}
	
	try {
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		String select = "SELECT question_id, question FROM questionanswer WHERE answer = ''";
		Statement stmt = con.createStatement();
		ResultSet rs = stmt.executeQuery(select);

		
%>
	<table>
		<tr>
			<td style="width=100%">
				<!-- question query display -->
				<table>
					<tr>
						<%
							ResultSetMetaData rsmd = rs.getMetaData();
							int columnsNumber = rsmd.getColumnCount();
							//rs.next();
							for (int i = 1; i <= columnsNumber; i++){
								String colName = rsmd.getColumnName(i);
								%>
								<td>
									<label><%= colName %></label>
								</td>
								<%
							}
						%>
					</tr>
					<%
					while(rs.next()){
						String colValue1 = rs.getString(1);
						String colValue2 = rs.getString(2);
					%>
						<tr>
							<td>
								<label><%= colValue1 %></label>
							</td>
							<td>
								<label><%= colValue2 %></label>
							</td>
						</tr>
					<%
					}
					%>
					
					
				
				</table>
			</td>
			<td style="vertical-align:top">
				<form id="custRep_answer"  method="post" action="CustRepUpdateAnswer.jsp" autocomplete="on">
					<!-- Section to answer query -->
					<label for="q_id">Question_ID:</label>
						<input type="number" name="question_id" id="q_id" value="">
					<label for="cr_answer">Answer</label>
						<textarea id="cr_answer" name="cr_answer" maxlength="300" rows="4" cols="50"></textarea>
					<input type="submit" name="submit" id="" value="Submit Answer">
				</form>
			</td>
		
		</tr>
	
	</table>

<%	
		
		
		
		
		
		
	} catch(Exception ex){
		out.print(ex);
	}
		
		
%>

</body>
</html>