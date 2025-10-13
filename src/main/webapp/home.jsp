<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PetCare - Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%--<%@ include file="inc/header.jsp" %>--%>

<div class="container my-5 text-center">
    <h1>Welcome to PetCare </h1>
    <p class="text-muted">
        <c:if test="${not empty sessionScope.user}">
            Logged in as <b>${sessionScope.user.username}</b> (<i>${sessionScope.role}</i>)
        </c:if>
    </p>

    <div class="row mt-5">
        <div class="col-md-4 mb-3">
            <div class="card p-3">
                <h4>About Us</h4>
                <p>Learn more about our pet care services and mission.</p>
                <a href="inc/about.jsp" class="btn btn-primary">Read More</a>
            </div>
        </div>

        <div class="col-md-4 mb-3">
            <div class="card p-3">
                <h4>Contact</h4>
                <p>Need support? Reach out to our team.</p>
                <a href="inc/footer.jsp" class="btn btn-success">Contact Us</a>
            </div>
        </div>

        <div class="col-md-4 mb-3">
            <div class="card p-3">
                <h4>Chat Support</h4>
                <p>Chat with our AI assistant for quick answers.</p>
                <a href="inc/chatbox.jsp" class="btn btn-warning">Open Chat</a>
            </div>
        </div>
    </div>
</div>

<%@ include file="inc/chatbox.jsp" %>
<%--<%@ include file="inc/footer.jsp" %>--%>
</body>
</html>