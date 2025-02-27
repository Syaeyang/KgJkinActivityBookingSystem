import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/AddActivityServlet")
public class AddActivityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AddActivityServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String activityName = request.getParameter("activityName");
        String activityType = request.getParameter("activityType").trim(); // Trim whitespace
        String rideFeature = request.getParameter("rideFeature");
        String sportFeature = request.getParameter("sportFeature");
        String packageIdStr = request.getParameter("packageId");

        int actId = -1; // Default invalid value

        try {
            // ✅ Load SQL Server driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            try (Connection con = DriverManager.getConnection(
                    "jdbc:sqlserver://kgjkinserver.database.windows.net:1433;"
                    + "database=kgJkinDB;"
                    + "user=kgjkinadmin@kgjkinserver;"
                    + "password=Mycuties_7;"
                    + "encrypt=true;"
                    + "trustServerCertificate=false;"
                    + "hostNameInCertificate=*.database.windows.net;"
                    + "loginTimeout=30;")) {

                // ✅ Insert into ACTIVITY table
                String activitySql = "INSERT INTO ACTIVITY (ACTNAME, ACTTYPE) VALUES (?, ?)";
                try (PreparedStatement ps = con.prepareStatement(activitySql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, activityName);
                    ps.setString(2, activityType);
                    int rowsInserted = ps.executeUpdate();

                    // ✅ Retrieve ACTID
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            actId = rs.getInt(1);
                            System.out.println("✅ New ACTID: " + actId); 
                        } else {
                            System.out.println("⚠️ No ACTID was generated.");
                        }
                    }
                }

                // ✅ Ensure ACTID is valid before inserting into child tables
                if (actId > 0) {
                    System.out.println("Activity Type: " + activityType);

                    if ("extremeRide".equalsIgnoreCase(activityType) && rideFeature != null && !rideFeature.trim().isEmpty()) {
                        System.out.println("🔹 Inserting into EXTREMERIDE");
                        try (PreparedStatement psRide = con.prepareStatement(
                                "INSERT INTO EXTREMERIDE (ACTID, RIDEFEATURE) VALUES (?, ?)")) {
                            psRide.setInt(1, actId);
                            psRide.setString(2, rideFeature);
                            psRide.executeUpdate();
                            System.out.println("✅ Inserted into EXTREMERIDE");
                        }
                    } else if ("extremeSport".equalsIgnoreCase(activityType) && sportFeature != null && !sportFeature.trim().isEmpty()) {
                        System.out.println("🔹 Inserting into EXTREMESPORT");
                        try (PreparedStatement psSport = con.prepareStatement(
                                "INSERT INTO EXTREMESPORT (ACTID, SPORTFEATURE) VALUES (?, ?)")) {
                            psSport.setInt(1, actId);
                            psSport.setString(2, sportFeature);
                            psSport.executeUpdate();
                            System.out.println("✅ Inserted into EXTREMESPORT");
                        }
                    } else {
                        System.out.println("⚠️ SportFeature is missing or activity type is incorrect.");
                    }

                    // ✅ Ensure packageId is valid before inserting into PACKAGE_ACTIVITY
                    if (packageIdStr != null && !packageIdStr.isEmpty()) {
                        try {
                            int packageId = Integer.parseInt(packageIdStr);
                            String packageActivitySql = "INSERT INTO PACKAGE_ACTIVITY (PACKAGEID, ACTID) VALUES (?, ?)";
                            try (PreparedStatement psPackageActivity = con.prepareStatement(packageActivitySql)) {
                                psPackageActivity.setInt(1, packageId);
                                psPackageActivity.setInt(2, actId);
                                psPackageActivity.executeUpdate();
                                System.out.println("✅ Inserted into PACKAGE_ACTIVITY");
                            }
                        } catch (NumberFormatException e) {
                            System.out.println("⚠️ Invalid package ID format: " + packageIdStr);
                        }
                    } else {
                        System.out.println("⚠️ Package ID is missing or empty.");
                    }
                } else {
                    System.out.println("⚠️ Failed to retrieve ACTID. No insert into EXTREMERIDE/EXTREMESPORT.");
                }

            }
        } catch (ClassNotFoundException e) {
            System.out.println("❌ JDBC Driver not found! Make sure you have added the SQL Server JDBC driver.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("❌ SQL Exception occurred!");
            e.printStackTrace();
        }

        // Redirect to AddPackage.jsp after successful insertion
        RequestDispatcher req = request.getRequestDispatcher("AddPackage.jsp");
        req.forward(request, response);
    }
}
