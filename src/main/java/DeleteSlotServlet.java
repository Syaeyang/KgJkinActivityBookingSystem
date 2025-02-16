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
 * Servlet implementation class DeleteSlotServlet
 */
@WebServlet("/DeleteSlotServlet") // Added WebServlet annotation
public class DeleteSlotServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    static Connection con = null;
    static PreparedStatement ps = null;

    public DeleteSlotServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int slotid = Integer.parseInt(request.getParameter("id"));

        try {
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

            // Delete slot using correct column name
            String sql = "DELETE FROM SLOT WHERE SLOTID = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, slotid);
            int rowsAffected = ps.executeUpdate();

            con.close();

            if (rowsAffected > 0) {
                request.setAttribute("message", "Slot deleted successfully.");
            } else {
                request.setAttribute("error", "Failed to delete slot. It may not exist.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        RequestDispatcher req = request.getRequestDispatcher("ListSlot.jsp");
        req.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
