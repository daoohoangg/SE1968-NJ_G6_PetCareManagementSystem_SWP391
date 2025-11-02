<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/inc/common-head.jspf" %>

    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Pet Service History</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --text: #1f2937;
            --muted: #6b7280;
            --line: #e5e7eb;
            --bg: #f7f9fc;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Inter, system-ui, sans-serif;
            color: var(--text);
            background: var(--bg);
        }

        .layout {
            display: flex;
            min-height: 100vh;
        }

        .content {
            flex: 1;
            padding: 28px 36px;
        }

        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 16px;
        }

        h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 700;
        }

        .subtitle {
            color: var(--muted);
            font-size: 14px;
            margin: 4px 0 0 0;
        }

        .actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-success {
            background: var(--success);
            color: white;
        }

        .btn-primary:hover, .btn-success:hover {
            filter: brightness(0.95);
        }

        .search-bar {
            display: flex;
            gap: 12px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .search-input {
            flex: 1;
            min-width: 250px;
            padding: 10px 14px;
            border: 1px solid var(--line);
            border-radius: 10px;
            font-size: 14px;
        }

        .filter-select {
            padding: 10px 14px;
            border: 1px solid var(--line);
            border-radius: 10px;
            font-size: 14px;
            min-width: 180px;
        }

        .card {
            background: white;
            border: 1px solid var(--line);
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead th {
            background: #f3f4f6;
            text-align: left;
            padding: 14px 18px;
            font-size: 13px;
            color: #4b5563;
            font-weight: 600;
            border-bottom: 1px solid var(--line);
        }

        tbody td {
            padding: 16px 18px;
            vertical-align: middle;
            border-top: 1px solid var(--line);
        }

        tbody tr:hover {
            background: #fafafa;
        }

        .pet-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .pet-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 16px;
        }

        .pet-details strong {
            display: block;
            font-size: 14px;
        }

        .pet-details span {
            font-size: 12px;
            color: var(--muted);
        }

        .service-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }

        .service-badge.grooming {
            background: #dbeafe;
            color: #1e40af;
        }

        .service-badge.spa {
            background: #fce7f3;
            color: #9f1239;
        }

        .service-badge.bath {
            background: #e0e7ff;
            color: #4338ca;
        }

        .service-badge.haircut {
            background: #fef3c7;
            color: #92400e;
        }

        .service-badge.nail {
            background: #d1fae5;
            color: #065f46;
        }

        .rating {
            display: flex;
            gap: 2px;
        }

        .rating i {
            color: #fbbf24;
            font-size: 14px;
        }

        .rating i.empty {
            color: #d1d5db;
        }

        .action-btns {
            display: flex;
            gap: 8px;
        }

        .icon-btn {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            border: none;
            background: #f3f4f6;
            color: var(--text);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }

        .icon-btn:hover {
            background: var(--primary);
            color: white;
        }

        .icon-btn.danger:hover {
            background: var(--danger);
        }

        .alert {
            padding: 12px 16px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        .empty {
            padding: 60px 20px;
            text-align: center;
            color: var(--muted);
        }

        .empty i {
            font-size: 48px;
            margin-bottom: 12px;
            opacity: 0.5;
        }

        @media (max-width: 768px) {
            .content {
                padding: 20px;
            }

            .header {
                flex-direction: column;
                align-items: flex-start;
            }

            .search-bar {
                flex-direction: column;
            }

            .search-input, .filter-select {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<jsp:include page="../inc/header.jsp"/>
<div class="layout">
    <% request.setAttribute("activePage", "pet-data"); %>
    <jsp:include page="../inc/side-bar.jsp"/>

    <main class="content">
        <div class="header">
            <div>
                <h1>Pet Service History</h1>
                <p class="subtitle">Records of past spa/grooming services for pets</p>
            </div>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/petServiceHistory?action=add" class="btn btn-primary">
                    <i class="ri-add-line"></i> Add Record
                </a>
                <a href="${pageContext.request.contextPath}/petServiceHistory?action=export&format=pdf" class="btn btn-success">
                    <i class="ri-file-pdf-line"></i> Export PDF
                </a>
            </div>
        </div>

        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success">
                <i class="ri-checkbox-circle-line"></i>
                ${sessionScope.success}
            </div>
            <c:remove var="success" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-error">
                <i class="ri-error-warning-line"></i>
                ${sessionScope.error}
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <form method="get" action="${pageContext.request.contextPath}/petServiceHistory">
            <div class="search-bar">
                <input type="text" name="search" class="search-input" 
                       placeholder="Search by Pet Name / Date..." 
                       value="${currentSearch}">
                <select name="serviceType" class="filter-select">
                    <option value="All Services">All Services</option>
                    <c:forEach var="type" items="${serviceTypes}">
                        <option value="${type}" ${currentServiceType == type ? 'selected' : ''}>${type}</option>
                    </c:forEach>
                </select>
                <button type="submit" class="btn btn-primary">
                    <i class="ri-search-line"></i> Search
                </button>
            </div>
        </form>

        <div class="card">
            <table>
                <thead>
                <tr>
                    <th>Date</th>
                    <th>Pet</th>
                    <th>Service Type</th>
                    <th>Staff</th>
                    <th>Notes</th>
                    <th>Rating</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty records}">
                        <tr>
                            <td colspan="7">
                                <div class="empty">
                                    <i class="ri-file-list-3-line"></i>
                                    <p>No service records found.</p>
                                </div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="record" items="${records}">
                            <tr>
                                <td>
                                    <fmt:formatDate value="${record.serviceDate}" pattern="yyyy-MM-dd" type="date"/>
                                </td>
                                <td>
                                    <div class="pet-info">
                                        <div class="pet-avatar">${record.pet.name.substring(0,1).toUpperCase()}</div>
                                        <div class="pet-details">
                                            <strong>${record.pet.name}</strong>
                                            <span>${record.pet.customer.fullName}</span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="service-badge ${record.serviceType.toLowerCase().replaceAll(' ', '-')}">
                                        <i class="ri-scissors-cut-line"></i>
                                        ${record.serviceType}
                                    </span>
                                </td>
                                <td>${record.staff.fullName}</td>
                                <td style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                    ${record.notes != null ? record.notes : '-'}
                                </td>
                                <td>
                                    <div class="rating">
                                        <c:forEach begin="1" end="5" var="star">
                                            <i class="ri-star-fill ${star <= (record.rating != null ? record.rating : 0) ? '' : 'empty'}"></i>
                                        </c:forEach>
                                    </div>
                                </td>
                                <td>
                                    <div class="action-btns">
                                        <a href="${pageContext.request.contextPath}/petServiceHistory?action=view&id=${record.id}" 
                                           class="icon-btn" title="View Details">
                                            <i class="ri-eye-line"></i>
                                        </a>
                                        <form method="post" action="${pageContext.request.contextPath}/petServiceHistory" 
                                              style="display:inline;" onsubmit="return confirm('Delete this record?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${record.id}">
                                            <button type="submit" class="icon-btn danger" title="Delete">
                                                <i class="ri-delete-bin-line"></i>
                                            </button>
                                        </form>
                                    </div>
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

<jsp:include page="../inc/chatbox.jsp"/>
<jsp:include page="../inc/footer.jsp"/>
</body>
</html>

