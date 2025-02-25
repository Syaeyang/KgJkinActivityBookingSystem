import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/LogInCrewServlet")
public class LogInCrewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LogInCrewServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection con = DriverManager.getConnection("jdbc:sqlserver://kgjkinserver.database.windows.net:1433;database=kgJkinDB;user=kgjkinadmin@kgjkinserver;password=Mycuties_7;encrypt=true;trustServerCertificate=false;");

            String sql = "SELECT CREWID FROM CREW WHERE CREWEMAIL = ? AND CREWPASSWORD = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                request.getSession().setAttribute("crewid", rs.getInt("CREWID"));
                response.sendRedirect("CrewProfile.jsp");
            } else {
                response.sendRedirect("LogInCrew.jsp?error=Invalid email or password.");
            }
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
