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
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddSlotServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String slotNo = request.getParameter("slotNo");
        String slotStart = request.getParameter("slotStart");
        String slotEnd = request.getParameter("slotEnd");

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system");

            String sql = "INSERT INTO SLOT(SLOTID, SLOTNO, SLOTSTART, SLOTEND) VALUES(SLOT_ID_SEQ.NEXTVAL,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, slotNo);
            ps.setString(2, slotStart);
            ps.setString(3, slotEnd);

            ps.executeUpdate();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        RequestDispatcher req = request.getRequestDispatcher("ListSlot.jsp");
        req.forward(request, response);
    }
}
