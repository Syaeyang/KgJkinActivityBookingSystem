<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%> 
<%@ page import="java.sql.*, java.util.ArrayList, java.util.HashMap" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>List Package And Activity</title>
    <link rel="stylesheet" href="ListPackage.css">
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

<div class="packages-container">
    <%
        ArrayList<HashMap<String, Object>> packages = new ArrayList<>();
        HashMap<Integer, ArrayList<HashMap<String, Object>>> activitiesByPackage = new HashMap<>();

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

            // Fetch the packages
            String packageQuery = "SELECT packageid, packagename, packageprice, packageduration, packagedetails FROM package";
            Statement packageStmt = con.createStatement();
            ResultSet packageRs = packageStmt.executeQuery(packageQuery);

            while (packageRs.next()) {
                HashMap<String, Object> pkg = new HashMap<>();
                int packageId = packageRs.getInt("packageid");
                pkg.put("id", packageId);
                pkg.put("name", packageRs.getString("packagename"));
                pkg.put("price", packageRs.getDouble("packageprice"));
                pkg.put("duration", packageRs.getString("packageduration"));
                pkg.put("details", packageRs.getString("packagedetails"));
                packages.add(pkg);
                activitiesByPackage.put(packageId, new ArrayList<>());
            }

            // Fetch activities associated with each package
            String activityQuery = "SELECT ACTIVITY.ACTID, ACTIVITY.ACTNAME, package.packageid " +
                                   "FROM ACTIVITY " +
                                   "INNER JOIN PACKAGE_ACTIVITY ON ACTIVITY.ACTID = PACKAGE_ACTIVITY.ACTID " +
                                   "INNER JOIN package ON PACKAGE_ACTIVITY.packageid = package.packageid " +
                                   "WHERE package.packageid = ?";
            PreparedStatement activityStmt = con.prepareStatement(activityQuery);

            for (HashMap<String, Object> pkg : packages) {
                int packageId = (int) pkg.get("id");
                activityStmt.setInt(1, packageId);
                ResultSet activityRs = activityStmt.executeQuery();

                while (activityRs.next()) {
                    HashMap<String, Object> act = new HashMap<>();
                    act.put("id", activityRs.getInt("ACTID"));
                    act.put("name", activityRs.getString("ACTNAME"));
                    activitiesByPackage.get(packageId).add(act);
                }
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>

    <% if (!packages.isEmpty()) { %>
        <% for (HashMap<String, Object> pkg : packages) { %>
            <div class="package">
                <h2>PACKAGE <%= pkg.get("name") %></h2>
                <img src="img/atv1.jpg" alt="Package Image" class="package-image">
                <ul>
                    <li>Details: <%= pkg.get("details") %></li>
                    <li>Duration: <%= pkg.get("duration") %> minutes</li>
                    <%
                        ArrayList<HashMap<String, Object>> activities = activitiesByPackage.get((int) pkg.get("id"));
                        if (!activities.isEmpty()) {
                            for (HashMap<String, Object> act : activities) { %>
                                <li><strong>Activity:</strong> <%= act.get("name") %></li>
                    <%      }
                        } else { %>
                                <li>No activities available for this package.</li>
                    <%  } %>
                    <li><b>Price: RM<%= String.format("%.2f", pkg.get("price")) %></b></li>
                </ul>
                <button class="book-btn" onclick="window.location.href='CreateBooking.jsp?packageId=<%= pkg.get("id") %>'">Book Now</button>
            </div>
        <% } %>
    <% } else { %>
        <p>No packages available.</p>
    <% } %>

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
</div>
</body>
</html>
