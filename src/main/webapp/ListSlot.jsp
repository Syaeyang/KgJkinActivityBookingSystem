<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import = "java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Slot List</title>
    <link rel="stylesheet" href="ListPackage.css">
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
</body>
  
<div class="packages-container">
    <table border="1" class="activity-table">
        <thead>
            <tr>
                <th>Slot ID</th>
                <th>Slot Number</th>
                <th>Start Time</th>
                <th>End Time</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                // Load SQL Server JDBC Driver
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                
                // Establish database connection
                String url = "jdbc:sqlserver://kgjkinserver.database.windows.net:1433;"
                           + "database=kgJkinDB;"
                           + "user=kgjkinadmin@kgjkinserver;"
                           + "password=Mycuties_7;"
                           + "encrypt=true;"
                           + "trustServerCertificate=false;"
                           + "hostNameInCertificate=*.database.windows.net;"
                           + "loginTimeout=30;";
                
                Connection con = DriverManager.getConnection(url);
                
                // Prepare SQL query to fetch all slots
                String sql = "SELECT SlotID, SlotNumber, StartTime, EndTime FROM SLOT ORDER BY SlotID";
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(sql);
                
                // Iterate through result set and display slot details
                while (rs.next()) {
                    int slotid = rs.getInt("SlotID");
                    String slotNo = rs.getString("SlotNumber");
                    String slotStart = rs.getString("StartTime");
                    String slotEnd = rs.getString("EndTime");
        %>
                    <tr>
                        <td><%= slotid %></td>
                        <td><%= slotNo %></td>
                        <td><%= slotStart %></td>
                        <td><%= slotEnd %> </td>
                        <td>
                            <button class="book-btn" onclick="UpdateSlot(<%= slotid %>)">Update</button>
                            <button class="book-btn" onclick="DeleteSlot(<%= slotid %>)">Delete</button>
                        </td>
                    </tr>
        <%
                }
                // Close the database connection
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error loading activity list.</p>");
            }
        %>
        </tbody>
    </table>
</div>

<script type="text/javascript">
    function UpdateSlot(id) {
        window.location.href = "UpdateSlot.jsp?id=" + id;
    }
    function DeleteSlot(id) {
        window.location.href = "DeleteSlotServlet?id=" + id;
    }
</script>
</html>
