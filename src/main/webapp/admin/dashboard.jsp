<%@ page import="com.hostel.DBConnection"%>
<%@ page import="java.sql.*"%>
<%
if (session.getAttribute("adminId") == null) {
	response.sendRedirect("login.jsp");
	return;
}
Connection c = DBConnection.getConnection();
Statement s = c.createStatement();
ResultSet a = s.executeQuery("SELECT COUNT(*) n FROM students");
a.next();
int students = a.getInt("n");
ResultSet b = s.executeQuery("SELECT COUNT(*) n FROM rooms");
b.next();
int rooms = b.getInt("n");
ResultSet d = s.executeQuery("SELECT COUNT(*) n FROM complaints WHERE status='Pending'");
d.next();
int pending = d.getInt("n");
c.close();
%>
<!DOCTYPE html>
<html>
<head>
<title>Admin Dashboard</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>
	<div class="container">
		<h1>Admin Dashboard</h1>
		<div class="stats">
			<div>
				Students<br>
				<b><%=students%></b>
			</div>
			<div>
				Rooms<br>
				<b><%=rooms%></b>
			</div>
			<div>
				Pending Complaints<br>
				<b><%=pending%></b>
			</div>
		</div>
		<div class="grid">
			<a class="tile" href="students.jsp">Students</a><a class="tile"
				href="rooms.jsp">Rooms</a><a class="tile" href="allocateRoom.jsp">Allocate
				Room</a><a class="tile" href="complaints.jsp">Complaints</a><a
				class="tile" href="logout.jsp">Logout</a>
		</div>
	</div>
</body>
</html>
