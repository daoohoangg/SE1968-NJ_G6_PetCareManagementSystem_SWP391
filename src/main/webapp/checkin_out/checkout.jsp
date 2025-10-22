<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.petcaresystem.enities.Booking" %>
<html>
<head>
    <title>Check-Out</title>
</head>
<body>
<h2>Checked-In Bookings</h2>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    if (bookings == null || bookings.isEmpty()) {
%>
    <p>No checked-in bookings.</p>
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
                <form method="post" action="<%= request.getContextPath() %>/reception/checkout">
                    <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>"/>
                    <button type="submit">Check Out</button>
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
