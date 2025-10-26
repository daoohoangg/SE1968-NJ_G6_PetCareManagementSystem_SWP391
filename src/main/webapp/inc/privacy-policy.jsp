<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Privacy Policy - PetCare</title>
    <style>
        .privacy-page-main {
            background-color: #f8f9fa;
            padding: 40px 0;
        }
        .privacy-content-card {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            border: 1px solid #e9ecef;
            max-width: 900px;
            margin: 0 auto;
        }
        .privacy-content-card h1 {
            font-weight: 700;
        }
        .privacy-content-card h2 {
            font-weight: 700;
            color: #333;
            margin-top: 30px;
            margin-bottom: 15px;
            font-size: 1.75rem;
        }
        .privacy-content-card p, .privacy-content-card li {
            line-height: 1.7;
            color: #555;
            font-size: 1.1rem;
        }
        .breadcrumb-container {
            background-color: #f8f9fa;
            padding: 12px 0;
            border-bottom: 1px solid #e9ecef;
            font-size: 0.9rem;
        }
        .breadcrumb-container .breadcrumb {
            margin-bottom: 0;
            background-color: transparent;
            padding: 0;
        }
        .breadcrumb-container .breadcrumb-item a {
            color: #007bff;
            text-decoration: none;
        }
        .breadcrumb-container .breadcrumb-item a:hover {
            text-decoration: underline;
        }
        .breadcrumb-container .breadcrumb-item.active {
            color: #6c757d;
        }
    </style>
</head>
<body>
<jsp:include page="header.jsp" />
<div class="breadcrumb-container">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="<%= request.getContextPath() %>/home">Home</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    Privacy Policy
                </li>
            </ol>
        </nav>
    </div>
</div>
<main class="privacy-page-main">
    <div class="privacy-content-card">
        <h1>Chính sách Bảo mật</h1>
        <hr>

        <h2>1. Mục đích và Phạm vi Thu thập Thông tin</h2>
        <p>
            PetCare thu thập thông tin khách hàng nhằm cung cấp dịch vụ chăm sóc tốt hơn và đưa ra các chương trình khuyến mãi, ưu đãi hấp dẫn dành cho khách hàng thân thiết.
        </p>
        <p>
            PetCare chỉ thu thập các thông tin cơ bản như tên, số điện thoại, email, địa chỉ và thông tin về các thú cưng bạn đang nuôi.
        </p>

        <h2>2. Phạm vi Sử dụng Thông tin</h2>
        <p>
            Thông tin khách hàng chỉ được sử dụng nội bộ tại PetCare cho mục đích chăm sóc khách hàng và hỗ trợ dịch vụ.
        </p>

        <h2>3. Thời gian Lưu trữ Thông tin</h2>
        <p>
            Thông tin khách hàng sẽ được lưu trữ vô thời hạn kể từ thời điểm khách hàng liên hệ với PetCare.
        </p>

        <h2>4. Địa chỉ của Đơn vị Thu thập và Quản lý Thông tin</h2>
        <p>
            Địa chỉ: Đại học FPT, Khu Công nghệ cao Hòa Lạc, Km29, Đại lộ Thăng Long, H. Thạch Thất, Hà Nội.
        </p>

        <h2>5. Cam kết Bảo mật Thông tin Cá nhân của Khách hàng</h2>
        <p>
            PetCare cam kết bảo mật thông tin cá nhân của bạn và sẽ không chia sẻ cho bất kỳ bên thứ ba nào vì mục đích thương mại mà không có sự đồng ý của bạn.
        </p>
    </div>

</main>

<jsp:include page="chatbox.jsp" />
<jsp:include page="footer.jsp" />
</body>
</html>