import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

/**
 * Servlet implementation class SignUpServlet
 */
@WebServlet("/SignUpServlet") // Added WebServlet annotation
public class SignUpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public SignUpServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      //retrieve form input
        String customerfirstname = request.getParameter("customerfirstname");
        String customerlastname = request.getParameter("customerlastname");
        String customeremail = request.getParameter("customeremail");
        String customerphone = request.getParameter("customerphone");
        String customerpassword = request.getParameter("customerpassword");

        int customerid=0;

        // Validate name: only letters and spaces allowed
        if (!customerfirstname.matches("^[A-Za-z\\s]+$")) {
            out.println("<p style='color:red;'>❌ Name must contain letters only — no numbers or symbols allowed.</p>");
            return;
        }
       if (!customerlastname.matches("^[A-Za-z\\s]+$")) {
            out.println("<p style='color:red;'>❌ Name must contain letters only — no numbers or symbols allowed.</p>");
            return;
        }

        // Validate phone: only digits
        if (!customerphone.matches("^[0-9]+$")) {
            out.println("<p style='color:red;'>❌ Phone number must contain digits only — letters or symbols are not allowed.</p>");
            return;
        }

        // Validate password strength: min 8 chars, 1 capital letter, 1 digit
        if (!customerpassword.matches("^(?=.*[A-Z])(?=.*\\d).{8,}$")) {
            out.println("<p style='color:red;'>❌ Password must be at least 8 characters long, with at least 1 uppercase letter and 1 number.</p>");
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

            // Check if email already exists
            PreparedStatement checkStmt = con.prepareStatement("SELECT * FROM CUSTOMER WHERE CUSTEMAIL = ?");
            checkStmt.setString(1, customeremail);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                out.println("<p style='color:red;'>❌ This email is already registered. Please use a different email.</p>");
            } else {
                  // Insert SQL query with auto-incremented Customer ID
            String sql = "INSERT INTO CUSTOMER (CUSTFIRSTNAME, CUSTLASTNAME, CUSTEMAIL, CUSTPHONENO, CUSTPASSWORD) " +
                         "OUTPUT INSERTED.CUSTID VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, customerfirstname);
            ps.setString(2, customerlastname);
            ps.setString(3, customeremail);
            ps.setString(4, customerphone);
            ps.setString(5, customerpassword); // Consider hashing before storing

            // Execute the query and get the generated Customer ID
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                customerid = rs.getInt(1);

                int i = ps.executeUpdate();
                if(i > 0) {
                    out.println("<p style='color:green;'>✅ Registration successful!</p>");
                } else {
                    out.println("<p style='color:red;'>❌ Registration failed. Please try again later.</p>");
                }
                rs.close();
            }

            rs.close();
            checkStmt.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red;'>❌ An error occurred while processing your registration.</p>");
        }
    }
}
