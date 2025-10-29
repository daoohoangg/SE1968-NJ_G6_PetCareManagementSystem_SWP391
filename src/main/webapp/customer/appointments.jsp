<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="java.util.*, java.math.BigDecimal, java.time.format.DateTimeFormatter" %>
<%@ page import="com.petcaresystem.enities.*" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    // ===== View-only prep (no DAO here) =====
    String ctx = request.getContextPath();

    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    if (appointments == null) appointments = Collections.emptyList();

    List<Pet> pets = (List<Pet>) request.getAttribute("pets");
    if (pets == null) pets = Collections.emptyList();

    List<Service> services = (List<Service>) request.getAttribute("services");
    if (services == null) services = Collections.emptyList();

    // Sort by Category.name then serviceName (null-safe)
    List<Service> sortedServices = new ArrayList<>(services);
    Collections.sort(sortedServices, new Comparator<Service>() {
        @Override public int compare(Service a, Service b) {
            String ca = (a!=null && a.getCategory()!=null && a.getCategory().getName()!=null) ? a.getCategory().getName() : "";
            String cb = (b!=null && b.getCategory()!=null && b.getCategory().getName()!=null) ? b.getCategory().getName() : "";
            int c = ca.compareToIgnoreCase(cb);
            if (c != 0) return c;
            String sa = (a!=null && a.getServiceName()!=null) ? a.getServiceName() : "";
            String sb = (b!=null && b.getServiceName()!=null) ? b.getServiceName() : "";
            return sa.compareToIgnoreCase(sb);
        }
    });

    String error     = (String) request.getAttribute("error");

    // Date formatter (LocalDateTime → String)
    DateTimeFormatter df = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/inc/common-head.jspf" %>

    <meta charset="UTF-8">
    <title>Appointments - PetCare</title>

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>

    <!-- Choices.js -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css"/>

    <style>
        body { background-color:#f5f7fb; font-family:'Inter','Segoe UI',system-ui,-apple-system,Roboto,Arial,sans-serif; }
        .page-container { max-width:1050px; margin:40px auto; }
        .card { border:none; border-radius:14px; box-shadow:0 6px 16px rgba(0,0,0,.08); }
        .card-header { background:#e9f2ff; color:#0d6efd; font-weight:600; border-top-left-radius:14px; border-top-right-radius:14px; }
        .form-label { font-weight:600; }
        .required::after { content:"*"; color:#dc3545; margin-left:4px; }
        .btn-primary { background-color:#0d6efd; border-color:#0d6efd; font-weight:600; }
        .btn-primary:hover { background-color:#0b5ed7; }
        .badge { letter-spacing:.3px; }
        .choices__list--multiple .choices__item { background-color:#0d6efd; border-color:#0d6efd; }
        .table thead th { white-space:nowrap; }
    </style>
</head>

<body>
<jsp:include page="/inc/header.jsp"/>

<div class="page-container">

    <!-- Alerts -->
    <c:choose>
        <c:when test="${param.created == '1'}">
            <div class="alert alert-success"><i class="bi bi-check-circle-fill me-2"></i>Appointment has been created successfully.</div>
        </c:when>
        <c:when test="${param.cancelled == '1'}">
            <div class="alert alert-info"><i class="bi bi-info-circle-fill me-2"></i>You have cancelled the appointment.</div>
        </c:when>
        <c:when test="${not empty error}">
            <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i><c:out value="${error}"/></div>
        </c:when>
    </c:choose>

    <!-- Create Appointment -->
    <div class="card mb-4">
        <div class="card-header">
            <i class="bi bi-calendar-plus-fill me-2"></i>Create New Appointment
        </div>
        <div class="card-body">
            <form method="post" action="<c:url value='/customer/appointments'/>">
                <div class="row g-3">

                    <!-- PET -->
                    <div class="col-md-6">
                        <label class="form-label required">Pet</label>
                        <c:choose>
                            <c:when test="${empty pets}">
                                <select class="form-select" disabled>
                                    <option>(You have no pets yet — please add one first)</option>
                                </select>
                            </c:when>
                            <c:otherwise>
                                <select id="petId" name="petId" class="form-select" required>
                                    <option value="" hidden>Select a pet</option>
                                    <c:forEach var="p" items="<%= pets %>">
                                        <c:if test="${p != null}">
                                            <option value="${p.idpet}">
                                                <c:out value="${p.name}"/>
                                                <c:if test="${not empty p.breed}"> - <c:out value="${p.breed}"/></c:if>
                                            </option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- SERVICES -->
                    <div class="col-md-6">
                        <label class="form-label required">Services</label>
                        <select id="serviceIds" name="serviceIds" class="form-select" multiple required>
                                <%
                                String currentCat = null;
                                for (int i = 0; i < sortedServices.size(); i++) {
                                    Service s = sortedServices.get(i);
                                    if (s == null) continue;

                                    String catName = (s.getCategory()!=null && s.getCategory().getName()!=null)
                                            ? s.getCategory().getName() : "Others";

                                    if (currentCat == null || !currentCat.equals(catName)) {
                                        if (currentCat != null) { %></optgroup><% }
                            currentCat = catName;
                        %>
                            <optgroup label="<%= currentCat %>">
                                <%
                                    }
                                    BigDecimal price = s.getPrice();
                                    String priceStr = (price != null) ? price.toPlainString() : "0";
                                %>
                                <option value="<%= s.getServiceId() %>" data-price="<%= priceStr %>">
                                    <%= s.getServiceName() %> (<%= priceStr %> ₫)
                                </option>
                                <%
                                    if (i == sortedServices.size() - 1) { %></optgroup><% }
                        } // end for
                            if (sortedServices.isEmpty()) {
                        %>
                            <option disabled>(No available services)</option>
                            <%
                                }
                            %>
                        </select>
                        <small id="totalPriceText" class="text-muted d-block mt-1">
                            Total services: 0 ₫
                        </small>
                    </div>

                    <!-- TIME -->
                    <div class="col-md-6">
                        <label class="form-label required">Start date & time</label>
                        <input type="datetime-local" name="startAt" class="form-control" required>
                    </div>

                    <!-- NOTES -->
                    <div class="col-12">
                        <label class="form-label">Notes</label>
                        <textarea name="notes" rows="3" class="form-control"
                                  placeholder="E.g., shampoo allergy, trim nails short..."></textarea>
                    </div>
                </div>

                <div class="mt-4 d-flex justify-content-between align-items-center">
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="bi bi-send-fill me-2"></i>Submit request
                    </button>
                    <a href="<c:url value='/home.jsp'/>" class="text-secondary text-decoration-none">
                        <i class="bi bi-arrow-left"></i> Back to Home
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- My Appointments -->
    <div class="card">
        <div class="card-header">
            <i class="bi bi-list-check me-2"></i>My Appointments
        </div>
        <div class="card-body">
            <%
                List<Appointment> apps = appointments;
                if (apps == null) apps = Collections.emptyList();
            %>
            <c:choose>
                <c:when test="<%= apps.isEmpty() %>">
                    <p class="text-muted mb-0">No appointments have been created yet.</p>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table align-middle table-hover">
                            <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Pet</th>
                                <th>Services</th>
                                <th>Start</th>
                                <th>End</th>
                                <th class="text-end">Total</th>
                                <th>Status</th>
                                <th class="text-end">Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                for (int i = 0; i < apps.size(); i++) {
                                    Appointment a = apps.get(i);

                                    String petName = (a!=null && a.getPet()!=null && a.getPet().getName()!=null)
                                            ? a.getPet().getName() : "(N/A)";

                                    StringBuilder svNames = new StringBuilder();
                                    List<Service> svs = (a!=null) ? a.getServices() : null;
                                    if (svs != null) {
                                        for (Service sv : svs) {
                                            if (sv!=null && sv.getServiceName()!=null) {
                                                if (svNames.length() > 0) svNames.append(", ");
                                                svNames.append(sv.getServiceName());
                                            }
                                        }
                                    }

                                    String startText = (a!=null && a.getAppointmentDate()!=null)
                                            ? a.getAppointmentDate().format(df) : "";
                                    String endText = (a!=null && a.getEndDate()!=null)
                                            ? a.getEndDate().format(df) : "—";

                                    String totalText = (a!=null && a.getTotalAmount()!=null)
                                            ? a.getTotalAmount().toPlainString() + " ₫" : "0 ₫";

                                    String status = (a!=null && a.getStatus()!=null) ? a.getStatus().name() : "PENDING";
                            %>
                            <tr>
                                <td><%= i + 1 %></td>
                                <td><%= petName %></td>
                                <td><%= (svNames.length() > 0) ? svNames.toString() : "—" %></td>
                                <td><%= startText %></td>
                                <td><%= endText %></td>
                                <td class="text-end"><%= totalText %></td>
                                <td>
                                    <% if ("CONFIRMED".equals(status)) { %>
                                    <span class="badge bg-primary">CONFIRMED</span>
                                    <% } else if ("COMPLETED".equals(status)) { %>
                                    <span class="badge bg-success">COMPLETED</span>
                                    <% } else if ("CANCELLED".equals(status)) { %>
                                    <span class="badge bg-secondary">CANCELLED</span>
                                    <% } else if ("IN_PROGRESS".equals(status)) { %>
                                    <span class="badge bg-info text-dark">IN&nbsp;PROGRESS</span>
                                    <% } else if ("NO_SHOW".equals(status)) { %>
                                    <span class="badge bg-dark">NO SHOW</span>
                                    <% } else { %>
                                    <span class="badge bg-warning text-dark"><%= status %></span>
                                    <% } %>
                                </td>
                                <td class="text-end">
                                    <% if (!"CANCELLED".equals(status) && !"COMPLETED".equals(status)) { %>
                                    <a href="<c:url value='/customer/appointments'>
                                                   <c:param name='action' value='cancel'/>
                                                   <c:param name='id' value='<%= String.valueOf(a.getAppointmentId()) %>'/>
                                                 </c:url>"
                                       class="btn btn-outline-danger btn-sm">
                                        <i class="bi bi-x-circle"></i> Cancel
                                    </a>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                } // end for
                            %>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- JS libs -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>

<!-- Init multi-select + total from data-price -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const el = document.getElementById('serviceIds');
        if (el) {
            new Choices(el, {
                removeItemButton: true,
                searchEnabled: true,
                shouldSort: false,
                placeholder: true,
                placeholderValue: 'Select services...',
                noResultsText: 'No services found',
                itemSelectText: ''
            });
        }

        const totalText = document.getElementById('totalPriceText');
        if (!el || !totalText) return;

        function numberWithDots(x) {
            const parts = (x || 0).toFixed(0).toString().split('.');
            parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, '.');
            return parts.join('.');
        }

        function updateTotal() {
            let total = 0;
            Array.from(el.selectedOptions).forEach(opt => {
                const price = parseFloat(opt.dataset.price || '0');
                if (!isNaN(price)) total += price;
            });
            totalText.textContent = "Total services: " + numberWithDots(total) + " ₫";
        }

        el.addEventListener('change', updateTotal);
    });
</script>
</body>
</html>
