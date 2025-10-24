<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.math.BigDecimal" %>
<%@ page import="com.petcaresystem.enities.*" %>
<%@ page import="com.petcaresystem.dao.ServiceDAO, com.petcaresystem.dao.PetDAO" %>



<%
    // ===== Context =====
    String ctx = request.getContextPath();

    // ===== Nhận data có thể đã được set bởi servlet =====
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    List<Pet> pets = (List<Pet>) request.getAttribute("pets");
    List<Service> services = (List<Service>) request.getAttribute("services");


    if (services == null || services.isEmpty()) {
        try {
            ServiceDAO sdao = new ServiceDAO();
            services = sdao.getActiveServices();
            request.setAttribute("services", services);
        } catch (Exception ignore) {
            services = Collections.emptyList();
        }
    }
    if (pets == null || pets.isEmpty()) {
        com.petcaresystem.enities.Account acc =
                (com.petcaresystem.enities.Account) session.getAttribute("account");
        if (acc != null) {
            com.petcaresystem.dao.PetDAO pdao = new com.petcaresystem.dao.PetDAO();
            pets = pdao.findByCustomerId(acc.getAccountId());
            request.setAttribute("pets", pets);
        } else {
            pets = java.util.Collections.emptyList();
        }
    }
    if (appointments == null) appointments = Collections.emptyList();

    if (appointments == null) appointments = Collections.emptyList();

    String error = (String) request.getAttribute("error");
    String created = request.getParameter("created");
    String cancelled = request.getParameter("cancelled");

    // ===== Sort services theo category.name rồi serviceName (null-safe) =====
    List<Service> sortedServices = new ArrayList<>(services);
    Collections.sort(sortedServices, new Comparator<Service>() {
        @Override
        public int compare(Service a, Service b) {
            String ca = (a != null && a.getCategory() != null && a.getCategory().getName() != null)
                    ? a.getCategory().getName() : "";
            String cb = (b != null && b.getCategory() != null && b.getCategory().getName() != null)
                    ? b.getCategory().getName() : "";
            int c = ca.compareToIgnoreCase(cb);
            if (c != 0) return c;
            String sa = (a != null && a.getServiceName() != null) ? a.getServiceName() : "";
            String sb = (b != null && b.getServiceName() != null) ? b.getServiceName() : "";
            return sa.compareToIgnoreCase(sb);
        }
    });
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Appointments - PetCare</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f7fb;
            font-family: 'Segoe UI', sans-serif;
        }

        .page-container {
            max-width: 1050px;
            margin: 40px auto;
        }

        .card {
            border: none;
            border-radius: 14px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
        }

        .card-header {
            background-color: #e9f2ff;
            color: #0d6efd;
            font-weight: 600;
        }

        .form-label {
            font-weight: 600;
        }

        .required::after {
            content: "*";
            color: #dc3545;
            margin-left: 4px;
        }

        .btn-primary {
            background-color: #0d6efd;
            border-color: #0d6efd;
            font-weight: 600;
        }

        .btn-primary:hover {
            background-color: #0b5ed7;
        }

        .badge {
            letter-spacing: .3px;
        }
    </style>
</head>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css">
<script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const el = document.getElementById('serviceIds');
        if (el) {
            new Choices(el, {
                removeItemButton: true,
                searchEnabled: true,
                shouldSort: false,
                placeholder: true,
                placeholderValue: 'Chọn dịch vụ...',
                noResultsText: 'Không tìm thấy dịch vụ',
                itemSelectText: ''
            });
        }
    });
</script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const el = document.getElementById('serviceIds');
        const totalText = document.getElementById('totalPriceText');
        if (!el || !totalText) return;

        const servicePrices = {};
        el.querySelectorAll('option').forEach(opt => {
            const text = opt.textContent || "";
            const match = text.match(/\(([\d.]+)\s*đ\)/);
            if (match) {

                const price = parseFloat(match[1]);
                servicePrices[opt.value] = price;
            }
        });

        function updateTotal() {
            let total = 0;
            Array.from(el.selectedOptions).forEach(opt => {
                if (servicePrices[opt.value]) total += servicePrices[opt.value];
            });

            totalText.textContent = "Tổng tiền dịch vụ: " + total.toFixed(2) + " đ";
        }

        el.addEventListener('change', updateTotal);
    });
</script>



<body>

<jsp:include page="/inc/header.jsp"/>

