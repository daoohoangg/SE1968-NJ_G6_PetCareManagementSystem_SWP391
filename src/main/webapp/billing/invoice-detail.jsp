<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.petcaresystem.enities.Invoice, com.petcaresystem.enities.Payment, java.util.*" %>
<html>
<head>
    <%@ include file="/inc/common-head.jspf" %>

    <title>Invoice Detail</title>
</head>
<body>
<%
    Invoice inv = (Invoice) request.getAttribute("invoice");
%>
<h2>Invoice #<%= inv.getInvoiceNumber() %></h2>
<p><b>Status:</b> <%= inv.getStatus() %></p>
<p><b>Customer:</b> <%= inv.getCustomer() != null ? inv.getCustomer().getFullName() : "-" %></p>
<p><b>Subtotal:</b> <%= inv.getSubtotal() %></p>
<p><b>Tax:</b> <%= inv.getTaxAmount() %></p>
<p><b>Discount:</b> <%= inv.getDiscountAmount() %></p>
<p><b>Total:</b> <%= inv.getTotalAmount() %></p>
<p><b>Paid:</b> <%= inv.getAmountPaid() %></p>
<p><b>Due:</b> <%= inv.getAmountDue() %></p>

<h3>Payments</h3>
<%
    List<Payment> payments = inv.getPayments();
    if (payments == null || payments.isEmpty()) {
%>
    <p>No payments yet.</p>
<%
    } else {
%>
    <table border="1" cellpadding="6" cellspacing="0">
        <tr>
            <th>ID</th>
            <th>Amount</th>
            <th>Date</th>
            <th>Status</th>
        </tr>
        <%
            for (Payment p : payments) {
        %>
        <tr>
            <td><%= p.getPaymentId() %></td>
            <td><%= p.getAmount() %></td>
            <td><%= p.getPaymentDate() %></td>
            <td><%= p.getStatus() %></td>
        </tr>
        <%
            }
        %>
    </table>
<%
    }
%>

<h3>Add Payment</h3>
<form method="post" action="<%= request.getContextPath() %>/billing/payments/add">
    <input type="hidden" name="invoiceId" value="<%= inv.getInvoiceId() %>"/>
    <label>Amount:</label>
    <input type="number" step="0.01" name="amount" required />
    <label>Method:</label>
    <input type="text" name="method" placeholder="CASH/CARD/..." />
    <label>Notes:</label>
    <input type="text" name="notes" />
    <button type="submit">Add Payment</button>
</form>

<p><a href="<%= request.getContextPath() %>/billing/invoices">Back to list</a></p>
</body>
</html>

