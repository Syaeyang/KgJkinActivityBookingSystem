<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Package</title>
    <link rel="stylesheet" href="AddPackage.css">
</head>
<body>
   
    <header class="site-header">
        <div class="logo">
            <img src="img/logo1.png" alt="Logo">
        </div>
        <nav class="nav-menu">
            <ul>
                <li><a href="HOME2.jsp">HOME</a></li>
                <li><a href="ListPackage.jsp">PACKAGE</a></li>
                <li><a href="BookingList.jsp">BOOKING</a></li>
            </ul>
        </nav>
    </header>
        
    <%
        // Retrieve packageId from the request parameter
        int packageid = Integer.parseInt(request.getParameter("packageId"));

        // Fetch package details from the database
        String packageName = "", price = "", duration = "", details = "";

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
            Connection con = DriverManager.getConnection(url);

            // SQL query to fetch package details
            String sql = "SELECT * FROM Package WHERE packageid = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, packageid);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                packageName = rs.getString("packagename");
                price = rs.getString("packageprice");
                duration = rs.getString("packageduration");
                details = rs.getString("packagedetails");
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    %>
        
    <form action="UpdatePackageServlet" method="post">
        <input type="hidden" name="packageid" value="<%= packageid %>">
        <div class="package-form">
            <div class="package-details">
                <h1>UPDATE PACKAGE</h1>
                <label>
                    Package Name<br>
                    <input type="text" id="packageName" name="packageName" class="input" value="<%= packageName %>" required>
                </label>
                <div class="activity">
                    <label>
                        Price<br>
                        <input type="number" id="price" name="price" class="input" step="0.01" value="<%= price %>" required>
                    </label>
                </div>
                <div class="activity">
                    <label>
                        Duration<br>
                        <input type="text" id="duration" name="duration" class="input" value="<%= duration %>" required>
                    </label>
                </div>
                <div class="activity">
                    <label>
                        Additional Details<br>
                        <input type="text" id="additionalDetails" name="additionalDetails" class="input" value="<%= details %>" required>
                    </label>
                </div>
            </div>
            <button type="submit" class="add-package-btn"><b>Update Package</b></button>
        </div>
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