<div class="page-container">

    <!-- Alerts -->
    <%
        if ("1".equals(created)) {
    %>
    <div class="alert alert-success"><i class="bi bi-check-circle-fill me-2"></i>Lịch hẹn đã được tạo thành công.</div>
    <%
    } else if ("1".equals(cancelled)) {
    %>
    <div class="alert alert-info"><i class="bi bi-info-circle-fill me-2"></i>Bạn đã huỷ lịch hẹn.</div>
    <%
    } else if (error != null) {
    %>
    <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i><%= error %>
    </div>
    <%
        }
    %>

    <!-- Form Đặt lịch -->
    <div class="card mb-4">
        <div class="card-header"><i class="bi bi-calendar-plus-fill me-2"></i>ĐẶT LỊCH HẸN MỚI</div>
        <div class="card-body">
            <form method="post" action="<%= ctx %>/customer/appointments">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label required">Thú cưng</label>

                        <%
                            if (pets == null || pets.isEmpty()) {
                                try {
                                    com.petcaresystem.enities.Account acc =
                                            (com.petcaresystem.enities.Account) session.getAttribute("account");
                                    if (acc != null) {
                                        com.petcaresystem.dao.PetDAO pdao = new com.petcaresystem.dao.PetDAO();
                                        pets = pdao.findByCustomerId(acc.getAccountId());
                                        request.setAttribute("pets", pets);
                                    } else {
                                        pets = java.util.Collections.emptyList();
                                    }
                                } catch (Exception e) {
                                    pets = java.util.Collections.emptyList();
                                }
                            }
                        %>

                        <% if (pets == null || pets.isEmpty()) { %>
                        <select class="form-select" disabled>
                            <option>(Bạn chưa có thú cưng nào – vui lòng thêm trước)</option>
                        </select>
                        <% } else { %>
                        <select id="petId" name="petId" class="form-select" required>
                            <option value="" hidden>Chọn thú cưng</option>
                            <% for (com.petcaresystem.enities.Pet p : pets) {
                                if (p == null) continue; %>
                            <option value="<%= p.getIdpet() %>">
                                <%= p.getName() %><%= (p.getBreed()!=null && !p.getBreed().isEmpty()) ? " - "+p.getBreed() : "" %>
                            </option>
                            <% } %>
                        </select>
                        <% } %>
                    </div>


                    <!-- SERVICES -->
                    <div class="col-md-6">
                        <label class="form-label required">Dịch vụ</label>
                        <select id="serviceIds" name="serviceIds" class="form-select" multiple required>
                            <%
                                if (sortedServices.isEmpty()) {
                            %>
                            <option disabled>(Chưa có dịch vụ khả dụng)</option>
                                <%
            } else {
                String currentCat = null;
                for (int i = 0; i < sortedServices.size(); i++) {
                    Service s = sortedServices.get(i);
                    if (s == null) continue;

                    String catName = (s.getCategory()!=null && s.getCategory().getName()!=null)
                            ? s.getCategory().getName() : "Khác";

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
                                <option value="<%= s.getServiceId() %>">
                                    <%= s.getServiceName() %> (<%= priceStr %> đ)
                                </option>
                                <%
                                    if (i == sortedServices.size() - 1) { %></optgroup>
                            <%          }
                            } // end for
                            } // end else
                            %>
                        </select>
                        <small id="totalPriceText" class="text-muted d-block mt-1">
                            Tổng tiền dịch vụ: 0 đ
                        </small>
                    </div>


                    <!-- TIME -->
                    <div class="col-md-6">
                        <label class="form-label required">Ngày & giờ bắt đầu</label>
                        <input type="datetime-local" name="startAt" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Kết thúc (tuỳ chọn)</label>
                        <input type="datetime-local" name="endAt" class="form-control">
                    </div>

                    <!-- NOTES -->
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
                if (appointments.isEmpty()) {
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
                            if (a == null) continue;
                            String status = (a.getStatus() != null) ? a.getStatus().name() : "PENDING";
                    %>
                    <tr>
                        <td><%= i + 1 %>
                        </td>
                        <td><%= a.getPet() != null ? a.getPet().getName() : "(N/A)" %>
                        </td>
                        <td><%= a.getAppointmentDate() != null ? a.getAppointmentDate() : "" %>
                        </td>
                        <td><%= a.getEndDate() != null ? a.getEndDate() : "—" %>
                        </td>
                        <td>
                            <%
                                if ("CONFIRMED".equals(status)) {
                            %><span class="badge bg-primary">CONFIRMED</span><%
                        } else if ("COMPLETED".equals(status)) {
                        %><span class="badge bg-success">COMPLETED</span><%
                        } else if ("CANCELLED".equals(status)) {
                        %><span class="badge bg-secondary">CANCELLED</span><%
                        } else {
                        %><span class="badge bg-warning text-dark"><%= status %></span><%
                            }
                        %>
                        </td>
                        <td class="text-end">
                            <%
                                if (!"CANCELLED".equals(status) && !"COMPLETED".equals(status)) {
                            %>
                            <a href="<%= ctx %>/customer/appointments?action=cancel&id=<%= a.getAppointmentId() %>"
                               class="btn btn-outline-danger btn-sm">
                                <i class="bi bi-x-circle"></i> Huỷ
                            </a>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                    <%
                        } // for
                    %>
                    </tbody>
                </table>
            </div>
            <%
                } // else
            %>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
