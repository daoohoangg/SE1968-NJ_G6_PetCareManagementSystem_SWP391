<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.petcaresystem.enities.Account" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/inc/common-head.jspf" %>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PetCare - Home</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    <style>
        body {
            font-family: 'Inter', system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
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
        .service-section {
            padding: 60px 0;
            background-color: #f8f9fa; /* Màu nền xám nhạt */
        }
        .service-title {
            font-weight: 700;
            color: #1976d2;
            margin-bottom: 25px;
        }
        .service-accordion-item {
            border: 1px solid #dee2e6;
            border-radius: 8px !important;
            margin-bottom: 10px;
            overflow: hidden;
        }
        .accordion-button {
            font-weight: 600;
            color: #333;
        }
        .accordion-button:not(.collapsed) {
            background-color: #e9f2ff;
            color: #0d6efd;
            box-shadow: none;
        }
        .accordion-button:focus {
            box-shadow: none;
            border-color: rgba(0,0,0,.125);
        }
        .service-list-item {
            padding: 1rem 1.25rem;
        }
        .service-image-grid img {
            width: 100%;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
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
<section class="service-section">
    <div class="container">
        <div class="row g-5 align-items-start">
            <div class="col-lg-7">
                <h2 class="service-title">Our Services & Pricing</h2>
                <p class="text-muted mb-4">
                    Click each category to see our services and pricing.
                </p>
                <div class="accordion" id="serviceAccordion">
                    <div class="accordion-item service-accordion-item">
                        <h2 class="accordion-header" id="headingOne">
                            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                Medical Checkup
                            </button>
                        </h2>
                        <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="#serviceAccordion">
                            <div class="accordion-body">
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item service-list-item d-flex justify-content-between align-items-center">
                                        <span>
                                            <strong>General Checkup</strong>
                                            <br>
                                            <small class="text-muted">Comprehensive health examination</small>
                                        </span>
                                        <span class="text-primary fw-bold ms-auto" style="white-space: nowrap;">
                                            75.00 đ
                                        </span>
                                    </li>
                                    <li class="list-group-item service-list-item d-flex justify-content-between align-items-center">
                                        <span>
                                            <strong>Vaccination</strong>
                                            <br>
                                            <small class="text-muted">Core and non-core vaccinations</small>
                                        </span>
                                        <span class="text-primary fw-bold ms-auto" style="white-space: nowrap;">
                                            45.00 đ
                                        </span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item service-accordion-item">
                        <h2 class="accordion-header" id="headingTwo">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                Surgery & Dental
                            </button>
                        </h2>
                        <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#serviceAccordion">
                            <div class="accordion-body">
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item service-list-item d-flex justify-content-between align-items-center">
                                        <span>
                                            <strong>Spay/Neuter Surgery</strong>
                                            <br>
                                            <small class="text-muted">Spaying or neutering procedure</small>
                                        </span>
                                        <span class="text-primary fw-bold ms-auto" style="white-space: nowrap;">
                                            200.00 đ
                                        </span>
                                    </li>
                                    <li class="list-group-item service-list-item d-flex justify-content-between align-items-center">
                                        <span>
                                            <strong>Dental Cleaning</strong>
                                            <br>
                                            <small class="text-muted">Professional dental cleaning</small>
                                        </span>
                                        <span class="text-primary fw-bold ms-auto" style="white-space: nowrap;">
                                            150.00 đ
                                        </span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item service-accordion-item">
                        <h2 class="accordion-header" id="headingThree">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                Grooming
                            </button>
                        </h2>
                        <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="#serviceAccordion">
                            <div class="accordion-body">
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item service-list-item d-flex justify-content-between align-items-center">
                                        <span>
                                            <strong>Basic Grooming</strong>
                                            <br>
                                            <small class="text-muted">Bath, brush, and nail trim</small>
                                        </span>
                                        <span class="text-primary fw-bold ms-auto" style="white-space: nowrap;">
                                            40.00 đ
                                        </span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item service-accordion-item">
                        <h2 class="accordion-header" id="headingFour">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFour" aria-expanded="false" aria-controls="collapseFour">
                                Emergency
                            </button>
                        </h2>
                        <div id="collapseFour" class="accordion-collapse collapse" aria-labelledby="headingFour" data-bs-parent="#serviceAccordion">
                            <div class="accordion-body">
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item service-list-item d-flex justify-content-between align-items-center">
                                        <span>
                                            <strong>Emergency Consultation</strong>
                                            <br>
                                            <small class="text-muted">Urgent medical consultation</small>
                                        </span>
                                        <span class="text-primary fw-bold ms-auto" style="white-space: nowrap;">
                                            100.00 đ
                                        </span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="mt-4">
                    <a href="<%= request.getContextPath() %>/customer/appointments.jsp" class="btn btn-primary">
                        <i class="fas fa-calendar-check me-2"></i> Book Appointment Now
                    </a>
                </div>
            </div>
            <div class="col-lg-5">
                <div class="service-image-grid">
                    <p class="text-muted fst-italic">
                       sẽ thêm ảnh sau
                    </p>
                    <img src="<%= request.getContextPath() %>/images/placeholder-service-1.jpg"
                         alt="Pet Grooming"
                         class="img-fluid rounded mb-3"
                         style="border: 1px solid #ddd; background: #eee; height: 250px; width:100%; object-fit: cover;">

                    <img src="<%= request.getContextPath() %>/images/placeholder-service-2.jpg"
                         alt="Pet Hotel"
                         class="img-fluid rounded"
                         style="border: 1px solid #ddd; background: #eee; height: 250px; width:100%; object-fit: cover;">
                </div>
            </div>

        </div>
    </div>
</section>
<%@ include file="inc/chatbox.jsp" %>
<%@ include file="inc/footer.jsp"%>
</body>
</html>
