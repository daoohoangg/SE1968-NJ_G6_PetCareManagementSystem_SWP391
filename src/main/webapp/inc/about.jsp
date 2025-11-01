<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/inc/common-head.jspf" %>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - PetCareManagementSystem</title>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .about-container {
            max-width: 900px;
            margin: 60px auto;
            background: #fff;
            padding: 40px 50px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            text-align: left;
        }
        h1, h2, h3 {
            color: #1976d2;
            font-weight: 700;
        }
        h1 {
            text-align: center;
            margin-bottom: 25px;
        }
        h2 {
            margin-top: 40px;
            margin-bottom: 15px;
            border-bottom: 2px solid #1976d2;
            display: inline-block;
            padding-bottom: 5px;
        }
        p, li {
            font-size: 1rem;
            line-height: 1.7;
            color: #555;
        }
        ul {
            margin-left: 25px;
        }
        .back-link {
            margin-top: 40px;
            text-align: center;
        }
        .back-link a {
            color: #1976d2;
            text-decoration: none;
            font-weight: bold;
        }
        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<jsp:include page="header.jsp" />
<div class="about-container">
    <h1>Pet Care Management System</h1>
    <p>
        The <strong>Pet Care Management System (PCMS)</strong> was born from a passion for animals and a vision to transform
        traditional pet care into a modern, technology-driven experience.
        Our system helps pet owners manage everything related to their pets — from booking care services to monitoring health — all in one place.
    </p>

    <h2>Who We Are</h2>
    <p>
        PCMS is an integrated online platform that connects <strong>pet owners</strong>, <strong>caregivers</strong>,
        and <strong>service providers</strong> in a seamless digital environment. It supports scheduling, online payments,
        and customer service to simplify pet care activities.
    </p>

    <h2>Vision</h2>
    <p>
        To become the leading pet care management system in Vietnam and Southeast Asia, providing smart,
        reliable, and community-oriented digital services for pet lovers.
    </p>

    <h2>Mission</h2>
    <ul>
        <li>Empower pet owners through easy and transparent service management tools.</li>
        <li>Promote responsible and loving pet ownership through technology.</li>
        <li>Ensure every pet receives professional, safe, and caring service experiences.</li>
        <li>Bridge the gap between technology and compassion in pet care.</li>
    </ul>

    <h2>Core Values</h2>
    <ul>
        <li><strong>Love & Compassion:</strong> Every feature is built with a genuine love for pets.</li>
        <li><strong>Professionalism & Safety:</strong> We ensure all data, services meet high standards.</li>
        <li><strong>Community Connection:</strong> Bringing together people who share the same love for animals.</li>
        <li><strong>Innovation:</strong> Continuously improving to keep up with global pet care trends.</li>
    </ul>

    <h2>Our Services</h2>
    <ul>
        <li><strong>Online Booking:</strong> Schedule grooming or veterinary checkups easily.</li>
        <li><strong>Pet Health Tracking:</strong> Manage vaccination, diet, and medical history conveniently.</li>
        <li><strong>Admin Dashboard:</strong> Manage customers, Appointment, Reports in one interface.</li>
    </ul>

    <h2>Our Team</h2>
    <p>
        Our team includes experienced developers, animal care specialists, and customer service experts
        who share the same mission — to make pet care management simpler, safer, and smarter.
        Every member contributes their expertise to ensure a high-quality and reliable system.
    </p>
    <div class="back-link">
        <a href="<%= request.getContextPath() %>/home">Back Home</a>
    </div>
</div>
<jsp:include page="footer.jsp" />
