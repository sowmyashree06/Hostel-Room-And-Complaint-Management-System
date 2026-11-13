<%@ page import="com.hostel.DBConnection"%>
<%@ page import="java.sql.*"%>
<%
if (session.getAttribute("adminId") != null) {
	response.sendRedirect("dashboard.jsp");
	return;
}
String msg = "";
if ("POST".equalsIgnoreCase(request.getMethod())) {
	try {
		Connection c = DBConnection.getConnection();
		PreparedStatement p = c.prepareStatement("SELECT admin_id FROM admin WHERE username=? AND password=?");
		p.setString(1, request.getParameter("username"));
		p.setString(2, request.getParameter("password"));
		ResultSet r = p.executeQuery();
		if (r.next()) {
	session.setAttribute("adminId", r.getInt("admin_id"));
	response.sendRedirect("dashboard.jsp");
	return;
		}
		msg = "Invalid admin credentials";
		c.close();
	} catch (Exception e) {
		msg = e.getMessage();
	}
}
%>
<!DOCTYPE html>
<html>
<head>
<title>Admin Login</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>
	<div class="container card">
		<h2>Admin Login</h2>
		<%
		if (!msg.isEmpty()) {
		%><div class="error"><%=msg%></div>
		<%}%>
		<form method="post">
			<input name="username" placeholder="Username" required><input
				type="password" name="password" placeholder="Password" required>
			<button class="btn">Login</button>
		</form>
		<p>
			<a href="../index.jsp">Home</a>
		</p>
	</div>
</body>
</html>
