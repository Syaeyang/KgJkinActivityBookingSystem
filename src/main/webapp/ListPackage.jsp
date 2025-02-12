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
          <li><a href="HOME1.jsp">HOME</a></li>
          <li><a href="ListPackage.jsp">PACKAGE</a></li>
          
        </ul>
      </nav>
    </header>
</body>

<div class="packages-container">

 <%
                    // Initialize collections to store packages and activities
                    ArrayList<HashMap<String, Object>> packages = new ArrayList<>();
                    HashMap<Integer, ArrayList<HashMap<String, Object>>> activitiesByPackage = new HashMap<>();

                    // Database connection
                    try {
                        Class.forName("oracle.jdbc.driver.OracleDriver");
                        Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system");

                        // Fetch the packages
                        String packageQuery = "SELECT packageid, packagename, packageprice, packageduration, packagedetails FROM package";
                        Statement packageStmt = con.createStatement();
                        ResultSet packageRs = packageStmt.executeQuery(packageQuery);

                        // Store packages
                        while (packageRs.next()) {
                            HashMap<String, Object> pkg = new HashMap<>();
                            int packageId = packageRs.getInt("packageid");
                            pkg.put("id", packageId);
                            pkg.put("name", packageRs.getString("packagename"));
                            pkg.put("price", packageRs.getDouble("packageprice"));
                            pkg.put("duration", packageRs.getString("packageduration"));
                            pkg.put("details", packageRs.getString("packagedetails"));
                            packages.add(pkg);

                            // Initialize empty list of activities for each package
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

                            // Store activities for each package
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

                    // Check if there are any packages
                    if (packages != null && !packages.isEmpty()) {
                        // Loop through each package and display its details
                        for (HashMap<String, Object> pkg : packages) {
                            int packageId = (int) pkg.get("id");
                %>
  
  <div class="package">
    <h2><%= pkg.get("name") %></h2>
    <img src="img/atv1.jpg" alt="Package 1" class="package-image">
    <ul>
      <li>Details: <%= pkg.get("details") %></li>
      <li>Duration: <%= pkg.get("duration") %> minutes</li>
      
      						<%
                                // Fetch the activities associated with this package ID
                                ArrayList<HashMap<String, Object>> activities = activitiesByPackage.get(packageId);
                                 
                                // Check if there are any activities for this package
                                if (activities != null && !activities.isEmpty()) {
                                    // Loop through and display each activity for this package
                                    for (HashMap<String, Object> act : activities) {
                            %>
                                <li>
                                    <strong>Activity:</strong> <%= act.get("name") %> 

                                </li>
                            <%
                                    }
                                } else {
                            %>
                                <li>No activities available for this package.</li>
                            <%
                                }
                            %>
        
      
      <b><li>Price: RM<%= String.format("%.2f", pkg.get("price")) %></li></b>
    </ul>  
    <button class="book-btn" onclick="window.location.href='CreateBooking.jsp?packageId=<%= packageId %>'" >Book Now</button>
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
</div>


</html>


