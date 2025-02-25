<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Package Activity</title>
    <link rel="stylesheet" href="AddPackage.css">
</head>
<body>
   
    <header class="site-header">
        <div class="logo">
            <img src="img/logo1.png" alt="Logo">
        </div>
        <nav class="nav-menu">
            <ul>
                <li><a href="HomeCrew.jsp">HOME</a></li>
                <li><a href="ListPackageCrew.jsp">PACKAGE</a></li>
                <li><a href="BookingList.jsp">BOOKING</a></li>
                <li><a href="ListSlot.jsp">SLOT</a></li>
                <li><a href="ListActivity.jsp">ACTIVITY</a></li>
            </ul>
        </nav>
    </header>

    <form action="AddActivityServlet" method="post">
        <div class="package-form">
            <div class="package-details">
                <h1>ADD ACTIVITY</h1>
                
                <label>
                    Activity Name<br>
                    <input type="text" id="activityName" name="activityName" placeholder="Enter activity name" required>
                </label>
                
                <label for="activityType">
                    Activity Type<br>
                    <select id="activityType" name="activityType" required>
                        <option value="" disabled selected>Select Activity Type</option>
                        <option value="extremeRide">Extreme Ride</option>
                        <option value="extremeSport">Extreme Sport</option>
                    </select>
                </label>
                
                <!-- Ride Feature Field (Hidden Initially) -->
                <div id="rideFields" style="display:none;">
                    <label>
                        Ride Feature<br>
                        <input type="text" id="rideFeature" name="rideFeature" placeholder="Enter ride feature">
                    </label>
                </div>

                <!-- Sport Feature Field (Hidden Initially) -->
                <div id="sportFields" style="display:none;">
                    <label>
                        Sport Feature<br>
                        <input type="text" id="sportFeature" name="sportFeature" placeholder="Enter sport feature">
                    </label>
                </div>

            </div>
            <button type="submit" class="add-package-btn"><b>Add Activity</b></button>
        </div>
    </form>

    <script>
        document.getElementById("activityType").addEventListener("change", function() {
            var activityType = this.value;
            if (activityType === "extremeRide") {
                document.getElementById("rideFields").style.display = "block";
                document.getElementById("sportFields").style.display = "none";
            } else if (activityType === "extremeSport") {
                document.getElementById("rideFields").style.display = "none";  
                document.getElementById("sportFields").style.display = "block";  
            } else {
                document.getElementById("rideFields").style.display = "none";
                document.getElementById("sportFields").style.display = "none";
            }
        });
    </script>

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

</body>
</html>
