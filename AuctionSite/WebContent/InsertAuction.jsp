<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeParseException" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Insert an Auction</title>		
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
		
		//Create a SQL statement
		Statement stmt = con.createStatement();
		//Get characteristics parameters from the HTML form at the createAuction.jsp
		String brand = request.getParameter("brand");
		String age_group = request.getParameter("age_group");
		String color = request.getParameter("color");
		String season = request.getParameter("season");
		String gender = request.getParameter("gender");
		String material = request.getParameter("material");
		String category = request.getParameter("category");
		String waist_size = request.getParameter("waist_size");
		String pant_length = request.getParameter("pant_length");
		String shoe_size = request.getParameter("shoe_size");
		String shoe_type = request.getParameter("shoe_type");
		String top_size = request.getParameter("top_size");
		String top_sleeve_length = request.getParameter("top_sleeve_length");
		
		String seller_login_id = (String)session.getAttribute("username");
		String auction_title = request.getParameter("auction_title");
		String description = request.getParameter("description");
		String closing_time = request.getParameter("closing_time");
		String hidden_min = request.getParameter("hidden_min");
		String min_bid_increment = request.getParameter("min_bid_increment");
		
		boolean commence_insert = false;
		int item_id = 0;
		
		boolean auctionInfoValid = !((auction_title == null) || (description == null) || (closing_time == null)
				|| (hidden_min == null) || (min_bid_increment == null) || auction_title.isEmpty() 
				|| description.isEmpty() || closing_time.isEmpty() || hidden_min.isEmpty() 
				|| min_bid_increment.isEmpty());
		
		boolean apparelInfoValid = !((brand == null) || (age_group == null) || (color == null) || (season == null) 
				|| (gender == null) || (material == null) || (category == null)
				|| brand.isEmpty() || age_group.isEmpty() || color.isEmpty() || season.isEmpty() 
				|| gender.isEmpty() || material.isEmpty() || category.isEmpty());
		
		boolean categoryInfoValid = !(((waist_size == null) || (pant_length == null) 
				|| waist_size.isEmpty() || pant_length.isEmpty()) 
				&& ((shoe_size == null) || (shoe_type == null) 
						|| shoe_size.isEmpty() || shoe_type.isEmpty()) 
				&& ((top_size == null) || (top_sleeve_length == null) 
						|| top_size.isEmpty() || top_sleeve_length.isEmpty()));
		
		if (!auctionInfoValid || !apparelInfoValid || !categoryInfoValid) {
			session.setAttribute("errorCode", -1);
			response.sendRedirect("CreateAuction.jsp");
			return;
		}
		else {
			LocalDateTime closing = LocalDateTime.parse(closing_time.replace(" ", "T"));
			if (!closing.isAfter(LocalDateTime.now())) {
				session.setAttribute("errorCode", -3);
				response.sendRedirect("CreateAuction.jsp");
				return;
			}
		}
		
		auction_title = auction_title.substring(0,1).toUpperCase() + auction_title.substring(1);
		description = description.substring(0,1).toUpperCase() + description.substring(1);
		brand =  brand.substring(0,1).toUpperCase() + brand.substring(1).toLowerCase();
		color = color.substring(0,1).toUpperCase() + color.substring(1).toLowerCase();
		material = material.substring(0,1).toUpperCase() + material.substring(1).toLowerCase();
		if (shoe_type != null && !shoe_type.isEmpty()) {
			shoe_type = shoe_type.substring(0,1).toUpperCase() + shoe_type.substring(1).toLowerCase();
		}
		
		if (category.equals("tops")){
			String select_tops = "select a.item_id " + 
							   	    "from apparel a " +
							        "where a.item_id IN " +
							        "(SELECT t.item_id FROM tops t WHERE t.size_group = ? AND t.sleeve_length = ?) " +
							        "AND a.brand = ? " + 
							        "AND a.age_group = ?" +
    							    "AND a.color = ? " + 
	    						    "AND a.season = ? " +
		    					    "AND a.gender = ? " + 
				    			    "AND a.material = ? " +
			    				    "AND a.category = ? ";
			PreparedStatement ps_t = con.prepareStatement(select_tops);
			ps_t.setString(1, top_size);
			ps_t.setString(2, top_sleeve_length);
			
			ps_t.setString(3, brand);
			ps_t.setString(4, age_group);
			ps_t.setString(5, color);
			ps_t.setString(6, season);
			ps_t.setString(7, gender);
			ps_t.setString(8, material);
			ps_t.setString(9, category);
			
			ResultSet rs_t = ps_t.executeQuery();
						
			if(rs_t.next()){
				item_id = rs_t.getInt("item_id");
			} else {
				commence_insert = true;
			}
			
			if(commence_insert){
				String insert_apparel_id = "INSERT INTO apparel(brand, age_group, " +
						"color, season, gender, material, category) VALUES (?, ?, ?, ?, ?, ?, ?)";
				PreparedStatement ps_insert_apparel = con.prepareStatement(insert_apparel_id);
				ps_insert_apparel.setString(1, brand);
				ps_insert_apparel.setString(2, age_group);
				ps_insert_apparel.setString(3, color);
				ps_insert_apparel.setString(4, season);
				ps_insert_apparel.setString(5, gender);
				ps_insert_apparel.setString(6, material);
				ps_insert_apparel.setString(7, category);
				ps_insert_apparel.executeUpdate();
				
				String get_max_id = "select max(item_id) as item_id from apparel";
				PreparedStatement max_id_stmt = con.prepareStatement(get_max_id);
				ResultSet max_rs = max_id_stmt.executeQuery();
				max_rs.next();
				item_id = max_rs.getInt("item_id");
				
				String insert_tops_id = "INSERT INTO tops(item_id, size_group, sleeve_length) "+
										"VALUES (?, ?, ?)";
				PreparedStatement ps_insert_tops = con.prepareStatement(insert_tops_id);
				ps_insert_tops.setInt(1, item_id);
				ps_insert_tops.setString(2, top_size);
				ps_insert_tops.setString(3, top_sleeve_length);
				ps_insert_tops.executeUpdate();
				ps_insert_apparel.close();
				ps_insert_tops.close();
			}
			
		} 
		else if (category.equals("bottoms")){		
			String select_bottoms = "select a.item_id " + 
			                               "from apparel a " +
			 		    			       "where a.item_id IN " +
						    		       "(SELECT b.item_id FROM bottoms b WHERE b.waist_size = ? AND b.length = ?) " +
							    	       "AND a.brand = ? " + 
								           "AND a.age_group = ?" +
									       "AND a.color = ? " + 
	    								   "AND a.season = ? " +
		    							   "AND a.gender = ? " + 
			    						   "AND a.material = ? " +
				    					   "AND a.category = ? ";
			
			PreparedStatement ps_b = con.prepareStatement(select_bottoms);
			
			ps_b.setString(1, waist_size);
			ps_b.setString(2, pant_length);
			
			ps_b.setString(3, brand);
			ps_b.setString(4, age_group);
			ps_b.setString(5, color);
			ps_b.setString(6, season);
			ps_b.setString(7, gender);
			ps_b.setString(8, material);
			ps_b.setString(9, category);
			
			ResultSet rs_b = ps_b.executeQuery();
			if(rs_b.next()){
				item_id = rs_b.getInt("item_id");
			} else {
				commence_insert = true;
			}
			
			if(commence_insert){
				String insert_apparel_id = "INSERT INTO apparel(brand, age_group, " +
						"color, season, gender, material, category) VALUES (?, ?, ?, ?, ?, ?, ?)";
				PreparedStatement ps_insert_apparel = con.prepareStatement(insert_apparel_id);
				ps_insert_apparel.setString(1, brand);
				ps_insert_apparel.setString(2, age_group);
				ps_insert_apparel.setString(3, color);
				ps_insert_apparel.setString(4, season);
				ps_insert_apparel.setString(5, gender);
				ps_insert_apparel.setString(6, material);
				ps_insert_apparel.setString(7, category);
				ps_insert_apparel.executeUpdate();
				
				String get_max_id = "select max(item_id) as item_id from apparel";
				PreparedStatement max_id_stmt = con.prepareStatement(get_max_id);
				ResultSet max_rs = max_id_stmt.executeQuery();
				max_rs.next();
				item_id = max_rs.getInt("item_id");
				
				String insert_bottoms_id = "INSERT INTO bottoms(item_id, waist_size, length) " +
										   "VALUES (?, ?, ?)";
				PreparedStatement ps_insert_bottoms = con.prepareStatement(insert_bottoms_id);
				ps_insert_bottoms.setInt(1, item_id);
				ps_insert_bottoms.setString(2, waist_size);
				ps_insert_bottoms.setString(3, pant_length);
				ps_insert_bottoms.executeUpdate();
				ps_insert_apparel.close();
				ps_insert_bottoms.close();
			}
			
		} 
		else if(category.equals("footwear")){		
			String select_footwear = "select a.item_id " + 
		   	                                "from apparel a " +
			                                "where a.item_id IN " +
			                                "(SELECT f.item_id FROM footwear f WHERE f.size = ? AND f.type = ?) " +
									        "AND a.brand = ? " + 
									        "AND a.age_group = ?" +
									        "AND a.color = ? " + 
									        "AND a.season = ? " +
									        "AND a.gender = ? " + 
									        "AND a.material = ? " +
									        "AND a.category = ? ";
			
			PreparedStatement ps_f = con.prepareStatement(select_footwear);
			
			ps_f.setString(1, shoe_size);
			ps_f.setString(2, shoe_type);
			
			ps_f.setString(3, brand);
			ps_f.setString(4, age_group);
			ps_f.setString(5, color);
			ps_f.setString(6, season);
			ps_f.setString(7, gender);
			ps_f.setString(8, material);
			ps_f.setString(9, category);
			ResultSet rs_f = ps_f.executeQuery();
			if(rs_f.next()){
				item_id = rs_f.getInt("item_id");
			} else {
				commence_insert = true;
			}
			
			if(commence_insert){
				String insert_apparel_id = "INSERT INTO apparel(brand, age_group, " +
						"color, season, gender, material, category) VALUES (?, ?, ?, ?, ?, ?, ?)";
				PreparedStatement ps_insert_apparel = con.prepareStatement(insert_apparel_id);
				ps_insert_apparel.setString(1, brand);
				ps_insert_apparel.setString(2, age_group);
				ps_insert_apparel.setString(3, color);
				ps_insert_apparel.setString(4, season);
				ps_insert_apparel.setString(5, gender);
				ps_insert_apparel.setString(6, material);
				ps_insert_apparel.setString(7, category);
				ps_insert_apparel.executeUpdate();
				
				String get_max_id = "select max(item_id) as item_id from apparel";
				PreparedStatement max_id_stmt = con.prepareStatement(get_max_id);
				ResultSet max_rs = max_id_stmt.executeQuery();
				max_rs.next();
				item_id = max_rs.getInt("item_id");
				
				String insert_footwear_id = "INSERT INTO footwear(item_id, size, type) " +
											"VALUES (?, ?, ?)";
				PreparedStatement ps_insert_footwear = con.prepareStatement(insert_footwear_id);
				ps_insert_footwear.setInt(1, item_id);
				ps_insert_footwear.setString(2, shoe_size);
				ps_insert_footwear.setString(3, shoe_type);
				ps_insert_footwear.executeUpdate();
				ps_insert_apparel.close();
				ps_insert_footwear.close();
			}						
		}
		else {
			session.setAttribute("errorCode", -2);
			//request.getRequestDispatcher("CreateAuction.jsp").forward(request, response);
			response.sendRedirect("CreateAuction.jsp");
			return;
		}
		
		//check for item_id in the apparel table, if exists, use that, otherwise insert a new record
		//needs a query for the item_id that matches all the above criteria. result will be the id or null.
		
		//get the current datetime
		String sql_insert = "Insert into auctionsellsbuys(seller_login_id, item_id, title, " +
							"description, closing_date_time, secret_minimum_price, minimum_bid_increment)" + 
							" values (?, ?, ?, ?, ?, ?, ?)";
		
		//Create a Prepared SQL statement
		PreparedStatement ps = con.prepareStatement(sql_insert);
		//Add parameters of the preparedStatement
		ps.setString(1, seller_login_id);
		ps.setInt(2, item_id); //Integer.parseInt(item_id)
		ps.setString(3, auction_title);
		ps.setString(4, description);
		ps.setString(5, closing_time);
		ps.setString(6, hidden_min);
		ps.setString(7, min_bid_increment);
		
		ps.executeUpdate();
		
		String select_auction_id = "SELECT max(auction_id) AS auction_id FROM auctionsellsbuys";
		ps = con.prepareStatement(select_auction_id);
		ResultSet rs = ps.executeQuery();
		int auction_id = -1;
		if(rs.next()) {
			auction_id = rs.getInt("auction_id");
		}
		
		ps.close();
		con.close();
		
		session.setAttribute("auction_id", auction_id);
		if (auction_id != -1) {
			response.sendRedirect("AuctionPage.jsp");
			return;
		}
		else {
			session.setAttribute("errorCode", -2);
			response.sendRedirect("CreateAuction.jsp");
			return;
		}
		
	} catch (DateTimeParseException dtpe){
		session.setAttribute("errorCode", -3);
		response.sendRedirect("CreateAuction.jsp");
		return;
	} catch (Exception e){		
		out.print(e);
	}	
	%>
</body>
</html>