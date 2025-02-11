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
            <!-- Display table structure -->
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
              // Establish database connection
              Class.forName("oracle.jdbc.driver.OracleDriver");
              Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system");

              // Prepare SQL query to fetch all slots
              String sql = "SELECT * FROM SLOT ORDER BY SLOTID";
              Statement stmt = con.createStatement();
              ResultSet rs = stmt.executeQuery(sql);

              // Iterate through result set and display slot details
              while (rs.next()) {
                  int slotid = rs.getInt(1);
                  String slotNo = rs.getString(2);
                  String slotStart = rs.getString(3);
                  String slotEnd = rs.getString(4);
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


