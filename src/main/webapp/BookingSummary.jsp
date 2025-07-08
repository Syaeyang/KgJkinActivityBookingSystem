<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking Summary</title>
    <link rel="stylesheet" href="BookingSummary.css">
    <script>
        function showCancelMessage() {
            alert("Sorry, you cannot cancel this booking.");
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

                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                LocalDate today = LocalDate.now();

                while (rs.next()) {
                    int bookingId = rs.getInt("BOOKINGID");
                    String bookingDateStr = rs.getString("BOOKINGDATE");
                    LocalDate bookingDate = LocalDate.parse(bookingDateStr, formatter);
        %>
            <div class="booking-details">
                <p><strong>Booking ID:</strong> <%= bookingId %></p>
                <p><strong>Date:</strong> <%= bookingDateStr %></p>
                <p><strong>Adults:</strong> <%= rs.getInt("BOOKINGADULTS") %></p>
                <p><strong>Children:</strong> <%= rs.getInt("BOOKINGCHILDREN") %></p>
                <p><strong>Status:</strong> <%= rs.getString("BOOKINGSTATUS") %></p>
                <p><strong>Package ID:</strong> <%= rs.getInt("PACKAGEID") %></p>
                <p><strong>Slot ID:</strong> <%= rs.getInt("SLOTID") %></p>

                <a href="UpdateBooking.jsp?bookingid=<%= bookingId %>" class="update-button">UPDATE</a>

                <% if (bookingDate.isAfter(today)) { %>
                    <a href="DeleteBooking.jsp?bookingid=<%= bookingId %>" class="cancel-button">CANCEL</a>
                <% } else { %>
                    <button class="cancel-button" onclick="showCancelMessage()">CANCEL</button>
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
