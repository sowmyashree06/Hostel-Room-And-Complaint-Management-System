<%@ page import="com.hostel.DBConnection" %>
<%@ page import="java.sql.*" %>
<%
String msg="";
Integer sidObj = (Integer)session.getAttribute("studentId");
if(sidObj == null){
    response.sendRedirect("../login.jsp");
    return;
}
int sid = sidObj;

if("POST".equalsIgnoreCase(request.getMethod())){
    String category=request.getParameter("category");
    String description=request.getParameter("description");
    if(category==null || description==null || category.isEmpty() || description.isEmpty()){
        msg="Please fill all fields.";
    } else {
        try {
            Connection con=DBConnection.getConnection();

            // Generate new complaint_id manually
            int newId=0;
            Statement st=con.createStatement();
            ResultSet rs=st.executeQuery("SELECT NVL(MAX(complaint_id),0)+1 FROM complaints");
            if(rs.next()) newId=rs.getInt(1);

            PreparedStatement ps=con.prepareStatement(
              "INSERT INTO complaints(complaint_id, student_id, category, description, complaint_date, status) VALUES(?,?,?,?,SYSDATE,'Pending')"
            );
            ps.setInt(1,newId);
            ps.setInt(2,sid);
            ps.setString(3,category);
            ps.setString(4,description);
            ps.executeUpdate();
            con.close();

            response.sendRedirect("complaints.jsp?added=1");
            return;
        } catch(Exception e){
            msg="Error: "+e.getMessage();
        }
    }
}
%>
<!DOCTYPE html>
<html>
<head>
<title>Submit Complaint</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="container card">
<h2>Submit Complaint</h2>
<% if(!msg.isEmpty()){ %><div class="message"><%=msg%></div><% } %>
<form method="post">
    <label>Select Category</label><br>
    <select name="category" required>
        <option value="">Select Category</option>
        <option>Electrical</option>
        <option>Plumbing</option>
        <option>Cleaning</option>
        <option>Wi-Fi</option>
        <option>Food</option>
        <option>Furniture</option>
        <option>Other</option>
    </select><br><br>

    <label>Describe your complaint</label><br>
    <textarea name="description" rows="6" required></textarea><br><br>

    <button class="btn" type="submit">Submit</button>
</form>
<p><a class="btn" href="dashboard.jsp">Back</a></p>
</div>
</body>
</html>
