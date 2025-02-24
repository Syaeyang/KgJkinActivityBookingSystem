<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Activity</title>
    <link rel="stylesheet" href="AddPackage.css">
</head>
<body>
    <header class="site-header">
        <div class="logo">
            <img src="img/logo1.png" alt="Logo">
        </div>
        <nav class="nav-menu">
            <ul>
                <li><a href="CrewProfile.jsp">HOME</a></li>
                <li><a href="ListPackageCrew.jsp">PACKAGE</a></li>
                <li><a href="BookingList.jsp">BOOKING</a></li>
            </ul>
        </nav>
    </header>

    <%
        String jdbcURL = "jdbc:sqlserver://kgjkinserver.database.windows.net:1433;database=kgJkinDB;user=kgjkinadmin@kgjkinserver;password=Mycuties_7;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // Retrieve parameters
        String actId = request.getParameter("actId");
        String packageId = request.getParameter("packageId");

        // Default values
        String activityName = "";
        String activityType = "";
        String rideFeature = "";
        String sportFeature = "";

        // Validate actId before querying
        if (actId != null && !actId.trim().isEmpty()) {
            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                conn = DriverManager.getConnection(jdbcURL);

                // Get activity details
                String sql = "SELECT A.ACTNAME, A.ACTTYPE, ER.RIDEFEATURE, ES.SPORTFEATURE " +
                             "FROM ACTIVITY A " +
                             "LEFT JOIN EXTREMERIDE ER ON A.ACTID = ER.ACTID " +
                             "LEFT JOIN EXTREMESPORT ES ON A.ACTID = ES.ACTID " +
                             "WHERE A.ACTID = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, actId);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    activityName = rs.getString("ACTNAME");
                    activityType = rs.getString("ACTTYPE");
                    rideFeature = rs.getString("RIDEFEATURE") != null ? rs.getString("RIDEFEATURE") : "";
                    sportFeature = rs.getString("SPORTFEATURE") != null ? rs.getString("SPORTFEATURE") : "";
                } else {
                    out.println("<p style='color:red;'>Activity not found. Please try again.</p>");
                }
                rs.close();
                pstmt.close();

                // If packageId is null, retrieve it from PACKAGE_ACTIVITY table
                if (packageId == null || packageId.trim().isEmpty()) {
                    String packageQuery = "SELECT packageid FROM PACKAGE_ACTIVITY WHERE actid = ?";
                    pstmt = conn.prepareStatement(packageQuery);
                    pstmt.setString(1, actId);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        packageId = rs.getString("packageid");
                    }
                }

            } catch (Exception e) {
                out.println("<p style='color:red;'>Error retrieving activity details.</p>");
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        } else {
            out.println("<p style='color:red;'>Invalid Activity ID.</p>");
        }
    %>

    <% if (actId != null && !actId.trim().isEmpty()) { %>
    <form action="UpdateActivityServlet" method="post">
        <input type="hidden" name="actid" value="<%= actId %>">
        <input type="hidden" name="packageId" value="<%= packageId %>">

        <div class="package-form">
            <div class="package-details">
                <h1>UPDATE ACTIVITY</h1>

                <label>
                    Activity Name<br>
                    <input type="text" id="activityName" name="activityName" value="<%= activityName %>" required>
                </label>

                <label for="activityType">
                    Activity Type<br>
                    <select id="activityType" name="activityType" required>
                        <option value="extremeRide" <%= "extremeRide".equals(activityType) ? "selected" : "" %>>Extreme Ride</option>
                        <option value="extremeSport" <%= "extremeSport".equals(activityType) ? "selected" : "" %>>Extreme Sport</option>
                    </select>
                </label>

                <div id="rideFields" style="<%= "extremeRide".equals(activityType) ? "display:block;" : "display:none;" %>">
                    <label>
                        Ride Feature<br>
                        <input type="text" id="rideFeature" name="rideFeature" value="<%= rideFeature %>">
                    </label>
                </div>

                <div id="sportFields" style="<%= "extremeSport".equals(activityType) ? "display:block;" : "display:none;" %>">
                    <label>
                        Sport Feature<br>
                        <input type="text" id="sportFeature" name="sportFeature" value="<%= sportFeature %>">
                    </label>
                </div>
            </div>
            <button class="add-package-btn" type="submit"><b>Update Activity</b></button>
        </div>
    </form>

    <% if (packageId != null && !packageId.trim().isEmpty()) { %>
        <a href="UpdatePackage.jsp?packageId=<%= packageId %>"></a>
    <% } else { %>
        <p style="color:red;">Error: Package ID is missing.</p>
    <% } %>

    <% } %>

    <script>
        document.getElementById("activityType").addEventListener("change", function () {
            var activityType = this.value;
            document.getElementById("rideFields").style.display = activityType === "extremeRide" ? "block" : "none";
            document.getElementById("sportFields").style.display = activityType === "extremeSport" ? "block" : "none";
        });
    </script>

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
