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
                <li><a href="HomeCrew.jsp">HOME</a></li>
                <li><a href="ListPackageCrew.jsp">PACKAGE</a></li>
                <li><a href="BookingList.jsp">BOOKING</a></li>
                <li><a href="ListSlot.jsp">SLOT</a></li>
                <li><a href="ListActivity.jsp">ACTIVITY</a></li>
            </ul>
        </nav>
    </header>

    <%
        String packageIdParam = request.getParameter("packageId");
        int packageId = 0;
        String packageName = "", price = "", duration = "", additionalDetails = "";

        if (packageIdParam != null && !packageIdParam.isEmpty()) {
            try {
                packageId = Integer.parseInt(packageIdParam);
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                String url = "jdbc:sqlserver://kgjkinserver.database.windows.net:1433;database=kgJkinDB;user=kgjkinadmin@kgjkinserver;password=Mycuties_7;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
                try (Connection con = DriverManager.getConnection(url);
                     PreparedStatement ps = con.prepareStatement("SELECT * FROM Package WHERE packageid = ?")) {
                    ps.setInt(1, packageId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            packageName = rs.getString("packagename");
                            price = rs.getString("packageprice");
                            duration = rs.getString("packageduration");
                            additionalDetails = rs.getString("packagedetails");
                        } else {
                            out.println("<p>Error: Package not found.</p>");
                            return;
                        }
                    }
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
                return;
            }
        } else {
            out.println("<p>Error: Missing package ID.</p>");
            return;
        }
    %>

    <form action="UpdatePackageServlet" method="post">
        <input type="hidden" name="packageId" value="<%= packageId %>">
        <div class="package-form">
            <div class="package-details">
                <h1>UPDATE PACKAGE</h1>
                <label>
                    Package Name<br>
                    <input type="text" name="packageName" class="input" value="<%= packageName %>" required>
                </label>
                <label>
                    Price<br>
                    <input type="number" name="price" class="input" step="0.01" value="<%= price %>" required>
                </label>
                <label>
                    Duration<br>
                    <input type="text" name="duration" class="input" value="<%= duration %>" required>
                </label>
                <label>
                    Additional Details<br>
                    <input type="text" name="additionalDetails" class="input" value="<%= additionalDetails %>" required>
                </label>
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
