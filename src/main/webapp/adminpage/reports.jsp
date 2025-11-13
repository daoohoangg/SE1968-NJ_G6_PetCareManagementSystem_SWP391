<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<title>Generate Reports</title>
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
    .staff-card{
        gap:20px;
    }
    .staff-card .card-header{
        flex-direction:column;
        align-items:flex-start;
        gap:6px;
    }
    .staff-list{
        list-style:none;
        margin:0;
        padding:0;
        display:flex;
        flex-direction:column;
        gap:14px;
    }
    .staff-list li{
        display:flex;
        align-items:center;
        justify-content:space-between;
        gap:16px;
        padding:14px 0;
        border-top:1px solid var(--line);
    }
    .staff-list li:first-child{
        border-top:none;
        padding-top:0;
    }
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
        font-size:14px;
    }
    .staff-info strong{
        display:block;
        font-size:15px;
        color:var(--text);
        margin-bottom:4px;
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
    .staff-meta .amount{
        color:var(--primary);
        font-size:16px;
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
        <% request.setAttribute("activePage", "reports"); %>
        <jsp:include page="../inc/side-bar.jsp" />
        <div class="reports-main">
            <div class="reports-header">
                <div class="reports-title">
                    <h1>Generate Reports</h1>
                    <p>Operational and financial reports from the system</p>
                </div>
            </div>

            <div class="stats-grid">
                <div class="stat-card">
                    <span class="stat-label">Total Revenue</span>
                    <span class="stat-value">
                        <c:choose>
                            <c:when test="${not empty totalRevenue}">
                                $<fmt:formatNumber value="${totalRevenue}" type="number" minFractionDigits="2" maxFractionDigits="2" groupingUsed="true"/>
                            </c:when>
                            <c:otherwise>$0.00</c:otherwise>
                        </c:choose>
                    </span>
                    <span class="stat-sub success"><i class="ri-arrow-up-s-line"></i>+12.5%</span>
                </div>
                <div class="stat-card">
                    <span class="stat-label">Total Appointments</span>
                    <span class="stat-value">
                        <c:choose>
                            <c:when test="${not empty totalAppointments}">
                                <fmt:formatNumber value="${totalAppointments}" type="number" groupingUsed="true"/>
                            </c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </span>
                    <span class="stat-sub">
                        <i class="ri-check-line"></i>
                        <a href="#">
                            <c:choose>
                                <c:when test="${not empty completionRate}">
                                    <fmt:formatNumber value="${completionRate}" type="number" minFractionDigits="1" maxFractionDigits="1"/>% completed
                                </c:when>
                                <c:otherwise>0% completed</c:otherwise>
                            </c:choose>
                        </a>
                    </span>
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
                            <!-- Hidden data container for daily revenue data (Monthly Revenue Trend) -->
                            <!-- Trục x: các ngày trong tháng (1, 2, 3, ..., 31) -->
                            <!-- Trục y: doanh thu (total_amount từ appointments COMPLETED) -->
                            <div id="revenueDataContainer" style="display:none;" data-revenue='<c:choose><c:when test="${not empty initialDailyRevenue}">[<c:forEach var="day" items="${initialDailyRevenue}" varStatus="status">{"day":<c:out value="${day.day}"/>,"revenue":<c:choose><c:when test="${day.revenue != null}"><fmt:formatNumber value="${day.revenue}" type="number" minFractionDigits="2" maxFractionDigits="2" groupingUsed="false"/></c:when><c:otherwise>0</c:otherwise></c:choose>}<c:if test="${!status.last}">,</c:if></c:forEach>]</c:when><c:otherwise>[]</c:otherwise></c:choose>'></div>
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

                    <!-- Detailed Financial Report - Tạm thời ẩn -->
                    <div class="card table-card" style="display: none;">
                        <div class="card-header">
                            <h2>Detailed Financial Report</h2>
                            <div class="table-actions">
                                <button class="action-btn secondary" type="button" id="printReportBtn"><i class="ri-printer-line"></i>Print</button>
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
                            <tbody id="financialReportTableBody">
                            <!-- Debug: serviceRevenue = ${serviceRevenue}, length = ${fn:length(serviceRevenue)} -->
                            <c:choose>
                                <c:when test="${not empty serviceRevenue}">
                                    <c:forEach var="service" items="${serviceRevenue}">
                                        <c:set var="serviceName" value="${service.name}"/>
                                        <c:set var="bookings" value="${service.bookings}"/>
                                        <c:set var="revenue" value="${service.revenue}"/>
                                        <c:set var="avgPrice" value="${service.avgPrice}"/>
                                        <c:set var="growth" value="${service.growth}"/>
                                        <tr>
                                            <td><c:out value="${serviceName}"/></td>
                                            <td><fmt:formatNumber value="${bookings}" type="number" groupingUsed="true"/></td>
                                            <td>$<fmt:formatNumber value="${revenue}" type="number" minFractionDigits="2" maxFractionDigits="2" groupingUsed="true"/></td>
                                            <td>$<fmt:formatNumber value="${avgPrice}" type="number" minFractionDigits="2" maxFractionDigits="2" groupingUsed="true"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty growth and growth != '0%'}">
                                                        <c:set var="growthValue" value="${fn:replace(growth, '%', '')}"/>
                                                        <c:choose>
                                                            <c:when test="${growthValue > 0}">
                                                                <span class="growth up"><i class="ri-arrow-up-s-line"></i><c:out value="${growth}"/></span>
                                                            </c:when>
                                                            <c:when test="${growthValue < 0}">
                                                                <span class="growth down"><i class="ri-arrow-down-s-line"></i><c:out value="${growth}"/></span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="growth flat"><i class="ri-subtract-line"></i><c:out value="${growth}"/></span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="growth flat"><i class="ri-subtract-line"></i>0%</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                            </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" style="text-align:center;color:var(--muted);padding:20px;">
                                            No financial data available for the selected date range
                                        </td>
                            </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="reports-panel" data-panel="operational">
                    <div class="chart-grid">
                        <div class="card" style="grid-column: 1 / -1;">
                            <div class="card-header">
                                <h2>Service Volume Trends</h2>
                                <span class="chip"><i class="ri-download-2-line"></i>Export</span>
                            </div>
                            <div class="chart-wrapper">
                                <canvas id="serviceVolumeChart"></canvas>
                            </div>
                            <!-- Hidden data container for service volume data -->
                            <div id="serviceVolumeDataContainer" style="display:none;" data-volume='<c:choose><c:when test="${not empty initialServiceVolume}">[<c:forEach var="month" items="${initialServiceVolume}" varStatus="status">{"month":"<c:out value="${month.month}" escapeXml="true"/>","completed":<c:out value="${month.completed}"/>}<c:if test="${!status.last}">,</c:if></c:forEach>]</c:when><c:otherwise>[]</c:otherwise></c:choose>'></div>
                        </div>
                        <!-- Customer Acquisition - Tạm thời ẩn -->
                        <div class="card" style="display: none;">
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

                    <div class="card staff-card">
                        <div class="card-header">
                            <h2>Staff Performance</h2>
                            <p>Highlights from the team</p>
                        </div>
                        <ul class="staff-list">
                            <c:choose>
                                <c:when test="${not empty staffPerformance}">
                                    <c:forEach var="staff" items="${staffPerformance}">
                                        <c:set var="fullName" value="${staff.fullName}"/>
                                        <c:set var="specialization" value="${staff.specialization}"/>
                                        <c:set var="completedCount" value="${staff.completedCount}"/>
                                        <c:set var="totalRevenue" value="${staff.totalRevenue}"/>
                                        
                                        <%-- Generate avatar initials from full name --%>
                                        <c:set var="nameParts" value="${fn:split(fullName, ' ')}"/>
                                        <c:set var="initials" value=""/>
                                        <c:choose>
                                            <c:when test="${fn:length(nameParts) >= 2}">
                                                <c:set var="initials" value="${fn:substring(nameParts[0], 0, 1)}${fn:substring(nameParts[fn:length(nameParts)-1], 0, 1)}"/>
                                            </c:when>
                                            <c:when test="${fn:length(nameParts) == 1}">
                                                <c:set var="initials" value="${fn:substring(nameParts[0], 0, 1)}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="initials" value="ST"/>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <li>
                                            <div class="staff-info">
                                                <div class="staff-avatar">${fn:toUpperCase(initials)}</div>
                                                <div>
                                                    <strong><c:out value="${fullName}"/></strong>
                                                    <span>
                                                        <c:out value="${empty specialization ? 'Staff' : specialization}"/>
                                                        &middot; 
                                                        <fmt:formatNumber value="${completedCount}" type="number"/>
                                                        <c:choose>
                                                            <c:when test="${completedCount == 1}"> appointment</c:when>
                                                            <c:otherwise> appointments</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="staff-meta">
                                                <span class="amount">$<fmt:formatNumber value="${totalRevenue}" type="number" minFractionDigits="2" maxFractionDigits="2" groupingUsed="true"/></span>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <li>
                                        <div class="staff-info">
                                            <div class="staff-avatar">--</div>
                                            <div>
                                                <strong>No staff performance data</strong>
                                                <span>No completed appointments found</span>
                                            </div>
                                        </div>
                                        <div class="staff-meta">
                                            <span class="amount">$0.00</span>
                                        </div>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Date range inputs - kiểm tra null/undefined để tránh lỗi
        const dateFieldInputs = document.querySelectorAll('.date-field input');
        const startDateInput = dateFieldInputs.length > 0 ? dateFieldInputs[0] : null;
        const endDateInput = dateFieldInputs.length > 1 ? dateFieldInputs[1] : null;
        
        // Generate Report button
        const generateReportBtn = document.getElementById('generateReportBtn');
        
        // Set default dates if not set (chỉ khi input tồn tại)
        if (startDateInput && (startDateInput.value === '' || !startDateInput.value)) {
            const startDate = new Date();
            startDate.setMonth(startDate.getMonth() - 1);
            startDateInput.value = startDate.toISOString().split('T')[0];
        }
        
        if (endDateInput && (endDateInput.value === '' || !endDateInput.value)) {
            const endDate = new Date();
            endDateInput.value = endDate.toISOString().split('T')[0];
        }
        
                 // Generate report handler
         if (generateReportBtn) {
             generateReportBtn.addEventListener('click', async () => {
                 const startDate = startDateInput ? startDateInput.value : '';
                 const endDate = endDateInput ? endDateInput.value : '';
                 
                 if (!startDate || !endDate) {
                     alert('Please select date range');
                     return;
                 }
                 
                 const originalText = generateReportBtn.innerHTML;
                 generateReportBtn.innerHTML = '<i class="ri-loader-4-line"></i> Generating...';
                 generateReportBtn.disabled = true;
                 
                 try {
                     // Get stats first
                     const statsResponse = await fetch('<%= request.getContextPath() %>/admin/reports/stats?' + 
                         new URLSearchParams({ startDate, endDate }), {
                         method: 'POST'
                     });
                     
                     const statsData = await statsResponse.json();
                     
                     if (statsData.success && statsData.stats) {
                         // Update stats cards
                         updateStatsCards(statsData.stats);
                     }
                     
                     // Get full report data for charts
                     const generateResponse = await fetch('<%= request.getContextPath() %>/admin/reports/generate?' + 
                         new URLSearchParams({ startDate, endDate }), {
                         method: 'POST'
                     });
                     
                     const generateData = await generateResponse.json();
                     
                     if (generateData.success && generateData.data) {
                         // Update financial charts
                         if (generateData.data.financial) {
                             updateFinancialCharts(generateData.data.financial);
                         }
                         
                         // Update operational charts
                         if (generateData.data.operational) {
                             updateOperationalCharts(generateData.data.operational);
                         }
                         
                         console.log('Report generated and charts updated successfully');
                     }
                 } catch (error) {
                     console.error('Generate report error:', error);
                     alert('Error: ' + error.message);
                 } finally {
                     generateReportBtn.innerHTML = originalText;
                     generateReportBtn.disabled = false;
                 }
             });
         }
        
        // Print report handler
        const printReportBtn = document.getElementById('printReportBtn');
        if (printReportBtn) {
            printReportBtn.addEventListener('click', () => {
                window.print();
            });
        }
        
        // Update stats cards with new data
        function updateStatsCards(stats) {
            const statValueElements = document.querySelectorAll('.stat-value');
            const statSubElements = document.querySelectorAll('.stat-sub');
            
            if (statValueElements.length >= 4 && statSubElements.length >= 4) {
                const totalRevenue = Number(stats.totalRevenue || 0);
                statValueElements[0].textContent = '$' + totalRevenue.toLocaleString(undefined, {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                });
                statSubElements[0].innerHTML = '<i class="ri-arrow-up-s-line"></i>' + stats.revenueGrowth;
                
                statValueElements[1].textContent = stats.totalAppointments;
                statSubElements[1].innerHTML = '<i class="ri-check-line"></i><a href="#">' + stats.completionRate + '% completed</a>';
                
                const averageTransaction = Number(stats.avgTransaction || 0);
                statValueElements[2].textContent = '$' + averageTransaction.toLocaleString(undefined, {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                });
                statSubElements[2].innerHTML = '<i class="ri-medal-line"></i><a href="#">Top: ' + stats.topService + '</a>';
                
                statValueElements[3].textContent = stats.customerRating + ' / 5.0';
                statSubElements[3].innerHTML = '<i class="ri-time-line"></i>Avg duration: ' + stats.avgDuration + ' min';
            }
        }
        
        // Load stats on page load
        loadStatsOnLoad();
        
        // Function to load stats when page loads
        function loadStatsOnLoad() {
            if (startDateInput && endDateInput && startDateInput.value && endDateInput.value) {
                setTimeout(() => {
                    if (generateReportBtn) {
                        generateReportBtn.click();
                    }
                }, 500);
            }
        }
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
                console.error('Canvas element not found:', id);
                return null;
            }
            
            // Destroy existing chart if exists
            const existingChart = Chart.getChart(canvas);
            if (existingChart) {
                existingChart.destroy();
            }
            
            try {
                const chart = new Chart(canvas, config);
                console.log('Chart created successfully:', id);
                return chart;
            } catch (e) {
                console.error('Error creating chart:', id, e);
                return null;
            }
        };

        // Revenue Trends Chart - Data from appointments.total_amount (COMPLETED status only)
        // Dữ liệu được lấy từ bảng appointments, cột total_amount, chỉ tính các appointments đã hoàn thành
        
        // Initialize revenue data from backend (appointments with COMPLETED status)
        // Lấy dữ liệu từ data attribute
        var initialRevenueData = [];
        try {
            var revenueDataContainer = document.getElementById('revenueDataContainer');
            if (revenueDataContainer) {
                var revenueDataJson = revenueDataContainer.getAttribute('data-revenue');
                console.log('Raw revenue data JSON:', revenueDataJson);
                if (revenueDataJson) {
                    initialRevenueData = JSON.parse(revenueDataJson);
                }
            }
        } catch (e) {
            console.error('Error parsing revenue data:', e);
            initialRevenueData = [];
        }
        
        console.log('Initial Revenue Data from appointments (COMPLETED):', initialRevenueData);
        console.log('Data length:', initialRevenueData.length);
        
        // Create chart with data from appointments (COMPLETED status only)
        const revenueChartCanvas = document.getElementById('revenueTrendChart');
        if (!revenueChartCanvas) {
            console.error('Revenue chart canvas not found!');
        } else {
            console.log('Revenue chart canvas found, creating chart...');
        }
        
        // Luôn tạo chart, dù có dữ liệu hay không
        // Monthly Revenue Trend: Trục x là các ngày trong tháng, Trục y là doanh thu
        if (initialRevenueData && initialRevenueData.length > 0) {
            console.log('Initial Daily Revenue Data from appointments (COMPLETED):', initialRevenueData);
            
            // Trục x: các ngày trong tháng (1, 2, 3, ..., 31)
            const revenueLabels = initialRevenueData.map(d => String(d.day));
            // Trục y: doanh thu
            const revenueData = initialRevenueData.map(d => {
                const val = parseFloat(d.revenue);
                return isNaN(val) ? 0 : val;
            });
            
            console.log('Chart Labels (Days):', revenueLabels);
            console.log('Chart Data (Revenue):', revenueData);
            
            if (revenueLabels.length === 0 || revenueData.length === 0) {
                console.error('Labels or data is empty!');
            }
            
            if (revenueLabels.length !== revenueData.length) {
                console.error('Labels and data length mismatch!', revenueLabels.length, 'vs', revenueData.length);
            }
            
            // Tạo chart với dữ liệu thực
            const chart = createChart('revenueTrendChart', {
            type: 'line',
            data: {
                    labels: revenueLabels,
                datasets: [{
                        label: 'Daily Revenue (from appointments.total_amount)',
                        data: revenueData,
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
                        tooltip: { 
                            mode: 'index', 
                            intersect: false,
                            callbacks: {
                                label: function(context) {
                                    return 'Revenue: $' + context.parsed.y.toLocaleString('en-US', {
                                        minimumFractionDigits: 2,
                                        maximumFractionDigits: 2
                                    });
                                }
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
                            ticks: { 
                                color: '#6b7280',
                                callback: function(value) {
                                    return '$' + value.toLocaleString('en-US');
                                }
                            }
                        }
                    }
                }
            });
            
            if (!chart) {
                console.error('Failed to create revenue chart with data!');
            }
        } else {
            // Fallback: Hiển thị chart rỗng nếu không có dữ liệu
            console.warn('No revenue data available from appointments. Data:', initialRevenueData);
            console.warn('Data length:', initialRevenueData ? initialRevenueData.length : 'null');
            
            // Tạo chart với dữ liệu rỗng - các ngày trong tháng (1-31)
            const emptyDays = Array.from({length: 31}, (_, i) => String(i + 1));
            const chart = createChart('revenueTrendChart', {
                type: 'line',
                data: {
                    labels: emptyDays,
                    datasets: [{
                        label: 'Daily Revenue',
                        data: Array(31).fill(0),
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
                            beginAtZero: true,
                        grid: { color: 'rgba(148,163,184,0.25)', borderDash: [6, 6] },
                        ticks: { color: '#6b7280' }
                    }
                }
            }
        });

            if (!chart) {
                console.error('Failed to create empty revenue chart!');
            }
        }
        
        // Đảm bảo servicePieChart được tạo
        const servicePieCanvas = document.getElementById('servicePieChart');
        if (!servicePieCanvas) {
            console.error('Service pie chart canvas not found!');
        } else {
            console.log('Service pie chart canvas found');
        }

        // Tạo service pie chart
        const servicePieChart = createChart('servicePieChart', {
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
        
        if (!servicePieChart) {
            console.error('Failed to create service pie chart!');
        } else {
            console.log('Service pie chart created successfully!');
        }

        // Load service volume data from hidden container
        const serviceVolumeContainer = document.getElementById('serviceVolumeDataContainer');
        let initialServiceVolume = [];
        if (serviceVolumeContainer) {
            try {
                const volumeDataAttr = serviceVolumeContainer.getAttribute('data-volume');
                if (volumeDataAttr) {
                    initialServiceVolume = JSON.parse(volumeDataAttr);
                    console.log('Service Volume Data from appointments (COMPLETED):', initialServiceVolume);
                }
            } catch (e) {
                console.error('Error parsing service volume data:', e);
                initialServiceVolume = [];
            }
        }

        // Tạo service volume chart với dữ liệu từ database
        if (initialServiceVolume && initialServiceVolume.length > 0) {
            const labels = initialServiceVolume.map(m => m.month || 'Unknown');
            const data = initialServiceVolume.map(m => parseInt(m.completed) || 0);
            
            console.log('Service Volume Chart Labels:', labels);
            console.log('Service Volume Chart Data:', data);

        createChart('serviceVolumeChart', {
            type: 'bar',
            data: {
                    labels: labels,
                datasets: [{
                    label: 'Completed Services',
                        data: data,
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
        }

        // Customer Acquisition Chart (đã ẩn, giữ lại code)
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

        // Fallback cho service volume chart nếu không có dữ liệu (12 tháng)
        if (!initialServiceVolume || initialServiceVolume.length === 0) {
            // Fallback: Tạo chart rỗng nếu không có dữ liệu
            console.warn('No service volume data available. Creating empty chart.');
            createChart('serviceVolumeChart', {
                type: 'bar',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                    datasets: [{
                        label: 'Completed Services',
                        data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
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
        }
         
         // ===== Export PDF/Excel Chip Buttons =====
         const pdfChips = document.querySelectorAll('.chip');
         pdfChips.forEach(chip => {
             chip.addEventListener('click', function() {
                 const text = this.textContent.toLowerCase();
                 if (text.includes('pdf')) {
                     exportToPDF();
                 } else if (text.includes('excel')) {
                     exportToExcel();
                 } else if (text.includes('export')) {
                     exportToExcel(); // Default export
                 }
             });
        });
        
        // Export to PDF function
        function exportToPDF() {
            const startDate = document.getElementById('startDate')?.value || '';
            const endDate = document.getElementById('endDate')?.value || '';
            
            let url = '<%= request.getContextPath() %>/admin/reports/export?format=pdf';
            if (startDate) url += '&startDate=' + encodeURIComponent(startDate);
            if (endDate) url += '&endDate=' + encodeURIComponent(endDate);
            
            window.open(url, '_blank');
        }
        
        // Export to Excel function
        function exportToExcel() {
            const startDate = document.getElementById('startDate')?.value || '';
            const endDate = document.getElementById('endDate')?.value || '';
            
            let url = '<%= request.getContextPath() %>/admin/reports/export?format=excel';
            if (startDate) url += '&startDate=' + encodeURIComponent(startDate);
            if (endDate) url += '&endDate=' + encodeURIComponent(endDate);
            
            window.open(url, '_blank');
        }
         
        // Function to update financial charts
        function updateFinancialCharts(financialData) {
            // Update revenue trend chart - Data from appointments.total_amount (COMPLETED status only)
            const revenueChart = Chart.getChart('revenueTrendChart');
            if (revenueChart && financialData.monthlyRevenue) {
                console.log('Updating revenue chart with data from appointments (COMPLETED):', financialData.monthlyRevenue);
                const labels = financialData.monthlyRevenue.map(m => m.month);
                const data = financialData.monthlyRevenue.map(m => parseFloat(m.revenue) || 0);
                
                revenueChart.data.labels = labels;
                revenueChart.data.datasets[0].data = data;
                revenueChart.update();
            }
            
            // Update service pie chart
            const pieChart = Chart.getChart('servicePieChart');
            if (pieChart && financialData.serviceRevenue) {
                const labels = financialData.serviceRevenue.map(s => s.name + ' ' + s.percentage + '%');
                const data = financialData.serviceRevenue.map(s => s.percentage);
                const colors = ['#2563eb', '#22c55e', '#f59e0b', '#f97316', '#a855f7'];
                
                pieChart.data.labels = labels;
                pieChart.data.datasets[0].data = data;
                pieChart.data.datasets[0].backgroundColor = colors.slice(0, data.length);
                pieChart.update();
            }
            
            // Update Detailed Financial Report table
            const tableBody = document.getElementById('financialReportTableBody');
            if (tableBody && financialData.serviceRevenue) {
                let html = '';
                if (financialData.serviceRevenue.length > 0) {
                    financialData.serviceRevenue.forEach(function(service) {
                        const revenue = parseFloat(service.revenue) || 0;
                        const avgPrice = parseFloat(service.avgPrice) || 0;
                        const growth = service.growth || '0%';
                        const growthValue = parseFloat(growth.replace('%', '')) || 0;
                        
                        let growthClass = 'flat';
                        let growthIcon = 'ri-subtract-line';
                        if (growthValue > 0) {
                            growthClass = 'up';
                            growthIcon = 'ri-arrow-up-s-line';
                        } else if (growthValue < 0) {
                            growthClass = 'down';
                            growthIcon = 'ri-arrow-down-s-line';
                        }
                        
                        html += '<tr>' +
                            '<td>' + (service.name || 'Unknown') + '</td>' +
                            '<td>' + (service.bookings || 0).toLocaleString() + '</td>' +
                            '<td>$' + revenue.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2}) + '</td>' +
                            '<td>$' + avgPrice.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2}) + '</td>' +
                            '<td><span class="growth ' + growthClass + '"><i class="' + growthIcon + '"></i>' + growth + '</span></td>' +
                            '</tr>';
                    });
                } else {
                    html = '<tr><td colspan="5" style="text-align:center;color:var(--muted);padding:20px;">No financial data available for the selected date range</td></tr>';
                }
                tableBody.innerHTML = html;
            }
        }
         
        // Function to update operational charts
        function updateOperationalCharts(operationalData) {
            // Update service volume chart
            const serviceVolumeChart = Chart.getChart('serviceVolumeChart');
            if (serviceVolumeChart && operationalData.serviceVolume) {
                const labels = operationalData.serviceVolume.map(s => s.month);
                const data = operationalData.serviceVolume.map(s => s.completed);
                
                serviceVolumeChart.data.labels = labels;
                serviceVolumeChart.data.datasets[0].data = data;
                serviceVolumeChart.update();
            }
            
            // Update customer acquisition chart
            const customerChart = Chart.getChart('customerAcquisitionChart');
            if (customerChart && operationalData.customerAcquisition) {
                const labels = operationalData.customerAcquisition.map(c => c.month);
                const newCustomers = operationalData.customerAcquisition.map(c => c.newCustomers);
                const returningCustomers = operationalData.customerAcquisition.map(c => c.returningCustomers);
                
                customerChart.data.labels = labels;
                customerChart.data.datasets[0].data = newCustomers;
                customerChart.data.datasets[1].data = returningCustomers;
                customerChart.update();
            }
        }
    });
 </script>
<jsp:include page="../inc/chatbox.jsp" />
<jsp:include page="../inc/footer.jsp" />


