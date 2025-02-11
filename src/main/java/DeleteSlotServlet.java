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

    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteSlotServlet() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int slotid = Integer.parseInt(request.getParameter("id"));

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system");

            String sql = "DELETE FROM SLOT WHERE SLOTID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, slotid);
            ps.executeUpdate();

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        RequestDispatcher req = request.getRequestDispatcher("ListSlot.jsp");
        req.forward(request, response);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
