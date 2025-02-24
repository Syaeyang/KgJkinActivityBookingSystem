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
        int slotId;

        // Validate slot ID
        try {
            slotId = Integer.parseInt(request.getParameter("slotid"));
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

        Connection con = null;
        PreparedStatement ps = null;

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
            con = DriverManager.getConnection(url);

            // Update slot details
            String sql = "UPDATE SLOT SET SLOTNO=?, SLOTSTART=?, SLOTEND=? WHERE SLOTID=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, slotNo);
            ps.setString(2, slotStart);
            ps.setString(3, slotEnd);
            ps.setInt(4, slotId);

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect("ListSlot.jsp?id=" + slotId);
            } else {
                response.getWriter().println("<h3>Error: Failed to update slot.</h3>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: Database error - " + e.getMessage() + "</h3>");
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
