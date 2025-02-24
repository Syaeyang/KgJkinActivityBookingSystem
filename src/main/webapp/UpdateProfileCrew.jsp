<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%> 
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Profile Crew</title>
    <link rel="stylesheet" href="SignUp.css">
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
            </ul>
        </nav>
    </header>

    <div class="container">
        <!-- Update Profile Crew Section -->
        <div class="section">
        
        <%
            // Retrieve CREWID from the request parameter
            int crewid = Integer.parseInt(request.getParameter("id"));

            // Fetch crew details from the database
            String firstName = "", lastName = "", email = "", phone = "";

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
                Connection con = DriverManager.getConnection(url);

                // SQL query to fetch crew details
                String sql = "SELECT * FROM CREW WHERE CREWID = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, crewid);

                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    firstName = rs.getString("CREWFIRSTNAME");
                    lastName = rs.getString("CREWLASTNAME");
                    email = rs.getString("CREWEMAIL");
                    phone = rs.getString("CREWPHONENO");
                }
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        %>
            
            <div class="form">
                <form action="UpdateProfileCrewServlet" method="post">
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
