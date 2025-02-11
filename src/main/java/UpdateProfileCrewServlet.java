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
        int crewid;
        
        // Validate input parameters
        try {
            crewid = Integer.parseInt(request.getParameter("crewid"));
        } catch (NumberFormatException e) {
            response.getWriter().println("<h3>Error: Invalid Crew ID format.</h3>");
            return;
        }

        String crewfirstname = request.getParameter("crewfirstname");
        String crewlastname = request.getParameter("crewlastname");
        String crewemail = request.getParameter("crewemail");
        String crewphone = request.getParameter("crewphone");

        if (crewfirstname == null || crewlastname == null || crewemail == null || crewphone == null) {
            response.getWriter().println("<h3>Error: Missing required profile details.</h3>");
            return;
        }

        try {
            // Load JDBC Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Establish database connection
            try (Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system");
                 PreparedStatement ps = con.prepareStatement("UPDATE CREW SET CREWFIRSTNAME = ?, CREWLASTNAME = ?, CREWEMAIL = ?, CREWPHONENO = ? WHERE CREWID = ?")) {

                ps.setString(1, crewfirstname);
                ps.setString(2, crewlastname);
                ps.setString(3, crewemail);
                ps.setString(4, crewphone);
                ps.setInt(5, crewid);

                int rowsUpdated = ps.executeUpdate();

                if (rowsUpdated > 0) {
                    response.sendRedirect("CrewProfile.jsp?id=" + crewid);
                } else {
                    response.getWriter().println("<h3>Error: Failed to update crew profile.</h3>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: Database error - " + e.getMessage() + "</h3>");
        }
    }
}
