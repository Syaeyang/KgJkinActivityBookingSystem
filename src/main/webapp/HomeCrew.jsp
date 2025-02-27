<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%> 
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crew Profile</title>
    <link rel="stylesheet" href="CrewProfile.css">
</head>
<body>
    <header class="site-header">
        <div class="logo">
            <img src="img/logo1.png" alt="Logo">
        </div>
        <nav class="nav-menu">
            <ul>
                <li><a href="HomeCrew.jsp">HOME</a></li>
                <li><a href="ListPackageCrew.jsp">PACKAGE</a></li>
                <li><a href="BookingList.jsp">BOOKING</a></li>
                <li><a href="ListSlot.jsp">SLOT</a></li>
                <li><a href="ListActivity.jsp">ACTIVITY</a></li>
            </ul>
        </nav>
    </header>

    <form>
    <%
        // Retrieve CREWID from session
        Integer crewid = (Integer) session.getAttribute("crewid");
        if (crewid == null) {
            response.sendRedirect("LogInCrew.jsp?error=Session expired. Please log in again.");
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
                       + "trustServerCertificate=false;";
            con = DriverManager.getConnection(url);
            
            String sql = "SELECT * FROM CREW WHERE CREWID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, crewid); 

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
    %>

    <div class="profile-container">
        <img src="img/FATTAH.jpg" alt="Profile Picture" class="profile-pic">
        <div class="profile-info">
            <h2><%= rs.getString("CREWFIRSTNAME") %> <%= rs.getString("CREWLASTNAME") %></h2>
            <p>Hello, <%= rs.getInt("CREWID") %>!</p>
            
            <a href="AddPackage.jsp">
                <button type="button"><b>New Package</b></button>
            </a>
            <a href="ListPackageUpdate.jsp">
                <button type="button"><b>Update Package</b></button>
            </a>
            <a href="AddSlot.jsp">
                <button type="button"><b>New Booking Slot</b></button>
            </a>
        </div>
    </div>
    
    <%
            } else {
                out.println("<p>No Profile found.</p>");
            }
            con.close();
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    %>
    </form>

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
