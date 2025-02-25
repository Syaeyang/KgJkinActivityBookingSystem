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
        String crewfirstname = request.getParameter("crewfirstname");
        String crewlastname = request.getParameter("crewlastname");
        String crewemail = request.getParameter("crewemail");
        String crewphone = request.getParameter("crewphone");
        String crewpassword = request.getParameter("crewpassword");

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
            Connection con = DriverManager.getConnection(url);

            // SQL query to insert the crew member
            String sql = "INSERT INTO CREW (CREWFIRSTNAME, CREWLASTNAME, CREWEMAIL, CREWPHONENO, CREWPASSWORD) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            // Set values into the prepared statement
            ps.setString(1, crewfirstname);
            ps.setString(2, crewlastname);
            ps.setString(3, crewemail);
            ps.setString(4, crewphone);
            ps.setString(5, crewpassword); // Store the hashed password

            // Execute query
            int rowsInserted = ps.executeUpdate();

            if (rowsInserted > 0) {
                // Retrieve the generated CREWID
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int crewid = rs.getInt(1); // Get the auto-generated ID

                    // Store crew ID in session
                    request.getSession().setAttribute("crewid", crewid);

                    // Redirect to profile
                    response.sendRedirect("CrewProfile.jsp");
                } else {
                    response.getWriter().println("Error: Unable to retrieve Crew ID.");
                }
            } else {
                response.getWriter().println("Error: Unable to create the crew account.");
            }

            // Close connection
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
