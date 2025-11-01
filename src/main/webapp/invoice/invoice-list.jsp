<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/inc/common-head.jspf" %>

    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Manage Invoices</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --primary-100: #e9f0ff;
            --text: #1f2937;
            --muted: #6b7280;
            --line: #e5e7eb;
            --bg: #f7f9fc;
            --table-head: #f3f4f6;
        }

        * {
            box-sizing: border-box
        }

        html, body {
            height: 100%
        }

        body {
            margin: 0;
            font-family: Inter, system-ui, Segoe UI, Roboto, Arial, sans-serif;
            color: var(--text);
            background: var(--bg)
        }

        .layout {
            display: flex;
            min-height: 100vh
        }

        /* Content */
        .content {
            flex: 1;
            padding: 28px 36px
        }

        .topbar {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 18px
        }

        .title-wrap {
            flex: 1
        }

        h2 {
            margin: 0 0 2px 0;
            font-size: 24px
        }

        .subtitle {
            margin: 0;
            color: var(--muted);
            font-size: 14px
        }

        /* Filter Card */
        .filter-card {
            background: #fff;
            border: 1px solid var(--line);
            border-radius: 14px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(15, 23, 42, .04)
        }

        .filter-row {
            display: flex;
            gap: 12px;
            align-items: flex-end;
            flex-wrap: wrap
        }

        .filter-group {
            flex: 1;
            min-width: 200px
        }

        .filter-label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 6px
        }

        .filter-input, .filter-select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid var(--line);
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit
        }

        .filter-input:focus, .filter-select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, .1)
        }

        .btn-filter, .btn-reset {
            padding: 10px 16px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            font-size: 14px;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 6px
        }

        .btn-filter {
            background: var(--primary);
            color: #fff
        }

        .btn-filter:hover {
            filter: brightness(.96)
        }

        .btn-reset {
            background: #f3f4f6;
            color: #374151;
            border: 1px solid var(--line);
            text-decoration: none
        }

        .btn-reset:hover {
            background: #e5e7eb
        }

        .results-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            color: var(--muted);
            font-size: 14px
        }

        .results-count {
            font-weight: 600;
            color: var(--text)
        }

        .card {
            background: #fff;
            border: 1px solid var(--line);
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(15, 23, 42, .04);
            margin-top: 20px
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0
        }

        thead th {
            background: var(--table-head);
            text-align: left;
            padding: 14px 18px;
            font-size: 13px;
            color: #4b5563;
            font-weight: 600;
            border-bottom: 1px solid var(--line)
        }

        tbody td {
            padding: 16px 18px;
            vertical-align: middle;
            border-top: 1px solid var(--line)
        }

        tbody tr:hover {
            background: #fafafa
        }

        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
            border: 1px solid
        }

        .badge.success {
            border-color: #bbf7d0;
            color: #15803d;
            background: #f0fdf4
        }

        .badge.warning {
            border-color: #fde68a;
            color: #92400e;
            background: #fefce8
        }

        .badge.danger {
            border-color: #fecaca;
            color: #991b1b;
            background: #fef2f2
        }

        .badge.primary {
            border-color: #bfdbfe;
            color: #1d4ed8;
            background: #eff6ff
        }

        .badge.secondary {
            border-color: #d1d5db;
            color: #374151;
            background: #f9fafb
        }

        .actions {
            display: flex;
            gap: 8px
        }

        .icon-btn {
            width: 34px;
            height: 34px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #fff;
            border: 1px solid var(--line);
            border-radius: 10px;
            cursor: pointer;
            color: #4b5563;
            transition: .15s;
            text-decoration: none
        }

        .icon-btn:hover {
            border-color: #c7cbd1;
            color: var(--text);
            background: #f9fafb
        }

        .icon-btn.delete:hover {
            color: #dc2626;
            border-color: #fecaca;
            background: #fff
        }

        .empty {
            padding: 40px;
            text-align: center;
            color: #6b7280;
            border: 1px dashed #ddd;
            border-radius: 8px;
            margin: 20px 0
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            padding: 24px 0;
            margin-top: 20px
        }

        .page-btn {
            min-width: 36px;
            height: 36px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #fff;
            border: 1px solid var(--line);
            border-radius: 8px;
            cursor: pointer;
            color: #374151;
            font-weight: 500;
            font-size: 14px;
            text-decoration: none;
            padding: 0 12px
        }

        .page-btn:hover:not(.active):not(.disabled) {
            background: #f9fafb;
            border-color: #c7cbd1
        }

        .page-btn.active {
            background: var(--primary);
            color: #fff;
            border-color: var(--primary)
        }

        .page-btn.disabled {
            opacity: .5;
            cursor: not-allowed;
            pointer-events: none
        }

        .page-info {
            color: var(--muted);
            font-size: 14px;
            margin: 0 8px
        }

        @media (max-width: 900px) {
            .content {
                padding: 22px
            }
        }
    </style>
