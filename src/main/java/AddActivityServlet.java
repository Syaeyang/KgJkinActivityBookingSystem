import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

/**
 * Servlet implementation class AddActivityServlet
 */
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
        String sportFeature = request.getParameter("SportFeature"); // Fixed parameter name

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int actId = -1; // Default invalid value

        try {
            // Load JDBC Driver
            Class.forName("oracle.jdbc.OracleDriver");

            // Establish connection
            con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system");

            // Insert into ACTIVITY table (parent table) and get generated ACTID
            String activitySql = "INSERT INTO ACTIVITY (ACTID, ACTNAME) VALUES (ACT_ID_SEQ.NEXTVAL, ?)";
            ps = con.prepareStatement(activitySql, new String[]{"ACTID"});
            ps.setString(1, activityName);
            ps.executeUpdate();

            // Retrieve generated ACTID
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                actId = rs.getInt(1);
            }

            // Ensure ACTID is valid before inserting into child table
            if (actId != -1) {
                if ("extremeRide".equals(activityType) && rideFeature != null) {
                    String extremeRideSql = "INSERT INTO EXTREMERIDE (ACTID, RIDEFEATURE) VALUES (?, ?)";
                    try (PreparedStatement psRide = con.prepareStatement(extremeRideSql)) {
                        psRide.setInt(1, actId);
                        psRide.setString(2, rideFeature);
                        psRide.executeUpdate();
                    }
                } else if ("extremeSport".equals(activityType) && sportFeature != null) {
                    String extremeSportSql = "INSERT INTO EXTREMESPORT (ACTID, SPORTFEATURE) VALUES (?, ?)";
                    try (PreparedStatement psSport = con.prepareStatement(extremeSportSql)) {
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
