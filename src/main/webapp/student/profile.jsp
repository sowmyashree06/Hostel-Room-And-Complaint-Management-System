<%@ page import="com.hostel.DBConnection"%>
<%@ page import="java.sql.*"%>
<%
if (session.getAttribute("studentId") == null) {
	response.sendRedirect("../login.jsp");
	return;
}
int sid = (Integer) session.getAttribute("studentId");
String msg = "";
if ("POST".equalsIgnoreCase(request.getMethod())) {
	Connection c = DBConnection.getConnection();
	PreparedStatement p = c
	.prepareStatement("UPDATE students SET name=?,phone=?,department=?,year_of_study=? WHERE student_id=?");
	p.setString(1, request.getParameter("name"));
	p.setString(2, request.getParameter("phone"));
	p.setString(3, request.getParameter("department"));
	p.setInt(4, Integer.parseInt(request.getParameter("year")));
	p.setInt(5, sid);
	p.executeUpdate();
	session.setAttribute("studentName", request.getParameter("name"));
	c.close();
	msg = "Profile updated.";
}
Connection c = DBConnection.getConnection();
PreparedStatement p = c.prepareStatement("SELECT * FROM students WHERE student_id=?");
p.setInt(1, sid);
ResultSet r = p.executeQuery();
r.next();
%>
<!DOCTYPE html>
<html>
<head>
<title>Profile</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>
	<div class="container card">
		<h2>My Profile</h2>
		<%
		if (!msg.isEmpty()) {
		%><div class="success"><%=msg%></div>
		<%}%>
		<form method="post">
			<input name="name" value="<%=r.getString("name")%>" required>
			<input value="<%=r.getString("roll_no")%>" disabled> <input
				value="<%=r.getString("email")%>" disabled> <input
				name="phone"
				value="<%=r.getString("phone") == null ? "" : r.getString("phone")%>">
			<input name="department"
				value="<%=r.getString("department") == null ? "" : r.getString("department")%>">
			<input type="number" name="year"
				value="<%=r.getInt("year_of_study")%>" min="1" max="5">
			<button class="btn">Update</button>
		</form>
		<p>
			<a href="dashboard.jsp">Back</a>
		</p>
	</div>
</body>
</html>
<%c.close();%>
