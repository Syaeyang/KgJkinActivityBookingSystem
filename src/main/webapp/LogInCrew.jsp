<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Homepage, Login, and Sign Up</title>
    <link rel="stylesheet" href="LogIn.css">
</head>
<body>
  <header class="site-header">
    <div class="logo">
      <img src="img/logo1.png" alt="Logo">
    </div>
    <nav class="nav-menu">
      <ul>
        <li><a href="Home.jsp">HOME</a></li>
        <li><a href="ListPackage.jsp">PACKAGE</a></li>
      
      </ul>
    </nav>
  </header>
  </body>

    <div class="container">
        <!-- Login Section -->
        <div class="section">
            <div class="form">
                <form action="/LogInCrewServlet" method="post">
                    <label for="">Email Address</label>
                    <input type="email" id="login-email" name="email" placeholder="Enter your email address" required>

                    <label for="login-password">Password</label>
                    <input type="password" id="login-password" name="password" placeholder="Enter your password" required>

                    <br> <button type="submit"><b>Login</b></button>
                    
                </form>
                
                <p>Log In for Crew Account <a href="LogInCrew.jsp">Log In</a></p>
            
            </div>
        </div>
       </div>

    <!-- Footer placed here, inside the body -->
  <footer class="footer">
    <div class="footer-container">
      <div class="icon">
        <img src="img/fb1.png" alt="Facebook Icon">
      </div>
      <div class="icon">
        <img src="img/email1.png" alt="Email Icon">
      </div>
      <div class="footer-text">&copy; 2025 Kg Jkin Xtreme Park. All Rights Reserved.</div>
    </div>
  </footer>
</html>