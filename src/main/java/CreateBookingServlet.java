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
            // Convert strings to integers and validate them
            int packageId = Integer.parseInt(packageIdStr);
            int adults = Integer.parseInt(adultsStr);
            int children = Integer.parseInt(childrenStr);
            int slotId = Integer.parseInt(slotIdStr);

            // Ensure the date is in the correct format (YYYY-MM-DD)
            if (!date.matches("\\d{4}-\\d{2}-\\d{2}")) {
                response.sendRedirect("CreateBooking.jsp?error=Invalid date format. Please use YYYY-MM-DD.");
                return;
            }

            // Database connection and insertion logic
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system");

            // Prepare the SQL query with TO_DATE to format the date
            String insertBookingQuery = "INSERT INTO BOOKING (BOOKINGID, BOOKINGDATE, BOOKINGADULTS, BOOKINGCHILDREN, SLOTID, PACKAGEID, BOOKINGSTATUS) " +
                                        "VALUES (BOOK_ID_SEQ.NEXTVAL, TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?, ?, ?)";
            
            // Prepare the statement with the input values
            PreparedStatement ps = con.prepareStatement(insertBookingQuery);
            ps.setString(1, date);  // Set the date in the format 'YYYY-MM-DD'
            ps.setInt(2, adults);    // Set the number of adults
            ps.setInt(3, children);  // Set the number of children
            ps.setInt(4, slotId);    // Set the slot ID
            ps.setInt(5, packageId);  // Set the package ID
            ps.setString(6, bookingStatus); // Set the booking status as PENDING

            // Execute the update and check if the insertion was successful
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                // If successful, redirect to the booking summary page
                response.sendRedirect("BookingSummary.jsp");
            } else {
                // If failed, redirect back to the CreateBooking.jsp page with an error message
                response.sendRedirect("CreateBooking.jsp?error=Failed to create booking.");
            }

            con.close();  // Close the connection to the database
        } catch (NumberFormatException e) {
            // Handle invalid number format (e.g., non-numeric inputs for adults, children, or slotId)
            response.sendRedirect("CreateBooking.jsp?error=Invalid number format. Please check your inputs.");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            // Redirect to CreateBooking.jsp with the error message
            response.sendRedirect("CreateBooking.jsp?error=Error: " + e.getMessage());
        }
    }
}
