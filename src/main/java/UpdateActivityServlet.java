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
 * Servlet implementation class UpdateActivityServlet
 */
@WebServlet("/UpdateActivityServlet")
public class UpdateActivityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UpdateActivityServlet() {
        super();
    }

    /**
     * Handles the POST request to update activity details.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve parameters from the request
        int actId = Integer.parseInt(request.getParameter("actId")); // Activity ID
        String activityName = request.getParameter("activityName");
        String activityType = request.getParameter("activityType");
        String rideFeature = request.getParameter("rideFeature");
        String sportFeature = request.getParameter("sportFeature");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            // Establish SQL Server connection
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://kgjkinserver.database.windows.net:1433;"
                       + "database=kgJkinDB;"
                       + "user=kgjkinadmin@kgjkinserver;"
                       + "password=Mycuties_7;"
                       + "encrypt=true;"
                       + "trustServerCertificate=false;"
                       + "hostNameInCertificate=*.database.windows.net;"
                       + "loginTimeout=30;";
            con = DriverManager.getConnection(url);

            // Update the activity name in the ACTIVITY table
            String activitySql = "UPDATE ACTIVITY SET ACTNAME = ? WHERE ACTID = ?";
            ps = con.prepareStatement(activitySql);
            ps.setString(1, activityName);
            ps.setInt(2, actId);
            ps.executeUpdate();

            // Update the child table based on activity type
            if ("extremeRide".equals(activityType)) {
                // Clear existing EXTREMESPORT entry (if any) for this ACTID
                String deleteSportSql = "DELETE FROM EXTREMESPORT WHERE ACTID = ?";
                try (PreparedStatement deletePs = con.prepareStatement(deleteSportSql)) {
                    deletePs.setInt(1, actId);
                    deletePs.executeUpdate();
                }

                // Update or insert into EXTREMERIDE
                String rideSql = "MERGE INTO EXTREMERIDE AS target " +
                                 "USING (SELECT ? AS ACTID, ? AS RIDEFEATURE) AS source " +
                                 "ON target.ACTID = source.ACTID " +
                                 "WHEN MATCHED THEN UPDATE SET target.RIDEFEATURE = source.RIDEFEATURE " +
                                 "WHEN NOT MATCHED THEN INSERT (ACTID, RIDEFEATURE) VALUES (source.ACTID, source.RIDEFEATURE);";
                try (PreparedStatement ridePs = con.prepareStatement(rideSql)) {
                    ridePs.setInt(1, actId);
                    ridePs.setString(2, rideFeature);
                    ridePs.executeUpdate();
                }
            } else if ("extremeSport".equals(activityType)) {
                // Clear existing EXTREMERIDE entry (if any) for this ACTID
                String deleteRideSql = "DELETE FROM EXTREMERIDE WHERE ACTID = ?";
                try (PreparedStatement deletePs = con.prepareStatement(deleteRideSql)) {
                    deletePs.setInt(1, actId);
                    deletePs.executeUpdate();
                }

                // Update or insert into EXTREMESPORT
                String sportSql = "MERGE INTO EXTREMESPORT AS target " +
                                  "USING (SELECT ? AS ACTID, ? AS SPORTFEATURE) AS source " +
                                  "ON target.ACTID = source.ACTID " +
                                  "WHEN MATCHED THEN UPDATE SET target.SPORTFEATURE = source.SPORTFEATURE " +
                                  "WHEN NOT MATCHED THEN INSERT (ACTID, SPORTFEATURE) VALUES (source.ACTID, source.SPORTFEATURE);";
                try (PreparedStatement sportPs = con.prepareStatement(sportSql)) {
                    sportPs.setInt(1, actId);
                    sportPs.setString(2, sportFeature);
                    sportPs.executeUpdate();
                }
            }

            // Redirect to the activity list page after successful update
            response.sendRedirect("ListActivity.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
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
