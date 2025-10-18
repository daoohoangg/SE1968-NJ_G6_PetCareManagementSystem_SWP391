<%@ page contentType="text/html; charset=UTF-8"%>
<jsp:include page="../inc/header.jsp" />
<section class="page">
    <div class="page-title"><h1>Dashboard</h1><p>Welcome to PetCare Management System</p></div>
    <jsp:include page="../inc/side-bar.jsp" />
    <div class="actions-row">
        <a class="btn primary">+ New Appointment</a>
        <a class="btn">+ Add Customer</a>
        <a class="btn danger">Emergency Alert</a>
        <a class="btn">View Reports</a>
    </div>

    <div class="cards grid-6">
        <div class="card stat"><div>Weather Today</div><div class="big">72°F</div></div>
        <div class="card stat"><div>System Status</div><div class="ok">All Systems Operational</div></div>
        <div class="card stat"><div>Total Customers</div><div class="big">1,247</div></div>
        <div class="card stat"><div>Active Services</div><div class="big">86</div></div>
        <div class="card stat"><div>Monthly Revenue</div><div class="big">$24,580</div></div>
        <div class="card stat"><div>Pending Appointments</div><div class="big">28</div></div>
    </div>

    <div class="grid-2">
        <div class="card"><div class="card-head"><strong>Revenue Trends</strong></div><canvas id="rev6"></canvas></div>
        <div class="card"><div class="card-head"><strong>Service Distribution</strong></div><canvas id="svcPie"></canvas></div>
    </div>

    <div class="card" style="margin-top:16px">
        <div class="card-head"><strong>Staff Performance Today</strong></div>
        <ul class="list">
            <li>Dr. Sarah Wilson — ⭐ 4.9 — $4580</li>
            <li>Mike Johnson — ⭐ 4.8 — $3720</li>
        </ul>
    </div>
</section>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    new Chart(document.getElementById('rev6'),{type:'line',data:{labels:['Jan','Feb','Mar','Apr','May','Jun'],datasets:[{label:'Revenue',data:[15000,18000,17000,20000,23000,22500]}]}});
    new Chart(document.getElementById('svcPie'),{type:'pie',data:{labels:['Grooming 35%','Veterinary 28%','Training 18%','Boarding 12%','Daycare 7%'],datasets:[{data:[35,28,18,12,7]}]}});
</script>
<jsp:include page="../inc/chatbox.jsp" />
<jsp:include page="../inc/footer.jsp" />
