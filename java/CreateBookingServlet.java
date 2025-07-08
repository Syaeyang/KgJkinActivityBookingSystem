import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/CreateBookingServlet")
public class CreateBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String packageIdStr = request.getParameter("packageId");
        String date = request.getParameter("date");
        String adultsStr = request.getParameter("adults");
        String childrenStr = request.getParameter("children");
        String slotIdStr = request.getParameter("slot");
        String bookingStatus = "PENDING";

        // Validate inputs
        if (packageIdStr == null || date == null || adultsStr == null || childrenStr == null || slotIdStr == null ||
            packageIdStr.trim().isEmpty() || date.trim().isEmpty() || adultsStr.trim().isEmpty() || 
            childrenStr.trim().isEmpty() || slotIdStr.trim().isEmpty()) {
            response.sendRedirect("CreateBooking.jsp?error=All fields are required.");
            return;
        }

        try {
            int packageId = Integer.parseInt(packageIdStr);
            int adults = Integer.parseInt(adultsStr);
            int children = Integer.parseInt(childrenStr);
            int slotId = Integer.parseInt(slotIdStr);

            if (!date.matches("\\d{4}-\\d{2}-\\d{2}")) {
                response.sendRedirect("CreateBooking.jsp?error=Invalid date format.");
                return;
            }

            // Database connection
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

            // Check slot availability
            String checkAvailabilityQuery = "SELECT Availability FROM SLOT WHERE SLOTID = ?";
            PreparedStatement checkPs = con.prepareStatement(checkAvailabilityQuery);
            checkPs.setInt(1, slotId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                int availability = rs.getInt("Availability");

                if (availability <= 0) {
                    response.sendRedirect("CreateBooking.jsp?error=Selected slot is no longer available.");
                    return;
                }

                // Insert booking
                String insertBookingQuery = "INSERT INTO BOOKING (BOOKINGDATE, BOOKINGADULTS, BOOKINGCHILDREN, SLOTID, PACKAGEID, BOOKINGSTATUS) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(insertBookingQuery);
                ps.setString(1, date);
                ps.setInt(2, adults);
                ps.setInt(3, children);
                ps.setInt(4, slotId);
                ps.setInt(5, packageId);
                ps.setString(6, bookingStatus);

                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    // Reduce availability
                    String updateSlotQuery = "UPDATE SLOT SET Availability = Availability - 1 WHERE SLOTID = ?";
                    PreparedStatement updatePs = con.prepareStatement(updateSlotQuery);
                    updatePs.setInt(1, slotId);
                    updatePs.executeUpdate();
                    updatePs.close();

                    response.sendRedirect("BookingSummary.jsp");
                } else {
                    response.sendRedirect("CreateBooking.jsp?error=Failed to create booking.");
                }

                ps.close();
            }

            checkPs.close();
            con.close();
        } catch (NumberFormatException e) {
            response.sendRedirect("CreateBooking.jsp?error=Invalid number format.");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("CreateBooking.jsp?error=Database error: " + e.getMessage());
        }
    }
}
