<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Manage Services</title>
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

        /* Content only */
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

        .search{
            background:#fff;border:1px solid var(--line);
            border-radius:12px;padding:10px 12px;margin:16px 0 20px;
            display:flex;align-items:center;gap:10px;
            box-shadow:0 1px 2px rgba(0,0,0,.03);
        }
        .search i{color:#9ca3af}
        .search input,.search select{
            border:none;outline:none;background:transparent;color:var(--text);font-size:14px
        }

        .card{background:#fff;border:1px solid var(--line);border-radius:14px;overflow:hidden;box-shadow:0 1px 3px rgba(15,23,42,.04)}
        table{width:100%;border-collapse:separate;border-spacing:0}
        thead th{background:var(--table-head);text-align:left;padding:14px 18px;font-size:13px;color:#4b5563;font-weight:600;border-bottom:1px solid var(--line)}
        tbody td{padding:16px 18px;vertical-align:middle;border-top:1px solid var(--line)}
        tbody tr:hover{background:#fafafa}
        .name strong{display:block;margin-bottom:4px}
        .desc{font-size:12px;color:#6b7280}

        .tag{display:inline-block;padding:4px 10px;border-radius:999px;font-size:12px;font-weight:600;border:1px solid #d1d5db;color:#374151;background:#fff}
        .tag.grooming{border-color:#bfdbfe;color:#1d4ed8}
        .tag.medical{border-color:#bbf7d0;color:#15803d}
        .tag.training{border-color:#fde68a;color:#92400e}

        .status{display:inline-flex;align-items:center;justify-content:center;padding:4px 10px;border-radius:999px;font-size:12px;font-weight:700;text-transform:lowercase}
        .status.active{background:var(--pill);color:#fff}
        .status.inactive{background:#e5e7eb;color:#374151}

        .actions{display:flex;gap:8px}
        .icon-btn{width:34px;height:34px;display:inline-flex;align-items:center;justify-content:center;background:#fff;border:1px solid var(--line);border-radius:10px;cursor:pointer;color:#4b5563;transition:.15s;text-decoration:none}
        .icon-btn:hover{border-color:#c7cbd1;color:var(--text);background:#f9fafb}
        .icon-btn.delete:hover{color:#dc2626;border-color:#fecaca;background:#fff}

        @media (max-width:900px){.content{padding:22px}.desc{display:none}}
    </style>
</head>
<body>
<div class="layout">
    <% request.setAttribute("currentPage", "manage-services"); %>

    <!-- Sidebar include (tự mang CSS của nó) -->
    <jsp:include page="../inc/side-bar.jsp" />

    <main class="content">
        <div class="topbar">
            <div class="title-wrap">
                <h2>Manage Services</h2>
                <p class="subtitle">Add, update, or delete service information</p>
            </div>
            <a class="btn-add" href="${pageContext.request.contextPath}/admin/service?action=add">
                <i class="ri-add-line"></i> Add Service
            </a>
        </div>

        <!-- Flash -->
        <c:if test="${not empty sessionScope.success}">
            <div style="margin:8px 0;color:#065f46;background:#d1fae5;border:1px solid #a7f3d0;padding:10px;border-radius:8px">${sessionScope.success}</div>
            <c:remove var="success" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div style="margin:8px 0;color:#991b1b;background:#fee2e2;border:1px solid #fecaca;padding:10px;border-radius:8px">${sessionScope.error}</div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <!-- Form filter -->
        <form class="search" method="get" action="${pageContext.request.contextPath}/admin/service">
            <input type="hidden" name="action" value="search"/>
            <i class="ri-search-line"></i>
            <input type="text" name="keyword" placeholder="Search services..." value="${fn:escapeXml(keyword)}"/>

            <select name="categoryId">
                <option value="">All categories</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.categoryId}" <c:if test="${selectedCategoryId == cat.categoryId}">selected</c:if>>${cat.name}</option>
                </c:forEach>
            </select>

            <select name="isActive">
                <option value="">All</option>
                <option value="true"  <c:if test="${selectedActive == 'true'}">selected</c:if>>Active</option>
                <option value="false" <c:if test="${selectedActive == 'false'}">selected</c:if>>Inactive</option>
            </select>

            <select name="sortBy">
                <option value="serviceId"   <c:if test="${sortBy == 'serviceId' || empty sortBy}">selected</c:if>>Newest</option>
                <option value="serviceName" <c:if test="${sortBy == 'serviceName'}">selected</c:if>>Name</option>
                <option value="price"       <c:if test="${sortBy == 'price'}">selected</c:if>>Price</option>
                <option value="duration"    <c:if test="${sortBy == 'duration'}">selected</c:if>>Duration</option>
                <option value="category"    <c:if test="${sortBy == 'category'}">selected</c:if>>Category</option>
                <option value="updated"     <c:if test="${sortBy == 'updated'}">selected</c:if>>Updated</option>
            </select>

            <select name="sortOrder">
                <option value="DESC" <c:if test="${sortOrder == 'DESC'}">selected</c:if>>Desc</option>
                <option value="ASC"  <c:if test="${sortOrder == 'ASC'}">selected</c:if>>Asc</option>
            </select>

            <button class="icon-btn" type="submit" title="Apply filters"><i class="ri-filter-3-line"></i></button>
        </form>

        <!-- Data binding -->
        <c:set var="rows" value="${serviceList}" />
        <c:if test="${empty rows}">
            <c:set var="rows" value="${services}" />
        </c:if>

        <div class="card">
            <table>
                <thead>
                <tr>
                    <th>Service Name</th>
                    <th>Category</th>
                    <th>Duration</th>
                    <th>Price</th>
                    <th>Status</th>
                    <th style="width:180px">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty rows}">
                        <tr><td colspan="6" style="padding:28px;text-align:center;color:#6b7280">No services found.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="s" items="${rows}">
                            <tr>
                                <td>
                                    <strong>${s.serviceName}</strong>
                                    <div class="desc"><c:out value="${s.description}" default="No description"/></div>
                                </td>
                                <td>
                                    <c:set var="catName" value="${s.category != null ? s.category.name : '-'}"/>
                                    <c:choose>
                                        <c:when test="${fn:toLowerCase(catName) == 'grooming'}"><span class="tag grooming">${catName}</span></c:when>
                                        <c:when test="${fn:toLowerCase(catName) == 'medical'}"><span class="tag medical">${catName}</span></c:when>
                                        <c:when test="${fn:toLowerCase(catName) == 'training'}"><span class="tag training">${catName}</span></c:when>
                                        <c:otherwise><span class="tag">${catName}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td><c:out value="${empty s.durationMinutes ? '-' : s.durationMinutes + ' min'}"/></td>
                                <td><fmt:formatNumber value="${s.price}" type="currency" currencySymbol="$" minFractionDigits="2"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${s.active}"><span class="status active">active</span></c:when>
                                        <c:otherwise><span class="status inactive">inactive</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="actions">
                                    <a class="icon-btn" href="${pageContext.request.contextPath}/admin/service?action=view&id=${s.serviceId}" title="View"><i class="ri-eye-line"></i></a>
                                    <a class="icon-btn" href="${pageContext.request.contextPath}/admin/service?action=edit&id=${s.serviceId}" title="Edit"><i class="ri-pencil-line"></i></a>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/service" style="display:inline">
                                        <input type="hidden" name="action" value="delete"/>
                                        <input type="hidden" name="id" value="${s.serviceId}"/>
                                        <button type="submit" class="icon-btn delete" onclick="return confirm('Delete this service?');"><i class="ri-delete-bin-line"></i></button>
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
</body>
</html>
