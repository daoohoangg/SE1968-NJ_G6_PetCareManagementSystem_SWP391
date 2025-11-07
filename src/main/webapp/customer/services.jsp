<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.petcaresystem.enities.Service" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/inc/common-head.jspf" %>
    <title>Our Services</title>
    <style>
        .page-header { background-color: #f8f9fa; padding: 3rem 0; margin-bottom: 40px; }
        .service-card { margin-bottom: 24px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .service-card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(25,118,210,0.15); }
        .service-card .card-title { color: #1976d2; }
        .service-card .card-price { font-size: 1.75rem; font-weight: 700; color: #dc3545; }
        .modal-service-image {
            width: 100%;
            height: 250px;
            object-fit: cover;
            border-radius: 8px;
            background-color: #f0f0f0;
            border: 1px solid #eee;
        }
        .modal-service-price {
            font-size: 2.25rem;
            font-weight: 700;
            color: #dc3545;
        }
    </style>
</head>
<body>
<%@ include file="/inc/header.jsp" %>

<div class="page-header">
    <div class="container">
        <h1 class="display-5 fw-bold">Our Services</h1>
        <p class="fs-5 text-muted">Explore the variety of care options we offer for your beloved pets.</p>
    </div>
</div>

<div class="container my-5">
    <%
        Map<Integer, String> detailedDescriptions = (Map<Integer, String>) request.getAttribute("detailedDescriptions");
        Map<Integer, String> imageNames = (Map<Integer, String>) request.getAttribute("imageNames");
        String error = (String) request.getAttribute("error");
        if (error != null) { %>
    <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <div class="row">
        <%
            List<Service> serviceList = (List<Service>) request.getAttribute("serviceList");
            if (serviceList == null || serviceList.isEmpty()) {
        %>
        <div class="col-12">
            <p class="text-center fs-4 text-muted">No services are available at this time. Please check back later.</p>
        </div>
        <%
        } else {
            for (Service service : serviceList) {
                String modalId = "serviceDetailModal-" + service.getServiceId();
                String fullDescription = (detailedDescriptions != null && detailedDescriptions.containsKey(service.getServiceId()))
                        ? detailedDescriptions.get(service.getServiceId())
                        : service.getDescription();

                String serviceImageName = (imageNames != null && imageNames.containsKey(service.getServiceId()))
                        ? imageNames.get(service.getServiceId())
                        : "service-placeholder.jpg";
        %>
        <div class="col-lg-4 col-md-6">
            <div class="card service-card h-100">
                <div class="card-body d-flex flex-column">
                    <h5 class="card-title fw-bold"><%= service.getServiceName() %></h5>
                    <small class="text-muted mb-2">
                        Category: <strong><%= service.getCategory().getName() %></strong>
                    </small>
                    <p class="card-text"><%= service.getDescription() %></p>
                    <div class="mt-auto">
                        <p class="mb-2">
                            <i class="fas fa-clock me-2 text-muted"></i>
                            Duration: <%= service.getDurationMinutes() %> minutes
                        </p>
                        <p class="card-price mb-3">
                            <%= service.getPrice() %> đ
                        </p>
                        <button type="button" class="btn btn-primary w-100"
                                data-bs-toggle="modal"
                                data-bs-target="#<%= modalId %>">
                            <i class="fas fa-eye me-2"></i> Detail
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="<%= modalId %>" tabindex="-1" aria-labelledby="<%= modalId %>Label" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="<%= modalId %>Label"><%= service.getServiceName() %></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row g-4">
                            <div class="col-md-5">
                                <img src="<%= request.getContextPath() %>/images/<%= serviceImageName %>"
                                     alt="<%= service.getServiceName() %>"
                                     class="modal-service-image">
                            </div>
                            <div class="col-md-7">
                                <p class="fs-5 text-muted mb-2"><%= service.getCategory().getName() %></p>
                                <p class="modal-service-price mb-3"><%= service.getPrice() %> đ</p>
                                <p class="mb-2">
                                    <i class="fas fa-clock me-2 text-muted"></i>
                                    <strong>Duration:</strong> <%= service.getDurationMinutes() %> minutes
                                </p>
                                <hr>
                                <p class="text-muted"><%= fullDescription %></p>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <a href="<%= request.getContextPath() %>/customer/appointments?service_id=<%= service.getServiceId() %>"
                           class="btn btn-primary">
                            <i class="fas fa-calendar-check me-2"></i> Book Now
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <%
                }
            }
        %>
    </div>
</div>

<%@ include file="/inc/chatbox.jsp" %>
<%@ include file="/inc/footer.jsp" %>
</body>
</html>