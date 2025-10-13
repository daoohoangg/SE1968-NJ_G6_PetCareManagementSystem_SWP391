<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.petcaresystem.enities.Account" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PetCare - Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .footer {
            background-color: #1976d2;
            color: #fff;
            padding: 25px 0;
            font-family: sans-serif;
            text-align: center;
            border-top: 4px solid #1565c0;
            margin-top: 40px;
        }
        .footer .footer-content { max-width: 1000px; margin: auto; }
        .footer h3 { margin: 0; font-size: 20px; font-weight: 600; }
        .footer p { margin: 6px 0; font-size: 14px;
            color: #e3f2fd;
        }

        .footer .links a {
            color: #bbdefb;
            text-decoration: none;
            margin: 0 10px;
            transition: color 0.2s;
        }

        .footer .links a:hover {
            color: #fff;
            text-decoration: underline;
        }

        .footer .copyright {
            margin-top: 10px;
            font-size: 13px;
            color: #e0e0e0;
        }
    </style>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>