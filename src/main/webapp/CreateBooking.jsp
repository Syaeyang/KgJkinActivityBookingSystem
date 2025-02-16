<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Booking</title>
    <link rel="stylesheet" href="CreateBooking.css">
    <script src="available.js" defer></script>
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
        <li><a href="BookingSummary.jsp">BOOKING</a></li>
      </ul>
    </nav>
  </header>

  <main>
    <% 
      String packageId = request.getParameter("packageId");
      String packageName = "", packagePrice = "", packageDuration = "", packageDetails = "";
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

          String packageQuery = "SELECT packagename, packageprice, packageduration, packagedetails FROM package WHERE packageId = ?";
          PreparedStatement ps = con.prepareStatement(packageQuery);
          ps.setString(1, packageId);
          ResultSet rs = ps.executeQuery();

          if (rs.next()) {
              packageName = rs.getString("packagename");
              packagePrice = String.format("%.2f", rs.getDouble("packageprice"));
              packageDuration = rs.getString("packageduration");
              packageDetails = rs.getString("packagedetails");
          }
          rs.close();
          ps.close();
      } catch (Exception e) {
          e.printStackTrace();
          out.println("<p>Error loading package details.</p>");
      }
    %>
    
    <section class="booking-section">
      <div class="image-container">
        <h1><b><%= packageName %></b></h1>
        <img src="img/atv1.jpg" alt="ATV Fun Ride">
      </div>
      
      <div class="booking-section">
        <% 
          try {
              String slotQuery = "SELECT SLOTID, SLOTSTART, SLOTEND, AVAILABILITY FROM SLOT ORDER BY SLOTID";
              Statement stmt = con.createStatement();
              ResultSet rs = stmt.executeQuery(slotQuery);
        %>
        
        <% String errorMessage = request.getParameter("error");
           if (errorMessage != null) {
               out.println("<p style='color:red;'>" + errorMessage + "</p>");
           }
        %>
        
        <form action="CreateBookingServlet" method="post">
          <div class="summary-container">
            <label for="date">Date:</label>
            <input type="date" id="date" name="date" required>
            <label for="adults">Adults:</label>
            <input type="number" id="adults" name="adults" min="1" value="1" required>
            <label for="children">Children:</label>
            <input type="number" id="children" name="children" min="0" value="0" required>
            <label for="slot">Select Slot</label>
            <select id="slot" name="slot" required>
              <option value="">-- Select a Slot --</option>
              <% while (rs.next()) {
                  int slotId = rs.getInt("SLOTID");
                  String slotStart = rs.getString("SLOTSTART");
                  String slotEnd = rs.getString("SLOTEND");
                  int availability = rs.getInt("AVAILABILITY");
                  if (availability > 0) {
              %>
              <option value="<%= slotId %>"><%= slotStart %> - <%= slotEnd %> (Available: <%= availability %>)</option>
              <% 
                  }
              }
              rs.close();
              stmt.close();
              con.close();
              %>
            </select>
            <input type="hidden" name="packageId" value="<%= packageId %>" />
            <button type="submit" class="book-btn">Book Now</button>
          </div>
        </form>
        <% } catch (Exception e) {
             e.printStackTrace();
             out.println("<p>Error loading slot list.</p>");
           } finally {
             if (con != null) try { con.close(); } catch (SQLException ignored) {}
           }
        %>
      </div>
    </section>
  </main>

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

  <script type="text/javascript">
    function SubmitBooking(id) {
        window.location.href = "CreateBookingServlet?id=" + id;
    }
  </script>
</body>
</html>
