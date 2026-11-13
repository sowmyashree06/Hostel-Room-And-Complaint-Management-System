<%@ page import="com.hostel.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.regex.*" %>
<%
String msg = "";
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String name=request.getParameter("name"), roll=request.getParameter("rollNo"),
           email=request.getParameter("email"), phone=request.getParameter("phone"),
           password=request.getParameter("password"), confirm=request.getParameter("confirmPassword"),
           dept=request.getParameter("department"), gender=request.getParameter("gender"),
           year=request.getParameter("year");
    if (name==null || roll==null || email==null || password==null || !password.equals(confirm)) {
        msg="Please check all required fields and confirm password.";
    } else {
        try {
            Connection con=DBConnection.getConnection();

            // Check if email or roll already exists
            PreparedStatement chk=con.prepareStatement("SELECT student_id FROM students WHERE email=? OR roll_no=?");
            chk.setString(1,email); chk.setString(2,roll); ResultSet cr=chk.executeQuery();
            if(cr.next()) {
                msg="Email or roll number already registered.";
            } else {
                // Generate new student_id manually
                int newId = 0;
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT NVL(MAX(student_id),0)+1 FROM students");
                if(rs.next()) {
                    newId = rs.getInt(1);
                }

                // Insert with student_id included
                PreparedStatement ps=con.prepareStatement(
                  "INSERT INTO students(student_id, name, roll_no, email, phone, password, gender, department, year_of_study) VALUES(?,?,?,?,?,?,?,?,?)"
                );
                ps.setInt(1,newId);
                ps.setString(2,name);
                ps.setString(3,roll);
                ps.setString(4,email);
                ps.setString(5,phone);
                ps.setString(6,password);
                ps.setString(7,gender);
                ps.setString(8,dept);
                ps.setInt(9,Integer.parseInt(year));
                ps.executeUpdate();

                response.sendRedirect("login.jsp?registered=1"); 
                return;
            }
            con.close();
        } catch(Exception e) { 
            msg="Registration failed: "+e.getMessage(); 
        }
    }
}
%>
<!DOCTYPE html>
<html>
<head>
<title>Student Registration</title>
<link rel="stylesheet" href="css/style.css">
<script src="js/validation.js"></script>
</head>
<body>
<div class="container card">
<h2>Student Registration</h2>

<% if(!msg.isEmpty()){ %>
<div class="error"><%=msg%></div>
<% } %>

<form method="post" onsubmit="return validateSignup()">
<input name="name" placeholder="Full Name" required>
<input name="rollNo" placeholder="Roll Number" required>
<input type="email" name="email" placeholder="Email" required>
<input name="phone" placeholder="Phone" required>
<select name="gender" required>
  <option value="">Gender</option>
  <option>Male</option>
  <option>Female</option>
  <option>Other</option>
</select>

<label>Department</label><br>
<input type="radio" id="cse" name="department" value="CSE" required><label for="cse">CSE</label>
<input type="radio" id="ece" name="department" value="ECE"><label for="ece">ECE</label>
<input type="radio" id="eee" name="department" value="EEE"><label for="eee">EEE</label>
<input type="radio" id="mech" name="department" value="MECH"><label for="mech">MECH</label>
<input type="radio" id="civil" name="department" value="CIVIL"><label for="civil">CIVIL</label>
<input type="radio" id="it" name="department" value="IT"><label for="it">IT</label>

<input type="number" name="year" min="1" max="5" placeholder="Year" required>
<input type="password" name="password" placeholder="Password" required>
<input type="password" name="confirmPassword" placeholder="Confirm Password" required>
<button class="btn" type="submit">Register</button>
</form>

<p>Already registered? <a href="login.jsp">Login</a></p>
</div>
</body>
</html>
