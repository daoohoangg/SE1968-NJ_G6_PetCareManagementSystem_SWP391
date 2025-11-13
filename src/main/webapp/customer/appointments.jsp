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
        .actions-cell { width: 160px; }
        .actions-cell .btn { white-space: nowrap; }
        body.modal-open .page-container { filter: blur(3px); transition: filter .2s ease; }
        
        /* Date & Time Picker Styling */
        #appointmentDate, #appointmentTime {
            border-left: none;
            transition: all 0.3s ease;
        }
        #appointmentDate:focus, #appointmentTime:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25);
        }
        .input-group-text {
            border-right: none;
            border-color: #dee2e6;
        }
        .input-group:focus-within .input-group-text {
            border-color: #0d6efd;
            background-color: #e7f1ff;
        }
        input[type="date"]::-webkit-calendar-picker-indicator,
        input[type="time"]::-webkit-calendar-picker-indicator {
            cursor: pointer;
            opacity: 0.6;
            transition: opacity 0.2s;
        }
        input[type="date"]::-webkit-calendar-picker-indicator:hover,
        input[type="time"]::-webkit-calendar-picker-indicator:hover {
            opacity: 1;
        }
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
            <form method="post" action="<%= ctx %>/customer/appointments" id="appointmentForm" onsubmit="return validateAppointmentForm()">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label required">Pet</label>
                        <% if (pets == null || pets.isEmpty()) { %>
                        <select class="form-select" disabled>
                            <option>(You don’t have any pets yet – please add one first)</option>
                        </select>
                        <% } else { 
                            // Loại bỏ duplicate pets dựa trên ID
                            Set<Long> seenIds = new HashSet<>();
                            List<Pet> uniquePets = new ArrayList<>();
                            for (Pet p : pets) {
                                if (p != null && p.getIdpet() != null && seenIds.add(p.getIdpet())) {
                                    uniquePets.add(p);
                                }
                            }
                        %>
                        <select id="petId" name="petId" class="form-select" required>
                            <option value="" hidden>Select a pet</option>
                            <% for (Pet p : uniquePets) { %>
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
                                    Integer duration = s.getDurationMinutes();
                                    String durationAttr = (duration != null && duration > 0) ? " data-duration=\"" + duration + "\"" : "";
                                    String durationText = (duration != null && duration > 0) ? " - " + duration + " min" : "";
                                %>
                                <option value="<%= s.getServiceId() %>"<%= durationAttr %>><%= s.getServiceName() %> (<%= priceStr %> đ)<%= durationText %></option>
                                <%
                                    if (i == sortedServices.size() - 1) { %></optgroup><% }
                        }
                        }
                        %>
                        </select>
                        <small id="totalPriceText" class="text-muted d-block mt-1">Services total: 0 đ</small>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Voucher Code</label>
                        <div class="input-group">
                            <input type="text" id="voucherCode" name="voucherCode" class="form-control"
                                   placeholder="Enter voucher code" maxlength="20">
                            <input type="hidden" id="voucherId" name="voucherId">
                            <button type="button" id="applyVoucherBtn" class="btn btn-outline-primary">
                                <i class="bi bi-check-circle me-1"></i>Apply
                            </button>
                        </div>
                        <small id="voucherMessage" class="text-muted d-block mt-1"></small>
                        <div id="voucherInfo" class="mt-2" style="display:none;">
                            <div class="alert alert-success py-2 px-3 mb-0">
                                <i class="bi bi-tag-fill me-2"></i>
                                <span id="voucherDiscountText"></span>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Appointment Date & Time</label>
                        <div class="row g-2">
                            <div class="col-6">
                                <div class="input-group">
                                    <span class="input-group-text bg-light">
                                        <i class="bi bi-calendar3 text-primary"></i>
                                    </span>
                                    <input type="date" id="appointmentDate" class="form-control">
                                </div>
                                <small class="text-muted">Date</small>
                            </div>
                            <div class="col-6">
                                <div class="input-group">
                                    <span class="input-group-text bg-light">
                                        <i class="bi bi-clock text-primary"></i>
                                    </span>
                                    <input type="time" id="appointmentTime" class="form-control">
                                </div>
                                <small class="text-muted">Time</small>
                            </div>
                        </div>
                        <input type="hidden" id="startAt" name="startAt">
                        <small class="text-muted d-block mt-2">
                            <i class="bi bi-info-circle me-1"></i>
                            Please select a date and time for your appointment
                        </small>
                    </div>

                    <div class="col-12">
                        <label class="form-label">Notes</label>
                        <textarea name="notes" rows="3" class="form-control"
                                  placeholder="E.g., allergic to shampoo, prefer short nail trim..."></textarea>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-12">
                        <div class="card bg-light">
                            <div class="card-body py-2">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="fw-semibold">Subtotal:</span>
                                    <span id="subtotalAmount" class="fw-bold">0 đ</span>
                                </div>
                                <div id="discountRow" class="d-flex justify-content-between align-items-center mt-2" style="display:none;">
                                    <span class="text-success">Discount:</span>
                                    <span id="discountAmount" class="text-success fw-bold">0 đ</span>
                                </div>
                                <hr class="my-2">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="fw-bold fs-5">Total:</span>
                                    <span id="finalTotalAmount" class="fw-bold fs-5 text-primary">0 đ</span>
                                </div>
                            </div>
                        </div>
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
                                    ("PENDING".equals(status) || "SCHEDULED".equals(status)) &&
                                            a.getTotalAmount() != null &&
                                            a.getTotalAmount().compareTo(java.math.BigDecimal.ZERO) > 0;

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
                        <td class="text-end actions-cell">
                            <div class="d-flex justify-content-end align-items-center gap-2 flex-wrap">
                                <% if (canPay) { %>
                                <button type="button"
                                        class="btn btn-success btn-sm js-open-qr"
                                        data-app-id="<%= a.getAppointmentId() %>"
                                        data-amount="<%= a.getTotalAmount()!=null ? a.getTotalAmount().toPlainString() : "0" %>">
                                    <i class="bi bi-qr-code-scan"></i> Pay
                                </button>
                                <% } %>

                                <% if ("PENDING".equals(status) || "SCHEDULED".equals(status)) { %>
                                <a href="<%= ctx %>/customer/appointments?action=cancel&id=<%= a.getAppointmentId() %>"
                                   class="btn btn-outline-danger btn-sm"
                                   onclick="return confirm('Cancel this appointment?');">
                                    <i class="bi bi-x-circle"></i> Cancel
                                </a>
                                <% } %>
                            </div>
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

                <!-- QR -->
                <div id="qrBox" class="mx-auto"
                     style="width:230px;height:230px;padding:10px;border:1px dashed #ced4da;border-radius:12px;transition:opacity .2s;"></div>
                <div id="qrNote" class="text-muted mt-2">Scan QR below to pay.</div>

                <!-- Cash message -->
                <div id="cashNote" class="mt-3 text-success fw-semibold d-none">
                    💵 Please make your payment at the counter.
                </div>

                <!-- Payment method -->
                <div class="mt-4">
                    <select id="mMethod" class="form-select text-center fw-semibold" style="max-width:220px;margin:auto;">
                        <option value="MOCK_QR" selected>Scan QR</option>
                        <option value="CASH">Cash</option>
                    </select>
                </div>
            </div>

            <div class="modal-footer justify-content-center">
                <button type="button" class="btn btn-primary px-4" id="mPaid">
                    <i class="bi bi-cash-coin me-1"></i> Paid
                </button>
                <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

