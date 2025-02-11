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
        int customerid;

        // Validate input parameters
        try {
            customerid = Integer.parseInt(request.getParameter("customerid"));
        } catch (NumberFormatException e) {
            response.getWriter().println("<h3>Error: Invalid Customer ID format.</h3>");
            return;
        }

        String customerfirstname = request.getParameter("customerfirstname");
        String customerlastname = request.getParameter("customerlastname");
        String customeremail = request.getParameter("customeremail");
        String customerphone = request.getParameter("customerphone");

        if (customerfirstname == null || customerlastname == null || customeremail == null || customerphone == null) {
            response.getWriter().println("<h3>Error: Missing required profile details.</h3>");
            return;
        }

        try {
            // Load JDBC Driver (Updated)
            Class.forName("oracle.jdbc.OracleDriver");

            // Establish database connection
            try (Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system");
                 PreparedStatement ps = con.prepareStatement("UPDATE CUSTOMER SET CUSTFIRSTNAME = ?, CUSTLASTNAME = ?, CUSTEMAIL = ?, CUSTPHONENO = ? WHERE CUSTID = ?")) {

                ps.setString(1, customerfirstname);
                ps.setString(2, customerlastname);
                ps.setString(3, customeremail);
                ps.setString(4, customerphone);
                ps.setInt(5, customerid);

                int rowsUpdated = ps.executeUpdate();

                if (rowsUpdated > 0) {
                    response.sendRedirect("CustomerProfile.jsp?id=" + customerid);
                } else {
                    response.getWriter().println("<h3>Error: Failed to update customer profile.</h3>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: Database error - " + e.getMessage() + "</h3>");
        }
    }
}
