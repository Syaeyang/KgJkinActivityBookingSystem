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
 * Servlet implementation class UpdateProfileServlet
 */
@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UpdateProfileServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int customerId;

        // Validate input parameters
        try {
            customerId = Integer.parseInt(request.getParameter("customerid"));
        } catch (NumberFormatException e) {
            response.getWriter().println("<h3>Error: Invalid Customer ID format.</h3>");
            return;
        }

        String customerFirstName = request.getParameter("customerfirstname");
        String customerLastName = request.getParameter("customerlastname");
        String customerEmail = request.getParameter("customeremail");
        String customerPhone = request.getParameter("customerphone");

        if (customerFirstName == null || customerLastName == null || customerEmail == null || customerPhone == null) {
            response.getWriter().println("<h3>Error: Missing required profile details.</h3>");
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

            // Update customer profile
            String sql = "UPDATE CUSTOMER SET CUSTFIRSTNAME = ?, CUSTLASTNAME = ?, CUSTEMAIL = ?, CUSTPHONENO = ? WHERE CUSTID = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, customerFirstName);
            ps.setString(2, customerLastName);
            ps.setString(3, customerEmail);
            ps.setString(4, customerPhone);
            ps.setInt(5, customerId);
            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect("CustomerProfile.jsp?id=" + customerId);
            } else {
                response.getWriter().println("<h3>Error: Failed to update customer profile.</h3>");
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
