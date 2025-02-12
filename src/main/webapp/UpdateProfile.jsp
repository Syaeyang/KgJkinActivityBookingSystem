<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Profile</title>
    <link rel="stylesheet" href="SignUp.css">
</head>
<body>
    <header class="site-header">
      <div class="logo">
        <img src="img/logo1.png" alt="Logo">

      </div>
      <nav class="nav-menu">
        <ul>
          <li><a href="HOME1.jsp">HOME</a></li>
          <li><a href="ListPackage.jsp">PACKAGE</a></li>
          
        </ul>
      </nav>
    </header>
  </body>    

    <div class="container">
    <h2>Update Profile</h2>
    
        <!-- Sign Up Section -->
        <div class="section">
        
        <%
            // Retrieve CUSTID from the request parameter
            int customerid = Integer.parseInt(request.getParameter("id"));

            // Fetch customer details from the database
            String firstName = "", lastName = "", email = "", phone = "";

            try {
                // Database connection
                Class.forName("oracle.jdbc.driver.OracleDriver");
                Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system");

                String sql = "SELECT * FROM CUSTOMER WHERE CUSTID = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, customerid);

                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    firstName = rs.getString("CUSTFIRSTNAME");
                    lastName = rs.getString("CUSTLASTNAME");
                    email = rs.getString("CUSTEMAIL");
                    phone = rs.getString("CUSTPHONENO");
                }
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        %>
            
            <div class="form">
                <form action="/UpdateProfileServlet" method="post">
                <input type="hidden" name="customerid" value="<%= customerid %>">
                
                    <label for="customerfirstname">First Name</label>
                    <input type="text" id="customerfirstname" name="customerfirstname" placeholder="Enter your first name" required>

                    <label for="customerlastname">Last Name</label>
                    <input type="text" id="customerlastname" name="customerlastname" placeholder="Enter your last name" required>

                    <label for="customeremail">Email Address</label>
                    <input type="text" id="customeremail" name="customeremail" placeholder="Enter your email address" required>

                    <label for="customerphone">Phone Number</label>
                    <input type="text" id="customerphone" name="customerphone" placeholder="Enter your phone number" required>
                    
          
                    <button type="submit"><b>Update Profile</b></button>
                           
                </form>
              
            </div>
        </div>
    </div>
    <footer class="footer">
      <div class="footer-container">
        <div class="icon">
          <img src="img/fb1.png" alt="Facebook Icon">
        </div>
        <div class="icon">
          <img src="img/email1.png" alt="Email Icon">
        </div>
        <div class="footer-text">&copy; 2025 Kg Jkin Xtreme Park. All Rights Reserved.</div>
      </div>
    </footer>
  </html>
