<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.petcaresystem.enities.Booking" %>
<html>
<head>
    <title>Check-In</title>
</head>
<body>
<h2>Pending Bookings</h2>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    if (bookings == null || bookings.isEmpty()) {
%>
    <p>No pending bookings.</p>
<%
    } else {
%>
    <table border="1" cellpadding="6" cellspacing="0">
        <tr>
            <th>ID</th>
            <th>Pet</th>
            <th>Customer</th>
            <th>Booking Date</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
        <%
            for (Booking b : bookings) {
        %>
        <tr>
            <td><%= b.getBookingId() %></td>
            <td><%= b.getPetName() %></td>
            <td><%= b.getCustomerName() %></td>
            <td><%= b.getBookingDate() %></td>
            <td><%= b.getStatus() %></td>
            <td>
                <form method="post" action="<%= request.getContextPath() %>/reception/checkin">
                    <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>"/>
                    <button type="submit">Check In</button>
                </form>
            </td>
        </tr>
        <%
            }
        %>
    </table>
<%
    }
%>
</body>
</html>
