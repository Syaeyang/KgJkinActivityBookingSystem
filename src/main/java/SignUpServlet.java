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
        // Retrieve form input
        String customerfirstname = request.getParameter("customerfirstname");
        String customerlastname = request.getParameter("customerlastname");
        String customeremail = request.getParameter("customeremail");
        String customerphone = request.getParameter("customerphone");
        String customerpassword = request.getParameter("customerpassword"); // Consider hashing for security

        int customerid = 0;

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
