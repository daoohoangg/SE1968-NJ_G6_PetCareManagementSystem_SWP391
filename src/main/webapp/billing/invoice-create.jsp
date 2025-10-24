<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Create Invoice</title>
</head>
<body>
<h2>Create Invoice From Appointment</h2>
<form method="post" action="<%= request.getContextPath() %>/billing/invoices/create">
    <label>Appointment ID:</label>
    <input type="number" name="appointmentId" required />
    <label>Subtotal (optional):</label>
    <input type="number" step="0.01" name="subtotal" />
    <label>Tax (optional):</label>
    <input type="number" step="0.01" name="tax" />
    <label>Discount (optional):</label>
    <input type="number" step="0.01" name="discount" />
    <button type="submit">Create</button>
</form>
<p><a href="<%= request.getContextPath() %>/billing/invoices">Back</a></p>
</body>
</html>
