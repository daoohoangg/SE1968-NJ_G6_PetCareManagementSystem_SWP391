<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.math.BigDecimal" %>
<%@ page import="com.petcaresystem.enities.*" %>
<%@ page import="com.petcaresystem.dao.PetDAO, com.petcaresystem.dao.ServiceDAO, com.petcaresystem.dao.AppointmentDAO" %>

<%
    String ctx = request.getContextPath();
    Account acc = (Account) session.getAttribute("account");

    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    List<Pet>         pets         = (List<Pet>)         request.getAttribute("pets");
    List<Service>     services     = (List<Service>)     request.getAttribute("services");

    if (services == null) {
        try {
            services = new ServiceDAO().getActiveServices();
            request.setAttribute("services", services);
        } catch (Exception e) { services = Collections.emptyList(); }
    }
    if (pets == null) {
        try {
            pets = (acc != null) ? new PetDAO().findByCustomerId(acc.getAccountId())
                    : Collections.emptyList();
            request.setAttribute("pets", pets);
        } catch (Exception e) { pets = Collections.emptyList(); }
    }
    if (appointments == null) {
        try {
            appointments = (acc != null) ? new AppointmentDAO().findByCustomer(acc.getAccountId())
                    : Collections.emptyList();
            request.setAttribute("appointments", appointments);
        } catch (Exception e) { appointments = Collections.emptyList(); }
    }

    String error     = (String) request.getAttribute("error");
    String created   = request.getParameter("created");
    String cancelled = request.getParameter("cancelled");

    List<Service> sortedServices = new ArrayList<>(services == null ? Collections.<Service>emptyList() : services);
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
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Appointments - PetCare</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css">
    <style>
        body { background-color:#f5f7fb; font-family:'Segoe UI',sans-serif; }
        .page-container { max-width:1050px; margin:40px auto; }
        .card { border:none; border-radius:14px; box-shadow:0 6px 16px rgba(0,0,0,.08); }
        .card-header { background:#e9f2ff; color:#0d6efd; font-weight:600; }
        .form-label { font-weight:600; }
        .required::after { content:"*"; color:#dc3545; margin-left:4px; }
        .btn-primary { font-weight:600; }
        .badge { letter-spacing:.3px; }
        body.modal-open .page-container { filter: blur(3px); transition: filter .2s ease; }
    </style>
</head>

<body>
<jsp:include page="/inc/header.jsp"/>

<div class="page-container">

    <%
        if ("1".equals(created)) {
    %>
    <div class="alert alert-success"><i class="bi bi-check-circle-fill me-2"></i>Appointment was created successfully.</div>
    <%
    } else if ("1".equals(cancelled)) {
    %>
    <div class="alert alert-info"><i class="bi bi-info-circle-fill me-2"></i>You cancelled the appointment.</div>
    <%
    } else if (error != null) {
    %>
    <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i><%= error %></div>
    <%
        }
        java.time.format.DateTimeFormatter df =
                java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        List<Appointment> apps = (appointments == null) ? Collections.emptyList() : appointments;
    %>

    <div class="card mb-4">
        <div class="card-header"><i class="bi bi-calendar-plus-fill me-2"></i>BOOK A NEW APPOINTMENT</div>
        <div class="card-body">
            <form method="post" action="<%= ctx %>/customer/appointments">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label required">Pet</label>
                        <% if (pets == null || pets.isEmpty()) { %>
                        <select class="form-select" disabled>
                            <option>(You don’t have any pets yet – please add one first)</option>
                        </select>
                        <% } else { %>
                        <select id="petId" name="petId" class="form-select" required>
                            <option value="" hidden>Select a pet</option>
                            <% for (Pet p : pets) { if (p == null) continue; %>
                            <option value="<%= p.getIdpet() %>">
                                <%= p.getName() %><%= (p.getBreed()!=null && !p.getBreed().isEmpty()) ? " - " + p.getBreed() : "" %>
                            </option>
                            <% } %>
                        </select>
                        <% } %>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label required">Services</label>
                        <select id="serviceIds" name="serviceIds" class="form-select" multiple required>
                            <%
                                if (sortedServices.isEmpty()) {
                            %>
                            <option disabled>(No available services)</option>
                                <%
                                } else {
                                    String currentCat = null;
                                    for (int i = 0; i < sortedServices.size(); i++) {
                                        Service s = sortedServices.get(i);
                                        if (s == null) continue;

                                        String catName = (s.getCategory()!=null && s.getCategory().getName()!=null)
                                                ? s.getCategory().getName() : "Other";

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
                                <option value="<%= s.getServiceId() %>"><%= s.getServiceName() %> (<%= priceStr %> đ)</option>
                                <%
                                    if (i == sortedServices.size() - 1) { %></optgroup><% }
                        }
                        }
                        %>
                        </select>
                        <small id="totalPriceText" class="text-muted d-block mt-1">Services total: 0 đ</small>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label required">Start date & time</label>
                        <input type="datetime-local" name="startAt" class="form-control" required>
                    </div>

                    <div class="col-12">
                        <label class="form-label">Notes</label>
                        <textarea name="notes" rows="3" class="form-control"
                                  placeholder="E.g., allergic to shampoo, prefer short nail trim..."></textarea>
                    </div>
                </div>

                <div class="mt-4 d-flex justify-content-between align-items-center">
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="bi bi-send-fill me-2"></i>Submit request
                    </button>
                    <a href="<%= ctx %>/home.jsp" class="text-secondary text-decoration-none">
                        <i class="bi bi-arrow-left"></i> Back to home
                    </a>
                </div>
            </form>
        </div>
    </div>

    <div class="card">
        <div class="card-header"><i class="bi bi-list-check me-2"></i>MY APPOINTMENTS</div>
        <div class="card-body">
            <% if (apps.isEmpty()) { %>
            <p class="text-muted mb-0">No appointments have been created yet.</p>
            <% } else { %>
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
                        <th class="text-end">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        for (int i = 0; i < apps.size(); i++) {
                            Appointment a = apps.get(i);
                            if (a == null) continue;

                            String petName = (a.getPet()!=null && a.getPet().getName()!=null)
                                    ? a.getPet().getName() : "(N/A)";

                            StringBuilder svNames = new StringBuilder();
                            List<Service> svs = a.getServices();
                            if (svs != null) {
                                for (Service sv : svs) {
                                    if (sv != null && sv.getServiceName()!=null) {
                                        if (svNames.length() > 0) svNames.append(", ");
                                        svNames.append(sv.getServiceName());
                                    }
                                }
                            }

                            String startTxt = (a.getAppointmentDate()!=null) ? a.getAppointmentDate().format(df) : "";
                            String endTxt   = (a.getEndDate()!=null)       ? a.getEndDate().format(df)       : "—";
                            String totalTxt = (a.getTotalAmount()!=null)   ? a.getTotalAmount().toPlainString() + " đ" : "0 đ";
                            String status   = (a.getStatus()!=null)        ? a.getStatus().name() : "PENDING";

                            boolean canPay =
                                    !"CANCELLED".equals(status) &&
                                            !"COMPLETED".equals(status) &&
                                            a.getTotalAmount() != null &&
                                            a.getTotalAmount().longValue() > 0L;
                    %>
                    <tr>
                        <td><%= i + 1 %></td>
                        <td><%= petName %></td>
                        <td><%= svNames.length()>0 ? svNames.toString() : "—" %></td>
                        <td><%= startTxt %></td>
                        <td><%= endTxt %></td>
                        <td class="text-end"><%= totalTxt %></td>
                        <td>
                            <% if ("CONFIRMED".equals(status)) { %>
                            <span class="badge bg-primary">CONFIRMED</span>
                            <% } else if ("COMPLETED".equals(status)) { %>
                            <span class="badge bg-success">COMPLETED</span>
                            <% } else if ("CANCELLED".equals(status)) { %>
                            <span class="badge bg-secondary">CANCELLED</span>
                            <% } else if ("IN_PROGRESS".equals(status)) { %>
                            <span class="badge bg-info text-dark">IN&nbsp;PROGRESS</span>
                            <% } else if ("PENDING".equals(status)) { %>
                            <span class="badge" style="background-color:#6f42c1;">PENDING</span>

                            <% } else if ("NO_SHOW".equals(status)) { %>
                            <span class="badge bg-dark">NO SHOW</span>
                            <% } else { %>
                            <span class="badge bg-warning text-dark"><%= status %></span>
                            <% } %>
                        </td>
                        <td class="text-end">
                            <% if (canPay) { %>
                            <button type="button"
                                    class="btn btn-success btn-sm me-1 js-open-qr"
                                    data-app-id="<%= a.getAppointmentId() %>"
                                    data-amount="<%= a.getTotalAmount()!=null ? a.getTotalAmount().toPlainString() : "0" %>">
                                <i class="bi bi-qr-code-scan"></i> Pay
                            </button>
                            <% } %>

                            <% if (!"CANCELLED".equals(status) && !"COMPLETED".equals(status)) { %>
                            <a href="<%= ctx %>/customer/appointments?action=cancel&id=<%= a.getAppointmentId() %>"
                               class="btn btn-outline-danger btn-sm"
                               onclick="return confirm('Cancel this appointment?');">
                                <i class="bi bi-x-circle"></i> Cancel
                            </a>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>
</div>

<!-- QR MODAL -->
<div class="modal fade" id="qrModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius:16px;">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-qr-code me-2"></i>Scan to pay</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center">
                <div class="small text-muted mb-2">Appointment: <span id="mAppId">—</span></div>
                <div class="fw-semibold mb-3">Amount: <span id="mAmount">0</span> đ</div>
                <div id="qrBox" class="mx-auto" style="width:260px;height:260px;padding:10px;border:1px dashed #dee2e6;border-radius:12px;"></div>
                <div class="text-muted mt-2">Scan QR.</div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="mPaid">
                    <i class="bi bi-cash-coin me-1"></i> Paid
                </button>
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const el = document.getElementById('serviceIds');
        const totalText = document.getElementById('totalPriceText');
        if (el) {
            new Choices(el, { removeItemButton:true, searchEnabled:true, shouldSort:false,
                placeholder:true, placeholderValue:'Select services...',
                noResultsText:'No services found', itemSelectText:'' });
            if (totalText) {
                const prices = {};
                el.querySelectorAll('option').forEach(opt => {
                    const txt = opt.textContent || '';
                    const m = txt.match(/\(([\d.]+)\s*đ\)/);
                    if (m) prices[opt.value] = parseFloat(m[1]);
                });
                function updateTotal(){
                    let sum = 0;
                    Array.from(el.selectedOptions).forEach(opt => { if (prices[opt.value]) sum += prices[opt.value]; });
                    totalText.textContent = 'Services total: ' + sum.toFixed(2) + ' đ';
                }
                el.addEventListener('change', updateTotal);
            }
        }

        const ctx = '<%= ctx %>';
        const modalEl = document.getElementById('qrModal');
        const qrModal = new bootstrap.Modal(modalEl);
        const box = document.getElementById('qrBox');
        const labId = document.getElementById('mAppId');
        const labAm = document.getElementById('mAmount');
        const btnPaid = document.getElementById('mPaid');

        document.querySelectorAll('.js-open-qr').forEach(btn => {
            btn.addEventListener('click', () => {
                const appId  = btn.getAttribute('data-app-id');
                const amount = btn.getAttribute('data-amount') || '0';
                labId.textContent = appId;
                labAm.textContent = Number(amount).toLocaleString('vi-VN');
                box.innerHTML = '';
                const payload = `PETCARE|APP=${appId}|AMOUNT=${amount}`;
                new QRCode(box, { text: payload, width: 240, height: 240, correctLevel: QRCode.CorrectLevel.M });
                qrModal.show();
            });
        });

        if (btnPaid) {
            btnPaid.addEventListener('click', async () => {
                const appId = (labId.textContent || '').trim();
                // chỉ giữ số và dấu .
                const rawAmount = (labAm.textContent || '0').replace(/[^\d.]/g, '');

                try {
                    const res = await fetch(ctx + '/customer/payments/mark-paid', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                        body: new URLSearchParams({
                            appointmentId: appId,
                            amount: rawAmount,
                            method: 'MOCK_QR'
                        })
                    });
                    if (!res.ok) throw new Error('HTTP ' + res.status);
                    location.reload();
                } catch (e) {
                    alert('Cannot Paid. Try Again!');
                }
            });
        }

    });
</script>
</body>
</html>
