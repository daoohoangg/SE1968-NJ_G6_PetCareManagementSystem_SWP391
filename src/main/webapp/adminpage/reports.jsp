<%@ page contentType="text/html; charset=UTF-8" %>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<style>
    :root{
        --primary:#2563eb;
        --primary-soft:#eef2ff;
        --success:#16a34a;
        --warning:#f97316;
        --danger:#dc2626;
        --muted:#6b7280;
        --text:#111827;
        --line:#e5e7eb;
        --bg:#f7f9fc;
        --surface:#ffffff;
        --shadow:0 18px 40px rgba(15,23,42,.08);
    }
    .reports-page{
        display:flex;
        background:var(--bg);
        font-family:Inter,system-ui,Segoe UI,Roboto,Arial,sans-serif;
        color:var(--text);
        width:100%;
    }
    .reports-main{
        flex:1;
        padding:32px 40px;
        display:flex;
        flex-direction:column;
        gap:28px;
    }
    .reports-header{
        display:flex;
        justify-content:space-between;
        align-items:flex-start;
        gap:18px;
        flex-wrap:wrap;
    }
    .reports-title h1{
        margin:0;
        font-size:28px;
        font-weight:600;
    }
    .reports-title p{
        margin:6px 0 0;
        color:var(--muted);
        font-size:14px;
    }
    .date-range{
        display:flex;
        align-items:center;
        gap:12px;
        background:var(--surface);
        border:1px solid var(--line);
        border-radius:14px;
        padding:10px 14px;
        box-shadow:0 10px 24px rgba(15,23,42,.08);
    }
    .date-field{
        display:inline-flex;
        align-items:center;
        gap:8px;
        padding:8px 12px;
        border:1px solid var(--line);
        border-radius:12px;
        background:#fff;
    }
    .date-field i{color:var(--primary);}
    .date-field input{
        border:none;
        background:transparent;
        outline:none;
        font-size:13px;
        color:var(--text);
    }
    .stats-grid{
        display:grid;
        gap:18px;
        grid-template-columns:repeat(auto-fit,minmax(200px,1fr));
    }
    .stat-card{
        background:var(--surface);
        border:1px solid rgba(148,163,184,.25);
        border-radius:18px;
        padding:20px 22px;
        box-shadow:var(--shadow);
        display:flex;
        flex-direction:column;
        gap:8px;
        min-height:0;
    }
    .stat-label{
        font-size:13px;
        color:var(--muted);
        text-transform:uppercase;
        letter-spacing:.05em;
        font-weight:600;
    }
    .stat-value{
        font-size:24px;
        font-weight:700;
    }
    .stat-sub{
        display:flex;
        align-items:center;
        gap:8px;
        font-size:12px;
        color:var(--muted);
    }
    .stat-sub.success{color:var(--success);}
    .stat-sub a{
        color:var(--primary);
        text-decoration:none;
        font-weight:600;
    }
    .reports-tabs{
        display:flex;
        align-items:center;
        gap:12px;
        background:#f3f4f6;
        padding:6px;
        border-radius:999px;
        border:1px solid rgba(148,163,184,.3);
        width:max-content;
    }
    .reports-tab{
        display:inline-flex;
        align-items:center;
        gap:8px;
        padding:10px 20px;
        border-radius:999px;
        border:none;
        background:transparent;
        font-weight:600;
        font-size:14px;
        color:#4b5563;
        cursor:pointer;
        transition:.18s;
    }
    .reports-tab.active{
        background:#fff;
        color:var(--primary);
        box-shadow:0 12px 20px rgba(37,99,235,.18);
    }
    .reports-content{
        display:flex;
        flex-direction:column;
        gap:28px;
    }
    .reports-panel{
        display:none;
        flex-direction:column;
        gap:24px;
    }
    .reports-panel.active{
        display:flex;
    }
    .chart-grid{
        display:grid;
        gap:24px;
        grid-template-columns:minmax(0,2fr) minmax(0,1.1fr);
    }
    .card{
        background:var(--surface);
        border:1px solid rgba(148,163,184,.25);
        border-radius:20px;
        padding:24px 26px;
        box-shadow:var(--shadow);
        display:flex;
        flex-direction:column;
        gap:20px;
        min-height:0;
    }
    .card-header{
        display:flex;
        align-items:center;
        justify-content:space-between;
        gap:12px;
    }
    .card-header h2{
        margin:0;
        font-size:18px;
        font-weight:600;
    }
    .export-group{
        display:flex;
        align-items:center;
        gap:10px;
    }
    .chip{
        display:inline-flex;
        align-items:center;
        gap:6px;
        padding:6px 12px;
        border-radius:12px;
        border:1px solid var(--line);
        background:#fff;
        color:var(--text);
        font-size:13px;
        font-weight:600;
        cursor:pointer;
        transition:.18s;
    }
    .chip:hover{
        border-color:rgba(37,99,235,.4);
        color:var(--primary);
    }
    .chart-wrapper{
        position:relative;
        width:100%;
        height:280px;
    }
    .chart-wrapper.pie{height:260px;}
    .metrics-grid{
        display:grid;
        grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
        gap:16px;
    }
    .metric-tile{
        border:1px solid var(--line);
        border-radius:16px;
        padding:16px 18px;
        background:#fff;
        box-shadow:0 12px 24px rgba(15,23,42,.04);
    }
    .metric-label{
        font-size:13px;
        color:var(--muted);
        margin-bottom:6px;
    }
    .metric-value{
        font-size:18px;
        font-weight:700;
        color:var(--primary);
    }
    .table-card{
        gap:20px;
    }
    .table-card table{
        width:100%;
        border-collapse:separate;
        border-spacing:0;
    }
    .table-card thead th{
        text-align:left;
        padding:14px 18px;
        font-size:13px;
        font-weight:700;
        color:#4b5563;
        background:#f3f4f6;
        border-bottom:1px solid var(--line);
    }
    .table-card tbody td{
        padding:16px 18px;
        border-bottom:1px solid var(--line);
        font-size:14px;
        color:var(--text);
    }
    .table-card tbody tr:last-child td{border-bottom:none;}
    .growth{
        display:inline-flex;
        align-items:center;
        gap:6px;
        padding:6px 10px;
        border-radius:999px;
        font-size:12px;
        font-weight:600;
    }
    .growth.up{
        background:rgba(22,163,74,.15);
        color:var(--success);
    }
    .growth.down{
        background:rgba(220,38,38,.18);
        color:var(--danger);
    }
    .growth.flat{
        background:rgba(148,163,184,.16);
        color:#475569;
    }
    .table-actions{
        display:flex;
        align-items:center;
        gap:10px;
    }
    .action-btn{
        display:inline-flex;
        align-items:center;
        gap:6px;
        padding:9px 16px;
        border-radius:12px;
        border:1px solid transparent;
        font-weight:600;
        font-size:14px;
        cursor:pointer;
        transition:.18s;
    }
    .action-btn.primary{
        background:var(--primary);
        color:#fff;
        box-shadow:0 14px 28px rgba(37,99,235,.25);
    }
    .action-btn.secondary{
        background:#fff;
        border-color:var(--line);
        color:var(--text);
    }
    .action-btn:hover{
        filter:brightness(.95);
    }
    @media (max-width:992px){
        .reports-main{padding:28px;}
        .chart-grid{grid-template-columns:1fr;}
    }
    @media (max-width:768px){
        .reports-main{padding:24px 18px;}
        .date-range{width:100%;justify-content:space-between;}
        .reports-tabs{width:100%;justify-content:center;}
    }