</div>

<script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Date & Time Picker Setup
        const dateInput = document.getElementById('appointmentDate');
        const timeInput = document.getElementById('appointmentTime');
        const hiddenInput = document.getElementById('startAt');
        
        // Set minimum date to today
        if (dateInput) {
            const today = new Date();
            const year = today.getFullYear();
            const month = String(today.getMonth() + 1).padStart(2, '0');
            const day = String(today.getDate()).padStart(2, '0');
            dateInput.min = `${year}-${month}-${day}`;
            
            // Set default to today if not set
            if (!dateInput.value) {
                dateInput.value = `${year}-${month}-${day}`;
            }
        }
        
        // Combine date and time into datetime-local format
        function updateDateTime() {
            if (dateInput && timeInput && hiddenInput) {
                const date = dateInput.value;
                const time = timeInput.value;
                // Only set value if both date and time are valid and not empty
                if (date && date.trim() !== '' && time && time.trim() !== '') {
                    hiddenInput.value = `${date}T${time}`;
                } else {
                    hiddenInput.value = '';
                }
            }
        }
        
        // Set default time if not set
        if (timeInput && !timeInput.value) {
            // Set default time to current time + 1 hour (rounded to nearest 30 minutes)
            const now = new Date();
            now.setHours(now.getHours() + 1);
            const minutes = Math.ceil(now.getMinutes() / 30) * 30;
            now.setMinutes(minutes);
            now.setSeconds(0);
            const hours = String(now.getHours()).padStart(2, '0');
            const mins = String(now.getMinutes()).padStart(2, '0');
            timeInput.value = `${hours}:${mins}`;
        }
        
        if (dateInput) dateInput.addEventListener('change', updateDateTime);
        if (timeInput) timeInput.addEventListener('change', updateDateTime);
        
        // Initial update (only if both date and time have values)
        setTimeout(updateDateTime, 100);
        
        // Form validation before submit
        function validateAppointmentForm() {
            // Update datetime nếu có giá trị
            if (dateInput && timeInput && hiddenInput) {
                updateDateTime();
            }
            
            // Nếu có chọn thời gian, kiểm tra không được chọn thời gian trong quá khứ
            const date = dateInput ? dateInput.value : '';
            const time = timeInput ? timeInput.value : '';
            const hiddenStartAt = hiddenInput ? hiddenInput.value : '';
            
            // Chỉ validate nếu có chọn cả date và time
            if (date && time && hiddenStartAt && hiddenStartAt.trim() !== '' && 
                hiddenStartAt !== 'T' && !hiddenStartAt.startsWith('T') &&
                !hiddenStartAt.includes('--') && hiddenStartAt.length >= 10) {
                try {
                    // Parse datetime từ hidden input (format: yyyy-MM-ddTHH:mm)
                    const selectedDateTime = new Date(hiddenStartAt);
                    const now = new Date();
                    
                    // Kiểm tra thời gian đã chọn có phải là quá khứ không
                    if (selectedDateTime < now) {
                        alert('Không thể đặt lịch hẹn trong quá khứ. Vui lòng chọn thời gian trong tương lai.');
                        if (dateInput) dateInput.focus();
                        return false;
                    }
                } catch (e) {
                    // Nếu parse lỗi, bỏ qua validation
                    console.warn('Error parsing datetime:', e);
                }
            }
            
            return true; // Cho phép submit nếu không có thời gian hoặc thời gian hợp lệ
        }
        
        // Voucher handling - declare first so it's available everywhere
        let currentVoucher = null;
        let currentSubtotal = 0;
        let choicesInstance = null;

        function updatePricing(subtotal) {
            currentSubtotal = subtotal;
            const subtotalEl = document.getElementById('subtotalAmount');
            const finalTotalEl = document.getElementById('finalTotalAmount');
            const discountRow = document.getElementById('discountRow');
            
            if (subtotalEl) {
                subtotalEl.textContent = subtotal.toFixed(2) + ' đ';
            }
            
            if (currentVoucher) {
                applyVoucherCalculation(subtotal, currentVoucher);
            } else {
                if (finalTotalEl) {
                    finalTotalEl.textContent = subtotal.toFixed(2) + ' đ';
                }
                if (discountRow) {
                    discountRow.style.display = 'none';
                }
            }
        }

        const el = document.getElementById('serviceIds');
        const totalText = document.getElementById('totalPriceText');
        if (el) {
            // Extract prices from options before Choices.js transforms the select
                const prices = {};
                el.querySelectorAll('option').forEach(opt => {
                    const txt = opt.textContent || '';
                    const m = txt.match(/\(([\d.]+)\s*đ\)/);
                    if (m) prices[opt.value] = parseFloat(m[1]);
                });
            // Khi người dùng đổi phương thức thanh toán
            const methodSel = document.getElementById('mMethod');
            if (methodSel) {
                methodSel.addEventListener('change', () => {
                    const val = methodSel.value;
                    const qrBox = document.getElementById('qrBox');
                    const qrNote = document.getElementById('qrNote');
                    const cashNote = document.getElementById('cashNote');
                    const btnPaid = document.getElementById('mPaid');

                    if (val === 'CASH') {
                        qrBox.classList.add('d-none');
                        qrNote.classList.add('d-none');
                        cashNote.classList.remove('d-none');
                        btnPaid.innerHTML = '<i class="bi bi-check-circle me-1"></i> OK';
                    } else {
                        qrBox.classList.remove('d-none');
                        qrNote.classList.remove('d-none');
                        cashNote.classList.add('d-none');
                        btnPaid.innerHTML = '<i class="bi bi-cash-coin me-1"></i> Paid';
                    }
                });
            }

            // Initialize Choices.js
            choicesInstance = new Choices(el, { 
                removeItemButton: true, 
                searchEnabled: true, 
                shouldSort: false,
                placeholder: true, 
                placeholderValue: 'Select services...',
                noResultsText: 'No services found', 
                itemSelectText: '' 
            });
            
            // Store reference to updateTotal for use in event handlers
            window.updateAppointmentTotal = updateTotal;

            // Function to update total
            function updateTotal() {
                    let sum = 0;
                try {
                    const selectedValues = choicesInstance.getValue(true); // Get array of selected values
                    if (selectedValues && Array.isArray(selectedValues)) {
                        selectedValues.forEach(value => {
                            if (prices[value]) {
                                sum += prices[value];
                            }
                        });
                    }
                } catch (e) {
                    console.error('Error getting selected values:', e);
                    // Fallback: try to get from original select element
                    const selectedOptions = el.selectedOptions || el.options;
                    for (let i = 0; i < selectedOptions.length; i++) {
                        const opt = selectedOptions[i];
                        if (opt.selected && prices[opt.value]) {
                            sum += prices[opt.value];
                        }
                    }
                }
                
                if (totalText) {
                    totalText.textContent = 'Services total: ' + sum.toFixed(2) + ' đ';
                }
                
                // Update pricing breakdown
                updatePricing(sum);
            }

            // Listen to Choices.js events - multiple event types for reliability
            function triggerUpdate() {
                setTimeout(updateTotal, 100);
            }
            
            // Method 1: Choices.js custom events
            el.addEventListener('addItem', triggerUpdate);
            el.addEventListener('removeItem', triggerUpdate);
            el.addEventListener('change', triggerUpdate);
            el.addEventListener('input', triggerUpdate);
            
            // Method 2: Watch for clicks on Choices container (after it's created)
            setTimeout(function() {
                const choicesContainer = el.parentElement;
                if (choicesContainer && choicesContainer.classList.contains('choices')) {
                    // Watch for clicks anywhere in the choices container
                    choicesContainer.addEventListener('click', function(e) {
                        // Only update if clicking on items or remove buttons
                        if (e.target.classList.contains('choices__item') || 
                            e.target.classList.contains('choices__button') ||
                            e.target.closest('.choices__list--multiple')) {
                            setTimeout(updateTotal, 150);
                        }
                    });
                    
                    // Also watch for keyboard events
                    choicesContainer.addEventListener('keydown', function(e) {
                        if (e.key === 'Enter' || e.key === ' ') {
                            setTimeout(updateTotal, 150);
                        }
                    });
                }
            }, 300);
            
            // Method 3: Periodic check as fallback (only if no items selected yet)
            let checkInterval = setInterval(function() {
                try {
                    const values = choicesInstance.getValue(true);
                    if (values && values.length > 0) {
                        // Once we have selections, rely on events
                        clearInterval(checkInterval);
                    } else {
                        // Keep checking until something is selected
                        updateTotal();
                    }
                } catch (e) {
                    // Ignore
                }
            }, 1000);
            
            // Clear interval after 30 seconds to avoid infinite polling
            setTimeout(function() {
                if (checkInterval) clearInterval(checkInterval);
            }, 30000);
            
            // Initial update
            setTimeout(updateTotal, 300);
        }

        function applyVoucherCalculation(subtotal, voucher) {
            let discount = 0;
            const discountType = voucher.discountType;
            const discountValue = parseFloat(voucher.discountValue);

            if (discountType === 'PERCENTAGE') {
                discount = (subtotal * discountValue) / 100;
            } else if (discountType === 'FIXED') {
                discount = Math.min(discountValue, subtotal);
            }

            const finalTotal = Math.max(0, subtotal - discount);
            
            const discountAmountEl = document.getElementById('discountAmount');
            const discountRow = document.getElementById('discountRow');
            const finalTotalEl = document.getElementById('finalTotalAmount');
            
            if (discountAmountEl) {
                discountAmountEl.textContent = '-' + discount.toFixed(2) + ' đ';
            }
            if (discountRow) {
                discountRow.style.display = 'flex';
            }
            if (finalTotalEl) {
                finalTotalEl.textContent = finalTotal.toFixed(2) + ' đ';
            }
        }

        const voucherCodeInput = document.getElementById('voucherCode');
        const applyVoucherBtn = document.getElementById('applyVoucherBtn');
        const voucherMessage = document.getElementById('voucherMessage');
        const voucherInfo = document.getElementById('voucherInfo');
        const voucherDiscountText = document.getElementById('voucherDiscountText');
        const voucherIdInput = document.getElementById('voucherId');

        if (applyVoucherBtn && voucherCodeInput) {
            applyVoucherBtn.addEventListener('click', async function() {
                const code = (voucherCodeInput.value || '').trim().toUpperCase();
                
                if (!code) {
                    if (voucherMessage) {
                        voucherMessage.textContent = 'Please enter a voucher code';
                        voucherMessage.className = 'text-danger d-block mt-1';
                    }
                    if (voucherInfo) voucherInfo.style.display = 'none';
                    currentVoucher = null;
                    if (voucherIdInput) voucherIdInput.value = '';
                    updatePricing(currentSubtotal);
                    return;
                }

                if (currentSubtotal <= 0) {
                    if (voucherMessage) {
                        voucherMessage.textContent = 'Please select services first';
                        voucherMessage.className = 'text-warning d-block mt-1';
                    }
                    return;
                }

                applyVoucherBtn.disabled = true;
                applyVoucherBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Checking...';

                try {
                    const response = await fetch(ctx + '/customer/vouchers/validate', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                        },
                        body: new URLSearchParams({
                            code: code,
                            subtotal: currentSubtotal.toString()
                        })
                    });

                    const data = await response.json();

                    if (data.success && data.voucher) {
                        currentVoucher = data.voucher;
                        if (voucherIdInput) voucherIdInput.value = data.voucher.voucherId;
                        
                        const discountType = data.voucher.discountType;
                        const discountValue = parseFloat(data.voucher.discountValue);
                        let discountText = '';
                        
                        if (discountType === 'PERCENTAGE') {
                            discountText = discountValue + '% off';
                        } else if (discountType === 'FIXED') {
                            discountText = discountValue.toFixed(2) + ' đ off';
                        }
                        
                        if (voucherDiscountText) {
                            voucherDiscountText.textContent = 'Voucher "' + code + '" applied: ' + discountText;
                        }
                        if (voucherInfo) voucherInfo.style.display = 'block';
                        if (voucherMessage) {
                            voucherMessage.textContent = '';
                            voucherMessage.className = 'text-muted d-block mt-1';
                        }
                        
                        applyVoucherCalculation(currentSubtotal, currentVoucher);
                    } else {
                        currentVoucher = null;
                        if (voucherIdInput) voucherIdInput.value = '';
                        if (voucherInfo) voucherInfo.style.display = 'none';
                        if (voucherMessage) {
                            voucherMessage.textContent = data.message || 'Invalid voucher code';
                            voucherMessage.className = 'text-danger d-block mt-1';
                        }
                        updatePricing(currentSubtotal);
                    }
                } catch (error) {
                    console.error('Error validating voucher:', error);
                    if (voucherMessage) {
                        voucherMessage.textContent = 'Error validating voucher. Please try again.';
                        voucherMessage.className = 'text-danger d-block mt-1';
                    }
                    currentVoucher = null;
                    if (voucherIdInput) voucherIdInput.value = '';
                    updatePricing(currentSubtotal);
                } finally {
                    applyVoucherBtn.disabled = false;
                    applyVoucherBtn.innerHTML = '<i class="bi bi-check-circle me-1"></i>Apply';
                }
            });
        }

        const ctx = '<%= ctx %>';
        const modalEl = document.getElementById('qrModal');
        if (modalEl) {
        const qrModal = new bootstrap.Modal(modalEl);
        const box = document.getElementById('qrBox');
        const labId = document.getElementById('mAppId');
        const labAm = document.getElementById('mAmount');
        const btnPaid = document.getElementById('mPaid');

            if (box && labId && labAm) {
                document.querySelectorAll('.js-open-qr').forEach(function (btn) {
                    btn.addEventListener('click', function () {
                const appId  = btn.getAttribute('data-app-id');
                const amount = btn.getAttribute('data-amount') || '0';
                        labId.textContent = appId || '';
                labAm.textContent = Number(amount).toLocaleString('vi-VN');

                box.innerHTML = '';
                        try {
                            new QRCode(box, {
                                text: 'PETCARE|APP=' + appId + '|AMOUNT=' + amount,
                                width: 240, height: 240, correctLevel: QRCode.CorrectLevel.M
                            });
                        } catch (e) {
                            console.error('Error generating QR code:', e);
                        }
                        if (qrModal && qrModal.show) {
                qrModal.show();
                        }
            });
        });
            }
// === Handle payment method toggle ===
            const methodSel = document.getElementById('mMethod');
            if (methodSel) {
                methodSel.addEventListener('change', () => {
                    const val = methodSel.value;
                    const qrBox = document.getElementById('qrBox');
                    const qrNote = document.getElementById('qrNote');
                    const cashNote = document.getElementById('cashNote');
                    const btnPaid = document.getElementById('mPaid');

                    if (val === 'CASH') {
                        qrBox.style.opacity = '0.3';
                        qrNote.classList.add('d-none');
                        cashNote.classList.remove('d-none');
                        btnPaid.innerHTML = '<i class="bi bi-check-circle me-1"></i> OK';
                    } else {
                        qrBox.style.opacity = '1';
                        qrNote.classList.remove('d-none');
                        cashNote.classList.add('d-none');
                        btnPaid.innerHTML = '<i class="bi bi-cash-coin me-1"></i> Paid';
                    }
                });
            }

            if (btnPaid) {
                btnPaid.addEventListener('click', async () => {
                    const appId = (labId.textContent || '').trim();
                    const rawAmount = (labAm.textContent || '0').replace(/[^\d.]/g, '');
                    const methodSel = document.getElementById('mMethod');
                    const selectedMethod = methodSel ? methodSel.value : 'MOCK_QR';

                    try {
                        const res = await fetch(ctx + '/customer/payments/mark-paid', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                            body: new URLSearchParams({
                                appointmentId: appId,
                                amount: rawAmount,
                                method: selectedMethod
                            })
                        });
                        if (!res.ok) throw new Error('HTTP ' + res.status);
                        location.reload();
                    } catch (e) {
                        alert('Cannot Paid. Try Again!');
                    }
                });
            }


        }
    });
</script>

</body>
</html>
