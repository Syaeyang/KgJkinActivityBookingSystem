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
 * Servlet implementation class UpdatePackageServlet
 */
@WebServlet("/UpdatePackageServlet")
public class UpdatePackageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UpdatePackageServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Remove doGet() call; we are handling only POST requests here.

        int packageid;
        double price;
        
        // Validate input parameters
        try {
            packageid = Integer.parseInt(request.getParameter("packageid"));
            price = Double.parseDouble(request.getParameter("price"));
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid package ID or price format.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        String packageName = request.getParameter("packageName");
        String duration = request.getParameter("duration");
        String details = request.getParameter("additionalDetails");

        if (packageName == null || duration == null || details == null) {
            request.setAttribute("errorMessage", "Missing required package details.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        try {
            // Load JDBC Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");

            try (Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system");
                 PreparedStatement ps = con.prepareStatement("UPDATE package SET packagename = ?, packageprice = ?, packageduration = ?, packagedetails = ? WHERE packageid = ?")) {

                ps.setString(1, packageName);
                ps.setDouble(2, price);
                ps.setString(3, duration);
                ps.setString(4, details);
                ps.setInt(5, packageid);

                int rowsUpdated = ps.executeUpdate();

                if (rowsUpdated > 0) {
                    response.sendRedirect("ListPackageUpdate.jsp?id=" + packageid);
                } else {
                    request.setAttribute("errorMessage", "Failed to update package.");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
