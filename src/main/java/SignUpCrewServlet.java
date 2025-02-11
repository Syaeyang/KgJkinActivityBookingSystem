import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/SignUpCrewServlet")
public class SignUpCrewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public SignUpCrewServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve input data from the form
        String crewid = request.getParameter("crewid");
        String crewfirstname = request.getParameter("crewfirstname");
        String crewlastname = request.getParameter("crewlastname");
        String crewemail = request.getParameter("crewemail");
        String crewphone = request.getParameter("crewphone");
        String crewpassword = request.getParameter("crewpassword");

        try {
            // Database connection
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ZOOTOPIA", "system");

            // SQL query to insert the crew member with manual CREWID input
            String sql = "INSERT INTO CREW (CREWID, CREWFIRSTNAME, CREWLASTNAME, CREWEMAIL, CREWPHONENO, CREWPASSWORD) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);

            // Set the input data into the prepared statement
            ps.setString(1, crewid);  // Manually provided CREWID
            ps.setString(2, crewfirstname);
            ps.setString(3, crewlastname);
            ps.setString(4, crewemail);
            ps.setString(5, crewphone);
            ps.setString(6, crewpassword);

            // Execute the query
            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                response.getWriter().println("Crew member account successfully created!");
            } else {
                response.getWriter().println("Error: Unable to create the crew account.");
            }

            // Close the connection
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }

        // After successful sign-up, redirect to the crew profile page (you can replace this with your own page URL)
        response.sendRedirect("CrewProfile.jsp?id=" + crewid);  // Redirect to the crew profile page
    }
}
