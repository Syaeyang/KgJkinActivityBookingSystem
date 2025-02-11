import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

@WebServlet("/AddPackageServlet")
public class AddPackageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AddPackageServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ArrayList<HashMap<String, Object>> packages = new ArrayList<>();
        HashMap<Integer, ArrayList<HashMap<String, Object>>> activitiesByPackage = new HashMap<>();
        
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            try (Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system")) {
                String packageQuery = "SELECT packageid, packagename, packageprice, packageduration, packagedetails FROM package";
                try (Statement packageStmt = con.createStatement(); ResultSet packageRs = packageStmt.executeQuery(packageQuery)) {
                    while (packageRs.next()) {
                        HashMap<String, Object> pkg = new HashMap<>();
                        int packageId = packageRs.getInt("packageid");
                        pkg.put("id", packageId);
                        pkg.put("name", packageRs.getString("packagename"));
                        pkg.put("price", packageRs.getDouble("packageprice"));
                        pkg.put("duration", packageRs.getString("packageduration"));
                        pkg.put("details", packageRs.getString("packagedetails"));
                        packages.add(pkg);
                        activitiesByPackage.put(packageId, new ArrayList<>());
                    }
                }

                String activityQuery = "SELECT ACTIVITY.ACTID, ACTIVITY.ACTNAME, ACTIVITY.ACTSAFETY FROM ACTIVITY INNER JOIN PACKAGE_ACTIVITY ON ACTIVITY.ACTID = PACKAGE_ACTIVITY.ACTID WHERE PACKAGE_ACTIVITY.packageid = ?";
                try (PreparedStatement activityStmt = con.prepareStatement(activityQuery)) {
                    for (HashMap<String, Object> pkg : packages) {
                        int packageId = (int) pkg.get("id");
                        activityStmt.setInt(1, packageId);
                        try (ResultSet activityRs = activityStmt.executeQuery()) {
                            while (activityRs.next()) {
                                HashMap<String, Object> act = new HashMap<>();
                                act.put("id", activityRs.getInt("ACTID"));
                                act.put("name", activityRs.getString("ACTNAME"));
                                act.put("safety", activityRs.getString("ACTSAFETY"));
                                activitiesByPackage.get(packageId).add(act);
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("packages", packages);
        request.setAttribute("activitiesByPackage", activitiesByPackage);
        RequestDispatcher rd = request.getRequestDispatcher("AddActivity.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("packageName");
        double price = Double.parseDouble(request.getParameter("price"));
        String duration = request.getParameter("duration");
        String details = request.getParameter("additionalDetails");

        ArrayList<HashMap<String, Object>> packages = new ArrayList<>();
        ArrayList<HashMap<String, Object>> activities = new ArrayList<>();

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            try (Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system")) {
                String sql = "INSERT INTO package(packageid, packagename, packageprice, packageduration, packagedetails) VALUES(product_id_seq.NEXTVAL, ?, ?, ?, ?)";
                try (PreparedStatement ps = con.prepareStatement(sql, new String[]{"packageid"})) {
                    ps.setString(1, name);
                    ps.setDouble(2, price);
                    ps.setString(3, duration);
                    ps.setString(4, details);
                    ps.executeUpdate();
                }

                String fetchPackages = "SELECT packageid, packagename, packageprice, packageduration, packagedetails FROM package";
                try (Statement packageStmt = con.createStatement(); ResultSet packageRs = packageStmt.executeQuery(fetchPackages)) {
                    while (packageRs.next()) {
                        HashMap<String, Object> packageData = new HashMap<>();
                        packageData.put("id", packageRs.getInt("packageid"));
                        packageData.put("name", packageRs.getString("packagename"));
                        packageData.put("price", packageRs.getDouble("packageprice"));
                        packageData.put("duration", packageRs.getString("packageduration"));
                        packageData.put("details", packageRs.getString("packagedetails"));
                        packages.add(packageData);
                    }
                }

                String fetchActivities = "SELECT ACTID, ACTNAME, ACTSAFETY FROM ACTIVITY";
                try (Statement activityStmt = con.createStatement(); ResultSet activityRs = activityStmt.executeQuery(fetchActivities)) {
                    while (activityRs.next()) {
                        HashMap<String, Object> activityData = new HashMap<>();
                        activityData.put("id", activityRs.getInt("ACTID"));
                        activityData.put("activityName", activityRs.getString("ACTNAME"));
                        activityData.put("safety", activityRs.getString("ACTSAFETY"));
                        activities.add(activityData);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while processing the request: " + e.getMessage());
        }

        request.setAttribute("packages", packages);
        request.setAttribute("activities", activities);
        RequestDispatcher req = request.getRequestDispatcher("ListPackageUpdate.jsp");
        req.forward(request, response);
    }
}
