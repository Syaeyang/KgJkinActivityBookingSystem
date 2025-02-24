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
    // Get booking ID from request
    String bookingId = request.getParameter("bookingid");
    if (bookingId == null || bookingId.isEmpty()) {
        out.println("<p>Invalid booking ID.</p>");
        return;
    }

    String packageId = "";
    String bookingDate = "";
    int bookingAdults = 1;
    int bookingChildren = 0;
    int slotId = 0;

    try {
        // Database connection
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://kgjkinserver.database.windows.net:1433;database=kgJkinDB;user=kgjkinadmin@kgjkinserver;password=Mycuties_7;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
        Connection con = DriverManager.getConnection(url);

        // Fetch booking details
        String bookingQuery = "SELECT BOOKINGDATE, BOOKINGADULTS, BOOKINGCHILDREN, PACKAGEID, SLOTID FROM BOOKING WHERE BOOKINGID = ?";
        PreparedStatement ps = con.prepareStatement(bookingQuery);
        ps.setString(1, bookingId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            bookingDate = rs.getString("BOOKINGDATE");
            bookingAdults = rs.getInt("BOOKINGADULTS");
            bookingChildren = rs.getInt("BOOKINGCHILDREN");
            packageId = rs.getString("PACKAGEID");
            slotId = rs.getInt("SLOTID");
        }
        rs.close();
        ps.close();

        // Fetch package details
        String packageName = "";
        String packagePrice = "";
        String packageDuration = "";
        String packageDetails = "";

        String packageQuery = "SELECT PACKAGENAME, PACKAGEPRICE, PACKAGEDURATION, PACKAGEDETAILS FROM PACKAGE WHERE PACKAGEID = ?";
        ps = con.prepareStatement(packageQuery);
        ps.setString(1, packageId);
        rs = ps.executeQuery();

        if (rs.next()) {
            packageName = rs.getString("PACKAGENAME");
            packagePrice = String.format("%.2f", rs.getDouble("PACKAGEPRICE"));
            packageDuration = rs.getString("PACKAGEDURATION");
            packageDetails = rs.getString("PACKAGEDETAILS");
        }
        rs.close();
        ps.close();

        // Fetch only available slots
        String slotQuery = "SELECT SLOTID, SLOTSTART, SLOTEND, AVAILABILITY FROM SLOT WHERE AVAILABILITY > 0 ORDER BY SLOTID";
        ps = con.prepareStatement(slotQuery);
        rs = ps.executeQuery();
  %>
  
    <section class="booking-section">
      <div class="image-container">
        <h1><b><%= packageName %></b></h1>
        <img src="img/atv1.jpg" alt="ATV Fun Ride">
      </div>
      
      <div class="booking-section">
       <form action="UpdateBookingServlet" method="post">
        <div class="summary-container">
          <input type="hidden" name="bookingid" value="<%= bookingId %>">
          <input type="hidden" name="packageid" value="<%= packageId %>">

          <label for="date">Date:</label>
          <input type="date" id="date" name="bookingdate" value="<%= bookingDate %>" required>

          <label for="adults">Adults:</label>
          <input type="number" id="adults" name="bookingadults" min="0" value="<%= bookingAdults %>">

          <label for="children">Children:</label>
          <input type="number" id="children" name="bookingchildren" min="0" value="<%= bookingChildren %>">

          <label for="slot">Select Slot:</label>
          <select id="slot" name="slotid" required>
            <option value="">-- Select a Slot --</option>
            <% 
            while (rs.next()) {
                int currentSlotId = rs.getInt("SLOTID");
                String slotStart = rs.getString("SLOTSTART");
                String slotEnd = rs.getString("SLOTEND");
                int availability = rs.getInt("AVAILABILITY");

                String selected = (currentSlotId == slotId) ? "selected" : "";
            %>
                <option value="<%= currentSlotId %>" <%= selected %>><%= slotStart %> - <%= slotEnd %> (Available: <%= availability %>)</option>
            <% 
            }
            rs.close();
            ps.close();
            con.close();
            %>
          </select>

          <button type="submit" class="book-btn">Update Booking</button>
        </div>
      </form>

      </div>
    </section>

  <%
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error loading booking details.</p>");
    }
  %>

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
</body>
</html>
