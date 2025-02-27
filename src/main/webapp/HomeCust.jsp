<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Profile</title>
    <link rel="stylesheet" href="CustomerProfile.css">
    <script src="sign up.js" defer></script>
</head>
<body>
    <header class="site-header">
      <div class="logo">
        <img src="img/logo1.png" alt="Logo">
      </div>
      <nav class="nav-menu">
        <ul>
           <li><a href="HomeCust.jsp">HOME</a></li>
          <li><a href="ListPackage.jsp">PACKAGE</a></li>
          <li><a href="BookingSummary.jsp">BOOKING</a></li>
        </ul>
      </nav>
    </header>

    <div class="profile-container">
    
    <%
        // Retrieve CUSTID from session
        Integer customerid = (Integer) session.getAttribute("custid");
        if (customerid == null) {
            response.sendRedirect("LogIn.jsp"); // Redirect if session is missing
            return;
        }

        Connection con = null;

        try {
            // Load SQL Server JDBC Driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Establish connection
            String url = "jdbc:sqlserver://kgjkinserver.database.windows.net:1433;"
                       + "database=kgJkinDB;"
                       + "user=kgjkinadmin@kgjkinserver;"
                       + "password=Mycuties_7;"
                       + "encrypt=true;"
                       + "trustServerCertificate=false;"
                       + "hostNameInCertificate=*.database.windows.net;"
                       + "loginTimeout=30;";
            con = DriverManager.getConnection(url);

            String sql = "SELECT * FROM CUSTOMER WHERE CUSTID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, customerid);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
    %>
    <img src="img/profile1.jpg" alt="Profile Picture" class="profile-pic">
    <div class="profile-info">
        <h2><%= rs.getString(2) %> <%= rs.getString(3) %></h2>
    </div>
    </div>

    <div class="container">
        <div class="section">
            <div class="form">
                <div class="info-container">
                    <label for="signup-email">Email Address: <%= rs.getString(4) %></label>
                    <br>
                    <label for="signup-phone">Phone Number: <%= rs.getString(5) %></label>
                </div>
                <a href="UpdateProfile.jsp?id=<%= customerid %>" class="button">Update Profile</a>
            </div>
        </div>
    </div>
    <%
            } else {
                out.println("<p>No Profile found with the given ID.</p>");
            }
            con.close();
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    %>
    
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
</body>
</html>
