<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8"><title>Payment Result</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
<%
    Boolean ok = (Boolean) request.getAttribute("paySuccess");
    String msg = (String) request.getAttribute("message");
    String txnRef = (String) request.getAttribute("txnRef");
    String amount = (String) request.getAttribute("amount");
    if (ok == null) ok = Boolean.FALSE;
%>
<div class="container" style="max-width:520px">
    <div class="alert <%= ok ? "alert-success" : "alert-danger" %>"><%= msg %></div>
    <ul class="list-unstyled">
        <li><b>TxnRef:</b> <%= txnRef==null?"":txnRef %></li>
        <li><b>Amount:</b> <%= amount==null?"":amount + " đ" %></li>
    </ul>
    <a class="btn btn-primary" href="<%= request.getContextPath() %>/customer/appointments">Back to Appointments</a>
</div>
</body>
</html>
