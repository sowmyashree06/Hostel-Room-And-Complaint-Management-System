<%@ page import="com.hostel.DBConnection" %>
<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("adminId")==null){
    response.sendRedirect("login.jsp");
    return;
}
String msg="";
if("POST".equalsIgnoreCase(request.getMethod())){
    Connection c=DBConnection.getConnection();
    c.setAutoCommit(false);
    try{
        int sid=Integer.parseInt(request.getParameter("studentId"));
        int rid=Integer.parseInt(request.getParameter("roomId"));

        // Check if student already has a room
        PreparedStatement a=c.prepareStatement(
            "SELECT allocation_id FROM room_allocation WHERE student_id=? AND vacated_date IS NULL"
        );
        a.setInt(1,sid);
        ResultSet ar=a.executeQuery();
        if(ar.next()){
            msg="Student already has an active room.";
        } else {
            // Check room capacity
            PreparedStatement q=c.prepareStatement(
                "SELECT capacity,occupied FROM rooms WHERE room_id=? FOR UPDATE"
            );
            q.setInt(1,rid);
            ResultSet rr=q.executeQuery();
            if(!rr.next()){
                msg="Room not found.";
            } else if(rr.getInt("occupied")>=rr.getInt("capacity")){
                msg="Room is full.";
            } else {
                // Generate new allocation_id manually
                int newId=0;
                Statement st=c.createStatement();
                ResultSet rs=st.executeQuery("SELECT NVL(MAX(allocation_id),0)+1 FROM room_allocation");
                if(rs.next()) newId=rs.getInt(1);

                // Insert allocation
                PreparedStatement i=c.prepareStatement(
                    "INSERT INTO room_allocation(allocation_id, student_id, room_id, allocated_date) VALUES(?,?,?,SYSDATE)"
                );
                i.setInt(1,newId);
                i.setInt(2,sid);
                i.setInt(3,rid);
                i.executeUpdate();

                // Update room occupancy
                PreparedStatement u=c.prepareStatement(
                    "UPDATE rooms SET occupied=occupied+1, status=CASE WHEN occupied+1>=capacity THEN 'Full' ELSE 'Available' END WHERE room_id=?"
                );
                u.setInt(1,rid);
                u.executeUpdate();

                c.commit();
                msg="Room allocated successfully.";
            }
        }
    } catch(Exception e){
        c.rollback();
        msg="Error: "+e.getMessage();
    } finally {
        c.close();
    }
}
Connection c=DBConnection.getConnection();
Statement st=c.createStatement();
ResultSet students=st.executeQuery("SELECT student_id,name,roll_no FROM students ORDER BY name");
%>
<!DOCTYPE html>
<html>
<head>
<title>Allocate Room</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="container card">
<h2>Allocate Room</h2>
<% if(!msg.isEmpty()){ %><div class="message"><%=msg%></div><% } %>
<form method="post">
    <select name="studentId" required>
        <option value="">Select Student</option>
        <% while(students.next()){ %>
        <option value="<%=students.getInt(1)%>"><%=students.getString(2)%> - <%=students.getString(3)%></option>
        <% } %>
    </select>

    <% ResultSet rooms=st.executeQuery("SELECT room_id,room_no,block,occupied,capacity FROM rooms WHERE occupied<capacity ORDER BY room_no"); %>
    <select name="roomId" required>
        <option value="">Select Room</option>
        <% while(rooms.next()){ %>
        <option value="<%=rooms.getInt(1)%>"><%=rooms.getString(2)%> / <%=rooms.getString(3)%> (<%=rooms.getInt(4)%>/<%=rooms.getInt(5)%>)</option>
        <% } %>
    </select>

    <button class="btn">Allocate</button>
</form>
<p><a href="dashboard.jsp">Back</a></p>
</div>
</body>
</html>
<% c.close(); %>
