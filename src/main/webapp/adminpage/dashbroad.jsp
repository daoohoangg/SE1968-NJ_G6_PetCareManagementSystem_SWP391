<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<title>Dashboard</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<style>
    :root{
        --primary:#2563eb;
        --primary-soft:#e8f0ff;
        --success:#16a34a;
        --warning:#f97316;
        --danger:#dc2626;
        --text:#111827;
        --muted:#6b7280;
        --bg:#f7f9fc;
        --line:#e5e7eb;
        --surface:#ffffff;
        --shadow:0 18px 40px rgba(15,23,42,.08);
    }
    .dashboard-page{
        display:flex;
        background:var(--bg);
        font-family:Inter,system-ui,Segoe UI,Roboto,Arial,sans-serif;
        color:var(--text);
        width:100%;
    }
    .dashboard-main{
        flex:1;
        padding:32px 40px;
        display:flex;
        flex-direction:column;
        gap:24px;
    }
    .dashboard-header{
        display:flex;
        align-items:flex-start;
        justify-content:space-between;
        gap:20px;
        flex-wrap:wrap;
    }
    .dashboard-title h1{
        margin:0;
        font-size:28px;
        font-weight:600;
    }
    .dashboard-title p{
        margin:8px 0 0;
        color:var(--muted);
        font-size:14px;
    }
    .quick-actions{
        display:flex;
        flex-wrap:wrap;
        gap:12px;
    }
    .action-btn{
        display:inline-flex;
        align-items:center;
        gap:8px;
        border-radius:12px;
        padding:10px 16px;
        font-size:14px;
        font-weight:600;
        text-decoration:none;
        border:1px solid transparent;
        transition:filter .18s, box-shadow .18s, transform .18s;
    }
    .action-btn i{font-size:18px}
    .action-btn.primary{
        background:var(--primary);
        color:#fff;
        box-shadow:0 12px 30px rgba(37,99,235,.25);
    }
    .action-btn.success{
        background:var(--success);
        color:#fff;
        box-shadow:0 12px 28px rgba(22,163,74,.2);
    }
    .action-btn.danger{
        background:var(--danger);
        color:#fff;
        box-shadow:0 12px 28px rgba(220,38,38,.2);
    }
    .action-btn.secondary{
        background:#fff;
        color:var(--text);
        border-color:var(--line);
    }
    .action-btn:hover{filter:brightness(.95);transform:translateY(-1px)}
    .stats-grid{
        display:grid;
        grid-template-columns:repeat(auto-fit,minmax(200px,1fr));
        gap:18px;
    }
    .card{
        background:var(--surface);
        border:1px solid rgba(148,163,184,.2);
        border-radius:20px;
        padding:20px 22px;
        box-shadow:var(--shadow);
        display:flex;
        flex-direction:column;
        gap:18px;
        min-height:0;
    }
    .stat-card{
        flex-direction:row;
        align-items:flex-start;
        gap:16px;
        padding:18px;
    }
    .stat-icon{
        width:46px;
        height:46px;
        border-radius:14px;
        display:flex;
        align-items:center;
        justify-content:center;
        background:var(--primary-soft);
        color:var(--primary);
        font-size:22px;
        flex-shrink:0;
    }
    .stat-card.success .stat-icon{
        background:rgba(22,163,74,.12);
        color:var(--success);
    }
    .stat-card.warning .stat-icon{
        background:rgba(249,115,22,.15);
        color:var(--warning);
    }
    .stat-card.info .stat-icon{
        background:rgba(79,70,229,.12);
        color:#4f46e5;
    }
    .stat-card.emergency .stat-icon{
        background:rgba(220,38,38,.15);
        color:var(--danger);
    }
    .stat-meta{
        display:flex;
        flex-direction:column;
        gap:4px;
    }
    .stat-label{
        font-size:13px;
        color:var(--muted);
        font-weight:500;
        text-transform:uppercase;
        letter-spacing:.04em;
    }
    .stat-value{
        font-size:22px;
        font-weight:700;
        color:var(--text);
    }
    .stat-sub{
        font-size:12px;
        color:var(--muted);
        line-height:1.4;
    }
    .card-head{
        display:flex;
        align-items:flex-start;
        justify-content:space-between;
        gap:12px;
    }
    .card-head h2{
        margin:0;
        font-size:18px;
        font-weight:600;
        color:var(--text);
    }
    .card-head p{
        margin:4px 0 0;
        font-size:13px;
        color:var(--muted);
    }
    .ghost-btn,
    .ghost-link{
        display:inline-flex;
        align-items:center;
        gap:6px;
        font-size:13px;
        font-weight:600;
        color:var(--primary);
        background:none;
        border:none;
        text-decoration:none;
        cursor:pointer;
        padding:6px 10px;
        border-radius:999px;
        transition:background .18s;
    }
    .ghost-btn:hover,
    .ghost-link:hover{
        background:var(--primary-soft);
        text-decoration:none;
    }
    .charts-grid{
        display:grid;
        grid-template-columns:minmax(0,2.1fr) minmax(0,1.4fr);
        gap:20px;
    }
    .chart-wrapper{
        position:relative;
        width:100%;
        height:260px;
    }
    .chart-wrapper.pie{height:240px}
    .legend{
        list-style:none;
        margin:0;
        padding:0;
        display:grid;
        grid-template-columns:repeat(2,minmax(0,1fr));
        gap:10px;
        font-size:13px;
        color:var(--muted);
    }
    .legend li{display:flex;align-items:center;gap:8px}
    .legend strong{color:var(--text)}
    .dot{
        width:10px;
        height:10px;
        border-radius:50%;
        display:inline-block;
    }
    .dot.grooming{background:#2563eb}
    .dot.veterinary{background:#16a34a}
    .dot.training{background:#f97316}
    .dot.boarding{background:#f59e0b}
    .dot.daycare{background:#ef4444}
    .split-grid{
        display:grid;
        grid-template-columns:repeat(auto-fit,minmax(300px,1fr));
        gap:20px;
    }
    .activity-list,
    .schedule-list,
    .staff-list{
        list-style:none;
        margin:0;
        padding:0;
        display:flex;
        flex-direction:column;
        gap:14px;
    }
    .activity-item,
    .schedule-item{
        display:flex;
        align-items:flex-start;
        gap:16px;
        padding:16px;
        border:1px solid var(--line);
        border-radius:16px;
        background:#fff;
        box-shadow:0 10px 24px rgba(15,23,42,.08);
    }
    .activity-item:hover,
    .schedule-item:hover{
        border-color:rgba(37,99,235,.25);
    }
    .activity-icon,
    .schedule-icon{
        width:42px;
        height:42px;
        border-radius:12px;
        display:flex;
        align-items:center;
        justify-content:center;
        background:var(--primary-soft);
        color:var(--primary);
        font-size:18px;
        flex-shrink:0;
    }
    .activity-item.urgent .activity-icon{
        background:rgba(220,38,38,.1);
        color:var(--danger);
    }
    .activity-info strong,
    .schedule-info strong{
        display:block;
        font-size:15px;
        color:var(--text);
    }
    .activity-info span,
    .schedule-info span{
        font-size:13px;
        color:var(--muted);
    }
    .activity-meta,
    .schedule-meta{
        margin-left:auto;
        display:flex;
        flex-direction:column;
        align-items:flex-end;
        gap:6px;
        font-size:12px;
        color:var(--muted);
        text-transform:capitalize;
    }
    .schedule-meta{
        align-items:flex-end;
        font-size:13px;
    }
    .time{
        font-weight:600;
        color:var(--text);
    }
    .badge{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        padding:4px 10px;
        border-radius:999px;
        font-size:11px;
        font-weight:700;
        letter-spacing:.04em;
        text-transform:uppercase;
    }
    .badge.in-progress{
        background:rgba(8,145,178,.15);
        color:#0e7490;
    }
    .badge.upcoming{
        background:rgba(37,99,235,.15);
        color:var(--primary);
    }
    .badge.urgent{
        background:rgba(220,38,38,.15);
        color:var(--danger);
    }
    .badge.success{
        background:rgba(22,163,74,.15);
        color:var(--success);
    }
    .staff-card .card-head{
        flex-direction:column;
        align-items:flex-start;
        gap:6px;
    }
    .staff-list li{
        display:flex;
        align-items:center;
        justify-content:space-between;
        gap:16px;
        padding:14px 0;
        border-top:1px solid var(--line);
    }
    .staff-list li:first-child{border-top:none;padding-top:0}
    .staff-info{
        display:flex;
        align-items:center;
        gap:14px;
    }
    .staff-avatar{
        width:44px;
        height:44px;
        border-radius:14px;
        background:var(--primary-soft);
        color:var(--primary);
        font-weight:700;
        display:flex;
        align-items:center;
        justify-content:center;
    }
    .staff-info span{
        font-size:13px;
        color:var(--muted);
    }
    .staff-meta{
        display:flex;
        align-items:center;
        gap:18px;
        font-size:14px;
        font-weight:600;
    }
    .rating{
        display:inline-flex;
        align-items:center;
        gap:4px;
        color:#f59e0b;
    }
    .rating i{font-size:16px}
    .amount{color:var(--text)}
    @media (max-width:1024px){
        .dashboard-main{padding:28px 28px}
        .charts-grid{grid-template-columns:1fr}
        .chart-wrapper{height:240px}
    }
    @media (max-width:768px){
        .dashboard-main{padding:24px 18px}
        .dashboard-header{flex-direction:column;align-items:flex-start}
        .quick-actions{width:100%}
        .action-btn{flex:1;justify-content:center}
        .split-grid{grid-template-columns:1fr}
    }
    @media (max-width:520px){
        .stats-grid{grid-template-columns:1fr}
    }
</style>

<jsp:include page="../inc/header.jsp" />
<main class="content-wrapper">
    <section class="page dashboard-page">
        <% request.setAttribute("activePage", "dashboard"); %>
        <jsp:include page="../inc/side-bar.jsp" />
        <div class="dashboard-main">
            <div class="dashboard-header">
                <div class="dashboard-title">
                    <h1>Dashboard</h1>
                    <p>Welcome back! Here's a snapshot of operations across PetCare.</p>
                </div>
                <div class="quick-actions">
                    <a class="action-btn primary" href="#"><i class="ri-add-line"></i>New Appointment</a>
                    <a class="action-btn success" href="#"><i class="ri-user-add-line"></i>Add Customer</a>
                    <a class="action-btn danger" href="#"><i class="ri-alarm-warning-line"></i>Emergency Alert</a>
                    <a class="action-btn secondary" href="#"><i class="ri-bar-chart-line"></i>View Reports</a>
                </div>
            </div>

            <div class="stats-grid">
                <div class="card stat-card">
                    <div class="stat-icon"><i class="ri-sun-cloudy-line"></i></div>
                    <div class="stat-meta">
                        <span class="stat-label">Weather Today</span>
                        <span class="stat-value">
                            <c:choose>
                                <c:when test="${not empty weatherTemperatureC}">
                                    <fmt:formatNumber value="${weatherTemperatureC}" minFractionDigits="0" maxFractionDigits="1"/>&deg;C
                                </c:when>
                                <c:otherwise>--&deg;C</c:otherwise>
                            </c:choose>
                        </span>
                        <span class="stat-sub">
                            <c:out value="${empty weatherSummary ? 'Comfortable conditions for outdoor activities' : weatherSummary}"/>
                        </span>
                    </div>
                </div>
                <div class="card stat-card success">
                    <div class="stat-icon"><i class="ri-checkbox-circle-line"></i></div>
                    <div class="stat-meta">
                        <span class="stat-label">System Status</span>
                        <span class="stat-value">All Systems Operational</span>
                        <span class="stat-sub">No incidents reported</span>
                    </div>
                </div>
                <div class="card stat-card info">
                    <div class="stat-icon"><i class="ri-nurse-line"></i></div>
                    <div class="stat-meta">
                        <span class="stat-label">Emergency Contact</span>
                        <span class="stat-value">Dr. Sarah Wilson</span>
                        <span class="stat-sub">(858) 132-4567</span>
                    </div>
                </div>
                <div class="card stat-card warning">
                    <div class="stat-icon"><i class="ri-group-line"></i></div>
                    <div class="stat-meta">
                        <span class="stat-label">Total Customers</span>
                        <span class="stat-value">
                            <c:choose>
                                <c:when test="${not empty totalCustomers}">
                                    <fmt:formatNumber value="${totalCustomers}" type="number" groupingUsed="true"/>
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </span>
                        <span class="stat-sub">Registered customers</span>
                    </div>
                </div>
                <div class="card stat-card">
                    <div class="stat-icon"><i class="ri-hearts-line"></i></div>
                    <div class="stat-meta">
                        <span class="stat-label">Happy Pets</span>
                        <span class="stat-value">
                            <c:choose>
                                <c:when test="${not empty happyPets}">
                                    <fmt:formatNumber value="${happyPets}" type="number" groupingUsed="true"/>
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </span>
                        <span class="stat-sub">Pets under our care</span>
                    </div>
                </div>
                <div class="card stat-card emergency">
                    <div class="stat-icon"><i class="ri-calendar-check-line"></i></div>
                    <div class="stat-meta">
                        <span class="stat-label">Pending Appointments</span>
                        <span class="stat-value">
                            <c:choose>
                                <c:when test="${not empty pendingAppointments}">
                                    <fmt:formatNumber value="${pendingAppointments}" type="number" groupingUsed="true"/>
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </span>
                        <span class="stat-sub">Awaiting service completion</span>
                    </div>
                </div>
            </div>

            <div class="charts-grid">
                <div class="card">
                    <div class="card-head">
                        <div>
                            <h2>Revenue Trends</h2>
                            <p>Last 6 Months</p>
                        </div>
                        <button class="ghost-btn" type="button"><i class="ri-download-2-line"></i>Export</button>
                    </div>
                    <div class="chart-wrapper">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>
                <div class="card">
                    <div class="card-head">
                        <div>
                            <h2>Service Distribution</h2>
                            <p>Current Month</p>
                        </div>
                    </div>
                    <div class="chart-wrapper pie">
                        <canvas id="serviceChart"></canvas>
                    </div>
                    <ul class="legend">
                        <li><span class="dot grooming"></span>Grooming <strong>35%</strong></li>
                        <li><span class="dot veterinary"></span>Veterinary <strong>28%</strong></li>
                        <li><span class="dot training"></span>Training <strong>18%</strong></li>
                        <li><span class="dot boarding"></span>Boarding <strong>12%</strong></li>
                        <li><span class="dot daycare"></span>Daycare <strong>7%</strong></li>
                    </ul>
                </div>
            </div>

            <div class="split-grid">
                <div class="card">
                    <div class="card-head">
                        <h2>Recent Activities</h2>
                        <a class="ghost-link" href="#">View All</a>
                    </div>
                    <ul class="activity-list">
                        <c:choose>
                            <c:when test="${not empty recentActivities}">
                                <c:forEach var="activity" items="${recentActivities}">
                                    <li class="activity-item${activity.urgent ? ' urgent' : ''}">
                                        <div class="activity-icon"><i class="${empty activity.icon ? 'ri-calendar-event-line' : activity.icon}"></i></div>
                                        <div class="activity-info">
                                            <strong>${activity.primaryText}</strong>
                                            <c:if test="${not empty activity.secondaryText}">
                                                <span>${activity.secondaryText}</span>
                                            </c:if>
                                        </div>
                                        <div class="activity-meta">
                                            <c:if test="${not empty activity.badgeLabel}">
                                                <span class="badge ${empty activity.badgeClass ? 'in-progress' : activity.badgeClass}">${activity.badgeLabel}</span>
                                            </c:if>
                                            <time>${activity.timeLabel}</time>
                                        </div>
                                    </li>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <li class="activity-item">
                                    <div class="activity-icon"><i class="ri-information-line"></i></div>
                                    <div class="activity-info">
                                        <strong>No recent activities yet</strong>
                                        <span>Service updates will appear here once recorded.</span>
                                    </div>
                                    <div class="activity-meta">
                                        <span class="badge upcoming">Waiting</span>
                                        <time>--</time>
                                    </div>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>

                <div class="card">
                    <div class="card-head">
                        <h2>Schedule</h2>
                        <a class="ghost-link" href="#">Full Calendar</a>
                    </div>
                    <ul class="schedule-list">
                        <c:choose>
                            <c:when test="${not empty upcomingSchedule}">
                                <c:forEach var="item" items="${upcomingSchedule}">
                                    <li class="schedule-item">
                                        <div class="schedule-icon"><i class="${empty item.icon ? 'ri-calendar-event-line' : item.icon}"></i></div>
                                        <div class="schedule-info">
                                            <strong>${item.primaryText}</strong>
                                            <c:if test="${not empty item.secondaryText}">
                                                <span>${item.secondaryText}</span>
                                            </c:if>
                                        </div>
                                        <div class="schedule-meta">
                                            <span class="time">${item.timeLabel}</span>
                                            <c:if test="${not empty item.badgeLabel}">
                                                <span class="badge ${empty item.badgeClass ? 'upcoming' : item.badgeClass}">${item.badgeLabel}</span>
                                            </c:if>
                                        </div>
                                    </li>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <li class="schedule-item">
                                    <div class="schedule-icon"><i class="ri-calendar-event-line"></i></div>
                                    <div class="schedule-info">
                                        <strong>No upcoming appointments</strong>
                                        <span>You're all caught up for now.</span>
                                    </div>
                                    <div class="schedule-meta">
                                        <span class="time">--</span>
                                        <span class="badge success">Relax</span>
                                    </div>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>

            <div class="card staff-card">
                <div class="card-head">
                    <h2>Staff Performance</h2>
                    <p>Highlights from the team</p>
                </div>
                <ul class="staff-list">
                    <li>
                        <div class="staff-info">
                            <div class="staff-avatar">SW</div>
                            <div>
                                <strong>Dr. Sarah Wilson</strong>
                                <span>Veterinarian &middot; 23 appointments</span>
                            </div>
                        </div>
                        <div class="staff-meta">
                            <span class="rating"><i class="ri-star-fill"></i>4.9</span>
                            <span class="amount">$4,580</span>
                        </div>
                    </li>
                    <li>
                        <div class="staff-info">
                            <div class="staff-avatar">MJ</div>
                            <div>
                                <strong>Mike Johnson</strong>
                                <span>Groomer &middot; 18 appointments</span>
                            </div>
                        </div>
                        <div class="staff-meta">
                            <span class="rating"><i class="ri-star-fill"></i>4.8</span>
                            <span class="amount">$3,720</span>
                        </div>
                    </li>
                    <li>
                        <div class="staff-info">
                            <div class="staff-avatar">ED</div>
                            <div>
                                <strong>Emma Davis</strong>
                                <span>Trainer &middot; 12 appointments</span>
                            </div>
                        </div>
                        <div class="staff-meta">
                            <span class="rating"><i class="ri-star-fill"></i>4.7</span>
                            <span class="amount">$2,180</span>
                        </div>
                    </li>
                    <li>
                        <div class="staff-info">
                            <div class="staff-avatar">AC</div>
                            <div>
                                <strong>Alex Chen</strong>
                                <span>Caregiver &middot; 8 appointments</span>
                            </div>
                        </div>
                        <div class="staff-meta">
                            <span class="rating"><i class="ri-star-fill"></i>4.9</span>
                            <span class="amount">$1,640</span>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </section>
</main>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const revenueCtx = document.getElementById('revenueChart');
    if (revenueCtx) {
        new Chart(revenueCtx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: 'Revenue',
                    data: [15200, 17450, 18900, 20500, 22800, 24650],
                    fill: true,
                    borderColor: '#2563eb',
                    backgroundColor: 'rgba(37,99,235,0.16)',
                    tension: 0.38,
                    borderWidth: 3,
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
                        beginAtZero: true,
                        grid: { color: 'rgba(148,163,184,0.25)', borderDash: [6, 6] },
                        ticks: { color: '#6b7280' }
                    }
                }
            }
        });
    }

    const serviceCtx = document.getElementById('serviceChart');
    if (serviceCtx) {
        new Chart(serviceCtx, {
            type: 'doughnut',
            data: {
                labels: ['Grooming', 'Veterinary', 'Training', 'Boarding', 'Daycare'],
                datasets: [{
                    data: [35, 28, 18, 12, 7],
                    backgroundColor: ['#2563eb', '#16a34a', '#f97316', '#f59e0b', '#ef4444'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: { callbacks: { label: (tooltipItem) => tooltipItem.label + ': ' + tooltipItem.parsed + '%' } }
                },
                cutout: '62%'
            }
        });
    }
</script>
<jsp:include page="../inc/chatbox.jsp" />
<jsp:include page="../inc/footer.jsp" />
