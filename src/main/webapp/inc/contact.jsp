<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/inc/common-head.jspf" %>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - PetCare</title>
    <style>
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
        .breadcrumb-container .breadcrumb-item.active {
            color: #6c757d;
        }
        .contact-page-section {
            padding: 60px 0;
            background-color: #f8f9fa;
        }
        .contact-form-info-card {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            border: none;
            overflow: hidden;
            height: 100%;
        }
        .contact-info-block {
            padding: 2.5rem;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .contact-info-block h3 {
            font-weight: 700;
            color: #333;
            margin-bottom: 25px;
        }
        .contact-info-block p {
            display: flex;
            align-items: flex-start;
            margin-bottom: 20px;
            color: #555;
            line-height: 1.7;
        }
        .contact-info-block i {
            font-size: 1.2rem;
            color: #0d6efd;
            width: 35px;
            margin-top: 5px;
        }
        .map-section iframe {
            width: 100%;
            height: 400px;
            border: 0;
            display: block;
        }
        .contact-form-block {
            padding: 2.5rem;
            height: 100%;
        }
        .contact-form-block h3 {
            font-weight: 700;
            color: #333;
            margin-bottom: 25px;
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
                    Contact Us
                </li>
            </ol>
        </nav>
    </div>
</div>
<main class="contact-page-section">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card contact-form-info-card">
                    <div class="row g-0">
                        <div class="col-lg-6 border-end">
                        <div class="contact-info-block">
                        <h3>Contact Information</h3>
                        <p>
                            <i class="fas fa-map-marker-alt"></i>
                            <span>
                                    <strong>Address:</strong><br>
                                    FPT University, Hoa Lac Hi-Tech Park, Km29, Thang Long Avenue, Thach That, Hanoi.
                                </span>
                        </p>
                        <p>
                            <i class="fas fa-phone"></i>
                            <span>
                                    <strong>Phone:</strong><br>
                                    0914.430.472
                                </span>
                        </p>
                        <p>
                            <i class="fas fa-envelope"></i>
                            <span>
                                    <strong>Email:</strong><br>
                                    hahshe186536@fpt.edu.vn
                                </span>
                        </p>
                        <p>
                            <i class="fas fa-clock"></i>
                            <span>
                                    <strong>Opening Hours:</strong><br>
                                    8:00 AM - 8:00 PM (All Days)
                                </span>
                        </p>
                    </div>
                    </div>
                        <div class="col-lg-6">
                            <div class="contact-form-block">
                                <h3>Send Us a Message</h3>
                                <p class="text-muted mb-4">
                                    Have questions? Fill out the form and we will get back to you shortly.
                                </p>
                                <% String message = (String) request.getAttribute("message"); %>
                                <% if (message != null && !message.isEmpty()) { %>
                                <div class="alert alert-info" role="alert">
                                    <%= message %>
                                </div>
                                <% } %>
                                <form action="<%= request.getContextPath() %>/contact" method="POST">
                                    <div class="mb-3">
                                        <label for="contactName" class="form-label">Full Name</label>
                                        <input type="text" class="form-control" id="contactName" name="name" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="contactEmail" class="form-label">Email</label>
                                        <input type="email" class="form-control" id="contactEmail" name="email" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="contactSubject" class="form-label">Subject</label>
                                        <input type="text" class="form-control" id="contactSubject" name="subject" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="contactMessage" class="form-label">Message</label>
                                        <textarea class="form-control" id="contactMessage" name="message" rows="5" required></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-primary btn-lg w-100">Send Message</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="map-section mt-4">
                        <iframe src="https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d6263.728864103876!2d105.52635412656335!3d21.015255038767684!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3135abc60e7d3f19%3A0x2be9d7d0b5abcbf4!2zVHLGsOG7nW5nIMSQ4bqhaSBo4buNYyBGUFQgSMOgIE7hu5lp!5e0!3m2!1svi!2s!4v1760922409624!5m2!1svi!2s" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<jsp:include page="chatbox.jsp" />
<jsp:include page="footer.jsp" />
</body>
</html>
