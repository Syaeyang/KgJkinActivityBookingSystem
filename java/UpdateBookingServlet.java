import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UpdateBookingServlet")
public class UpdateBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingid"));
        String bookingDate = request.getParameter("bookingdate");
        int bookingAdults = Integer.parseInt(request.getParameter("bookingadults"));
        int bookingChildren = Integer.parseInt(request.getParameter("bookingchildren"));
        int newSlotId = Integer.parseInt(request.getParameter("slotid"));

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://kgjkinserver.database.windows.net:1433;database=kgJkinDB;";
            con = DriverManager.getConnection(url, "kgjkinadmin@kgjkinserver", "Mycuties_7");

            // 1. Get the old slot ID before update
            String getOldSlotQuery = "SELECT SLOTID FROM BOOKING WHERE BOOKINGID = ?";
            ps = con.prepareStatement(getOldSlotQuery);
            ps.setInt(1, bookingId);
            var rs = ps.executeQuery();
            int oldSlotId = -1;
            if (rs.next()) {
                oldSlotId = rs.getInt("SLOTID");
            }
            rs.close();
            ps.close();

            // 2. Update old slot to Available = 1
            if (oldSlotId != -1 && oldSlotId != newSlotId) {
                String updateOldSlot = "UPDATE SLOT SET Availability = 1 WHERE SLOTID = ?";
                ps = con.prepareStatement(updateOldSlot);
                ps.setInt(1, oldSlotId);
                ps.executeUpdate();
                ps.close();
            }

            // 3. Set new slot to Available = 0
            String updateNewSlot = "UPDATE SLOT SET Availability = 0 WHERE SLOTID = ?";
            ps = con.prepareStatement(updateNewSlot);
            ps.setInt(1, newSlotId);
            ps.executeUpdate();
            ps.close();

            // 4. Now update the booking record
            String updateBooking = "UPDATE BOOKING SET BOOKINGDATE=?, BOOKINGADULTS=?, BOOKINGCHILDREN=?, SLOTID=? WHERE BOOKINGID=?";
            ps = con.prepareStatement(updateBooking);
            ps.setString(1, bookingDate);
            ps.setInt(2, bookingAdults);
            ps.setInt(3, bookingChildren);
            ps.setInt(4, newSlotId);
            ps.setInt(5, bookingId);
            ps.executeUpdate();

            // Done!
            response.sendRedirect("BookingSummary.jsp?bookingid=" + bookingId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error updating booking.");
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}
