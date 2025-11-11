<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
        return;
    }
%>
<c:if test="${empty activePage}">
    <c:set var="requestUri" value="${pageContext.request.requestURI}" />
    <c:choose>
        <c:when test="${fn:contains(requestUri, '/admin/dashboard')}">
            <c:set var="activePage" value="dashboard" />
        </c:when>
        <c:when test="${fn:contains(requestUri, '/admin/service')}">
            <c:set var="activePage" value="manage-services" />
        </c:when>
        <c:when test="${fn:contains(requestUri, '/admin/config')}">
            <c:set var="activePage" value="configure-system" />
        </c:when>
        <c:when test="${fn:contains(requestUri, '/admin/accounts')}">
            <c:set var="activePage" value="manage-accounts" />
        </c:when>
        <c:when test="${fn:contains(requestUri, '/admin/ai')}">
            <c:set var="activePage" value="ai-features" />
        </c:when>
        <c:when test="${fn:contains(requestUri, '/admin/reports')}">
            <c:set var="activePage" value="reports" />
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
           class="menu-item ${activePage == 'dashboard' ? 'active' : ''}">
            <i class="ri-dashboard-line"></i>Dashboard
        </a>

        <a href="${pageContext.request.contextPath}/admin/service"
           class="menu-item ${activePage == 'manage-services' ? 'active' : ''}">
            <i class="ri-scissors-line"></i>Manage Services
        </a>

        <a href="${pageContext.request.contextPath}/admin/config"
           class="menu-item ${activePage == 'configure-system' ? 'active' : ''}">
            <i class="ri-settings-3-line"></i>Configure System
        </a>

        <a href="${pageContext.request.contextPath}/admin/accounts"
           class="menu-item ${activePage == 'manage-accounts' ? 'active' : ''}">
            <i class="ri-user-settings-line"></i>Manage Accounts
        </a>

        <a href="${pageContext.request.contextPath}/admin/ai"
           class="menu-item ${activePage == 'ai-features' ? 'active' : ''}">
            <i class="ri-robot-line"></i>AI Features
        </a>

<%--        <a href="${pageContext.request.contextPath}/admin/reports"--%>
<%--           class="menu-item ${activePage == 'reports' ? 'active' : ''}">--%>
<%--            <i class="ri-bar-chart-2-line"></i>Generate Reports--%>
<%--        </a>--%>
    </nav>
</aside>