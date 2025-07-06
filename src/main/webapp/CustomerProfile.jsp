<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Customer Profile</title>
  <link rel="stylesheet" href="CustomerProfile.css">
  <style>
    .profile-pic {
      width: 200px;
      height: 200px;
      border-radius: 50%;
      object-fit: cover;
      border: 3px solid #ccc;
      cursor: pointer;
      transition: 0.3s ease;
    }

    .profile-pic:hover {
      opacity: 0.8;
      border-color: #4CAF50;
    }

    #fileInput {
      display: none;
    }

    .logout-button button {
      background-color: #ffffff;
      color: #0057b8;
      font-weight: bold;
      padding: 8px 16px;
      border: 2px solid #ffffff;
      border-radius: 6px;
      cursor: pointer;
      transition: all 0.3s ease;
      font-size: 1rem;
    }

    .logout-button button:hover {
      background-color: #ffd700;
      color: #000;
      border-color: #ffd700;
    }

    .header-right {
      display: flex;
      align-items: center;
      gap: 20px;
    }

    .nav-menu ul {
      list-style: none;
      padding: 0;
      margin: 0;
      display: flex;
      gap: 20px;
    }

    .nav-menu a {
      text-decoration: none;
      font-weight: bold;
      color: #0057b8;
    }
  </style>
</head>
<body>
  <header class="site-header">
    <div class="logo">
      <img src="img/logo1.png" alt="Logo">
    </div>
    <div class="header-right">
      <nav class="nav-menu">
        <ul>
          <li><a href="HomeCust.jsp">HOME</a></li>
          <li><a href="ListPackage.jsp">PACKAGE</a></li>
          <li><a href="BookingSummary.jsp">BOOKING</a></li>
        </ul>
      </nav>
      <div class="logout-button">
        <button type="button" onclick="confirmLogout()">Log Out</button>
      </div>
    </div>
  </header>

<%
  HttpSession sess = request.getSession(false);
  Integer customerid = (sess != null) ? (Integer) sess.getAttribute("custid") : null;

  if (customerid == null) {
    response.sendRedirect("LogIn.jsp");
    return;
  }

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

    String sql = "SELECT * FROM CUSTOMER WHERE CUSTID = ?";
    PreparedStatement ps = con.prepareStatement(sql);
    ps.setInt(1, customerid);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
%>

<!-- Profile Section -->
<div class="profile-container" style="text-align: center; padding: 20px;">
  <img src="img/icon1.png" alt="Profile Picture" class="profile-pic" id="profilePreview" onclick="triggerFileInput()">
  <input type="file" id="fileInput" accept="image/*" onchange="previewProfile(event)">

  <div class="profile-info">
    <h2><%= rs.getString("CUSTFIRSTNAME") %> <%= rs.getString("CUSTLASTNAME") %></h2>
  </div>
</div>

<!-- Details Section -->
<div class="container">
  <div class="section">
    <div class="form">
      <div class="info-container">
        <label>Email Address: <%= rs.getString("CUSTEMAIL") %></label><br>
        <label>Phone Number: <%= rs.getString("CUSTPHONENO") %></label>
      </div>
      <a href="UpdateProfile.jsp" class="button">Update Profile</a>
    </div>
  </div>
</div>

<%
    } else {
      out.println("<p>No profile found.</p>");
    }
    rs.close();
    ps.close();
  } catch (Exception e) {
    out.println("<p>Error: " + e.getMessage() + "</p>");
  } finally {
    if (con != null) try { con.close(); } catch (SQLException ignored) {}
  }
%>

<!-- Footer -->
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

<!-- ✅ JS: Profile picture live preview + logout -->
<script>
  function triggerFileInput() {
    document.getElementById("fileInput").click();
  }

  function previewProfile(event) {
    const file = event.target.files[0];
    const preview = document.getElementById('profilePreview');

    if (file && file.type.startsWith('image/')) {
      const reader = new FileReader();
      reader.onload = function (e) {
        preview.src = e.target.result;
      };
      reader.readAsDataURL(file);
    } else {
      alert("Please select a valid image file.");
    }
  }

  function confirmLogout() {
    if (confirm("Are you sure you want to log out?")) {
      alert("You have been logged out successfully.");
      window.location.href = "Home.jsp"; // ✅ Redirect to home page
    }
  }
</script>

</body>
</html>
