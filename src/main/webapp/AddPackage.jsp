<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import = "java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Package Activity</title>
    <link rel="stylesheet" href="AddPackage.css">
</head>
<body>
   
        <header class="site-header">
          <div class="logo">
            <img src="img/logo1.png" alt="Logo">
          </div>
          <nav class="nav-menu">
            <ul>
              <li><a href="HOME2.jsp">HOME</a></li>
              <li><a href="ListPackage.jsp">PACKAGE</a></li>
              <li><a href="BookingList.jsp">BOOKING</a></li>
            </ul>
          </nav>
        </header>
      
 
            <form action="AddPackageServlet" method="post">
            <div class="package-form">
                <div class="package-details">
                  <h1>ADD PACKAGE</h1>
                    <label>
                        Package Name<br>
                        <input type="text" id="packageName" name="packageName" class = "input" required>
                    </label>
                    <div class="activity">
                        <label>
                            Price<br>
                            <input type="number" id="price" name="price" class = "input"  step="0.01" required>
                        </label>
                       
                    </div>
                    <div class="activity">
                        <label>
                            Duration<br>
                            <input type="text" id="duration" name="duration" class = "input"  required>
                        </label>
                                           </div>
                    <div class="activity">
                        <label>
                           Additional Details<br>
                           <input type="text" id="additionalDetails" name="additionalDetails" class = "input"  required>
                        </label>
               
                    </div>

                </div>
                <button type="submit" class="add-package-btn"><b>Add Package</b></button>
                <button class ="add-package-btn" onclick="window.location.href='AddActivity.jsp'">Add New Activity</button>
               
            </div>
        </form>
            
</body>

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
      </html>
  
