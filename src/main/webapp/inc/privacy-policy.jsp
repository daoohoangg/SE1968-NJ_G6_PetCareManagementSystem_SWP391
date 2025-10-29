<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/inc/common-head.jspf" %>

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
        <h1>Privacy Policy</h1>
        <hr>
        <h2>1. Purpose and Scope of Information Collection</h2>
        <p>
            PetCare collects customer information to provide better care services and to offer attractive promotions and discounts for loyal customers.
        </p>
        <p>
            PetCare only collects basic information such as name, phone number, email, address, and information about the pets you own.
        </p>
        <h2>2. Scope of Information Use</h2>
        <p>
            Customer information is used internally at PetCare for the purpose of customer care and service support.
        </p>
        <h2>3. Duration of Information Storage</h2>
        <p>
            Customer information will be stored indefinitely from the time the customer contacts PetCare.
        </p>
        <h2>4. Address of the Information Collection and Management Unit</h2>
        <p>
            Address: FPT University, Hoa Lac High-Tech Park, Km29, Thang Long Avenue, Thach That District, Hanoi.
        </p>

        <h2>5. Commitment to Customer Personal Information Security</h2>
        <p>
            PetCare is committed to protecting your personal information and will not share it with any third party for commercial purposes without your consent.
        </p>
    </div>

</main>

<jsp:include page="chatbox.jsp" />
<jsp:include page="footer.jsp" />
</body>
</html>
