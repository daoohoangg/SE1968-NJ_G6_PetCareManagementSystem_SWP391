<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.petcaresystem.enities.enu.AccountRoleEnum" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !(AccountRoleEnum.STAFF.name().equalsIgnoreCase(role))) {
        return;
    }
%>

<c:if test="${empty activePage}">
    <c:set var="requestUri" value="${pageContext.request.requestURI}" />
    <c:choose>
        <%-- Trang /petServiceHistory mà LoginController đang trỏ đến --%>
        <c:when test="${fn:contains(requestUri, '/petServiceHistory')}">
            <c:set var="activePage" value="my-tasks" />
        </c:when>
        <%-- Thêm một trang lịch làm việc (ví dụ) --%>
        <c:when test="${fn:contains(requestUri, '/staff/schedule')}">
            <c:set var="activePage" value="my-schedule" />
        </c:when>
        <%-- Job Assignment page --%>
        <c:when test="${fn:contains(requestUri, '/staff/jobassignment')}">
            <c:set var="activePage" value="job-assignment" />
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
        <p>Staff Portal</p>
    </div>
    <nav class="menu">
        <a href="${pageContext.request.contextPath}/petServiceHistory"
           class="menu-item ${activePage == 'my-tasks' ? 'active' : ''}">
            <i class="ri-task-line"></i> My Tasks
        </a>
        <a href="${pageContext.request.contextPath}/staff/schedule"
           class="menu-item ${activePage == 'my-schedule' ? 'active' : ''}">
            <i class="ri-calendar-todo-line"></i> My Schedule
        </a>
        <a href="${pageContext.request.contextPath}/staff/jobassignment"
           class="menu-item ${activePage == 'job-assignment' ? 'active' : ''}">
            <i class="ri-user-settings-line"></i> Job Assignment
        </a>
    </nav>
</aside>