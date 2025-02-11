<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Slot Time</title>
    <link rel="stylesheet" href="AddPackage.css">
</head>
<body>
   
        <header class="site-header">
          <div class="logo">
            <img src="img/logo1.png" alt="Logo">
          </div>
          <nav class="nav-menu">
            <ul>
              <li><a href="HOME2.jsp">HOME</a></li>
              <li><a href="ListPackage.jsp">PACKAGE</a></li>
              <li><a href="BookingList.jsp">BOOKING</a></li>
            </ul>
          </nav>
        </header>
      
        
        
            <form action="/AddSlotServlet" method="post">
            <div class="package-form">
                <div class="package-details">
                  <h1>ADD SLOT</h1>
                    <label>
                         Slot No<br>
                       <input type="text" id="slotNo" name="slotNo" placeholder="Enter Slot No" required>
                    </label>
                    <div class="activity">
                        <label>
                            Slot Start Time<br>
                            <input type="text" id="slotStart" name="slotStart" placeholder="Enter Slot Start Time" required>
                        </label>
                       
                    </div>
                    <div class="activity">
                        <label>
                            Slot End Time<br>
                            <input type="text" id="slotEnd" name="slotEnd" placeholder="Enter Slot End Time" required>
                        </label>
                     </div>
                   

                
                 <button type="submit" class="add-package-btn">Add Booking Slot</button>
                
            </div>
            </div>
        </form>
            
</body>

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
  