</style>

<jsp:include page="../inc/header.jsp" />
<main class="content-wrapper">
    <section class="page reports-page">
        <% request.setAttribute("currentPage", "reports"); %>
        <jsp:include page="../inc/side-bar.jsp" />
        <div class="reports-main">
            <div class="reports-header">
                <div class="reports-title">
                    <h1>Generate Reports</h1>
                    <p>Operational and financial reports from the system</p>
                </div>
                <div class="date-range">
                    <div class="date-field">
                        <i class="ri-calendar-line"></i>
                        <input type="date" value="2024-01-01">
                    </div>
                    <span style="color:var(--muted);font-weight:600;">to</span>
                    <div class="date-field">
                        <i class="ri-calendar-line"></i>
                        <input type="date" value="2024-01-31">
                    </div>
                </div>
            </div>

            <div class="stats-grid">
                <div class="stat-card">
                    <span class="stat-label">Total Revenue</span>
                    <span class="stat-value">$91,000</span>
                    <span class="stat-sub success"><i class="ri-arrow-up-s-line"></i>+12.5%</span>
                </div>
                <div class="stat-card">
                    <span class="stat-label">Total Appointments</span>
                    <span class="stat-value">624</span>
                    <span class="stat-sub"><i class="ri-check-line"></i><a href="#">94.2% completed</a></span>
                </div>
                <div class="stat-card">
                    <span class="stat-label">Avg Transaction</span>
                    <span class="stat-value">$76.5</span>
                    <span class="stat-sub"><i class="ri-medal-line"></i><a href="#">Top: Dog Grooming</a></span>
                </div>
                <div class="stat-card">
                    <span class="stat-label">Customer Rating</span>
                    <span class="stat-value">4.7 / 5.0</span>
                    <span class="stat-sub"><i class="ri-time-line"></i>Avg duration: 67 min</span>
                </div>
            </div>

            <div class="reports-tabs">
                <button class="reports-tab active" type="button" data-target="financial"><i class="ri-bar-chart-line"></i>Financial Reports</button>
                <button class="reports-tab" type="button" data-target="operational"><i class="ri-pie-chart-line"></i>Operational Reports</button>
            </div>

            <div class="reports-content">
                <div class="reports-panel active" data-panel="financial">
                    <div class="chart-grid">
                        <div class="card">
                            <div class="card-header">
                                <h2>Monthly Revenue Trend</h2>
                                <div class="export-group">
                                    <span class="chip"><i class="ri-file-pdf-line"></i>PDF</span>
                                    <span class="chip"><i class="ri-file-excel-line"></i>Excel</span>
                                </div>
                            </div>
                            <div class="chart-wrapper">
                                <canvas id="revenueTrendChart"></canvas>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-header">
                                <h2>Revenue by Service</h2>
                                <div class="export-group">
                                    <span class="chip"><i class="ri-file-download-line"></i>PDF</span>
                                </div>
                            </div>
                            <div class="chart-wrapper pie">
                                <canvas id="servicePieChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <div class="card table-card">
                        <div class="card-header">
                            <h2>Detailed Financial Report</h2>
                            <div class="table-actions">
                                <button class="action-btn primary" type="button"><i class="ri-bar-chart-2-line"></i>Generate Report</button>
                                <button class="action-btn secondary" type="button"><i class="ri-printer-line"></i>Print</button>
                            </div>
                        </div>
                        <table>
                            <thead>
                            <tr>
                                <th>Service Category</th>
                                <th>Bookings</th>
                                <th>Revenue</th>
                                <th>Avg Price</th>
                                <th>Growth</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>Dog Grooming</td>
                                <td>35</td>
                                <td>$8,750</td>
                                <td>$250.00</td>
                                <td><span class="growth up"><i class="ri-arrow-up-s-line"></i>+18%</span></td>
                            </tr>
                            <tr>
                                <td>Cat Grooming</td>
                                <td>25</td>
                                <td>$5,500</td>
                                <td>$220.00</td>
                                <td><span class="growth up"><i class="ri-arrow-up-s-line"></i>+12%</span></td>
                            </tr>
                            <tr>
                                <td>Health Checkup</td>
                                <td>20</td>
                                <td>$6,300</td>
                                <td>$315.00</td>
                                <td><span class="growth flat"><i class="ri-subtract-line"></i>0%</span></td>
                            </tr>
                            <tr>
                                <td>Vaccination</td>
                                <td>15</td>
                                <td>$4,800</td>
                                <td>$320.00</td>
                                <td><span class="growth down"><i class="ri-arrow-down-s-line"></i>-6%</span></td>
                            </tr>
                            <tr>
                                <td>Training</td>
                                <td>5</td>
                                <td>$1,200</td>
                                <td>$240.00</td>
                                <td><span class="growth down"><i class="ri-arrow-down-s-line"></i>-7%</span></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="reports-panel" data-panel="operational">
                    <div class="chart-grid">
                        <div class="card">
                            <div class="card-header">
                                <h2>Service Volume Trends</h2>
                                <span class="chip"><i class="ri-download-2-line"></i>Export</span>
                            </div>
                            <div class="chart-wrapper">
                                <canvas id="serviceVolumeChart"></canvas>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-header">
                                <h2>Customer Acquisition</h2>
                                <span class="chip"><i class="ri-download-2-line"></i>Export</span>
                            </div>
                            <div class="chart-wrapper">
                                <canvas id="customerAcquisitionChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h2>Operational Metrics</h2>
                        </div>
                        <div class="metrics-grid">
                            <div class="metric-tile">
                                <div class="metric-label">Appointment Utilization</div>
                                <div class="metric-value">87.3%</div>
                            </div>
                            <div class="metric-tile">
                                <div class="metric-label">On-time Performance</div>
                                <div class="metric-value">92.1%</div>
                            </div>
                            <div class="metric-tile">
                                <div class="metric-label">Average Wait Time</div>
                                <div class="metric-value">12 min</div>
                            </div>
                            <div class="metric-tile">
                                <div class="metric-label">Staff Productivity</div>
                                <div class="metric-value">94.5%</div>
                            </div>
                            <div class="metric-tile">
                                <div class="metric-label">Customer Satisfaction</div>
                                <div class="metric-value">4.8 / 5</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const tabs = document.querySelectorAll('.reports-tab');
        const panels = document.querySelectorAll('.reports-panel');

        tabs.forEach((tab) => {
            tab.addEventListener('click', () => {
                const target = tab.getAttribute('data-target');
                tabs.forEach((btn) => btn.classList.toggle('active', btn === tab));
                panels.forEach((panel) => panel.classList.toggle('active', panel.dataset.panel === target));
            });
        });

        const createChart = (id, config) => {
            const canvas = document.getElementById(id);
            if (!canvas) {
                return null;
            }
            return new Chart(canvas, config);
        };

        createChart('revenueTrendChart', {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: 'Revenue',
                    data: [15500, 17800, 16900, 19000, 21000, 22400],
                    borderColor: '#2563eb',
                    backgroundColor: 'rgba(37,99,235,0.18)',
                    borderWidth: 3,
                    tension: 0.38,
                    fill: true,
                    pointRadius: 4,
                    pointBackgroundColor: '#2563eb'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: { mode: 'index', intersect: false }
                },
                scales: {
                    x: {
                        grid: { display: false },
                        ticks: { color: '#6b7280' }
                    },
                    y: {
                        beginAtZero: false,
                        grid: { color: 'rgba(148,163,184,0.25)', borderDash: [6, 6] },
                        ticks: { color: '#6b7280' }
                    }
                }
            }
        });

        createChart('servicePieChart', {
            type: 'doughnut',
            data: {
                labels: ['Dog Grooming 35%', 'Cat Grooming 25%', 'Health Checkup 20%', 'Vaccination 15%', 'Training 5%'],
                datasets: [{
                    data: [35, 25, 20, 15, 5],
                    backgroundColor: ['#2563eb', '#22c55e', '#f59e0b', '#f97316', '#a855f7'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '62%',
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: (context) => context.label
                        }
                    }
                }
            }
        });

        createChart('serviceVolumeChart', {
            type: 'bar',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: 'Completed Services',
                    data: [84, 88, 92, 104, 116, 128],
                    backgroundColor: '#2563eb',
                    borderRadius: 12,
                    barThickness: 30
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    x: {
                        grid: { display: false },
                        ticks: { color: '#6b7280' }
                    },
                    y: {
                        beginAtZero: true,
                        grid: { color: 'rgba(148,163,184,0.25)', borderDash: [6, 6] },
                        ticks: { color: '#6b7280' }
                    }
                }
            }
        });

        createChart('customerAcquisitionChart', {
            type: 'bar',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [
                    {
                        label: 'New Customers',
                        data: [24, 28, 34, 38, 42, 47],
                        backgroundColor: '#2563eb',
                        borderRadius: 12,
                        barThickness: 24
                    },
                    {
                        label: 'Returning Customers',
                        data: [18, 20, 24, 29, 33, 38],
                        backgroundColor: '#22c55e',
                        borderRadius: 12,
                        barThickness: 24
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'bottom',
                        labels: {
                            usePointStyle: true,
                            padding: 20
                        }
                    }
                },
                scales: {
                    x: {
                        grid: { display: false },
                        ticks: { color: '#6b7280' }
                    },
                    y: {
                        beginAtZero: true,
                        grid: { color: 'rgba(148,163,184,0.25)', borderDash: [6, 6] },
                        ticks: { color: '#6b7280' }
                    }
                }
            }
        });
    });
</script>
<jsp:include page="../inc/chatbox.jsp" />
<jsp:include page="../inc/footer.jsp" />
