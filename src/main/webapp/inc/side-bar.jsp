<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${empty currentPage}">
    <c:set var="requestUri" value="${pageContext.request.requestURI}" />
    <c:choose>
        <c:when test="${fn:contains(requestUri, '/admin/dashboard')}">
            <c:set var="currentPage" value="dashboard" />
        </c:when>
        <c:when test="${fn:contains(requestUri, '/admin/service')}">
            <c:set var="currentPage" value="manage-services" />
        </c:when>
        <c:when test="${fn:contains(requestUri, '/admin/config')}">
            <c:set var="currentPage" value="configure-system" />
        </c:when>
        <c:when test="${fn:contains(requestUri, '/admin/accounts')}">
            <c:set var="currentPage" value="manage-accounts" />
        </c:when>
        <c:when test="${fn:contains(requestUri, '/admin/ai')}">
            <c:set var="currentPage" value="ai-features" />
        </c:when>
        <c:when test="${fn:contains(requestUri, '/admin/reports')}">
            <c:set var="currentPage" value="reports" />
        </c:when>
    </c:choose>
</c:if>

<%
    if (request.getAttribute("sidebarStylesLoaded") == null) {
        request.setAttribute("sidebarStylesLoaded", Boolean.TRUE);
%>
<style>
    .sidebar{
        width:260px;
        min-height:100%;
        background:#111827;
        color:#f9fafb;
        display:flex;
        flex-direction:column;
        gap:28px;
        padding:32px 28px;
        box-shadow:8px 0 24px rgba(15,23,42,0.08);
    }
    .sidebar .logo{
        display:flex;
        flex-direction:column;
        gap:6px;
    }
    .sidebar .logo i{
        font-size:28px;
        color:#38bdf8;
    }
    .sidebar .logo span{
        font-size:20px;
        font-weight:600;
        letter-spacing:0.02em;
    }
    .sidebar .logo p{
        margin:0;
        color:#cbd5f5;
        font-size:12px;
        text-transform:uppercase;
        letter-spacing:0.18em;
    }
    .sidebar .menu{
        display:flex;
        flex-direction:column;
        gap:10px;
    }
    .sidebar .menu-item{
        display:flex;
        align-items:center;
        gap:12px;
        padding:12px 14px;
        border-radius:12px;
        color:#d1d5db;
        text-decoration:none;
        font-size:14px;
        font-weight:500;
        transition:background 0.2s ease, color 0.2s ease, transform 0.2s ease;
    }
    .sidebar .menu-item i{
        font-size:18px;
    }
    .sidebar .menu-item:hover{
        background:rgba(59,130,246,0.16);
        color:#e8f0ff;
        transform:translateX(4px);
    }
    .sidebar .menu-item.active{
        background:#2563eb;
        color:#ffffff;
        box-shadow:0 12px 24px rgba(37,99,235,0.32);
    }
    .sidebar .menu-item.active i{
        color:#ffffff;
    }
    @media (max-width:1024px){
        .sidebar{
            width:220px;
            padding:28px 22px;
        }
    }
    @media (max-width:768px){
        .sidebar{
            position:sticky;
            top:0;
            flex-direction:row;
            width:100%;
            min-height:auto;
            padding:18px 20px;
            justify-content:space-between;
            align-items:center;
            box-shadow:0 6px 16px rgba(15,23,42,0.08);
            z-index:110;
        }
        .sidebar .logo{
            flex-direction:row;
            align-items:center;
        }
        .sidebar .logo p{
            display:none;
        }
        .sidebar .menu{
            flex-direction:row;
            flex-wrap:wrap;
            gap:8px;
            justify-content:flex-end;
        }
        .sidebar .menu-item{
            padding:8px 12px;
            border-radius:10px;
            font-size:13px;
        }
    }
</style>
<%
    }
%>
<aside class="sidebar">
    <div class="logo">
        <p>Management System</p>
    </div>
    <nav class="menu">
        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="menu-item ${currentPage == 'dashboard' ? 'active' : ''}">
            <i class="ri-dashboard-line"></i>Dashboard
        </a>

        <a href="${pageContext.request.contextPath}/admin/service"
           class="menu-item ${currentPage == 'manage-services' ? 'active' : ''}">
            <i class="ri-scissors-line"></i>Manage Services
        </a>

        <a href="${pageContext.request.contextPath}/admin/config"
           class="menu-item ${currentPage == 'configure-system' ? 'active' : ''}">
            <i class="ri-settings-3-line"></i>Configure System
        </a>

        <a href="${pageContext.request.contextPath}/admin/accounts"
           class="menu-item ${currentPage == 'manage-accounts' ? 'active' : ''}">
            <i class="ri-user-settings-line"></i>Manage Accounts
        </a>

        <a href="${pageContext.request.contextPath}/admin/ai"
           class="menu-item ${currentPage == 'ai-features' ? 'active' : ''}">
            <i class="ri-robot-line"></i>AI Features
        </a>

        <a href="${pageContext.request.contextPath}/admin/reports"
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
