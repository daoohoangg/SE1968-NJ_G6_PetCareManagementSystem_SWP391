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
        .stats-section {
            padding: 60px 0;
            background: linear-gradient(to right, #e0f2f7, #e6f7ff);
            text-align: center;
            color: #333;
        }
        .stats-number {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 10px;
            color: #1976d2;
        }
        .stats-number.text-danger { color: #dc3545 !important; }
        .stats-number.text-success { color: #198754 !important; }

        .stats-title {
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
            font-size: 1.1rem;
        }
        .stats-description {
            color: #6c757d;
            font-size: 0.9rem;
            line-height: 1.6;
        }
        .service-section {
            padding: 60px 0;
            background-color: #f8f9fa;
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
        .service-column-image {
            width: 100%;
            height: 500px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .service-column-image:hover {
            transform: scale(1.03);
            box-shadow: 0 8px 24px rgba(0,0,0,0.2);
        }
        .price-summary-list {
            padding: 1rem 1.25rem;
        }
        .price-summary-list p {
            font-size: 1.1rem;
            margin-bottom: 1rem;
            display: flex;
            justify-content: space-between;
            border-bottom: 1px dashed #dee2e6;
            padding-bottom: 1rem;
        }
        .price-summary-list p:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }
        .price-summary-list small {
            font-size: 0.9rem;
        }
        .price-summary-list .price-span {
            color: #0d6efd;
            font-weight: bold;
        }
        .about-image {
            height: 100%;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            width: 100%;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .about-image:hover {
            transform: scale(1.03);
            box-shadow: 0 8px 24px rgba(0,0,0,0.2);
        }
        .team-section {
            padding: 60px 0;
            background-color: #fff;
        }
        .team-section .section-title {
            font-weight: 700;
            color: #1976d2;
            margin-bottom: 20px;
            text-align: center;
        }
        .team-section .team-description {
            color: #6c757d;
            font-size: 1.1rem;
            line-height: 1.7;
            margin-bottom: 30px;
            text-align: center;
        }
        .team-image {
            border-radius: 8px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
            max-height: 500px;
            width: 100%;
            object-fit: cover;
            display: block;
            margin-left: auto;
            margin-right: auto;
        }
        .why-choose-section {
            padding: 60px 0;
            background-color: #fff;
        }
        .why-choose-section .section-title {
            font-weight: 700;
            color: #1976d2;
            margin-bottom: 40px;
            text-align: center;
        }
        .why-choose-card {
            background-color: #fff;
            padding: 24px;
            border-radius: 8px;
            height: 100%;
            border: 1px solid #e9ecef;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            text-align: center;
        }
        .why-choose-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }
        .why-choose-card .icon-box {
            font-size: 2.5rem;
            margin-bottom: 15px;
        }
        .icon-color-1 { color: #0d6efd; }
        .icon-color-2 { color: #198754; }
        .icon-color-3 { color: #6f42c1; }
        .icon-color-4 { color: #dc3545; }
        .icon-color-5 { color: #ffc107; }
        .icon-color-6 { color: #fd7e14; }

        .why-choose-card h5 {
            font-weight: 600;
            color: #212529;
            margin-bottom: 15px;
        }
        .why-choose-card p {
            color: #6c757d;
            font-size: 0.9rem;
            line-height: 1.6;
        }
        .testimonial-section {
            background-color: #f8f9fa;
            color: #333;
            text-align: center;
            padding: 60px 0;
        }
        .testimonial-section-title {
            font-family: 'Inter', sans-serif;
            font-weight: 700;
            color: #1976d2;
        }
        .testimonial-card {
            background-color: #fff;
            border: 1px solid #dee2e6;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .testimonial-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 24px rgba(25,118,210,0.15);
        }
        .testimonial-card h5 {
            color: #212529;
        }
        .testimonial-text {
            font-size: 1.05rem;
            line-height: 1.6;
            color: #555;
        }
        .carousel-control-prev-icon,
        .carousel-control-next-icon {
            background-color: rgba(25,118,210,0.2);
            border-radius: 50%;
            padding: 20px;
        }
        .carousel-control-prev-icon:hover,
        .carousel-control-next-icon:hover {
            background-color: rgba(25,118,210,0.35);
        }
        .carousel-control-prev,
        .carousel-control-next {
            width: 5%;
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

        <div class="col-lg-5">
            <img src="<%= request.getContextPath() %>/images/pethome.jpg"
                 alt="About Us Image"
                 class="img-fluid about-image"
                 style="background: #eee; border: 1px solid #ddd; object-fit: cover; width: 100%;">
        </div>

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
            <div class="mt-4">
                <a href="<%= request.getContextPath() %>/inc/about.jsp" class="btn btn-primary">
                    <i class="fas fa-arrow-right me-2"></i> Explore now.
                </a>
            </div>
        </div>
    </div>
</main>
<section class="stats-section">
    <div class="container">
        <div class="row">
            <div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
                <h2 class="stats-number text-danger">+500</h2>
                <h5 class="stats-title">Pets Served</h5>
                <p class="stats-description">From cute pet animals.</p>
            </div>
            <div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
                <h2 class="stats-number text-success">+10</h2>
                <h5 class="stats-title">Pet-Loving Staff</h5>
                <p class="stats-description">A professional, dedicated care team available 24/7.</p>
            </div>
            <div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
                <h2 class="stats-number text-danger">+5</h2>
                <h5 class="stats-title">Modern Boarding Rooms</h5>
                <p class="stats-description">Equipped with A/C, cameras, toys, and private spaces.</p>
            </div>
            <div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
                <h2 class="stats-number text-success">+100</h2>
                <h5 class="stats-title">Loyal Customers</h5>
                <p class="stats-description">Pet owners who trust us with their pets during business or travel.</p>
            </div>

        </div>
    </div>
</section>
<section class="service-section">
    <div class="container">
        <div class="row g-4">

            <div class="col-lg-6">
                <h2 class="service-title">Our Services & Pricing</h2>
                <p class="text-muted mb-4">
                    Click each category to see our services and pricing.
                </p>
                <div class="accordion" id="serviceAccordion">
                    <div class="accordion-item service-accordion-item">
                        <h2 class="accordion-header" id="headingOne">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="false" aria-controls="collapseOne">
                                Services Included
                            </button>
                        </h2>
                        <div id="collapseOne" class="accordion-collapse collapse" aria-labelledby="headingOne" data-bs-parent="#serviceAccordion">
                            <div class="accordion-body">
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item service-list-item">
                                        <strong>General Checkup</strong>
                                        <br>
                                        <small class="text-muted">Comprehensive health examination</small>
                                    </li>
                                    <li class="list-group-item service-list-item">
                                        <strong>Vaccination</strong>
                                        <br>
                                        <small class="text-muted">Core and non-core vaccinations</small>
                                    </li>
                                    <li class="list-group-item service-list-item">
                                        <strong>Spay/Neuter Surgery</strong>
                                        <br>
                                        <small class="text-muted">Spaying or neutering procedure</small>
                                    </li>
                                    <li class="list-group-item service-list-item">
                                        <strong>Dental Cleaning</strong>
                                        <br>
                                        <small class="text-muted">Professional dental cleaning</small>
                                    </li>
                                    <li class="list-group-item service-list-item">
                                        <strong>Basic Grooming</strong>
                                        <br>
                                        <small class="text-muted">Bath, brush, and nail trim</small>
                                    </li>
                                    <li class="list-group-item service-list-item">
                                        <strong>Emergency Consultation</strong>
                                        <br>
                                        <small class="text-muted">Urgent medical consultation</small>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item service-accordion-item">
                        <h2 class="accordion-header" id="headingTwo">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                Pricing
                            </button>
                        </h2>
                        <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#serviceAccordion">
                            <div class="accordion-body price-summary-list">
                                <p>
                                    <span>
                                        <strong>Basic Grooming</strong>
                                        <br>
                                        <small class="text-muted">Bath, brush, nail trim</small>
                                    </span>
                                    <span class="price-span">from 40.00 đ</span>
                                </p>
                                <p>
                                    <span>
                                        <strong>Medical Checkup</strong>
                                        <br>
                                        <small class="text-muted">General checkup & vaccination</small>
                                    </span>
                                    <span class="price-span">from 45.00 đ</span>
                                </p>
                                <p>
                                    <span>
                                        <strong>Surgery & Dental</strong>
                                        <br>
                                        <small class="text-muted">Cleaning, Spay/Neuter</small>
                                    </span>
                                    <span class="price-span">from 150.00 đ</span>
                                </p>
                                <p>
                                    <span>
                                        <strong>Emergency</strong>
                                        <br>
                                        <small class="text-muted">Urgent consultation</small>
                                    </span>
                                    <span class="price-span">from 100.00 đ</span>
                                </p>
                            </div>
                        </div>
                    </div>
                </div> <div class="mt-4">
                <a href="<%= request.getContextPath() %>/customer/appointments.jsp" class="btn btn-primary">
                    <i class="fas fa-calendar-check me-2"></i> Book Appointment Now
                </a>
            </div>
            </div> <div class="col-lg-6">
            <div class="row g-4">
                <div class="col-6">
                    <img src="<%= request.getContextPath() %>/images/petgrooming.jpg"
                         alt="Pet Grooming"
                         class="img-fluid service-column-image"
                         style="border: 1px solid #ddd; background: #eee;">
                </div>
                <div class="col-6">
                    <img src="<%= request.getContextPath() %>/images/petspa.jpg"
                         alt="Pet Spa"
                         class="img-fluid service-column-image"
                         style="border: 1px solid #ddd; background: #eee;">
                </div>
            </div>
        </div>
        </div>
    </div>
</section>
<section class="team-section">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <h2 class="section-title">Meet Our Staff</h2>
                <p class="team-description">
                    Our professional groomers is dedicated to providing the highest level of care. We treat every pet like our own.
                </p>
            </div>
        </div>
        <div class="row mt-4">
            <div class="col-12">
                <img src="<%= request.getContextPath() %>/images/staff.png"
                     alt="PetCare Team"
                     class="img-fluid team-image"
                     style="background: #eee;">
            </div>
        </div>
    </div>
</section>
<section class="why-choose-section">
    <div class="container">
        <div class="row">
            <div class="col-12 text-center">
                <h2 class="section-title">6 Reasons You Should Choose PetCare</h2>
            </div>
        </div>
        <div class="row g-4 mt-4">
            <div class="col-lg-4 col-md-6">
                <div class="why-choose-card">
                    <div class="icon-box icon-color-1"><i class="fas fa-leaf"></i></div>
                    <h5>Friendly Environment</h5>
                    <p>We create a quiet, clean, and friendly space, helping pets feel safe and relaxed.</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="why-choose-card">
                    <div class="icon-box icon-color-2"><i class="fas fa-box-archive"></i></div>
                    <h5>Comprehensive Services</h5>
                    <p>Full services from medical check-ups, grooming, designed for your pet.</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="why-choose-card">
                    <div class="icon-box icon-color-3"><i class="fas fa-headset"></i></div>
                    <h5>Fast Support</h5>
                    <p>Our team is always ready to support, handling any of your pet's issues gently and effectively.</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="why-choose-card">
                    <div class="icon-box icon-color-4"><i class="fas fa-users"></i></div>
                    <h5>Dedicated Staff</h5>
                    <p>Our friendly and professional staff are always ready to assist customers with care and enthusiasm.</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="why-choose-card">
                    <div class="icon-box icon-color-5"><i class="fas fa-microchip"></i></div>
                    <h5>Modern Facilities</h5>
                    <p>Equipped with modern tools, A/C, and cameras to ensure a safe and comfortable experience.</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="why-choose-card">
                    <div class="icon-box icon-color-6"><i class="fas fa-clock"></i></div>
                    <h5>Always Ready to Serve</h5>
                    <p>We operate 24/7. When you call, we will be there to care for your pet attentively.</p>
                </div>
            </div>
        </div>
    </div>
</section>
<section class="testimonial-section py-5">
    <div class="container">
        <h2 class="text-center mb-5 testimonial-section-title">
            Reviews
        </h2>

        <div id="testimonialCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="6000">
            <div class="carousel-inner">

                <div class="carousel-item active">
                    <div class="row justify-content-center">
                        <div class="col-md-10 col-lg-8">
                            <div class="testimonial-card p-4 text-center">
                                <img src="<%= request.getContextPath() %>/images/review1.png" alt="Phuong"
                                     class="rounded-circle mb-3" style="width:120px; height:120px; object-fit:cover;">
                                <p class="testimonial-text fst-italic mb-3">
                                    “The spa service here is wonderful. My poodle is always pampered, and her fur is so soft and smells amazing. Very satisfied with the service quality!”
                                </p>
                                <h5 class="fw-bold mb-0">Nguyen Thi Phuong</h5>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="carousel-item">
                    <div class="row justify-content-center">
                        <div class="col-md-10 col-lg-8">
                            <div class="testimonial-card p-4 text-center">
                                <img src="<%= request.getContextPath() %>/images/review2.png" alt="Thanh"
                                     class="rounded-circle mb-3" style="width:120px; height:120px; object-fit:cover;">
                                <p class="testimonial-text fst-italic mb-3">
                                    “The veterinarians here are very professional and dedicated. They clearly explained my cat's health condition and provided an effective treatment plan.”
                                </p>
                                <h5 class="fw-bold mb-0">Tran Quoc Thanh</h5>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="carousel-item">
                    <div class="row justify-content-center">
                        <div class="col-md-10 col-lg-8">
                            <div class="testimonial-card p-4 text-center">
                                <img src="<%= request.getContextPath() %>/images/review3.png" alt="Anh"
                                     class="rounded-circle mb-3" style="width:120px; height:120px; object-fit:cover;">
                                <p class="testimonial-text fst-italic mb-3">
                                    “The space at PetCare is so clean and airy. I feel completely at ease leaving my pet at their hotel when I'm away on business.”
                                </p>
                                <h5 class="fw-bold mb-0">Pham Hoang Anh</h5>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="carousel-item">
                    <div class="row justify-content-center">
                        <div class="col-md-10 col-lg-8">
                            <div class="testimonial-card p-4 text-center">
                                <img src="<%= request.getContextPath() %>/images/review4.png" alt="Duc"
                                     class="rounded-circle mb-3" style="width:120px; height:120px; object-fit:cover;">
                                <p class="testimonial-text fst-italic mb-3">
                                    “I really love the grooming service. The groomers are very skilled, styled my Corgi just as I wanted, and he looks so neat and adorable now.”
                                </p>
                                <h5 class="fw-bold mb-0">Vu Duc Minh</h5>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="carousel-item">
                    <div class="row justify-content-center">
                        <div class="col-md-10 col-lg-8">
                            <div class="testimonial-card p-4 text-center">
                                <img src="<%= request.getContextPath() %>/images/review5.png" alt="Huyen"
                                     class="rounded-circle mb-3" style="width:120px; height:120px; object-fit:cover;">
                                <p class="testimonial-text fst-italic mb-3">
                                    “The facilities are very modern. The waiting area, clinic rooms, and boarding rooms are all well-equipped, giving a very professional and safe feeling.”
                                </p>
                                <h5 class="fw-bold mb-0">Le Thanh Huyen</h5>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <button class="carousel-control-prev" type="button" data-bs-target="#testimonialCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#testimonialCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>
        </div>
    </div>
</section>
<%@ include file="inc/chatbox.jsp" %>
<%@ include file="inc/footer.jsp"%>
</body>
</html>
