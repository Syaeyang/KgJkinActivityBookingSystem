<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.util.ArrayList, java.util.HashMap"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Update Package And Activity</title>
<link rel="stylesheet" href="ListPackage.css">
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

    <div class="packages-container">
        <%
        ArrayList<HashMap<String, Object>> packages = new ArrayList<>();
        HashMap<Integer, ArrayList<HashMap<String, Object>>> activitiesByPackage = new HashMap<>();

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://kgjkinserver.database.windows.net:1433;" +
                         "database=kgJkinDB;" +
                         "user=kgjkinadmin@kgjkinserver;" +
                         "password=Mycuties_7;" +
                         "encrypt=true;" +
                         "trustServerCertificate=false;" +
                         "hostNameInCertificate=*.database.windows.net;" +
                         "loginTimeout=30;";
            Connection con = DriverManager.getConnection(url);

            // Fetch all packages
            String packageQuery = "SELECT packageid, packagename, packageprice, packageduration, packagedetails FROM Package";
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

            // Fetch all activities linked to packages
            String activityQuery = "SELECT ACTIVITY.ACTID, ACTIVITY.ACTNAME, Package.packageid " +
                                   "FROM ACTIVITY " +
                                   "INNER JOIN PACKAGE_ACTIVITY ON ACTIVITY.ACTID = PACKAGE_ACTIVITY.ACTID " +
                                   "INNER JOIN Package ON PACKAGE_ACTIVITY.packageid = Package.packageid " +
                                   "WHERE Package.packageid = ?";
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

        if (!packages.isEmpty()) {
            for (HashMap<String, Object> pkg : packages) {
                int packageId = (int) pkg.get("id");
        %>

        <div class="package">
            <h2>Package <%= pkg.get("name") %></h2>
            <img src="img/atv1.jpg" alt="Package Image" class="package-image">
            <ul>
                <li><strong>Details:</strong> <%= pkg.get("details") %></li>
                <li><strong>Duration:</strong> <%= pkg.get("duration") %> minutes</li>

                <%
                ArrayList<HashMap<String, Object>> activities = activitiesByPackage.get(packageId);
                if (!activities.isEmpty()) {
                    for (HashMap<String, Object> act : activities) {
                %>
                <li><strong>Activity:</strong> <%= act.get("name") %></li>
                <%
                    }
                } else {
                %>
                <li>No activities available for this package.</li>
                <%
                }
                %>

                <li><strong>Price: RM<%= String.format("%.2f", pkg.get("price")) %></strong></li>
            </ul>

            <!-- UPDATE BUTTON: Now placed below all details -->
            <button class="book-btn"
                onclick="window.location.href='UpdateActivity.jsp?packageId=<%= packageId %>'">
                UPDATE PACKAGE
            </button>
        </div>

        <%
            }
        } else {
        %>
        <p>No packages available.</p>
        <%
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
    </div>
</body>
</html>
