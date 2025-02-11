<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Booking</title>
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
        <li><a href="BookingList.jsp">BOOKING</a></li>
      </ul>
    </nav>
  </header>

  <main>
  
  <%
    // Retrieve packageId from the query string
    String packageId = request.getParameter("packageId");

    // Declare package details variables
    String packageName = "";
    String packagePrice = "";
    String packageDuration = "";
    String packageDetails = "";

    // Fetch the package details based on packageId
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system");

        // SQL query to fetch package details by packageId
        String packageQuery = "SELECT packagename, packageprice, packageduration, packagedetails FROM package WHERE packageid = ?";
        PreparedStatement ps = con.prepareStatement(packageQuery);
        ps.setString(1, packageId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            packageName = rs.getString("packagename");
            packagePrice = String.format("%.2f", rs.getDouble("packageprice"));
            packageDuration = rs.getString("packageduration");
            packageDetails = rs.getString("packagedetails");
        }

        con.close();
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
    // Fetch available slots from the database
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system");

        // Fetch slots with availability
        String slotQuery = "SELECT SLOTID, SLOTSTART, SLOTEND, AVAILABILITY FROM SLOT ORDER BY SLOTID";
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(slotQuery);

    %>
      
       <form action="/UpdateBookingServlet" method="post">
        <div class="summary-container">
          <label for="date">Date:</label>
          <input type="date" id="date" name="date">
          <label for="adults">Adults:</label>
          <input type="number" id="adults" name="adults" min="0" value="1">
          <label for="children">Children:</label>
          <input type="number" id="children" name="children" min="0" value="0">
          <label for="slot">Select Slot</label>
          <select id="slot" name="slot" required>
          
            <option value="">-- Select a Slot --</option>
            <% 
            // Loop through each slot and add an option for the dropdown
            while (rs.next()) {
                int slotid = rs.getInt("SLOTID");
                String slotStart = rs.getString("SLOTSTART");
                String slotEnd = rs.getString("SLOTEND");
                int availability = rs.getInt("AVAILABILITY");
                
                // Only show slots that are available (availability > 0)
                if (availability > 0) {
            %>
                <option value="<%= slotid %>"><%= slotStart %> - <%= slotEnd %> (Available: <%= availability %>)</option>
                <% 
                }
            }
            %>
            
          </select>
          <button type="submit" class="book-btn" onclick="submitBooking()">Update Booking</button>
          <input type="hidden" name="packageId" value="<%= packageId %>" />
        </div>
        
        </form>
      </div>
      
       <%
    con.close();
} catch (Exception e) {
    e.printStackTrace();
    out.println("<p>Error loading slot list.</p>");
}
%>
    </section>
  </main>

  <!-- Footer placed here, inside the body -->
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
        window.location.href = "UpdateBookingServlet?id=" + id;
    }
</script>
</body>
