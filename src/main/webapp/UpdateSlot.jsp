<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%> 
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Slot Time</title>
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
        // Retrieve SLOTID from the request parameter
        int slotid = Integer.parseInt(request.getParameter("id"));

        // Fetch slot details from the database
        String slotNo = "", slotStart = "", slotEnd = "";

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

            // SQL query to fetch slot details
            String sql = "SELECT * FROM SLOT WHERE SLOTID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, slotid);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                slotNo = rs.getString("SLOTNO");
                slotStart = rs.getString("SLOTSTART");
                slotEnd = rs.getString("SLOTEND");
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    %>
    
    <form action="UpdateSlotServlet" method="post">
        <div class="package-form">
            <div class="package-details">
                <h1>UPDATE SLOT</h1>
                <label>
                    Slot No<br>
                    <input type="text" id="slotNo" name="slotNo" placeholder="Enter Slot No" required>
                </label>
                <div class="activity">
                    <label>
                        Slot Start Time<br>
                        <input type="text" id="slotStart" name="slotStart" placeholder="Enter Slot Start Time" required>
                    </label>
                </div>
                <div class="activity">
                    <label>
                        Slot End Time<br>
                        <input type="text" id="slotEnd" name="slotEnd" placeholder="Enter Slot End Time" required>
                    </label>
                </div>
                <button type="submit" class="add-package-btn">Update Slot</button>
            </div>
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
