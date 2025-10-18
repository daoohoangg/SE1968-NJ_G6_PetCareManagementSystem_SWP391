<%@ page contentType="text/html; charset=UTF-8"%>
<jsp:include page="../inc/header.jsp" />
<section class="page">
    <jsp:include page="../inc/side-bar.jsp" />
    <h1>System Configuration</h1><p>Configure rules, schedules, vouchers, and email notifications</p>
    <div class="tabs sub">
        <a class="tab active" href="${pageContext.request.contextPath}/config/schedule">Schedule</a>
        <a class="tab" href="${pageContext.request.contextPath}/config/vouchers">Vouchers</a>
        <a class="tab" href="${pageContext.request.contextPath}/config/email">Email</a>
        <a class="tab" href="${pageContext.request.contextPath}/config/rules">Rules</a>
    </div>

    <div class="card">
        <strong>Business Hours</strong>
        <ul class="hours">
            <li>Monday <span>08:00 AM — 06:00 PM</span> <input type="checkbox" checked/></li>
            <li>Tuesday <span>08:00 AM — 06:00 PM</span> <input type="checkbox" checked/></li>
            <li>Wednesday <span>08:00 AM — 06:00 PM</span> <input type="checkbox" checked/></li>
            <li>Thursday <span>08:00 AM — 06:00 PM</span> <input type="checkbox" checked/></li>
            <li>Friday <span>08:00 AM — 06:00 PM</span> <input type="checkbox" checked/></li>
            <li>Saturday <span>09:00 AM — 05:00 PM</span> <input type="checkbox" checked/></li>
            <li>Sunday <span>Closed</span> <input type="checkbox"/></li>
        </ul>
        <button class="btn success">Save All Settings</button>
    </div>
</section>
<jsp:include page="../inc/chatbox.jsp" />
<jsp:include page="../inc/footer.jsp" />
