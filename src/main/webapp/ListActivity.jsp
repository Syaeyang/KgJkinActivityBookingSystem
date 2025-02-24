<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%> 
<%@ page import = "java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Now</title>
    <link rel="stylesheet" href="ListPackage.css">
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
        </ul>
      </nav>
    </header>
</body>
  
  <div class="packages-container">
    <%
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

            // Query to join parent table with child tables and identify type
            String sql = "SELECT A.ACTID, A.ACTNAME, " +
                         "ER.RIDEFEATURE, ES.SPORTFEATURE, " +
                         "CASE " +
                         "    WHEN ER.RIDEFEATURE IS NOT NULL THEN 'Extreme Ride' " +
                         "    WHEN ES.SPORTFEATURE IS NOT NULL THEN 'Extreme Sport' " +
                         "    ELSE 'General Activity' " +
                         "END AS ACTIVITYTYPE " +
                         "FROM ACTIVITY A " +
                         "LEFT JOIN EXTREMERIDE ER ON A.ACTID = ER.ACTID " +
                         "LEFT JOIN EXTREMESPORT ES ON A.ACTID = ES.ACTID " +
                         "ORDER BY A.ACTID";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
    %>
            <!-- Display table structure -->
            <table border="1" class="activity-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Type</th>
                        <th>Ride Feature</th>
                        <th>Sport Feature</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
    <%
            // Iterate through result set and display activity details in table rows
            while (rs.next()) {
                int actid = rs.getInt("ACTID");
                String activityName = rs.getString("ACTNAME");
                String rideFeature = rs.getString("RIDEFEATURE");
                String sportFeature = rs.getString("SPORTFEATURE");
                String activityType = rs.getString("ACTIVITYTYPE");
    %>
                    <tr>
                        <td><%= actid %></td>
                        <td><%= activityName %></td>
                        <td><%= activityType %></td>
                        <td><%= rideFeature != null ? rideFeature : "N/A" %></td>
                        <td><%= sportFeature != null ? sportFeature : "N/A" %></td>
                        <td>
                            <button class="action-btn" onclick="UpdateActivity(<%= actid %>)">Update</button>
                        </td>
                    </tr>
    <%
            }
            // Close the database connection
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error loading activity list.</p>");
        }
    %>
                </tbody>
            </table>
</div>

<script type="text/javascript">
    function UpdateActivity(id) {
        window.location.href = "UpdateActivity.jsp?id=" + id;
    }
</script>

</html>
