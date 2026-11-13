<%@ page import="com.hostel.DBConnection" %>
<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("studentId")==null){
    response.sendRedirect("../login.jsp");
    return;
}
int sid = (Integer)session.getAttribute("studentId");
String msg="";
%>
<!DOCTYPE html>
<html>
<head>
<title>My Complaints</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="container card">
<h2>My Complaints</h2>

<table border="1" class="table">
<tr>
    <th>ID</th>
    <th>Category</th>
    <th>Description</th>
    <th>Date</th>
    <th>Status</th>
    <th>Action</th>
</tr>
<%
try {
    Connection con = DBConnection.getConnection();
    PreparedStatement ps = con.prepareStatement(
        "SELECT complaint_id, category, description, complaint_date, status FROM complaints WHERE student_id=? ORDER BY complaint_date DESC"
    );
    ps.setInt(1, sid);
    ResultSet rs = ps.executeQuery();
    while(rs.next()){
%>
<tr>
    <td><%=rs.getInt("complaint_id")%></td>
    <td><%=rs.getString("category")%></td>
    <td><%=rs.getString("description")%></td>
    <td><%=rs.getDate("complaint_date")%></td>
    <td><%=rs.getString("status")%></td>
    <td>
        <% if("Pending".equalsIgnoreCase(rs.getString("status"))){ %>
            <a class="btn" href="editComplaint.jsp?id=<%=rs.getInt("complaint_id")%>">Edit</a>
        <% } else { %>
            <span style="color:gray;">Locked</span>
        <% } %>
    </td>
</tr>
<%
    }
    con.close();
} catch(Exception e){
    msg="Error: "+e.getMessage();
}
%>
</table>

<% if(!msg.isEmpty()){ %>
<div class="error"><%=msg%></div>
<% } %>

<p><a class="btn" href="addComplaint.jsp">Add New Complaint</a></p>
<p><a class="btn" href="dashboard.jsp">Back</a></p>
</div>
</body>
</html>
