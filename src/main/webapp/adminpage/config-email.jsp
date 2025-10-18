<%@ page contentType="text/html; charset=UTF-8"%>
<jsp:include page="../inc/header.jsp" />
<section class="page">
    <jsp:include page="../inc/side-bar.jsp" />
    <div class="card">
        <div class="card-head">
            <strong>Email Notifications</strong>
        </div>
        <p>Configure SMTP credentials and notification templates.</p>
        <div class="form-grid">
            <label>SMTP Host <input type="text" placeholder="smtp.petcare.com"/></label>
            <label>Port <input type="number" value="587"/></label>
            <label>Username <input type="text" placeholder="notifications@petcare.com"/></label>
            <label>Password <input type="password" value=""/></label>
            <label>From Name <input type="text" value="PetCare Notifications"/></label>
            <label>Reply-to Email <input type="email" placeholder="support@petcare.com"/></label>
        </div>
        <button class="btn success" style="margin-top:16px">Save Email Settings</button>
    </div>
</section>
<jsp:include page="../inc/chatbox.jsp" />
<jsp:include page="../inc/footer.jsp" />
