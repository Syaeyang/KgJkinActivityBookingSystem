import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/CreateBookingServlet")
public class CreateBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve parameters from the form submission
        String packageIdStr = request.getParameter("packageId");
        String date = request.getParameter("date");  // Assuming date is passed as YYYY-MM-DD
        String adultsStr = request.getParameter("adults");
        String childrenStr = request.getParameter("children");
        String slotIdStr = request.getParameter("slot");
        String bookingStatus = "PENDING";

        // Validate input values
        if (packageIdStr == null || date == null || adultsStr == null || childrenStr == null || slotIdStr == null ||
            packageIdStr.isEmpty() || date.isEmpty() || adultsStr.isEmpty() || childrenStr.isEmpty() || slotIdStr.isEmpty()) {
            response.sendRedirect("CreateBooking.jsp?error=All fields are required.");
            return;
        }

        try {
            // Convert strings to integers
            int packageId = Integer.parseInt(packageIdStr);
            int adults = Integer.parseInt(adultsStr);
            int children = Integer.parseInt(childrenStr);
            int slotId = Integer.parseInt(slotIdStr);

            // Ensure the date is in the correct format (YYYY-MM-DD)
            if (!date.matches("\\d{4}-\\d{2}-\\d{2}")) {
                response.sendRedirect("CreateBooking.jsp?error=Invalid date format. Please use YYYY-MM-DD.");
                return;
            }

            // Establish SQL Server connection
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

            // Insert into BOOKING table (SQL Server uses IDENTITY(1,1) for auto-increment)
            String insertBookingQuery = "INSERT INTO BOOKING (BOOKINGDATE, BOOKINGADULTS, BOOKINGCHILDREN, SLOTID, PACKAGEID, BOOKINGSTATUS) " +
                                        "VALUES (CAST(? AS DATE), ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(insertBookingQuery);
            ps.setString(1, date);  // Set the date in the format 'YYYY-MM-DD'
            ps.setInt(2, adults);    // Set the number of adults
            ps.setInt(3, children);  // Set the number of children
            ps.setInt(4, slotId);    // Set the slot ID
            ps.setInt(5, packageId); // Set the package ID
            ps.setString(6, bookingStatus); // Set the booking status as PENDING

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("BookingSummary.jsp");
            } else {
                response.sendRedirect("CreateBooking.jsp?error=Failed to create booking.");
            }

            ps.close();
            con.close();
        } catch (NumberFormatException e) {
            response.sendRedirect("CreateBooking.jsp?error=Invalid number format. Please check your inputs.");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("CreateBooking.jsp?error=Error: " + e.getMessage());
        }
    }
}
