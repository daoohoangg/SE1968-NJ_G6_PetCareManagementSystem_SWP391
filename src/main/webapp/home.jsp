<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.petcaresystem.enities.Account" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/inc/common-head.jspf" %>

    <meta charset="UTF-8">
    <title>PetCare - Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    <style>
        .hero-banner {
            background-image: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.3)),
            url('<%= request.getContextPath() %>/images/banner.jpg');
            background-size: cover;
            background-position: center;
            padding: 10rem 0;
            color: white;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.5);
        }
        .hero-content {
            text-align: right;
        }
        .about-section {
            padding: 60px 0;
        }
        .about-section h2 {
            font-weight: 700;
            color: #1976d2;
            margin-bottom: 25px;
            position: relative;
            display: inline-block;
        }
        .about-section h2::after {
            content: '';
            display: block;
            width: 60px;
            height: 3px;
            background-color: #1976d2;
            margin-top: 8px;
        }

        .about-section p {
            line-height: 1.7;
            color: #555;
            margin-bottom: 15px;
        }
        .about-section .quote {
            font-style: italic;
            font-weight: 500;
            color: #333;
            border-left: 3px solid #1976d2;
            padding-left: 15px;
            margin-top: 20px;
        }
        .info-list-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 25px;
        }
        .info-list-item .icon {
            font-size: 1.5rem;
            color: #1976d2;
            width: 40px;
            margin-top: 5px;
        }
        .info-list-item .info-content h6 {
            font-weight: 700;
            color: #333;
            margin-bottom: 5px;
            text-transform: uppercase;
        }
        .info-list-item .info-content p {
            margin-bottom: 0;
            font-size: 0.9rem;
            color: #555;
        }
    </style>
</head>
<body>
<%@ include file="inc/header.jsp" %>

<div class="hero-banner">
    <div class="container">
        <div class="row">
            <div class="col-lg-6 offset-lg-6 hero-content">
                <h1 class="display-4 fw-bold">Welcome to PetCare</h1>
                <p class="fs-4">Your pet's health and happiness is our top priority.</p>
                <%
                    Account user = (Account) session.getAttribute("account");
                    if (user != null) {
                %>
                <p class="fs-5 mt-3">
                    Logged in as <b><%= user.getFullName() %></b> (<i><%= user.getRole().name() %></i>)
                </p>
                <%
                    }
                %>
            </div>
        </div>
    </div>
</div>
<main class="about-section container">
    <div class="row g-5 align-items-center">
        <div class="col-lg-7">
            <h2>PETCARE SYSTEM</h2>
            <p>
                Welcome to PetCare, the all-in-one solution for managing pets. We are dedicated to providing the best services for pet owners (dogs, cats) right at FPT University, Hanoi.
            </p>
            <p>
                Our system offers a full range of services from <strong>Appointment Booking, Pet Management,</strong> to <strong>Services.</strong> Our goal is to keep your pets healthy, beautiful, and happy!
            </p>
            <p>
                PetCare has a friendly, enthusiastic team with high expertise in <strong>pet care.</strong> We are always learning and improving our skills to serve our customers better every day.
            </p>
            <p class="quote">
                "PetCare - The solution for modern pet care services."
            </p>
        </div>
        <div class="col-lg-5">
            <div class="info-list-item">
                <div class="icon"><i class="fas fa-map-marker-alt"></i></div>
                <div class="info-content">
                    <h6>Address</h6>
                    <p>FPT University, Hoa Lac Hi-Tech Park, Km29, Thang Long Avenue, Thach That, Hanoi.</p>
                </div>
            </div>
            <div class="info-list-item">
                <div class="icon"><i class="fas fa-clock"></i></div>
                <div class="info-content">
                    <h6>Opening Hours</h6>
                    <p>8:00 AM - 8:00 PM (All Days)</p>
                </div>
            </div>
            <div class="info-list-item">
                <div class="icon"><i class="fas fa-phone-alt"></i></div>
                <div class="info-content">
                    <h6>Consult & Booking</h6>
                    <p>Phone: <strong>0914.430.472</strong></p>
                </div>
            </div>
            <div class="info-list-item">
                <div class="icon"><i class="fas fa-envelope"></i></div>
                <div class="info-content">
                    <h6>Email</h6>
                    <p>hahshe186536@fpt.edu.vn</p>
                </div>
            </div>

        </div>
    </div>
</main>

<%@ include file="inc/chatbox.jsp" %>
<%@ include file="inc/footer.jsp"%>
</body>
</html>
