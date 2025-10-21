<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<aside class="sidebar">
    <div class="logo">
        <i class="ri-heart-line"></i>
        <span>PetCare Pro</span>
        <p>Management System</p>
    </div>
    <nav class="menu">
        <a href="${pageContext.request.contextPath}/dashboard"
           class="menu-item ${currentPage == 'dashboard' ? 'active' : ''}">
            <i class="ri-dashboard-line"></i>Dashboard
        </a>

        <a href="${pageContext.request.contextPath}/services"
           class="menu-item ${currentPage == 'manage-services' ? 'active' : ''}">
            <i class="ri-scissors-line"></i>Manage Services
        </a>

        <a href="${pageContext.request.contextPath}/config"
           class="menu-item ${currentPage == 'configure-system' ? 'active' : ''}">
            <i class="ri-settings-3-line"></i>Configure System
        </a>

        <a href="${pageContext.request.contextPath}/accounts"
           class="menu-item ${currentPage == 'manage-accounts' ? 'active' : ''}">
            <i class="ri-user-settings-line"></i>Manage Accounts
        </a>

        <a href="${pageContext.request.contextPath}/ai"
           class="menu-item ${currentPage == 'ai-features' ? 'active' : ''}">
            <i class="ri-robot-line"></i>AI Features
        </a>

        <a href="${pageContext.request.contextPath}/reports"
           class="menu-item ${currentPage == 'reports' ? 'active' : ''}">
            <i class="ri-bar-chart-2-line"></i>Generate Reports
        </a>

        <a href="${pageContext.request.contextPath}/reception/checkin"
           class="menu-item ${currentPage == 'checkin' ? 'active' : ''}">
            <i class="ri-login-box-line"></i>Check-In
        </a>

        <a href="${pageContext.request.contextPath}/reception/checkout"
           class="menu-item ${currentPage == 'checkout' ? 'active' : ''}">
            <i class="ri-logout-box-line"></i>Check-Out
        </a>

        <a href="${pageContext.request.contextPath}/petServiceHistory"
           class="menu-item ${currentPage == 'pet-data' ? 'active' : ''}">
            <i class="ri-file-list-3-line"></i>Pet Data
        </a>
    </nav>
</aside>
