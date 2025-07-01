import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/UpdatePackageServlet")
public class UpdatePackageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int packageId;
        double price;

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

        if (packageName == null || duration == null || details == null || packageName.isEmpty() || duration.isEmpty() || details.isEmpty()) {
            response.getWriter().println("<h3>Error: Missing required package details.</h3>");
            return;
        }

        try (Connection con = DriverManager.getConnection(
                "jdbc:sqlserver://kgjkinserver.database.windows.net:1433;"
                        + "database=kgJkinDB;"
                        + "user=kgjkinadmin@kgjkinserver;"
                        + "password=Mycuties_7;"
                        + "encrypt=true;"
                        + "trustServerCertificate=false;"
                        + "hostNameInCertificate=*.database.windows.net;"
                        + "loginTimeout=30;");
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE Package SET packagename = ?, packageprice = ?, packageduration = ?, packagedetails = ? WHERE packageid = ?")) {
            
            ps.setString(1, packageName);
            ps.setDouble(2, price);
            ps.setString(3, duration);
            ps.setString(4, details);
            ps.setInt(5, packageId);
            
            if (ps.executeUpdate() > 0) {
                response.sendRedirect("ListPackageCrew.jsp");
            } else {
                response.getWriter().println("<h3>Error: Failed to update package.</h3>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: Database error - " + e.getMessage() + "</h3>");
        }
    }
}
