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
        Hệ thống Quản lý Thú cưng (PCMS) là một nền tảng sáng tạo được thiết kế để đơn giản hóa và hiện đại hóa các hoạt động chăm sóc thú cưng.
    </p>
    <p>
        Mục tiêu của chúng tôi là kết nối chủ sở hữu thú cưng, người chăm sóc và nhà cung cấp dịch vụ thông qua một hệ thống dễ sử dụng, hỗ trợ
        đặt lịch trực tuyến, mua sản phẩm và quản lý sức khỏe thú cưng.
    </p>
    <p>
        Hệ thống đảm bảo sự tiện lợi, chính xác và độ tin cậy cao hơn — giúp bạn chăm sóc thú cưng của mình mọi lúc, mọi nơi.
    </p>
    <div class="back-link">
        <a href="<%= request.getContextPath() %>/home">Back Home</a>
    </div>
</div>
<jsp:include page="footer.jsp" />