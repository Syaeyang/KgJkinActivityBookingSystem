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
        request.setAttribute("errorMsg", "❌ First name must contain letters only — no numbers or symbols allowed.");
        request.getRequestDispatcher("SignUp.jsp").forward(request, response);
        return;
        }

        // Validate last name
        if (!customerlastname.matches("^[A-Za-z\\s]+$")) {
        request.setAttribute("errorMsg", "❌ Last name must contain letters only — no numbers or symbols allowed.");
        request.getRequestDispatcher("SignUp.jsp").forward(request, response);
        return;
        }

        // Validate phone number
        if (!customerphone.matches("^[0-9]+$")) {
        request.setAttribute("errorMsg", "❌ Phone number must contain digits only — letters or symbols are not allowed.");
        request.getRequestDispatcher("SignUp.jsp").forward(request, response);
        return;
        }

        // Validate email format
        if (!customeremail.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$")) {
        request.setAttribute("errorMsg", "❌ Please enter a valid email address (e.g., example@domain.com).");
        request.getRequestDispatcher("SignUp.jsp").forward(request, response);
        return;
        }
        
        // Validate password
        if (!customerpassword.matches("^(?=.*[A-Z])(?=.*\\d).{8,}$")) {
        request.setAttribute("errorMsg", "❌ Password must be at least 8 characters long, with at least 1 uppercase letter and 1 number.");
        request.getRequestDispatcher("SignUp.jsp").forward(request, response);
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
        // Check if customer ID was successfully created
       // Redirect to CustomerProfile.jsp with the new customer ID  

        if (customerid > 0) {
            response.sendRedirect("CustomerProfile.jsp?id=" + customerid);
        } else {
            response.getWriter().println("Error: Unable to create the account.");
        }
    }
} 

  
