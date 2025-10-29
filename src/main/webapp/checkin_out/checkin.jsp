<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/inc/common-head.jspf" %>

    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Check-In Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        :root{
            --primary:#2563eb; --primary-100:#e9f0ff;
            --text:#1f2937; --muted:#6b7280;
            --line:#e5e7eb; --bg:#f7f9fc;
            --table-head:#f3f4f6; --pill:#111827;
            --success:#10b981; --warning:#f59e0b;
        }
        *{box-sizing:border-box}
        html,body{height:100%}
        body{margin:0;font-family:Inter,system-ui,Segoe UI,Roboto,Arial,Helvetica,sans-serif;color:var(--text);background:var(--bg)}
        .layout{display:flex;min-height:100vh}

        /* Content */
        .content{flex:1;padding:28px 36px}
        .topbar{display:flex;align-items:center;gap:16px;margin-bottom:18px}
        .title-wrap{flex:1}
        h2{margin:0 0 2px 0;font-size:24px}
        .subtitle{margin:0;color:var(--muted);font-size:14px}

        .card{background:#fff;border:1px solid var(--line);border-radius:14px;overflow:hidden;box-shadow:0 1px 3px rgba(15,23,42,.04);margin-top:20px}
        table{width:100%;border-collapse:separate;border-spacing:0}
        thead th{background:var(--table-head);text-align:left;padding:14px 18px;font-size:13px;color:#4b5563;font-weight:600;border-bottom:1px solid var(--line)}
        tbody td{padding:16px 18px;vertical-align:middle;border-top:1px solid var(--line)}
        tbody tr:hover{background:#fafafa}

        .status{display:inline-flex;align-items:center;justify-content:center;padding:4px 10px;border-radius:999px;font-size:12px;font-weight:700}
        .status.pending{background:#fef3c7;color:#92400e}
        .status.checked-in{background:#d1fae5;color:#065f46}

        .btn-checkin{
            display:inline-flex;align-items:center;gap:6px;
            background:var(--success);color:#fff;border:none;
            padding:8px 14px;border-radius:8px;font-weight:600;cursor:pointer;
            box-shadow:0 1px 0 rgba(0,0,0,.05);text-decoration:none;
            font-size:13px;
        }
        .btn-checkin:hover{filter:brightness(.96)}

        .empty{padding:40px;text-align:center;color:#6b7280;border:1px dashed #ddd;border-radius:8px;margin:20px 0}

        /* Filter Form */
        .filter-form{background:#fff;border:1px solid var(--line);border-radius:12px;padding:20px;margin-bottom:20px;display:flex;gap:12px;align-items:end;flex-wrap:wrap}
        .form-group{flex:1;min-width:200px}
        .form-group label{display:block;font-size:13px;font-weight:600;color:var(--text);margin-bottom:6px}
        .form-group input{width:100%;padding:8px 12px;border:1px solid var(--line);border-radius:8px;font-size:14px}
        .form-group input:focus{outline:none;border-color:var(--primary);box-shadow:0 0 0 3px rgba(37,99,235,.1)}
        .btn-filter{padding:8px 16px;background:var(--primary);color:#fff;border:none;border-radius:8px;font-weight:600;cursor:pointer;font-size:14px}
        .btn-filter:hover{filter:brightness(.95)}
        .btn-reset{padding:8px 16px;background:#6b7280;color:#fff;border:none;border-radius:8px;font-weight:600;cursor:pointer;font-size:14px}
        .btn-reset:hover{filter:brightness(.95)}

        /* Pagination */
        .pagination-wrapper{display:flex;justify-content:space-between;align-items:center;margin-top:20px;padding:16px 20px;background:#fff;border:1px solid var(--line);border-radius:12px}
        .pagination-info{color:var(--muted);font-size:14px}
        .pagination{display:flex;gap:6px;list-style:none;margin:0;padding:0}
        .pagination a,.pagination span{display:flex;align-items:center;justify-content:center;min-width:36px;height:36px;padding:0 12px;border:1px solid var(--line);border-radius:8px;color:var(--text);text-decoration:none;font-size:14px;font-weight:500}
        .pagination a:hover{background:var(--bg);border-color:var(--primary)}
        .pagination .active{background:var(--primary);color:#fff;border-color:var(--primary)}
        .pagination .disabled{color:#d1d5db;cursor:not-allowed;pointer-events:none}

        @media (max-width:900px){.content{padding:22px}.filter-form{flex-direction:column}.pagination-wrapper{flex-direction:column;gap:12px}}
    </style>
</head>
<body>
<jsp:include page="../inc/header.jsp" />
<div class="layout">
    <% request.setAttribute("activePage", "checkin"); %>
    <jsp:include page="../inc/side-bar.jsp" />

    <main class="content">
        <div class="topbar">
            <div class="title-wrap">
                <h2>Check-In Management</h2>
                <p class="subtitle">Receptionist confirms guest/pet check-in</p>
            </div>
        </div>

        <c:if test="${not empty sessionScope.success}">
            <div style="margin:8px 0;color:#065f46;background:#d1fae5;border:1px solid #a7f3d0;padding:10px;border-radius:8px">${sessionScope.success}</div>
            <c:remove var="success" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div style="margin:8px 0;color:#991b1b;background:#fee2e2;border:1px solid #fecaca;padding:10px;border-radius:8px">${sessionScope.error}</div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <!-- Filter Form -->
        <form method="get" action="${pageContext.request.contextPath}/reception/checkin" class="filter-form">
            <div class="form-group">
                <label for="customerName">Customer Name</label>
                <input type="text" id="customerName" name="customerName" value="${customerName}" placeholder="Search by customer name...">
            </div>
            <div class="form-group">
                <label for="petName">Pet Name</label>
                <input type="text" id="petName" name="petName" value="${petName}" placeholder="Search by pet name...">
            </div>
            <div style="display:flex;gap:8px">
                <button type="submit" class="btn-filter"><i class="ri-search-line"></i> Filter</button>
                <a href="${pageContext.request.contextPath}/reception/checkin" class="btn-reset" style="text-decoration:none;display:flex;align-items:center"><i class="ri-refresh-line"></i> Reset</a>
            </div>
        </form>

        <div class="card">
            <table>
                <thead>
                <tr>
                    <th>Appointment ID</th>
                    <th>Customer Name</th>
                    <th>Pet Name</th>
                    <th>Appointment Date</th>
                    <th>Services</th>
                    <th>Status</th>
                    <th style="width:140px">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty appointments}">
                        <tr><td colspan="7" class="empty">No appointments available for check-in today.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="apt" items="${appointments}">
                            <tr>
                                <td><strong>#${apt.appointmentId}</strong></td>
                                <td>${apt.customer.fullName}</td>
                                <td>${apt.pet.name}</td>
                                <td>${apt.formattedDate}</td>
                                <td>
                                    <c:forEach var="svc" items="${apt.services}" varStatus="status">
                                        ${svc.serviceName}<c:if test="${!status.last}">, </c:if>
                                    </c:forEach>
                                </td>
                                <td><span class="status ${apt.status == 'SCHEDULED' ? 'pending' : 'checked-in'}">${apt.status}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${apt.status == 'SCHEDULED'}">
                                            <form method="post" action="${pageContext.request.contextPath}/reception/checkin" style="display:inline">
                                                <input type="hidden" name="appointmentId" value="${apt.appointmentId}"/>
                                                <button type="submit" class="btn-checkin" onclick="return confirm('Confirm check-in for ${apt.customer.fullName}?');">
                                                    <i class="ri-login-box-line"></i> Check In
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color:#10b981;font-weight:600;font-size:13px">
                                                <i class="ri-checkbox-circle-fill"></i> Checked In
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="pagination-wrapper">
                <div class="pagination-info">
                    Showing ${(currentPage - 1) * 10 + 1} to ${currentPage * 10 > totalRecords ? totalRecords : currentPage * 10} of ${totalRecords} results
                </div>
                <ul class="pagination">
                    <c:if test="${currentPage > 1}">
                        <li><a href="?page=${currentPage - 1}&customerName=${customerName}&petName=${petName}"><i class="ri-arrow-left-s-line"></i></a></li>
                    </c:if>
                    <c:if test="${currentPage <= 1}">
                        <li><span class="disabled"><i class="ri-arrow-left-s-line"></i></span></li>
                    </c:if>

                    <c:forEach begin="${currentPage > 2 ? currentPage - 2 : 1}" 
                               end="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" 
                               var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <li><span class="active">${i}</span></li>
                            </c:when>
                            <c:otherwise>
                                <li><a href="?page=${i}&customerName=${customerName}&petName=${petName}">${i}</a></li>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <li><a href="?page=${currentPage + 1}&customerName=${customerName}&petName=${petName}"><i class="ri-arrow-right-s-line"></i></a></li>
                    </c:if>
                    <c:if test="${currentPage >= totalPages}">
                        <li><span class="disabled"><i class="ri-arrow-right-s-line"></i></span></li>
                    </c:if>
                </ul>
            </div>
        </c:if>
    </main>
</div>

<jsp:include page="../inc/chatbox.jsp" />
<jsp:include page="../inc/footer.jsp" />
</body>
</html>

