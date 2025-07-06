<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Crew Profile</title>
  <link rel="stylesheet" href="CrewProfile.css">
  <style>
    .logout-btn {
      background-color: transparent;
      border: 2px solid #fff;
      color: #fff;
      padding: 6px 12px;
      border-radius: 5px;
      cursor: pointer;
      font-weight: bold;
      transition: 0.3s;
    }

    .logout-btn:hover {
      background-color: #ffd700;
      color: #000;
      border-color: #ffd700;
    }

    .nav-menu ul {
      display: flex;
      align-items: center;
      gap: 20px;
      list-style: none;
      padding: 0;
    }

    .nav-menu li {
      display: inline-block;
    }

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
  </style>
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
        <li>
          <button class="logout-btn" onclick="confirmLogout()">LOG OUT</button>
        </li>
      </ul>
    </nav>
  </header>

  <form>
    <%
      Integer crewid = (Integer) session.getAttribute("crewid");

      if (crewid != null) {
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
          Connection con = DriverManager.getConnection(url);

          String sql = "SELECT CREWFIRSTNAME, CREWLASTNAME FROM CREW WHERE CREWID = ?";
          PreparedStatement ps = con.prepareStatement(sql);
          ps.setInt(1, crewid);
          ResultSet rs = ps.executeQuery();

          if (rs.next()) {
    %>
      <div class="profile-container" style="text-align:center; padding: 20px;">
        <img src="img/icon1.png" alt="Profile Picture" class="profile-pic" id="profilePreview" onclick="triggerFileInput()">
        <input type="file" id="fileInput" accept="image/*" onchange="previewProfile(event)">

        <div class="profile-info">
          <h2><%= rs.getString("CREWFIRSTNAME") %> <%= rs.getString("CREWLASTNAME") %></h2>
          <p>Hello, Crew ID: <%= crewid %>!</p>

          <a href="AddActivity.jsp"><button type="button"><b>Add Package & Activity</b></button></a>
          <a href="ListPackageCrew.jsp"><button type="button"><b>Update Package</b></button></a>
          <a href="AddSlot.jsp"><button type="button"><b>New Booking Slot</b></button></a>
          <a href="UpdateProfile.jsp"><button type="button"><b>Update Profile</b></button></a>
        </div>
      </div>
    <%
          } else {
            out.println("<p>No Profile found with the given ID.</p>");
          }
          con.close();
        } catch (Exception e) {
          out.println("<p>Error: " + e.getMessage() + "</p>");
        }
      } else {
        out.println("<p>Error: You are not logged in. Please <a href='LogInCrew.jsp'>log in</a>.</p>");
      }
    %>
  </form>

  <footer class="footer">
    <div class="footer-container">
      <div class="icon"><img src="img/fb1.png" alt="Facebook Icon"></div>
      <div class="icon"><img src="img/email1.png" alt="Email Icon"></div>
      <div class="footer-text">&copy; 2025 Kg Jkin Xtreme Park. All Rights Reserved.</div>
    </div>
  </footer>

  <!-- ✅ JavaScript for Logout & Profile Image Preview -->
  <script>
    function confirmLogout() {
      if (confirm("Are you sure you want to log out?")) {
        alert("You have been logged out successfully.");
        window.location.href = "Home.jsp";
      }
    }

    function triggerFileInput() {
      document.getElementById("fileInput").click();
    }

    function previewProfile(event) {
      const file = event.target.files[0];
      const preview = document.getElementById("profilePreview");

      if (file && file.type.startsWith("image/")) {
        const reader = new FileReader();
        reader.onload = function (e) {
          preview.src = e.target.result;
        };
        reader.readAsDataURL(file);
      } else {
        alert("Please select a valid image file.");
      }
    }
  </script>
</body>
</html>
