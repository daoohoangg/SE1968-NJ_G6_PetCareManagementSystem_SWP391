<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.petcaresystem.enities.Account" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PetCare - Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>
<%@ include file="inc/header.jsp" %>

<div class="container mt-4">

    <div class="p-5 mb-4 bg-light rounded-3">
        <div class="container-fluid py-5 text-center">
            <h1 class="display-5 fw-bold">Welcome to PetCare</h1>
            <p class="fs-4 text-muted">Your pet's health and happiness is our top priority.</p>
            <%
                Account user = (Account) session.getAttribute("user");
                if (user != null) {
            %>
            <p class="text-muted mt-3">
                Logged in as <b><%= user.getFullName() %></b> (<i><%= user.getRole().name() %></i>)
            </p>
            <%
                }
            %>
        </div>
    </div>

    <div class="row text-center">
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
<%@ include file="inc/footer.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>