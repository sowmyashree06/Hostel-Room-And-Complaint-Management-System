<%@ page import="com.hostel.DBConnection" %>
<%@ page import="java.sql.*" %>

<%
if (session.getAttribute("adminId") == null) {
    response.sendRedirect("login.jsp");
    return;
}

String msg = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {
    try {
        Connection x = DBConnection.getConnection();

        PreparedStatement p = x.prepareStatement(
            "INSERT INTO rooms(room_id, room_no, block, floor, capacity, occupied, status) " +
            "VALUES(?, ?, ?, ?, ?, 0, 'Available')"
        );

        p.setInt(1, Integer.parseInt(request.getParameter("roomId")));
        p.setString(2, request.getParameter("roomNo"));
        p.setString(3, request.getParameter("block"));
        p.setInt(4, Integer.parseInt(request.getParameter("floor")));
        p.setInt(5, Integer.parseInt(request.getParameter("capacity")));

        p.executeUpdate();
        x.close();

        msg = "Room added successfully.";

    } catch (Exception e) {
        msg = e.getMessage();
    }
}

Connection c = DBConnection.getConnection();
Statement s = c.createStatement();

ResultSet r = s.executeQuery(
    "SELECT * FROM rooms ORDER BY room_id"
);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Rooms</title>
    <link rel="stylesheet" href="../css/style.css">
</head>

<body>

<div class="container">

    <h2>Manage Rooms</h2>

    <% if (!msg.isEmpty()) { %>
        <div class="success">
            <%= msg %>
        </div>
    <% } %>

    <form method="post" class="inline">

        <input type="number"
               name="roomId"
               placeholder="Room ID"
               required>

        <input type="text"
               name="roomNo"
               placeholder="Room No"
               required>

        <input type="text"
               name="block"
               placeholder="Block"
               required>

        <input type="number"
               name="floor"
               placeholder="Floor"
               required>

        <input type="number"
               name="capacity"
               placeholder="Capacity"
               required>

        <button type="submit" class="btn">
            Add Room
        </button>

    </form>

    <table>

        <tr>
            <th>Room ID</th>
            <th>Room No</th>
            <th>Block</th>
            <th>Floor</th>
            <th>Capacity</th>
            <th>Occupied</th>
            <th>Status</th>
        </tr>

        <% while (r.next()) { %>
        <tr>
            <td><%= r.getInt("room_id") %></td>
            <td><%= r.getString("room_no") %></td>
            <td><%= r.getString("block") %></td>
            <td><%= r.getInt("floor") %></td>
            <td><%= r.getInt("capacity") %></td>
            <td><%= r.getInt("occupied") %></td>
            <td><%= r.getString("status") %></td>
        </tr>
        <% } %>

    </table>

    <br>

    <a href="dashboard.jsp" class="btn">
        Back
    </a>

</div>

</body>
</html>

<%
c.close();
%>