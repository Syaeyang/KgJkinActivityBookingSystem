<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
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
          <li><a href="Home.jsp">HOME</a></li>
          <li><a href="ListPackage.jsp">PACKAGE</a></li>
        </ul>
      </nav>
    </header>

<%
    // Get session and retrieve customer ID
    HttpSession sess = request.getSession(false);
    Integer customerid = (sess != null) ? (Integer) sess.getAttribute("custid") : null;

    if (customerid == null) { 
        response.sendRedirect("LogIn.jsp"); // Redirect if not logged in
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

        // Query to fetch customer details
        String sql = "SELECT * FROM CUSTOMER WHERE CUSTID = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, customerid);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
%>

<div class="profile-container">
    <img src="img/profile1.jpg" alt="Profile Picture" class="profile-pic">
    <div class="profile-info">
        <h2><%= rs.getString("CUSTFIRSTNAME") %> <%= rs.getString("CUSTLASTNAME") %></h2>
    </div>
</div>

<div class="container">
    <div class="section">
        <div class="form">
            <div class="info-container">
                <label>Email Address: <%= rs.getString("CUSTEMAIL") %></label><br>
                <label>Phone Number: <%= rs.getString("CUSTPHONENO") %></label>
            </div>
            <a href="UpdateProfile.jsp" class="button">Update Profile</a>
        </div>
    </div>
</div>

<%
        } else {
            out.println("<p>No profile found.</p>");
        }
        rs.close();
        ps.close();
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        if (con != null) try { con.close(); } catch (SQLException ignored) {}
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
