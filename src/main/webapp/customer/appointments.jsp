<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.petcaresystem.enities.Appointment, com.petcaresystem.enities.Pet, com.petcaresystem.enities.Service" %>

<%
    String ctx = request.getContextPath();

    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    List<Pet> pets = (List<Pet>) request.getAttribute("pets");
    List<Service> services = (List<Service>) request.getAttribute("services");

    String error = (String) request.getAttribute("error");
    String created = request.getParameter("created");
    String cancelled = request.getParameter("cancelled");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Appointments - PetCare</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color:#f5f7fb; font-family: 'Segoe UI', sans-serif; }
        .page-container { max-width:1050px; margin:40px auto; }
        .card { border:none; border-radius:14px; box-shadow:0 6px 16px rgba(0,0,0,0.08); }
        .card-header { background-color:#e9f2ff; color:#0d6efd; font-weight:600; }
        .form-label { font-weight:600; }
        .required::after { content:"*"; color:#dc3545; margin-left:4px; }
        .btn-primary { background-color:#0d6efd; border-color:#0d6efd; font-weight:600; }
        .btn-primary:hover { background-color:#0b5ed7; }
    </style>
</head>
<body>

<jsp:include page="/inc/header.jsp"/>

<div class="page-container">

    <!-- Alerts -->
    <% if ("1".equals(created)) { %>
    <div class="alert alert-success"><i class="bi bi-check-circle-fill me-2"></i>Lịch hẹn đã được tạo thành công.</div>
    <% } else if ("1".equals(cancelled)) { %>
    <div class="alert alert-info"><i class="bi bi-info-circle-fill me-2"></i>Bạn đã huỷ lịch hẹn.</div>
    <% } else if (error != null) { %>
    <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i><%= error %></div>
    <% } %>

    <!-- Form Đặt lịch -->
    <div class="card mb-4">
        <div class="card-header"><i class="bi bi-calendar-plus-fill me-2"></i>ĐẶT LỊCH HẸN MỚI</div>
        <div class="card-body">
            <form method="post" action="<%= ctx %>/customer/appointments">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label required">Thú cưng</label>
                        <select name="petId" class="form-select" required>
                            <option value="" hidden>Chọn thú cưng</option>
                            <%
                                if (pets != null) {
                                    for (Pet p : pets) {
                            %>
                            <option value="<%= p.getPetId() %>"><%= p.getName() %> - <%= p.getBreed() %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label required">Dịch vụ</label>
                        <select name="serviceIds" class="form-select" multiple required>
                            <%
                                if (services != null) {
                                    for (Service s : services) {
                            %>
                            <option value="<%= s.getServiceId() %>"><%= s.getServiceName() %> (<%= s.getPrice() %>$)</option>
                            <%
                                    }
                                }
                            %>
                        </select>
                        <div class="form-text">Giữ Ctrl/⌘ để chọn nhiều dịch vụ</div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label required">Ngày & giờ bắt đầu</label>
                        <input type="datetime-local" name="startAt" class="form-control" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Kết thúc (tuỳ chọn)</label>
                        <input type="datetime-local" name="endAt" class="form-control">
                    </div>

                    <div class="col-12">
                        <label class="form-label">Ghi chú</label>
                        <textarea name="notes" rows="3" class="form-control"
                                  placeholder="Ví dụ: dị ứng sữa tắm, muốn cắt móng ngắn..."></textarea>
                    </div>
                </div>

                <div class="mt-4 d-flex justify-content-between align-items-center">
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="bi bi-send-fill me-2"></i>Gửi yêu cầu
                    </button>
                    <a href="<%= ctx %>/home" class="text-secondary text-decoration-none">
                        <i class="bi bi-arrow-left"></i> Quay về trang chủ
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Danh sách lịch hẹn -->
    <div class="card">
        <div class="card-header"><i class="bi bi-list-check me-2"></i>LỊCH HẸN CỦA TÔI</div>
        <div class="card-body">
            <%
                if (appointments == null || appointments.isEmpty()) {
            %>
            <p class="text-muted mb-0">Hiện chưa có lịch hẹn nào được tạo.</p>
            <%
            } else {
            %>
            <div class="table-responsive">
                <table class="table align-middle table-hover">
                    <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>Thú cưng</th>
                        <th>Bắt đầu</th>
                        <th>Kết thúc</th>
                        <th>Trạng thái</th>
                        <th class="text-end">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        for (int i = 0; i < appointments.size(); i++) {
                            Appointment a = appointments.get(i);
                            String status = a.getStatus().name();
                    %>
                    <tr>
                        <td><%= i + 1 %></td>
                        <td><%= a.getPet().getName() %></td>
                        <td><%= a.getAppointmentDate() %></td>
                        <td><%= (a.getEndDate() != null ? a.getEndDate() : "—") %></td>
                        <td>
                            <% if ("CONFIRMED".equals(status)) { %>
                            <span class="badge bg-primary">CONFIRMED</span>
                            <% } else if ("COMPLETED".equals(status)) { %>
                            <span class="badge bg-success">COMPLETED</span>
                            <% } else if ("CANCELLED".equals(status)) { %>
                            <span class="badge bg-secondary">CANCELLED</span>
                            <% } else { %>
                            <span class="badge bg-warning text-dark"><%= status %></span>
                            <% } %>
                        </td>
                        <td class="text-end">
                            <% if (!"CANCELLED".equals(status) && !"COMPLETED".equals(status)) { %>
                            <a href="<%= ctx %>/customer/appointments?action=cancel&id=<%= a.getAppointmentId() %>"
                               class="btn btn-outline-danger btn-sm">
                                <i class="bi bi-x-circle"></i> Huỷ
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
            <%
                } // end else
            %>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
