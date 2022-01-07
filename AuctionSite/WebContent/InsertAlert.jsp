<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Insert an Alert</title>
</head>
<body>
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
			
			Statement stmt = con.createStatement();		
			
			String brand = request.getParameter("brand");
			if ("".equals(brand)) brand = null;
			
			String age_group = request.getParameter("age_group");
			if ("".equals(age_group)) age_group = null;
			
			String color = request.getParameter("color");
			if ("".equals(color)) color = null;
			
			String season = request.getParameter("season");
			if ("".equals(season)) season = null;
			
			String gender = request.getParameter("gender");
			if ("".equals(gender)) gender = null;
			
			String material = request.getParameter("material");
			if ("".equals(material)) material = null;
			
			String category = request.getParameter("category");
			if ("".equals(category)) category = null;
			
			String waist_size = request.getParameter("waist_size");
			if ("".equals(waist_size)) waist_size = null;
			
			String pant_length = request.getParameter("pant_length");
			if ("".equals(pant_length)) pant_length = null;
			
			String shoe_size = request.getParameter("shoe_size");
			if ("".equals(shoe_size)) shoe_size = null;
			
			String shoe_type = request.getParameter("shoe_type");
			if ("".equals(shoe_type)) shoe_type = null;
			
			String top_size = request.getParameter("top_size");
			if ("".equals(top_size)) top_size = null;
			
			String top_sleeve_length = request.getParameter("top_sleeve_length");
			if ("".equals(top_sleeve_length)) top_sleeve_length = null;
			
			String user_id = (String)session.getAttribute("username");
			
			String extraAttributes = "";
			String extraJoin = "";	
			
			if ("tops".equals(category)){	
				extraAttributes = "s.size_group, s.sleeve_length ";
				extraJoin = "JOIN (SELECT * FROM WishApparelTops t WHERE TRUE ";
				
				if(top_size != null){
					extraJoin += " AND t.size_group = \'" + top_size + "\'";
				}
				else {
					extraJoin += " AND t.size_group IS NULL";	
				}
				
				if(top_sleeve_length != null){
					extraJoin += " AND t.sleeve_length = \'" + top_sleeve_length + "\'";
				}
				else {
					extraJoin += " AND t.sleeve_length IS NULL";
				}
				
				extraJoin += ") s USING (user_login_id, wish_id) ";
			}
			else if ("bottoms".equals(category)){			
				extraAttributes = "s.waist_size, s.length ";
				extraJoin = "JOIN (SELECT * FROM WishApparelBottoms b WHERE TRUE ";
				
				if(waist_size != null){
					extraJoin += " AND b.waist_size = \'" + waist_size + "\'";
				}
				else {
					extraJoin += " AND b.waist_size IS NULL";	
				}
				
				if(pant_length != null){
					extraJoin += " AND b.length = \'" + pant_length + "\'";
				}
				else {
					extraJoin += " AND b.length IS NULL";
				}
				
				extraJoin += ") s USING (user_login_id, wish_id) ";
			}
			else if ("footwear".equals(category)){			
				extraAttributes = "s.size, s.type ";	
				extraJoin = "JOIN (SELECT * FROM WishApparelFootwear f WHERE TRUE ";
				
				if(shoe_type != null){
					extraJoin += " AND f.type = \'" + shoe_type + "\'";
				}
				else {
					extraJoin += " AND f.type IS NULL";	
				}
				
				if(shoe_size != null){
					extraJoin += " AND f.size >= \'" + shoe_size + "\'";
				}
				else {
					extraJoin += " AND f.size IS NULL";
				}
				
				extraJoin += ") s USING (user_login_id, wish_id) ";
			}
			
			String select_wish = "SELECT a.brand, a.age_group, a.color, a.season, a.gender, a.material, a.category, " + extraAttributes +
					"FROM AlertForWishApparel a " + extraJoin + "WHERE a.user_login_id = ? AND a.brand <=> ? " + 
					"AND a.age_group <=> ? AND a.color <=> ? AND a.season <=> ? AND a.gender <=> ? AND a.material <=> ? AND a.category <=> ?";
			
			PreparedStatement ps = con.prepareStatement(select_wish);
			ps.setString(1, user_id);
			ps.setString(2, brand);
			ps.setString(3, age_group);
			ps.setString(4, color);
			ps.setString(5, season);
			ps.setString(6, gender);
			ps.setString(7, material);
			ps.setString(8, category);
			if(ps.executeQuery().next()) {
				response.sendRedirect("CreateAlert.jsp");
				return;
			}			
			ps.close();
			
			String max_wish = "SELECT MAX(wish_id) FROM alertforwishapparel WHERE user_login_id = ?";
			
			PreparedStatement ps_wish_id = con.prepareStatement(max_wish);
			ps_wish_id.setString(1, user_id);
			ResultSet rs = ps_wish_id.executeQuery();
			rs.next();
			int wish_id = rs.getInt("MAX(wish_id)") + 1;
			ps_wish_id.close();
			
			String insert_wish = "INSERT INTO alertforwishapparel(user_login_id, wish_id, brand, age_group, " +
					"color, season, gender, material, category) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement ps_insert_apparel = con.prepareStatement(insert_wish);
			ps_insert_apparel.setString(1, user_id);
			ps_insert_apparel.setInt(2, wish_id);
			ps_insert_apparel.setString(3, brand);
			ps_insert_apparel.setString(4, age_group);
			ps_insert_apparel.setString(5, color);
			ps_insert_apparel.setString(6, season);
			ps_insert_apparel.setString(7, gender);
			ps_insert_apparel.setString(8, material);
			ps_insert_apparel.setString(9, category);
			ps_insert_apparel.executeUpdate();
			ps_insert_apparel.close();
			
			if ("tops".equals(category)){				
				String insert_wish_top = "INSERT INTO wishappareltops(user_login_id, wish_id, size_group, sleeve_length) "+
						"VALUES (?, ?, ?, ?)";
				PreparedStatement ps_insert_top = con.prepareStatement(insert_wish_top);
				ps_insert_top.setString(1, user_id);
				ps_insert_top.setInt(2, wish_id);
				ps_insert_top.setString(3, top_size);
				ps_insert_top.setString(4, top_sleeve_length);
				ps_insert_top.executeUpdate();
				ps_insert_top.close();
			}
			else if ("bottoms".equals(category)){					
				String insert_wish_bottom = "INSERT INTO wishapparelbottoms(user_login_id, wish_id, waist_size, length) "+
						"VALUES (?, ?, ?, ?)";
				PreparedStatement ps_insert_bottom = con.prepareStatement(insert_wish_bottom);
				ps_insert_bottom.setString(1, user_id);
				ps_insert_bottom.setInt(2, wish_id);
				ps_insert_bottom.setString(3, waist_size);
				ps_insert_bottom.setString(4, pant_length);
				ps_insert_bottom.executeUpdate();
				ps_insert_bottom.close();
			}
			else if ("footwear".equals(category)){					
				String insert_wish_footwear = "INSERT INTO wishapparelfootwear(user_login_id, wish_id, size, type) "+
						"VALUES (?, ?, ?, ?)";
				PreparedStatement ps_insert_footwear = con.prepareStatement(insert_wish_footwear);
				ps_insert_footwear.setString(1, user_id);
				ps_insert_footwear.setInt(2, wish_id);
				ps_insert_footwear.setString(3, shoe_size);
				ps_insert_footwear.setString(4, shoe_type);
				ps_insert_footwear.executeUpdate();
				ps_insert_footwear.close();
			}
			
			con.close();
			
			response.sendRedirect("CreateAlert.jsp");
			
		} catch (Exception ex){
			out.print(ex);
		}
%>
</body>
</html>