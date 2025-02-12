<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import = "java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Booking List</title>
  <link rel="stylesheet" href="BookingList.css">
</head>
<body>

<header class="site-header">
            <div class="logo">
                <img src="img/logo1.png" alt="Logo">
            </div>
            <nav class="nav-menu">
                <ul>
                    <li><a href="HOME2">HOME</a></li>
                    <li><a href="ListPackageUpdate">PACKAGE</a></li>
                    <li><a href="BookingList">BOOKING</a></li>
                </ul>
            </nav>
        </header>

  <h1>Booking List</h1>
  <div class="slots-container">
    <% 
      // Fetching data only from the BOOKING table
      try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system");

        // Query to fetch data from BOOKING table
        String sql = "SELECT BOOKINGID, BOOKINGDATE, BOOKINGADULTS, BOOKINGCHILDREN, BOOKINGSTATUS FROM BOOKING";
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
    %>
        <div class="booking-item">
          <p><strong>Booking ID:</strong> <%= rs.getInt("BOOKINGID") %></p>
          <p><strong>Date:</strong> <%= rs.getString("BOOKINGDATE") %></p>
          <p><strong>Adults:</strong> <%= rs.getInt("BOOKINGADULTS") %></p>
          <p><strong>Children:</strong> <%= rs.getInt("BOOKINGCHILDREN") %></p>
          <p><strong>Status:</strong> <%= rs.getString("BOOKINGSTATUS") %></p>

          <!-- Buttons for approval/rejection -->
          <form action="/UpdateBookingConfirmation" method="post">
            <input type="hidden" name="bookingId" value="<%= rs.getInt("BOOKINGID") %>">
            <button type="submit" name="status" value="APPROVED" class="approve-btn">Approve</button>
            <button type="submit" name="status" value="DECLINED" class="decline-btn">Decline</button>
          </form>
        </div>
    <% 
        }
        con.close();
      } catch (Exception e) {
        e.printStackTrace();
    %>
        <p>Error fetching booking data. Please try again later.</p>
    <% 
      }
    %>
  </div>
  
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
