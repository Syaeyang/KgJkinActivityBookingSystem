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
 * Servlet implementation class UpdateProfileCrewServlet
 */
@WebServlet("/UpdateProfileCrewServlet")
public class UpdateProfileCrewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UpdateProfileCrewServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int crewId;

        // Validate input parameters
        try {
            crewId = Integer.parseInt(request.getParameter("crewid"));
        } catch (NumberFormatException e) {
            response.getWriter().println("<h3>Error: Invalid Crew ID format.</h3>");
            return;
        }

        String crewFirstName = request.getParameter("crewfirstname");
        String crewLastName = request.getParameter("crewlastname");
        String crewEmail = request.getParameter("crewemail");
        String crewPhone = request.getParameter("crewphone");

        if (crewFirstName == null || crewLastName == null || crewEmail == null || crewPhone == null) {
            response.getWriter().println("<h3>Error: Missing required profile details.</h3>");
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

            // Update crew profile
            String sql = "UPDATE CREW SET CREWFIRSTNAME = ?, CREWLASTNAME = ?, CREWEMAIL = ?, CREWPHONENO = ? WHERE CREWID = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, crewFirstName);
            ps.setString(2, crewLastName);
            ps.setString(3, crewEmail);
            ps.setString(4, crewPhone);
            ps.setInt(5, crewId);
            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect("CrewProfile.jsp?id=" + crewId);
            } else {
                response.getWriter().println("<h3>Error: Failed to update crew profile.</h3>");
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
