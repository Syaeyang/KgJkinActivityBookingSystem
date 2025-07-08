<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.SQLException" %>

<%
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

} catch (ClassNotFoundException e) {
    e.printStackTrace();
} catch (SQLException e) {
    e.printStackTrace();
} finally {
    if (con != null) {
        try {
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
%>



<!DOCTYPE html>
<html>
<!-- Google Material Icons (eye icon) -->
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<head>
    <meta charset="UTF-8">
    <title>Sign Up</title>
    <!-- correct this linkage when deploy betul betul -->
    <link rel="stylesheet" href="SignUp.css"> 
</head>
<body>
    <header class="site-header">
        <div class="logo">
            <img src="img/logo1.png" alt="Logo">
        </div>
        <nav class="nav-menu">
            <ul>
                <li><a href="Home.jsp">HOME</a></li>
                <li><a href="ListPackage.jsp">PACKAGE</a></li>
            </ul>
        </nav>
    </header>

    <div class="container">
        <!-- Sign Up Section -->
        <div class="section">
            <div class="form">
                    <%
                        String errorMsg = (String) request.getAttribute("errorMsg");
                        if (errorMsg != null) {
                    %>
                        <p style="color:red;"><%= errorMsg %></p>
                    <%
                        }
                    %>

                    <form action="SignUpServlet" method="post">
                    <label for="customerfirstname">First Name</label>
                    <input type="text" id="customerfirstname" name="customerfirstname" placeholder="Enter your first name" required>

                    <label for="customerlastname">Last Name</label>
                    <input type="text" id="customerlastname" name="customerlastname" placeholder="Enter your last name" required>

                    <label for="customeremail">Email Address</label>
                    <input type="text" id="customeremail" name="customeremail" placeholder="Enter your email address" required>

                    <label for="customerphone">Phone Number</label>
                    <input type="text" id="customerphone" name="customerphone" placeholder="Enter your phone number" required>
                    
                    <label for="customerpassword">Password</label>
                    <div style="position: relative;">
                        <input type="password" id="customerpassword" name="customerpassword" placeholder="Enter a password" required>
                        <span class="material-icons" id="togglePassword" style="
                            position: absolute;
                            right: 10px;
                            top: 50%;
                            transform: translateY(-50%);
                            cursor: pointer;
                            font-size: 22px;
                            color: #666;">visibility</span>
                    </div>

                    <small id="password-strength" style="color: gray;">Password strength: </small>

                    <script>
                        const passwordInput = document.getElementById("customerpassword");
                        const togglePassword = document.getElementById("togglePassword");
                        const strengthText = document.getElementById("password-strength");

                        togglePassword.addEventListener("click", function () {
                            const type = passwordInput.getAttribute("type") === "password" ? "text" : "password";
                            passwordInput.setAttribute("type", type);
                            this.textContent = type === "password" ? "visibility" : "visibility_off";
                        });

                        passwordInput.addEventListener("input", function () {
                            const password = this.value;
                            if (password.length < 8) {
                                strengthText.textContent = "Password strength: Weak";
                                strengthText.style.color = "red";
                            } else if (/[A-Z]/.test(password) && /[0-9]/.test(password)) {
                                strengthText.textContent = "Password strength: Strong";
                                strengthText.style.color = "green";
                            } else {
                                strengthText.textContent = "Password strength: Medium";
                                strengthText.style.color = "orange";
                            }
                        });
                    </script>


                    <button type="submit"><b>Sign Up</b></button>
                </form>

                <p>Sign Up for Crew Account <a href="SignUpCrew.jsp">Sign Up</a></p>
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
