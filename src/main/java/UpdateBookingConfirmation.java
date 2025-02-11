import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/UpdateBookingConfirmation")
public class UpdateBookingConfirmation extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingIdStr = request.getParameter("bookingId");
        String status = request.getParameter("status");

        if (bookingIdStr == null || status == null) {
            response.getWriter().println("Invalid request.");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);

            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system");

            // Update the booking status in the BOOKING table
            String sql = "UPDATE BOOKING SET BOOKINGSTATUS = ? WHERE BOOKINGID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, bookingId);

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect("BookingList.jsp"); // Redirect to the booking list page
            } else {
                response.getWriter().println("Failed to update booking status.");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