</head>
<body>
<jsp:include page="../inc/header.jsp"/>
<div class="layout">
    <% request.setAttribute("currentPage", "invoices"); %>
    <jsp:include page="../inc/side-bar.jsp"/>

    <main class="content">
        <div class="topbar">
            <div class="title-wrap">
                <h2>Manage Invoices</h2>
                <p class="subtitle">View and manage customer invoices</p>
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

        <!-- Search & Filter -->
        <div class="filter-card">
            <form method="get" action="${pageContext.request.contextPath}/invoices">
                <div class="filter-row">
                    <div class="filter-group">
                        <label class="filter-label">Search</label>
                        <input type="text" name="search" class="filter-input"
                               placeholder="Invoice number, customer name..."
                               value="${searchTerm}">
                    </div>
                    <div class="filter-group" style="flex:0.8">
                        <label class="filter-label">Status</label>
                        <select name="status" class="filter-select">
                            <option value="ALL" ${selectedStatus == null || selectedStatus == 'ALL' ? 'selected' : ''}>
                                All Status
                            </option>
                            <c:forEach var="s" items="${statuses}">
                                <option value="${s}" ${selectedStatus == s.name() ? 'selected' : ''}>${s}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div style="display:flex;gap:8px">
                        <button type="submit" class="btn-filter">
                            <i class="ri-search-line"></i> Search
                        </button>
                        <a href="${pageContext.request.contextPath}/invoices" class="btn-reset">
                            <i class="ri-refresh-line"></i> Reset
                        </a>
                    </div>
                </div>
            </form>
        </div>

        <!-- Results Info -->
        <div class="results-info">
            <span>
                Showing <span class="results-count">${fn:length(invoiceList)}</span> of
                <span class="results-count">${totalRecords != null ? totalRecords : fn:length(invoiceList)}</span> invoices
            </span>
            <c:if test="${totalPages != null && totalPages > 0}">
                <span>Page ${currentPage != null ? currentPage : 1} of ${totalPages}</span>
            </c:if>
        </div>

        <div class="card">
            <table>
                <thead>
                <tr>
                    <th>Invoice #</th>
                    <th>Customer</th>
                    <th>Issue Date</th>
                    <th>Due Date</th>
                    <th>Total</th>
                    <th>Amount Due</th>
                    <th>Status</th>
                    <th style="width:120px">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty invoiceList}">
                        <tr>
                            <td colspan="8" class="empty">No invoices found.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="inv" items="${invoiceList}">
                            <tr>
                                <td><strong>${inv.invoiceNumber}</strong></td>
                                <td>${inv.customer.fullName}</td>
                                <td>${inv.formattedIssueDate}</td>
                                <td>${inv.formattedDueDate}</td>
                                <td>${inv.formattedTotal}</td>
                                <td>${inv.formattedAmountDue}</td>
                                <td>
                                    <span class="badge ${inv.statusBadgeClass}">${inv.status}</span>
                                </td>
                                <td class="actions">
                                    <a class="icon-btn"
                                       href="${pageContext.request.contextPath}/invoices?action=view&id=${inv.invoiceId}"
                                       title="View">
                                        <i class="ri-eye-line"></i>
                                    </a>
                                    <form method="get" action="${pageContext.request.contextPath}/invoices"
                                          style="display:inline">
                                        <input type="hidden" name="action" value="delete"/>
                                        <input type="hidden" name="id" value="${inv.invoiceId}"/>
                                        <button type="submit" class="icon-btn delete"
                                                onclick="return confirm('Delete this invoice?');">
                                            <i class="ri-delete-bin-line"></i>
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

        <!-- Pagination -->
        <c:if test="${totalPages != null && totalPages > 1}">
            <div class="pagination">
                <c:set var="currentPageNum" value="${currentPage != null ? currentPage : 1}"/>
                <c:url var="prevUrl" value="${pageContext.request.contextPath}/invoices">
                    <c:param name="page" value="${currentPageNum - 1}"/>
                    <c:if test="${searchTerm != null}"><c:param name="search" value="${searchTerm}"/></c:if>
                    <c:if test="${selectedStatus != null}"><c:param name="status" value="${selectedStatus}"/></c:if>
                </c:url>
                <c:url var="nextUrl" value="${pageContext.request.contextPath}/invoices">
                    <c:param name="page" value="${currentPageNum + 1}"/>
                    <c:if test="${searchTerm != null}"><c:param name="search" value="${searchTerm}"/></c:if>
                    <c:if test="${selectedStatus != null}"><c:param name="status" value="${selectedStatus}"/></c:if>
                </c:url>

                <a href="${prevUrl}" class="page-btn ${currentPageNum == 1 ? 'disabled' : ''}">
                    <i class="ri-arrow-left-s-line"></i> Prev
                </a>

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <c:if test="${i == 1 || i == totalPages || (i >= currentPageNum - 2 && i <= currentPageNum + 2)}">
                        <c:url var="pageUrl" value="${pageContext.request.contextPath}/invoices">
                            <c:param name="page" value="${i}"/>
                            <c:if test="${searchTerm != null}"><c:param name="search" value="${searchTerm}"/></c:if>
                            <c:if test="${selectedStatus != null}"><c:param name="status"
                                                                            value="${selectedStatus}"/></c:if>
                        </c:url>
                        <a href="${pageUrl}" class="page-btn ${currentPageNum == i ? 'active' : ''}">${i}</a>
                    </c:if>
                    <c:if test="${i == 2 && currentPageNum > 4}">
                        <span class="page-info">...</span>
                    </c:if>
                    <c:if test="${i == totalPages - 1 && currentPageNum < totalPages - 3}">
                        <span class="page-info">...</span>
                    </c:if>
                </c:forEach>

                <a href="${nextUrl}" class="page-btn ${currentPageNum == totalPages ? 'disabled' : ''}">
                    Next <i class="ri-arrow-right-s-line"></i>
                </a>
            </div>
        </c:if>
    </main>
</div>

<jsp:include page="../inc/chatbox.jsp"/>
<jsp:include page="../inc/footer.jsp"/>
</body>
</html>

