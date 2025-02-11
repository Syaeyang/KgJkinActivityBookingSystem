import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

/**
 * Servlet implementation class UpdateSlotServlet
 */
@WebServlet("/UpdateSlotServlet")
public class UpdateSlotServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UpdateSlotServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int slotid;

        // Validate slot ID
        try {
            slotid = Integer.parseInt(request.getParameter("slotid"));
        } catch (NumberFormatException e) {
            response.getWriter().println("<h3>Error: Invalid Slot ID format.</h3>");
            return;
        }

        String slotNo = request.getParameter("slotNo");
        String slotStart = request.getParameter("slotStart");
        String slotEnd = request.getParameter("slotEnd");

        // Validate that inputs are not null
        if (slotNo == null || slotStart == null || slotEnd == null) {
            response.getWriter().println("<h3>Error: Missing required slot details.</h3>");
            return;
        }

        try {
            // Load JDBC Driver
            Class.forName("oracle.jdbc.OracleDriver");

            // Establish database connection
            try (Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system");
                 PreparedStatement ps = con.prepareStatement("UPDATE SLOT SET SLOTNO=?, SLOTSTART=?, SLOTEND=? WHERE SLOTID=?")) {

                ps.setString(1, slotNo);
                ps.setString(2, slotStart);
                ps.setString(3, slotEnd);
                ps.setInt(4, slotid); // Corrected index from 5 to 4

                int rowsUpdated = ps.executeUpdate();

                if (rowsUpdated > 0) {
                    response.sendRedirect("ListSlot.jsp?id=" + slotid);
                } else {
                    response.getWriter().println("<h3>Error: Failed to update slot.</h3>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: Database error - " + e.getMessage() + "</h3>");
        }
    }
}
