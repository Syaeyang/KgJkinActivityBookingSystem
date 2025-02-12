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

    /**
     * Handles the POST request to update package details.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int packageId;
        double price;

        // Validate input parameters
        try {
            packageId = Integer.parseInt(request.getParameter("packageId"));
            price = Double.parseDouble(request.getParameter("price"));
        } catch (NumberFormatException e) {
            response.getWriter().println("<h3>Error: Invalid package ID or price format.</h3>");
            return;
        }

        String packageName = request.getParameter("packageName");
        String duration = request.getParameter("duration");
        String details = request.getParameter("additionalDetails");

        if (packageName == null || duration == null || details == null) {
            response.getWriter().println("<h3>Error: Missing required package details.</h3>");
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

            // Update package details in the database
            String sql = "UPDATE PACKAGE SET PACKAGENAME = ?, PACKAGEPRICE = ?, PACKAGEDURATION = ?, PACKAGEDETAILS = ? WHERE PACKAGEID = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, packageName);
            ps.setDouble(2, price);
            ps.setString(3, duration);
            ps.setString(4, details);
            ps.setInt(5, packageId);
            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect("ListPackageUpdate.jsp?id=" + packageId);
            } else {
                response.getWriter().println("<h3>Error: Failed to update package.</h3>");
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
