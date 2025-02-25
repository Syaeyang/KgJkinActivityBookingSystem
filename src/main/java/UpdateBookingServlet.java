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
        int slotId = Integer.parseInt(request.getParameter("slotid"));

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://kgjkinserver.database.windows.net:1433;database=kgJkinDB;";
            con = DriverManager.getConnection(url, "kgjkinadmin@kgjkinserver", "Mycuties_7");

            String query = "UPDATE BOOKING SET BOOKINGDATE=?, BOOKINGADULTS=?, BOOKINGCHILDREN=?, SLOTID=? WHERE BOOKINGID=?";
            ps = con.prepareStatement(query);
            ps.setString(1, bookingDate);
            ps.setInt(2, bookingAdults);
            ps.setInt(3, bookingChildren);
            ps.setInt(4, slotId);
            ps.setInt(5, bookingId);

            ps.executeUpdate();

            response.sendRedirect("BookingSummary.jsp?bookingid=" + bookingId);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error updating booking.");
        }
    }
}
