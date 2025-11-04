<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // ==== Data from the mock servlet ====
    String ctx        = request.getContextPath();
    Long   amount     = (Long)  request.getAttribute("amount");          // VND
    String txnRef     = (String) request.getAttribute("txnRef");         // e.g. MOCK-10043-...
    // QR payload (mock) just for visual effect
    String qrPayload  = ("VNPAY-MOCK|txnRef=" + txnRef + "|amount=" + amount + "|currency=VND").replace(" ", "%20");
%>
<!doctype html>
<html lang="en">
<head>
    <%@ include file="/inc/common-head.jspf" %>
    <meta charset="UTF-8">
    <title>Mock VNPAY QR</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <style>
        body { background:#f7f9fc; }
        main { padding:40px 0; }
        .pay-card { max-width:520px; margin:0 auto; }
        .pay-card .card-header { background:#fff; }
        .qrc { width: 220px; height: 220px; margin: 0 auto; }
    </style>
</head>
<body>

<!-- Common header -->
<jsp:include page="/inc/header.jsp" />

<main>
    <div class="card shadow-sm pay-card">
        <div class="card-header fw-bold">
            <i class="bi bi-qr-code-scan me-2"></i>Mock VNPAY QR
        </div>
        <div class="card-body text-center">

            <p class="mb-1">Transaction Ref: <b><%= txnRef %></b></p>
            <p class="mb-3">Amount: <b><%= amount %> VND</b></p>

            <div id="qrcode" class="qrc mb-3"></div>

            <div class="d-grid gap-2">
                <!-- No redirect: just show popup in center -->
                <a href="#" id="btn-mock-success" class="btn btn-success">
                    Paid
                </a>
                <a href="#" id="btn-mock-fail" class="btn btn-outline-secondary">
                    Cancel
                </a>
                <a href="<%= ctx %>/customer/appointments" class="btn btn-link">
                    &larr; Back
                </a>
            </div>

        </div>
    </div>
</main>

<!-- Common footer -->
<jsp:include page="/inc/footer.jsp" />

<!-- Modal: Success -->
<div class="modal fade" id="paySuccessModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content p-4 text-center">
            <div class="display-5 text-success mb-2">✔</div>
            <h5 class="mb-1">Payment Successful</h5>
            <p class="text-muted mb-3">
                Ref: <b><%= txnRef %></b> • Amount: <b><%= amount %> VND</b>
            </p>
            <button type="button" class="btn btn-success" data-bs-dismiss="modal">Close</button>
        </div>
    </div>
</div>

<!-- Modal: Fail -->
<div class="modal fade" id="payFailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content p-4 text-center">
            <div class="display-5 text-danger mb-2">✖</div>
            <h5 class="mb-1">Payment Failed</h5>
            <p class="text-muted mb-3">You can try again later.</p>
            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
        </div>
    </div>
</div>

<!-- QR + Popup Logic -->
<script>
    (function () {
        // Generate mock QR code
        new QRCode(document.getElementById("qrcode"), {
            text: "<%= qrPayload %>",
            width: 220, height: 220,
            correctLevel: QRCode.CorrectLevel.H
        });

        let successTimer = null;
        let failTimer = null;

        function openModal(id) {
            const el = document.getElementById(id);
            const modal = new bootstrap.Modal(el, { backdrop: 'static', keyboard: false });
            modal.show();
            return { modal, el };
        }

        // Click "I have scanned & paid" → open success modal + start redirect timer
        document.getElementById('btn-mock-success').addEventListener('click', function (e) {
            e.preventDefault();
            const { el } = openModal('paySuccessModal');
            // Closing modal will cancel the timer → stay on mock page
            el.addEventListener('hidden.bs.modal', function onHide() {
                if (successTimer) { clearTimeout(successTimer); successTimer = null; }
                el.removeEventListener('hidden.bs.modal', onHide);
            });
            successTimer = setTimeout(function () {
                window.location.href = "<%= ctx %>/customer/appointments";
            }, 3000);
        });

        // Click "Cancel" → open fail modal + start redirect timer
        document.getElementById('btn-mock-fail').addEventListener('click', function (e) {
            e.preventDefault();
            const { el } = openModal('payFailModal');
            el.addEventListener('hidden.bs.modal', function onHide() {
                if (failTimer) { clearTimeout(failTimer); failTimer = null; }
                el.removeEventListener('hidden.bs.modal', onHide);
            });
            failTimer = setTimeout(function () {
                window.location.href = "<%= ctx %>/customer/appointments";
            }, 2400);
        });
    })();
</script>

</body>
</html>
