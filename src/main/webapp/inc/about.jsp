<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - PetCareManagementSystem</title>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .about-container {
            max-width: 850px;
            margin: 60px auto;
            background: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        h1 {
            color: #1976d2;
            margin-bottom: 15px;
            font-weight: 700;
        }
        p {
            font-size: 1.1rem;
            line-height: 1.7;
            color: #555;
            margin-bottom: 20px;
        }
        .back-link {
            margin-top: 25px;
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
        The Pet Care Management System (PCMS) is an innovative platform designed to simplify and modernize pet care activities.
    </p>
    <p>
        Our goal is to connect pet owners, caregivers, and service providers through an easy-to-use system that supports
        online scheduling, product purchasing, and pet health management.
    </p>
    <p>
        The system ensures greater convenience, accuracy, and reliability — helping you care for your pets anytime, anywhere.
    </p>
    <div class="back-link">
        <a href="<%= request.getContextPath() %>/home">Back Home</a>
    </div>
</div>
<jsp:include page="footer.jsp" />