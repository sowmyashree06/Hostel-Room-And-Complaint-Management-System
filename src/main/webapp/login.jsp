<%@ page import="com.hostel.DBConnection" %>
<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("studentId")!=null){
    response.sendRedirect("student/dashboard.jsp");
    return;
}
String msg="";
if("1".equals(request.getParameter("registered"))) msg="Registration successful. Please login.";

if("POST".equalsIgnoreCase(request.getMethod())){
  try{
    Connection con=DBConnection.getConnection();
    PreparedStatement ps=con.prepareStatement(
      "SELECT student_id,name FROM students WHERE email=? AND password=?"
    );
    ps.setString(1,request.getParameter("email"));
    ps.setString(2,request.getParameter("password"));
    ResultSet rs=ps.executeQuery();
    if(rs.next()){
      session.setAttribute("studentId", rs.getInt("student_id"));
      session.setAttribute("studentName", rs.getString("name"));
      response.sendRedirect("student/dashboard.jsp");
      return;
    } else {
      msg="Invalid email or password.";
    }
    con.close();
  } catch(Exception e){
    msg="Login failed: "+e.getMessage();
  }
}
%>
<!DOCTYPE html>
<html>
<head>
<title>Student Login</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="container card">
<h2>Student Login</h2>
<% if(!msg.isEmpty()){ %><div class="message"><%=msg%></div><% } %>
<form method="post">
  <input type="email" name="email" placeholder="Email" required>
  <input type="password" name="password" placeholder="Password" required>
  <button class="btn">Login</button>
</form>
<p><a href="signup.jsp">Create account</a> | <a href="admin/login.jsp">Admin Login</a></p>
</div>
</body>
</html>
