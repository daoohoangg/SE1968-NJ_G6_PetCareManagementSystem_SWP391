<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<section class="page">
    <div class="page-title">
        <h1>Generate Reports</h1>
        <p>Operational and financial reports from the system</p>
        <div class="date-range">
            <input type="date" value="2024-01-01"/>
            <span>to</span>
            <input type="date" value="2024-01-31"/>
        </div>
    </div>

    <!-- Stat Cards -->
    <div class="cards grid-4">
        <div class="card stat">
            <div class="stat-title">Total Revenue</div>
            <div class="stat-value">$91,000</div>
            <div class="stat-sub">↑ +12.5%</div>
        </div>
        <div class="card stat">
            <div class="stat-title">Total Appointments</div>
            <div class="stat-value">624</div>
            <div class="stat-sub"><a href="#">94.2% completed</a></div>
        </div>
        <div class="card stat">
            <div class="stat-title">Avg Transaction</div>
            <div class="stat-value">$76.5</div>
            <div class="stat-sub"><a href="#">Top: Dog Grooming</a></div>
        </div>
        <div class="card stat">
            <div class="stat-title">Customer Rating</div>
            <div class="stat-value">4.7/5.0</div>
            <div class="stat-sub">Avg duration: 67min</div>
        </div>
    </div>

    <!-- Tabs (mock) -->
    <div class="tabs">
        <button class="tab active">Financial Reports</button>
        <button class="tab">Operational Reports</button>
    </div>

    <div class="grid-2">
        <div class="card">
            <div class="card-head">
                <strong>Service Volume Trends</strong>
                <button class="btn">Export</button>
            </div>
            <canvas id="svcVolume"></canvas>
        </div>

        <div class="card">
            <div class="card-head">
                <strong>Customer Acquisition</strong>
                <button class="btn">Export</button>
            </div>
            <canvas id="custAcq"></canvas>
        </div>
    </div>

    <div class="card" style="margin-top:16px">
        <strong>Operational Metrics</strong>
        <div class="metrics">
            <div class="pill">Appointment Utilization <b>87.3%</b></div>
            <div class="pill">On-time Performance <b>92.1%</b></div>
            <div class="pill">Average Wait Time <b>12 min</b></div>
            <div class="pill">Staff Productivity <b>94.5%</b></div>
        </div>
    </div>
</section>

<!-- Chart.js demo -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const ctx1 = document.getElementById('svcVolume');
    new Chart(ctx1, {
        type: 'bar',
        data: { labels:['Jan','Feb','Mar','Apr','May','Jun'],
            datasets:[{ label:'Services', data:[85,92,100,98,115,128] }] }
    });
    const ctx2 = document.getElementById('custAcq');
    new Chart(ctx2, {
        type: 'bar',
        data: { labels:['Jan','Feb','Mar','Apr','May','Jun'],
            datasets:[
                { label:'New', data:[20,30,25,35,40,45] },
                { label:'Returning', data:[55,50,60,55,65,70] }
            ] }
    });
</script>
