<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.petcaresystem.enities.Invoice, java.time.format.DateTimeFormatter" %>
<html>
<head>
    <title>Invoices</title>
</head>
<body>
<h2>Invoices</h2>
<a href="<%= request.getContextPath() %>/billing/invoices/create">Create Invoice</a>
<%
    List<Invoice> invoices = (List<Invoice>) request.getAttribute("invoices");
    if (invoices == null || invoices.isEmpty()) {
%>
    <p>No invoices.</p>
<%
    } else {
%>
    <table border="1" cellpadding="6" cellspacing="0">
        <tr>
            <th>ID</th>
            <th>Number</th>
            <th>Customer</th>
            <th>Issue Date</th>
            <th>Total</th>
            <th>Status</th>
            <th></th>
        </tr>
        <%
            for (Invoice i : invoices) {
        %>
        <tr>
            <td><%= i.getInvoiceId() %></td>
            <td><%= i.getInvoiceNumber() %></td>
            <td><%= (i.getCustomer() != null ? i.getCustomer().getFullName() : "-") %></td>
            <td><%= i.getIssueDate() %></td>
            <td><%= i.getTotalAmount() %></td>
            <td><%= i.getStatus() %></td>
            <td><a href="<%= request.getContextPath() %>/billing/invoices/view?id=<%= i.getInvoiceId() %>">View</a></td>
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
