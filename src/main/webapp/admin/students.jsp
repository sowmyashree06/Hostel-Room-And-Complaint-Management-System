<%@ page import="com.hostel.DBConnection"%>
<%@ page import="java.sql.*"%>
<%
if (session.getAttribute("adminId") == null) {
	response.sendRedirect("login.jsp");
	return;
}
Connection c = DBConnection.getConnection();
Statement s = c.createStatement();
ResultSet r = s.executeQuery(
		"SELECT student_id,name,roll_no,email,phone,department,year_of_study FROM students ORDER BY student_id DESC");
%>
<!DOCTYPE html>
<html>
<head>
<title>Students</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>
	<div class="container">
		<h2>Students</h2>
		<table>
			<tr>
				<th>ID</th>
				<th>Name</th>
				<th>Roll</th>
				<th>Email</th>
				<th>Phone</th>
				<th>Department</th>
				<th>Year</th>
			</tr>
			<%
			while (r.next()) {
			%><tr>
				<td><%=r.getInt(1)%></td>
				<td><%=r.getString(2)%></td>
				<td><%=r.getString(3)%></td>
				<td><%=r.getString(4)%></td>
				<td><%=r.getString(5)%></td>
				<td><%=r.getString(6)%></td>
				<td><%=r.getInt(7)%></td>
			</tr>
			<%}%>
		</table>
		<p>
			<a href="dashboard.jsp">Back</a>
		</p>
	</div>
</body>
</html>
<%c.close();%>
