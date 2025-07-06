<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.io.PrintWriter" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Booking Summary</title>
  <link rel="stylesheet" href="BookingSummary.css">
  <style>
    .booking-details {
      border: 1px solid #ccc;
      padding: 15px;
      margin-bottom: 20px;
      background-color: #f9f9f9;
    }
    .update-button, .cancel-button {
      padding: 8px 16px;
      margin-right: 10px;
      border: none;
      border-radius: 5px;
      text-decoration: none;
      font-weight: bold;
      color: white;
      cursor: pointer;
    }
    .update-button {
      background-color: #007BFF;
    }
    .cancel-button {
      background-color: #dc3545;
    }
  </style>
  <script>
    function showCancelMessage(message) {
      alert(message);
    }
  </script>
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

  <main class="summary-container">
    <h1>Booking Summary</h1>
    <%
      Connection con = null;
      try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://kgjkinserver.database.windows.net:1433;"
                   + "database=kgJkinDB;"
                   + "user=kgjkinadmin@kgjkinserver;"
                   + "password=Mycuties_7;"
                   + "encrypt=true;"
                   + "trustServerCertificate=false;"
                   + "hostNameInCertificate=*.database.windows.net;"
                   + "loginTimeout=30;";
        con = DriverManager.getConnection(url);

        String query = "SELECT BOOKINGID, BOOKINGDATE, BOOKINGADULTS, BOOKINGCHILDREN, BOOKINGSTATUS, PACKAGEID, SLOTID FROM BOOKING";
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
          int bookingId = rs.getInt("BOOKINGID");
          String bookingDateStr = rs.getString("BOOKINGDATE");

          // Convert to LocalDate
          LocalDate bookingDate = LocalDate.parse(bookingDateStr);
          LocalDate today = LocalDate.now();

    %>
      <div class="booking-details">
        <p><strong>Booking ID:</strong> <%= bookingId %></p>
        <p><strong>Date:</strong> <%= bookingDateStr %></p>
        <p><strong>Adults:</strong> <%= rs.getInt("BOOKINGADULTS") %></p>
        <p><strong>Children:</strong> <%= rs.getInt("BOOKINGCHILDREN") %></p>
        <p><strong>Status:</strong> <%= rs.getString("BOOKINGSTATUS") %></p>
        <p><strong>Package ID:</strong> <%= rs.getInt("PACKAGEID") %></p>
        <p><strong>Slot ID:</strong> <%= rs.getInt("SLOTID") %></p>

        <!-- Update Button -->
        <a href="UpdateBooking.jsp?bookingid=<%= bookingId %>" class="update-button">UPDATE</a>

        <!-- Cancel Button Logic -->
        <% if (bookingDate.isAfter(today)) { %>
          <!-- Cancel allowed before booking date -->
          <a href="#" class="cancel-button" onclick="showCancelMessage('Booking ID <%= bookingId %> has been cancelled (simulated).')">CANCEL</a>
        <% } else { %>
          <!-- Cancel not allowed on the day -->
          <a href="#" class="cancel-button" onclick="showCancelMessage('Sorry, you cannot cancel this booking today!')">CANCEL</a>
        <% } %>
      </div>
    <%
        }
        rs.close();
        ps.close();
      } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
      } finally {
        if (con != null) try { con.close(); } catch (SQLException ignored) {}
      }
    %>
  </main>

  <footer class="footer">
    <div class="footer-container">
      <div class="footer-text">&copy; 2025 Kg Jkin Xtreme Park. All Rights Reserved.</div>
    </div>
  </footer>
</body>
</html>