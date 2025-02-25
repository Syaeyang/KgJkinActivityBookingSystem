<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="LogIn.css">
</head>
<body>
    <header class="site-header">
        <div class="logo">
            <img src="img/logo1.png" alt="Logo">
        </div>
        <nav class="nav-menu">
            <ul>
                <li><a href="Home.jsp">HOME</a></li>
            </ul>
        </nav>
    </header>

    <div class="container">
        <div class="section">
            <div class="form">
                <h2>Login</h2>

                <!-- Display error message if login fails -->
                <% if (request.getParameter("error") != null) { %>
                    <p style="color:red;"><%= request.getParameter("error") %></p>
                <% } %>

                <form action="LogInServlet" method="post">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="Enter your email" required>

                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>

                    <br> <button type="submit"><b>Login</b></button>
                </form>
                <p>Log In for Crew Account <a href="LogInCrew.jsp">Log In</a></p>
            </div>
        </div>
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
