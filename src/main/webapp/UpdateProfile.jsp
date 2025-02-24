<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Profile</title>
    <link rel="stylesheet" href="SignUp.css">
</head>
<body>
    <header class="site-header">
        <div class="logo">
            <img src="img/logo1.png" alt="Logo">
        </div>
        <nav class="nav-menu">
            <ul>
                <li><a href="HOME1.jsp">HOME</a></li>
                <li><a href="ListPackage.jsp">PACKAGE</a></li>
            </ul>
        </nav>
    </header>

    <div class="container">
        <h2>Update Profile</h2>

        <!-- Update Profile Section -->
        <div class="section">
        <%
            // Retrieve customer ID from session
            HttpSession sess = request.getSession(false);
            Integer customerid = (sess != null) ? (Integer) sess.getAttribute("custid") : null;

            if (customerid == null) { 
                response.sendRedirect("login.jsp"); // Redirect if not logged in
                return;
            }

            // Fetch customer details from the database
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

                // SQL query to fetch customer details
                String sql = "SELECT * FROM CUSTOMER WHERE CUSTID = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, customerid);

                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    firstName = rs.getString("CUSTFIRSTNAME");
                    lastName = rs.getString("CUSTLASTNAME");
                    email = rs.getString("CUSTEMAIL");
                    phone = rs.getString("CUSTPHONENO");
                }
                rs.close();
                ps.close();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        %>
            
            <div class="form">
                <form action="UpdateProfileServlet" method="post">
                    <input type="hidden" name="customerid" value="<%= customerid %>">

                    <label for="customerfirstname">First Name</label>
                    <input type="text" id="customerfirstname" name="customerfirstname" value="<%= firstName %>" required>

                    <label for="customerlastname">Last Name</label>
                    <input type="text" id="customerlastname" name="customerlastname" value="<%= lastName %>" required>

                    <label for="customeremail">Email Address</label>
                    <input type="text" id="customeremail" name="customeremail" value="<%= email %>" required>

                    <label for="customerphone">Phone Number</label>
                    <input type="text" id="customerphone" name="customerphone" value="<%= phone %>" required>

                    <button type="submit"><b>Update Profile</b></button>
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
