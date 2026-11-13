<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("studentId")==null){response.sendRedirect("../login.jsp");return;}
int sid=(Integer)session.getAttribute("studentId");
%>
<!DOCTYPE html><html><head><title>Student Dashboard</title><link rel="stylesheet" href="../css/style.css"></head>
<body><div class="container">
<h1>Welcome, <%=session.getAttribute("studentName")%></h1>
<div class="grid">
<a class="tile" href="profile.jsp">My Profile</a>
<a class="tile" href="roomDetails.jsp">My Room</a>
<a class="tile" href="complaints.jsp">My Complaints</a>
<a class="tile" href="addComplaint.jsp">New Complaint</a>
<a class="tile" href="../logout.jsp">Logout</a>
</div></div></body></html>
