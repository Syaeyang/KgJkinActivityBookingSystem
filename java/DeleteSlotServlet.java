import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/DeleteSlotServlet")
public class DeleteSlotServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int slotid = Integer.parseInt(request.getParameter("id"));

        try {
            // Load JDBC driver
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

            String sql = "DELETE FROM SLOT WHERE SLOTID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, slotid);
            int rowsAffected = ps.executeUpdate();

            con.close();

            if (rowsAffected > 0) {
                // Redirect with success message
                response.sendRedirect("ListSlot.jsp?message=deleted");
            } else {
                response.sendRedirect("ListSlot.jsp?error=notfound");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ListSlot.jsp?error=" + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
