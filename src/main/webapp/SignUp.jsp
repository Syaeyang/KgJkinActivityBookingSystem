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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Homepage, Login, and Sign Up</title>
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
                    <input type="password" id="customerpassword" name="customerpassword" placeholder="Enter a password" required>

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
