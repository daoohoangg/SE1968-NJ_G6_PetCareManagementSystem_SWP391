<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Check-Out Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        :root{
            --primary:#2563eb; --primary-100:#e9f0ff;
            --text:#1f2937; --muted:#6b7280;
            --line:#e5e7eb; --bg:#f7f9fc;
            --table-head:#f3f4f6; --pill:#111827;
            --success:#10b981; --danger:#ef4444;
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
        .status.checked-in{background:#d1fae5;color:#065f46}
        .status.checked-out{background:#e5e7eb;color:#374151}

        .btn-checkout{
            display:inline-flex;align-items:center;gap:6px;
            background:var(--danger);color:#fff;border:none;
            padding:8px 14px;border-radius:8px;font-weight:600;cursor:pointer;
            box-shadow:0 1px 0 rgba(0,0,0,.05);text-decoration:none;
            font-size:13px;
        }
        .btn-checkout:hover{filter:brightness(.96)}

        .empty{padding:40px;text-align:center;color:#6b7280;border:1px dashed #ddd;border-radius:8px;margin:20px 0}

        @media (max-width:900px){.content{padding:22px}}
    </style>
</head>
<body>
<jsp:include page="../inc/header.jsp" />
<div class="layout">
    <% request.setAttribute("activePage", "checkout"); %>
    <jsp:include page="../inc/side-bar.jsp" />

    <main class="content">
        <div class="topbar">
            <div class="title-wrap">
                <h2>Check-Out Management</h2>
                <p class="subtitle">Receptionist confirms guest/pet check-out and closes records</p>
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

        <div class="card">
            <table>
                <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Customer Name</th>
                    <th>Pet Name</th>
                    <th>Booking Date</th>
                    <th>Status</th>
                    <th style="width:140px">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty bookings}">
                        <tr><td colspan="6" class="empty">No checked-in bookings found.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="b" items="${bookings}">
                            <tr>
                                <td><strong>#${b.bookingId}</strong></td>
                                <td>${b.customerName}</td>
                                <td>${b.petName}</td>
                                <td><fmt:formatDate value="${b.bookingDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td><span class="status checked-in">Checked-In</span></td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/reception/checkout" style="display:inline">
                                        <input type="hidden" name="bookingId" value="${b.bookingId}"/>
                                        <button type="submit" class="btn-checkout" onclick="return confirm('Confirm check-out for ${b.customerName}?');">
                                            <i class="ri-logout-box-line"></i> Check Out
                                        </button>
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
