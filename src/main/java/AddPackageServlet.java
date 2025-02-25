import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;

@WebServlet("/AddPackageServlet")
public class AddPackageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("packageName");
        String priceStr = request.getParameter("price");
        String duration = request.getParameter("duration");
        String details = request.getParameter("additionalDetails");

        if (name == null || name.isEmpty() || priceStr == null || priceStr.isEmpty() || duration == null || duration.isEmpty() || details == null || details.isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            RequestDispatcher req = request.getRequestDispatcher("AddPackage.jsp");
            req.forward(request, response);
            return;
        }

        double price;
        try {
            price = Double.parseDouble(priceStr);
            if (price <= 0) {
                throw new NumberFormatException("Price must be greater than zero.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid price format.");
            RequestDispatcher req = request.getRequestDispatcher("AddPackage.jsp");
            req.forward(request, response);
            return;
        }

        int newPackageId = -1;
        int latestActId = -1;

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            try (Connection con = DriverManager.getConnection("jdbc:sqlserver://kgjkinserver.database.windows.net:1433;database=kgJkinDB;user=kgjkinadmin@kgjkinserver;password=Mycuties_7;encrypt=true;trustServerCertificate=false;loginTimeout=30;")) {

                // Step 1: Get the most recent activity ID
                String getLatestActivity = "SELECT TOP 1 ACTID FROM ACTIVITY ORDER BY ACTID DESC";
                try (Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery(getLatestActivity)) {
                    if (rs.next()) {
                        latestActId = rs.getInt("ACTID");
                        System.out.println("Latest Activity ID: " + latestActId); // Debugging
                    }
                }

                if (latestActId == -1) {
                    response.sendRedirect("AddActivity.jsp?error=No activities found. Please add an activity first.");
                    return;
                }

                // Step 2: Insert the new package
                String insertPackageSQL = "INSERT INTO Package(packagename, packageprice, packageduration, packagedetails) VALUES(?, ?, ?, ?)";
                try (PreparedStatement ps = con.prepareStatement(insertPackageSQL, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, name);
                    ps.setDouble(2, price);
                    ps.setString(3, duration);
                    ps.setString(4, details);
                    ps.executeUpdate();

                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            newPackageId = rs.getInt(1);
                            System.out.println("New Package ID: " + newPackageId); // Debugging
                        }
                    }
                }

                if (newPackageId == -1) {
                    request.setAttribute("errorMessage", "Failed to insert package.");
                    RequestDispatcher req = request.getRequestDispatcher("AddPackage.jsp");
                    req.forward(request, response);
                    return;
                }

                // Step 3: Link the package to the latest activity
                String linkActivitySQL = "INSERT INTO PACKAGE_ACTIVITY(packageid, ACTID) VALUES(?, ?)";
                try (PreparedStatement linkStmt = con.prepareStatement(linkActivitySQL)) {
                    linkStmt.setInt(1, newPackageId);
                    linkStmt.setInt(2, latestActId);
                    int rowsAffected = linkStmt.executeUpdate();
                    System.out.println("Rows inserted into PACKAGE_ACTIVITY: " + rowsAffected); // Debugging
                }

            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "SQL Error: " + e.getMessage());
            RequestDispatcher req = request.getRequestDispatcher("AddPackage.jsp");
            req.forward(request, response);
            return;
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            RequestDispatcher req = request.getRequestDispatcher("AddPackage.jsp");
            req.forward(request, response);
            return;
        }

        response.sendRedirect("ListPackageCrew.jsp?success=Package added successfully");
    }
}
