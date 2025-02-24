import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Servlet implementation class AddSlotServlet
 */
@WebServlet("/AddSlotServlet")
public class AddSlotServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AddSlotServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String slotNo = request.getParameter("slotNo");
        String slotStart = request.getParameter("slotStart");
        String slotEnd = request.getParameter("slotEnd");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int slotId = -1; // Default error-handling value

        try {
            // Load SQL Server JDBC Driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Establish connection
            String url = "jdbc:sqlserver://kgjkinserver.database.windows.net:1433;"
                       + "database=kgJkinDB;"
                       + "user=kgjkinadmin@kgjkinserver;"
                       + "password=Mycuties_7;"
                       + "encrypt=true;"
                       + "trustServerCertificate=false;"
                       + "hostNameInCertificate=*.database.windows.net;"
                       + "loginTimeout=30;";
            con = DriverManager.getConnection(url);

            // Insert new slot into the SLOT table, setting Availability = 1 by default
            String sql = "INSERT INTO SLOT (SLOTNO, SLOTSTART, SLOTEND, Availability) VALUES (?, ?, ?, ?);";
            ps = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);

            ps.setString(1, slotNo);
            ps.setString(2, slotStart);
            ps.setString(3, slotEnd);
            ps.executeUpdate();

            // Retrieve the generated SLOTID
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                slotId = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        // Pass slotId to ListSlot.jsp
        request.setAttribute("slotId", slotId);
        RequestDispatcher req = request.getRequestDispatcher("ListSlot.jsp");
        req.forward(request, response);
    }
}
