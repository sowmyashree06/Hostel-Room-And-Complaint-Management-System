<%@ page import="com.hostel.DBConnection"%>
<%@ page import="java.sql.*"%>
<%
if (session.getAttribute("studentId") == null) {
	response.sendRedirect("../login.jsp");
	return;
}
int sid = (Integer) session.getAttribute("studentId");
Connection c = DBConnection.getConnection();
PreparedStatement p = c.prepareStatement(
		"SELECT r.room_no,r.block,r.floor,r.capacity,r.occupied,a.allocated_date FROM room_allocation a JOIN rooms r ON a.room_id=r.room_id WHERE a.student_id=? AND a.vacated_date IS NULL");
p.setInt(1, sid);
ResultSet rs = p.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<title>My Room</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>
	<div class="container card">
		<h2>My Room</h2>
		<%
		if (rs.next()) {
		%>
		<table>
			<tr>
				<th>Room</th>
				<td><%=rs.getString("room_no")%></td>
			</tr>
			<tr>
				<th>Block</th>
				<td><%=rs.getString("block")%></td>
			</tr>
			<tr>
				<th>Floor</th>
				<td><%=rs.getInt("floor")%></td>
			</tr>
			<tr>
				<th>Capacity</th>
				<td><%=rs.getInt("capacity")%></td>
			</tr>
			<tr>
				<th>Occupied</th>
				<td><%=rs.getInt("occupied")%></td>
			</tr>
		</table>
		<%
		} else {
		%><p>No room has been allocated to you yet.</p>
		<%}%><p>
			<a href="dashboard.jsp">Back</a>
		</p>
	</div>
</body>
</html>
<%c.close();%>
