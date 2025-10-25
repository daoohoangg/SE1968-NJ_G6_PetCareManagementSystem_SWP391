<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Pet Service History</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        :root{
            --primary:#2563eb; --primary-100:#e9f0ff;
            --text:#1f2937; --muted:#6b7280;
            --line:#e5e7eb; --bg:#f7f9fc;
            --table-head:#f3f4f6; --pill:#111827;
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

        .btn-add{
            display:inline-flex;align-items:center;gap:8px;
            background:var(--primary);color:#fff;border:none;
            padding:10px 14px;border-radius:10px;font-weight:600;cursor:pointer;
            box-shadow:0 1px 0 rgba(0,0,0,.05);text-decoration:none
        }
        .btn-add:hover{filter:brightness(.96)}

        .card{background:#fff;border:1px solid var(--line);border-radius:14px;overflow:hidden;box-shadow:0 1px 3px rgba(15,23,42,.04);margin-top:20px}
        table{width:100%;border-collapse:separate;border-spacing:0}
        thead th{background:var(--table-head);text-align:left;padding:14px 18px;font-size:13px;color:#4b5563;font-weight:600;border-bottom:1px solid var(--line)}
        tbody td{padding:16px 18px;vertical-align:middle;border-top:1px solid var(--line)}
        tbody tr:hover{background:#fafafa}

        .tag{display:inline-block;padding:4px 10px;border-radius:999px;font-size:12px;font-weight:600;border:1px solid #d1d5db;color:#374151;background:#fff}
        .tag.grooming{border-color:#bfdbfe;color:#1d4ed8;background:#eff6ff}
        .tag.medical{border-color:#bbf7d0;color:#15803d;background:#f0fdf4}
        .tag.training{border-color:#fde68a;color:#92400e;background:#fefce8}
        .tag.spa{border-color:#e9d5ff;color:#6b21a8;background:#faf5ff}

        .actions{display:flex;gap:8px}
        .icon-btn{width:34px;height:34px;display:inline-flex;align-items:center;justify-content:center;background:#fff;border:1px solid var(--line);border-radius:10px;cursor:pointer;color:#4b5563;transition:.15s;text-decoration:none}
        .icon-btn:hover{border-color:#c7cbd1;color:var(--text);background:#f9fafb}
        .icon-btn.delete:hover{color:#dc2626;border-color:#fecaca;background:#fff}

        .empty{padding:40px;text-align:center;color:#6b7280;border:1px dashed #ddd;border-radius:8px;margin:20px 0}

        @media (max-width:900px){.content{padding:22px}}
    </style>
</head>
<body>
<jsp:include page="../inc/header.jsp" />
<div class="layout">
    <% request.setAttribute("activePage", "pet-data"); %>
    <jsp:include page="../inc/side-bar.jsp" />

    <main class="content">
        <div class="topbar">
            <div class="title-wrap">
                <h2>Pet Service History</h2>
                <p class="subtitle">Records of past spa/grooming services for pets</p>
            </div>
            <a class="btn-add" href="${pageContext.request.contextPath}/petServiceHistory?action=add">
                <i class="ri-add-line"></i> Add Record
            </a>
        </div>

        <c:if test="${not empty sessionScope.success}">
            <div style="margin:8px 0;color:#065f46;background:#d1fae5;border:1px solid #a7f3d0;padding:10px;border-radius:8px">${sessionScope.success}</div>
            <c:remove var="success" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div style="margin:8px 0;color:#991b1b;background:#fee2e2;border:1px solid #fecaca;padding:10px;border-radius:8px">${sessionScope.error}</div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <div class="card">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Pet Name</th>
                    <th>Service Type</th>
                    <th>Description</th>
                    <th>Service Date</th>
                    <th>Cost</th>
                    <th>Staff</th>
                    <th style="width:120px">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty historyList}">
                        <tr><td colspan="8" class="empty">No service history records found.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="h" items="${historyList}">
                            <tr>
                                <td><strong>#${h.id}</strong></td>
                                <td>${h.pet.name}</td>
                                <td>
                                    <c:set var="serviceType" value="${fn:toLowerCase(h.serviceType)}"/>
                                    <c:choose>
                                        <c:when test="${fn:contains(serviceType, 'grooming')}"><span class="tag grooming">${h.serviceType}</span></c:when>
                                        <c:when test="${fn:contains(serviceType, 'medical')}"><span class="tag medical">${h.serviceType}</span></c:when>
                                        <c:when test="${fn:contains(serviceType, 'training')}"><span class="tag training">${h.serviceType}</span></c:when>
                                        <c:when test="${fn:contains(serviceType, 'spa')}"><span class="tag spa">${h.serviceType}</span></c:when>
                                        <c:otherwise><span class="tag">${h.serviceType}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td><c:out value="${h.description}" default="-"/></td>
                                <td><fmt:formatDate value="${h.serviceDate}" pattern="dd/MM/yyyy"/></td>
                                <td><fmt:formatNumber value="${h.cost}" type="currency" currencySymbol="$" minFractionDigits="2"/></td>
                                <td>${h.staff != null ? h.staff.fullName : '-'}</td>
                                <td class="actions">
                                    <a class="icon-btn" href="${pageContext.request.contextPath}/petServiceHistory?action=view&id=${h.id}" title="View"><i class="ri-eye-line"></i></a>
                                    <form method="get" action="${pageContext.request.contextPath}/petServiceHistory" style="display:inline">
                                        <input type="hidden" name="action" value="delete"/>
                                        <input type="hidden" name="idhistory" value="${h.id}"/>
                                        <button type="submit" class="icon-btn delete" onclick="return confirm('Delete this record?');"><i class="ri-delete-bin-line"></i></button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </main>
</div>

<jsp:include page="../inc/chatbox.jsp" />
<jsp:include page="../inc/footer.jsp" />
</body>
</html>
