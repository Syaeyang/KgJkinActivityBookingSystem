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

/**
 * Servlet implementation class AddSlotServlet
 */
@WebServlet("/AddSlotServlet") // Servlet mapped to this URL
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

            // Insert new slot into the SLOT table
            String sql = "INSERT INTO SLOT (SLOTNO, SLOTSTART, SLOTEND) VALUES (?, ?, ?)";
            ps = con.prepareStatement(sql);

            ps.setString(1, slotNo);
            ps.setString(2, slotStart);
            ps.setString(3, slotEnd);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        // Forward request to ListSlot.jsp after inserting
        RequestDispatcher req = request.getRequestDispatcher("ListSlot.jsp");
        req.forward(request, response);
    }
}
