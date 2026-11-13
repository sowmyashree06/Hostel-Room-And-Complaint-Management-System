<%@ page import="com.hostel.DBConnection"%>
<%@ page import="java.sql.*"%>
<%
if (session.getAttribute("adminId") == null) {
	response.sendRedirect("login.jsp");
	return;
}
String msg = "";
if (request.getParameter("id") != null && request.getParameter("status") != null) {
	Connection x = DBConnection.getConnection();
	PreparedStatement p = x.prepareStatement("UPDATE complaints SET status=?,admin_remark=? WHERE complaint_id=?");
	p.setString(1, request.getParameter("status"));
	p.setString(2, request.getParameter("remark"));
	p.setInt(3, Integer.parseInt(request.getParameter("id")));
	p.executeUpdate();
	x.close();
	msg = "Complaint updated.";
}
Connection c = DBConnection.getConnection();
PreparedStatement p = c.prepareStatement(
		"SELECT c.*,s.name,s.roll_no FROM complaints c JOIN students s ON c.student_id=s.student_id ORDER BY c.complaint_date DESC");
ResultSet r = p.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<title>Complaints</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>
	<div class="container">
		<h2>Complaint Management</h2>
		<%
		if (!msg.isEmpty()) {
		%><div class="success"><%=msg%></div>
		<%}%>
		<table>
			<tr>
				<th>Student</th>
				<th>Category</th>
				<th>Description</th>
				<th>Date</th>
				<th>Status</th>
				<th>Update</th>
			</tr>
			<%
			while (r.next()) {
			%><tr>
				<td><%=r.getString("name")%> (<%=r.getString("roll_no")%>)</td>
				<td><%=r.getString("category")%></td>
				<td><%=r.getString("description")%></td>
				<td><%=r.getDate("complaint_date")%></td>
				<td><%=r.getString("status")%></td>
				<td>
					<form method="post">
						<input type="hidden" name="id"
							value="<%=r.getInt("complaint_id")%>"><select
							name="status"><option>Pending</option>
							<option>In Progress</option>
							<option>Resolved</option></select><input name="remark"
							placeholder="Remark">
						<button>Save</button>
					</form>
				</td>
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
