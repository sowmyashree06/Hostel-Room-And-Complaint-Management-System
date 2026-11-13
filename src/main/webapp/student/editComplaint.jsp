<%@ page import="com.hostel.DBConnection" %>
<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("studentId")==null){
    response.sendRedirect("../login.jsp");
    return;
}
int sid = (Integer)session.getAttribute("studentId");
int id = Integer.parseInt(request.getParameter("id"));
String msg="";

// Handle update
if("POST".equalsIgnoreCase(request.getMethod())){
    Connection c = DBConnection.getConnection();
    try {
        PreparedStatement p = c.prepareStatement(
            "UPDATE complaints SET category=?, description=? WHERE complaint_id=? AND student_id=? AND status='Pending'"
        );
        p.setString(1, request.getParameter("category"));
        p.setString(2, request.getParameter("description"));
        p.setInt(3, id);
        p.setInt(4, sid);
        int updated = p.executeUpdate();
        c.close();
        if(updated > 0){
            response.sendRedirect("complaints.jsp?updated=1");
            return;
        } else {
            msg="Complaint cannot be updated (maybe already processed).";
        }
    } catch(Exception e){
        msg="Error: "+e.getMessage();
    }
}

// Fetch complaint details
Connection c = DBConnection.getConnection();
PreparedStatement p = c.prepareStatement(
    "SELECT * FROM complaints WHERE complaint_id=? AND student_id=?"
);
p.setInt(1, id);
p.setInt(2, sid);
ResultSet r = p.executeQuery();
if(!r.next()){
    c.close();
    response.sendRedirect("complaints.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
<title>Edit Complaint</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="container card">
<h2>Edit Complaint</h2>

<% if(!msg.isEmpty()){ %>
<div class="message"><%=msg%></div>
<% } %>

<form method="post">
    <label>Select Category</label><br>
    <select name="category" required>
        <option value="<%=r.getString("category")%>" selected><%=r.getString("category")%></option>
        <option>Electrical</option>
        <option>Plumbing</option>
        <option>Cleaning</option>
        <option>Wi-Fi</option>
        <option>Food</option>
        <option>Furniture</option>
        <option>Other</option>
    </select><br><br>

    <label>Describe your complaint</label><br>
    <textarea name="description" rows="6" required><%=r.getString("description")%></textarea><br><br>

    <button class="btn">Update</button>
</form>

<p><a class="btn" href="complaints.jsp">Back</a></p>
</div>
</body>
</html>
<% c.close(); %>
