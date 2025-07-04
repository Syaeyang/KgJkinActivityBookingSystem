import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/UpdateActivityServlet")
public class UpdateActivityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:sqlserver://kgjkinserver.database.windows.net:1433;"
                                       + "database=kgJkinDB;"
                                       + "encrypt=true;"
                                       + "trustServerCertificate=false;"
                                       + "hostNameInCertificate=*.database.windows.net;"
                                       + "loginTimeout=30;";

    private static final String DB_USER = "kgjkinadmin@kgjkinserver";
    private static final String DB_PASSWORD = "Mycuties_7"; 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            int actId = Integer.parseInt(request.getParameter("actid"));
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            String activityName = request.getParameter("activityName");
            String activityType = request.getParameter("activityType");
            String rideFeature = "extremeRide".equals(activityType) ? request.getParameter("rideFeature") : "";
            String sportFeature = "extremeSport".equals(activityType) ? request.getParameter("sportFeature") : "";

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                String updateActivitySQL = "UPDATE ACTIVITY SET ACTNAME = ?, ACTTYPE = ? WHERE ACTID = ?";
                try (PreparedStatement ps = con.prepareStatement(updateActivitySQL)) {
                    ps.setString(1, activityName);
                    ps.setString(2, activityType);
                    ps.setInt(3, actId);
                    ps.executeUpdate();
                }

                if ("extremeRide".equals(activityType)) {
                    try (PreparedStatement ps = con.prepareStatement("DELETE FROM EXTREMESPORT WHERE ACTID = ?")) {
                        ps.setInt(1, actId);
                        ps.executeUpdate();
                    }
                    String rideSql = "MERGE INTO EXTREMERIDE AS target USING (SELECT ? AS ACTID, ? AS RIDEFEATURE) AS source "
                                   + "ON target.ACTID = source.ACTID "
                                   + "WHEN MATCHED THEN UPDATE SET target.RIDEFEATURE = source.RIDEFEATURE "
                                   + "WHEN NOT MATCHED THEN INSERT (ACTID, RIDEFEATURE) VALUES (source.ACTID, source.RIDEFEATURE);";
                    try (PreparedStatement ps = con.prepareStatement(rideSql)) {
                        ps.setInt(1, actId);
                        ps.setString(2, rideFeature);
                        ps.executeUpdate();
                    }
                } else if ("extremeSport".equals(activityType)) {
                    try (PreparedStatement ps = con.prepareStatement("DELETE FROM EXTREMERIDE WHERE ACTID = ?")) {
                        ps.setInt(1, actId);
                        ps.executeUpdate();
                    }
                    String sportSql = "MERGE INTO EXTREMESPORT AS target USING (SELECT ? AS ACTID, ? AS SPORTFEATURE) AS source "
                                    + "ON target.ACTID = source.ACTID "
                                    + "WHEN MATCHED THEN UPDATE SET target.SPORTFEATURE = source.SPORTFEATURE "
                                    + "WHEN NOT MATCHED THEN INSERT (ACTID, SPORTFEATURE) VALUES (source.ACTID, source.SPORTFEATURE);";
                    try (PreparedStatement ps = con.prepareStatement(sportSql)) {
                        ps.setInt(1, actId);
                        ps.setString(2, sportFeature);
                        ps.executeUpdate();
                    }
                }
                response.sendRedirect("UpdatePackage.jsp?packageId=" + packageId);
            }
        } catch (NumberFormatException e) {
            response.getWriter().println("Invalid number format: " + e.getMessage());
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
