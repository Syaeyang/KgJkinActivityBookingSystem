import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/LogInServlet")
public class LogInServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LogInServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form inputs
        String email = request.getParameter("email");  // Match with JSP form input name
        String password = request.getParameter("password");

        if (email == null || password == null || email.isEmpty() || password.isEmpty()) {
            response.sendRedirect("LogIn.jsp?error=Email and password are required.");
            return;
        }

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

            // Updated SQL query to match table structure
            String sql = "SELECT CUSTID, CUSTFIRSTNAME FROM CUSTOMER WHERE CUSTEMAIL = ? AND CUSTPASSWORD = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Valid credentials, create session
                HttpSession session = request.getSession();
                session.setAttribute("custid", rs.getInt("CUSTID"));
                session.setAttribute("firstName", rs.getString("CUSTFIRSTNAME"));
                session.setAttribute("email", email);

                response.sendRedirect("CustomerProfile.jsp"); // Redirect to profile page
            } else {
                // Invalid credentials
                response.sendRedirect("LogIn.jsp?error=Invalid email or password.");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("LogIn.jsp?error=Database connection error.");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }
}
