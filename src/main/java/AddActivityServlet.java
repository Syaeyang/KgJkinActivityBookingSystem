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
        String activityType = request.getParameter("activityType");
        String rideFeature = request.getParameter("rideFeature");
        String sportFeature = request.getParameter("SportFeature"); // Ensure this matches form input

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int actId = -1; // Default invalid value

        try {
            // Load SQL Server JDBC Driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Establish connection
            String url = "jdbc:sqlserver://kgjkinserver.database.windows.net:1433;"
                       + "database=kgJkinDB;"
                       + "user=kgjkinadmin@kgjkinserver;"
                       + "password=Mycuties_7;"
                       + "encrypt=true;"
                       + "trustServerCertificate=false;"
                       + "hostNameInCertificate=*.database.windows.net;"
                       + "loginTimeout=30;";
            con = DriverManager.getConnection(url);

            // Insert into ACTIVITY table and retrieve ACTID
            String activitySql = "INSERT INTO ACTIVITY (ACTNAME) OUTPUT INSERTED.ACTID VALUES (?)";
            ps = con.prepareStatement(activitySql);
            ps.setString(1, activityName);

            rs = ps.executeQuery();
            if (rs.next()) {
                actId = rs.getInt(1);
            }

            // Ensure ACTID is valid before inserting into child tables
            if (actId != -1) {
                if ("extremeRide".equals(activityType) && rideFeature != null && !rideFeature.isEmpty()) {
                    try (PreparedStatement psRide = con.prepareStatement(
                            "INSERT INTO EXTREMERIDE (ACTID, RIDEFEATURE) VALUES (?, ?)")) {
                        psRide.setInt(1, actId);
                        psRide.setString(2, rideFeature);
                        psRide.executeUpdate();
                    }
                } else if ("extremeSport".equals(activityType) && sportFeature != null && !sportFeature.isEmpty()) {
                    try (PreparedStatement psSport = con.prepareStatement(
                            "INSERT INTO EXTREMESPORT (ACTID, SPORTFEATURE) VALUES (?, ?)")) {
                        psSport.setInt(1, actId);
                        psSport.setString(2, sportFeature);
                        psSport.executeUpdate();
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Proper resource cleanup
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }

        // Redirect to a page showing the updated activity list
        RequestDispatcher req = request.getRequestDispatcher("ListPackageUpdate.jsp");
        req.forward(request, response);
    }
}
