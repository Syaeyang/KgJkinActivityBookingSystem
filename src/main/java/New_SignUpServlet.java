import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
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
        // Retrieve form input
        String customerfirstname = request.getParameter("customerfirstname");
        String customerlastname = request.getParameter("customerlastname");
        String customeremail = request.getParameter("customeremail");
        String customerphone = request.getParameter("customerphone");
        String customerpassword = request.getParameter("customerpassword"); // Consider hashing for security

        int customerid = 0;

        // Set up writer for messages
        PrintWriter out = response.getWriter();

        // Validate first name
        if (!customerfirstname.matches("^[A-Za-z\\s]+$")) {
            out.println("<p style='color:red;'>❌ First name must contain letters only — no numbers or symbols allowed.</p>");
            return;
        }

        // Validate last name
        if (!customerlastname.matches("^[A-Za-z\\s]+$")) {
            out.println("<p style='color:red;'>❌ Last name must contain letters only — no numbers or symbols allowed.</p>");
            return;
        }

        // Validate phone number
        if (!customerphone.matches("^[0-9]+$")) {
            out.println("<p style='color:red;'>❌ Phone number must contain digits only — letters or symbols are not allowed.</p>");
            return;
        }

        // Validate password
        if (!customerpassword.matches("^(?=.*[A-Z])(?=.*\\d).{8,}$")) {
            out.println("<p style='color:red;'>❌ Password must be at least 8 characters long, with at least 1 uppercase letter and 1 number.</p>");
            return;

            // Validate email format
        if (!customeremail.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$")) {
            out.println("<p style='color:red;'>❌ Please enter a valid email address (e.g., example@domain.com).</p>");
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
            ResultSet emailCheck = checkStmt.executeQuery();

            if (emailCheck.next()) {
                out.println("<p style='color:red;'>❌ This email is already registered. Please use a different email.</p>");
                emailCheck.close();
                checkStmt.close();
                con.close();
                return;
            }

            emailCheck.close();
            checkStmt.close();

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
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }

        if (customerid > 0) {
            response.sendRedirect("CustomerProfile.jsp?id=" + customerid);
        } else {
            response.getWriter().println("Error: Unable to create the account.");
        }
    }
}
