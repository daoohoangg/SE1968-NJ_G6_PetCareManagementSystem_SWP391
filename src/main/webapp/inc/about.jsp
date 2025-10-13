<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>About Us - Pet Care Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #f5f5f5;
            color: #333;
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
        .about-container img {
            width: 120px;
            height: auto;
            margin-bottom: 20px;
        }
        h1 {
            color: #1976d2;
            margin-bottom: 15px;
        }
        p {
            font-size: 15px;
            line-height: 1.6;
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

<div class="about-container">
    <img src="images/logo.png" alt="Pet Care Logo"> // sẽ thêm ảnh sau
    <h1>About Pet Care Management System</h1>
    <p>
        Pet Care Management System is an innovative platform designed to simplify and modernize pet care operations.
        Our goal is to connect pet owners, caregivers, and service providers through an easy-to-use system that supports
        online booking, product purchasing, and pet health management.
    </p>
    <p>
        The system ensures better convenience, accuracy, and reliability — helping you take care of your pets
        anytime, anywhere.
    </p>
    <div class="back-link">
        <a href="<%= request.getContextPath() %>/home">← Back to Home</a>
    </div>
</div>

<jsp:include page="footer.jsp" />
</body>
</html>
