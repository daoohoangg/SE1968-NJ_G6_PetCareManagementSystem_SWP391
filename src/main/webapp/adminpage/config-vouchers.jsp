<%@ page contentType="text/html; charset=UTF-8"%>
<jsp:include page="../inc/header.jsp" />
<section class="page">
    <jsp:include page="../inc/side-bar.jsp" />
    <div class="card">
        <div class="card-head">
            <strong>Voucher Settings</strong>
        </div>
        <p>Manage promotional vouchers and discount rules.</p>
        <div class="table">
            <div class="row head">
                <div>Code</div><div>Type</div><div>Value</div><div>Expiry</div><div>Status</div>
            </div>
            <div class="row">
                <div>WELCOME10</div><div>Percentage</div><div>10%</div><div>2025-12-31</div><div>Active</div>
            </div>
            <div class="row">
                <div>FREESPA15</div><div>Percentage</div><div>15%</div><div>2025-06-30</div><div>Active</div>
            </div>
        </div>
        <button class="btn primary" style="margin-top:16px">Create Voucher</button>
    </div>
</section>
<jsp:include page="../inc/chatbox.jsp" />
<jsp:include page="../inc/footer.jsp" />
