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

        .btn-add, .btn-export{
            display:inline-flex;align-items:center;gap:8px;
            background:var(--primary);color:#fff;border:none;
            padding:10px 14px;border-radius:10px;font-weight:600;cursor:pointer;
            box-shadow:0 1px 0 rgba(0,0,0,.05);text-decoration:none;font-size:14px
        }
        .btn-add:hover, .btn-export:hover{filter:brightness(.96)}
        .btn-export{background:#10b981;margin-left:8px}

        /* Search & Filter */
        .filter-card{
            background:#fff;border:1px solid var(--line);border-radius:14px;
            padding:20px;margin-bottom:20px;box-shadow:0 1px 3px rgba(15,23,42,.04)
        }
        .filter-row{display:flex;gap:12px;align-items:flex-end;flex-wrap:wrap}
        .filter-group{flex:1;min-width:200px}
        .filter-label{display:block;font-size:13px;font-weight:600;color:#374151;margin-bottom:6px}
        .filter-input, .filter-select{
            width:100%;padding:10px 12px;border:1px solid var(--line);
            border-radius:8px;font-size:14px;font-family:inherit
        }
        .filter-input:focus, .filter-select:focus{outline:none;border-color:var(--primary);box-shadow:0 0 0 3px rgba(37,99,235,.1)}
        .btn-filter, .btn-reset{
            padding:10px 16px;border-radius:8px;font-weight:600;cursor:pointer;
            font-size:14px;border:none;display:inline-flex;align-items:center;gap:6px
        }
        .btn-filter{background:var(--primary);color:#fff}
        .btn-filter:hover{filter:brightness(.96)}
        .btn-reset{background:#f3f4f6;color:#374151;border:1px solid var(--line);text-decoration:none}
        .btn-reset:hover{background:#e5e7eb}

        .results-info{
            display:flex;justify-content:space-between;align-items:center;
            padding:12px 0;color:var(--muted);font-size:14px
        }
        .results-count{font-weight:600;color:var(--text)}

        .rating{color:#fbbf24;font-size:14px}

        /* Pagination */
        .pagination{
            display:flex;justify-content:center;align-items:center;gap:8px;
            padding:24px 0;margin-top:20px
        }
        .page-btn{
            min-width:36px;height:36px;display:inline-flex;align-items:center;justify-content:center;
            background:#fff;border:1px solid var(--line);border-radius:8px;
            cursor:pointer;color:#374151;font-weight:500;font-size:14px;text-decoration:none;
            padding:0 12px
        }
        .page-btn:hover:not(.active):not(.disabled){background:#f9fafb;border-color:#c7cbd1}
        .page-btn.active{background:var(--primary);color:#fff;border-color:var(--primary)}
        .page-btn.disabled{opacity:.5;cursor:not-allowed;pointer-events:none}
        .page-info{color:var(--muted);font-size:14px;margin:0 8px}

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
            <div style="display:flex;gap:8px">
                <a class="btn-export" href="${pageContext.request.contextPath}/petServiceHistory?action=export&search=${searchTerm}&serviceType=${selectedServiceType}&petId=${selectedPetId}">
                    <i class="ri-download-2-line"></i> Export CSV
                </a>
                <a class="btn-add" href="${pageContext.request.contextPath}/petServiceHistory?action=add">
                    <i class="ri-add-line"></i> Add Record
                </a>
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
            <form method="get" action="${pageContext.request.contextPath}/petServiceHistory">
                <div class="filter-row">
                    <div class="filter-group">
                        <label class="filter-label">Search</label>
                        <input type="text" name="search" class="filter-input" 
                               placeholder="Pet name, description, notes..." 
                               value="${searchTerm}">
                    </div>
                    <div class="filter-group" style="flex:0.8">
                        <label class="filter-label">Service Type</label>
                        <select name="serviceType" class="filter-select">
                            <option value="All" ${selectedServiceType == null || selectedServiceType == 'All' ? 'selected' : ''}>All Services</option>
                            <c:forEach var="type" items="${serviceTypes}">
                                <option value="${type}" ${selectedServiceType == type ? 'selected' : ''}>${type}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div style="display:flex;gap:8px">
                        <button type="submit" class="btn-filter">
                            <i class="ri-search-line"></i> Search
                        </button>
                        <a href="${pageContext.request.contextPath}/petServiceHistory" class="btn-reset">
                            <i class="ri-refresh-line"></i> Reset
                        </a>
                    </div>
                </div>
            </form>
        </div>

        <!-- Results Info -->
        <div class="results-info">
            <span>
                Showing <span class="results-count">${fn:length(historyList)}</span> of 
                <span class="results-count">${totalRecords != null ? totalRecords : fn:length(historyList)}</span> records
                <c:if test="${selectedPet != null}">
                    for <strong>${selectedPet.name}</strong>
                </c:if>
            </span>
            <c:if test="${totalPages != null && totalPages > 0}">
                <span>Page ${currentPage != null ? currentPage : 1} of ${totalPages}</span>
            </c:if>
        </div>

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
                    <th>Rating</th>
                    <th style="width:120px">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty historyList}">
                        <tr><td colspan="9" class="empty">No service history records found.</td></tr>
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
                                <td>${h.formattedDate}</td>
                                <td>$<fmt:formatNumber value="${h.cost}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                <td>${h.staff != null ? h.staff.fullName : '-'}</td>
                                <td>
                                    <c:if test="${h.rating != null}">
                                        <span class="rating">
                                            <c:forEach begin="1" end="${h.rating}">★</c:forEach>
                                            <c:forEach begin="${h.rating + 1}" end="5">☆</c:forEach>
                                        </span>
                                    </c:if>
                                    <c:if test="${h.rating == null}">-</c:if>
                                </td>
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

        <!-- Pagination -->
        <c:if test="${totalPages != null && totalPages > 1}">
            <div class="pagination">
                <c:set var="currentPageNum" value="${currentPage != null ? currentPage : 1}"/>
                <c:url var="prevUrl" value="/petServiceHistory">
                    <c:param name="page" value="${currentPageNum - 1}"/>
                    <c:if test="${searchTerm != null}"><c:param name="search" value="${searchTerm}"/></c:if>
                    <c:if test="${selectedServiceType != null}"><c:param name="serviceType" value="${selectedServiceType}"/></c:if>
                    <c:if test="${selectedPetId != null}"><c:param name="petId" value="${selectedPetId}"/></c:if>
                </c:url>
                <c:url var="nextUrl" value="/petServiceHistory">
                    <c:param name="page" value="${currentPageNum + 1}"/>
                    <c:if test="${searchTerm != null}"><c:param name="search" value="${searchTerm}"/></c:if>
                    <c:if test="${selectedServiceType != null}"><c:param name="serviceType" value="${selectedServiceType}"/></c:if>
                    <c:if test="${selectedPetId != null}"><c:param name="petId" value="${selectedPetId}"/></c:if>
                </c:url>

                <a href="${prevUrl}" class="page-btn ${currentPageNum == 1 ? 'disabled' : ''}">
                    <i class="ri-arrow-left-s-line"></i> Prev
                </a>

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <c:if test="${i == 1 || i == totalPages || (i >= currentPageNum - 2 && i <= currentPageNum + 2)}">
                        <c:url var="pageUrl" value="/petServiceHistory">
                            <c:param name="page" value="${i}"/>
                            <c:if test="${searchTerm != null}"><c:param name="search" value="${searchTerm}"/></c:if>
                            <c:if test="${selectedServiceType != null}"><c:param name="serviceType" value="${selectedServiceType}"/></c:if>
                            <c:if test="${selectedPetId != null}"><c:param name="petId" value="${selectedPetId}"/></c:if>
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

<jsp:include page="../inc/chatbox.jsp" />
<jsp:include page="../inc/footer.jsp" />
</body>
</html>
