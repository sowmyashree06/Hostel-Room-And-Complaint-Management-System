HOSTEL ROOM & COMPLAINT MANAGEMENT SYSTEM - MAVEN WEB PROJECT

This version is arranged for Maven + Eclipse WTP + Apache Tomcat 9.

IMPORTANT:
1. Import the ZIP as an Existing Maven Project in Eclipse.
2. Tomcat 9 is recommended for this project (javax.servlet).
3. Run database.sql in Oracle SQL Developer.
4. Edit src/main/java/com/hostel/DBConnection.java and set your Oracle USER/PASSWORD.
5. Right-click project -> Maven -> Update Project.
6. Open the Servers view. Right-click Tomcat v9.0 Server -> Add and Remove.
7. HostelManagementSystem should now be available. Add it and start the server.
8. Open http://localhost:8080/HostelManagementSystem/

Default admin:
username: admin
password: admin123

Oracle URL in the project:
jdbc:oracle:thin:@localhost:1521:XE
Change it if your Oracle service name is different.

Maven web structure:
src/main/java/com/hostel/DBConnection.java
src/main/webapp/*.jsp
src/main/webapp/student/*.jsp
src/main/webapp/admin/*.jsp
src/main/webapp/css/style.css
src/main/webapp/js/validation.js
src/main/webapp/WEB-INF/web.xml
