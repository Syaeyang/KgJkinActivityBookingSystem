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
            // Database connection
            Class.forName("oracle.jdbc.driver.OracleDriver");
            con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system");

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
                String rideSql = "MERGE INTO EXTREMERIDE USING DUAL ON (ACTID = ?) " +
                                 "WHEN MATCHED THEN UPDATE SET RIDEFEATURE = ? " +
                                 "WHEN NOT MATCHED THEN INSERT (ACTID, RIDEFEATURE) VALUES (?, ?)";
                try (PreparedStatement ridePs = con.prepareStatement(rideSql)) {
                    ridePs.setInt(1, actId);
                    ridePs.setString(2, rideFeature);
                    ridePs.setInt(3, actId);
                    ridePs.setString(4, rideFeature);
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
                String sportSql = "MERGE INTO EXTREMESPORT USING DUAL ON (ACTID = ?) " +
                                  "WHEN MATCHED THEN UPDATE SET SPORTFEATURE = ? " +
                                  "WHEN NOT MATCHED THEN INSERT (ACTID, SPORTFEATURE) VALUES (?, ?)";
                try (PreparedStatement sportPs = con.prepareStatement(sportSql)) {
                    sportPs.setInt(1, actId);
                    sportPs.setString(2, sportFeature);
                    sportPs.setInt(3, actId);
                    sportPs.setString(4, sportFeature);
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
