<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/inc/common-head.jspf" %>

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
        .page-size-select{
            border:1px solid var(--line);
            border-radius:10px;
            padding:6px 10px;
            background:#fff;
            color:var(--text);
            font-size:13px;
        }
        .page-size-control{
            display:flex;
            align-items:center;
            gap:6px;
            color:var(--muted);
            font-size:13px;
        }
        .pagination-bar{
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-top:16px;
            background:#fff;
            border:1px solid var(--line);
            border-radius:12px;
            padding:10px 16px;
            box-shadow:0 6px 12px rgba(15,23,42,.05);
        }
        .pagination-info{color:var(--muted);font-size:13px;}
        .pagination-controls{display:flex;align-items:center;gap:8px;}
        .pager-btn{
            border:1px solid var(--line);
            background:#fff;
            border-radius:10px;
            padding:6px 12px;
            font-size:13px;
            font-weight:600;
            color:var(--text);
            text-decoration:none;
            display:inline-flex;
            align-items:center;
            gap:6px;
            transition:.18s;
        }
        .pager-btn:hover{border-color:#bfdbfe;color:#2563eb;}
        .pager-btn.disabled{opacity:.5;pointer-events:none;}


        .card{background:#fff;border:1px solid var(--line);border-radius:14px;overflow:hidden;box-shadow:0 1px 3px rgba(15,23,42,.04)}
        table{width:100%;border-collapse:separate;border-spacing:0}
        thead th{background:var(--table-head);text-align:left;padding:14px 18px;font-size:13px;color:#4b5563;font-weight:600;border-bottom:1px solid var(--line)}
        tbody td{padding:16px 18px;vertical-align:middle;border-top:1px solid var(--line)}
        tbody tr:hover{background:#fafafa}
        .name strong{display:block;margin-bottom:4px}
        .desc{font-size:12px;color:#6b7280}
        .empty-row{padding:22px 16px;text-align:center;color:#6b7280;font-size:14px}

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

        .modal-backdrop{
            position:fixed;inset:0;background:rgba(17,24,39,.7);
            display:none;align-items:center;justify-content:center;
            z-index:1200;padding:20px;
            backdrop-filter:none !important;
            -webkit-backdrop-filter:none !important;
        }
        .modal-backdrop.show{display:flex}
        .modal-card{
            width:100%;max-width:520px;background:#fff;border-radius:16px;
            box-shadow:0 28px 60px rgba(15,23,42,.25);
            border:1px solid rgba(148,163,184,.18);
            overflow:hidden;animation:modalShow .22s ease-out;
            opacity: 1 !important;
            filter: none !important;
            backdrop-filter: none !important;
            -webkit-backdrop-filter:none !important;
            background-color:#fff;
            color:var(--text);
        }
        .modal-card form{background:#fff;}
        .modal-header,
        .modal-body{background:#fff;}
        .modal-header{
            padding:22px 28px 12px;display:flex;justify-content:space-between;align-items:flex-start;
        }
        .modal-title{margin:0;font-size:20px;font-weight:600;color:var(--text)}
        .modal-sub{margin:4px 0 0;font-size:13px;color:var(--muted)}
        .modal-close{
            border:none;background:transparent;color:#6b7280;font-size:22px;cursor:pointer;
            padding:0;margin:0 0 0 12px;line-height:1;
        }
        .modal-body{padding:0 28px 0}
        .modal-grid{display:grid;gap:14px}
        .modal-field{display:flex;flex-direction:column;gap:6px}
        .modal-field label{font-size:13px;font-weight:600;color:#374151}
        .modal-field input,
        .modal-field textarea,
        .modal-field select{
            border:1px solid var(--line);border-radius:10px;padding:11px 12px;
            font-size:14px;color:var(--text);background:#fff;
            transition:border-color .15s, box-shadow .15s;
        }
        .modal-field textarea{min-height:90px;resize:vertical}
        .modal-field input:focus,
        .modal-field textarea:focus,
        .modal-field select:focus{
            border-color:var(--primary);box-shadow:0 0 0 3px rgba(37,99,235,.18);outline:none;
        }
        .modal-actions{
            margin-top:22px;
            padding:16px 28px 28px;
            border-top:1px solid var(--line);
            display:flex;
            justify-content:flex-end;
            align-items:center;
            gap:12px;
            background:#fff;
            margin-left:-28px;
            margin-right:-28px;
        }
        .modal-actions button{
            display:inline-flex;
            align-items:center;
            justify-content:center;
            padding:10px 16px;
            border-radius:10px;
            font-size:14px;
            font-weight:600;
            cursor:pointer;
            border:none;
            white-space:nowrap;
        }
        .btn-cancel{
            background:#f3f4f6;
            color:#374151;
        }
        .btn-primary{
            background:var(--primary);
            color:#fff;
            box-shadow:0 1px 0 rgba(0,0,0,.05);
        }
        .btn-primary:hover{filter:brightness(.96)}
        body.modal-open{overflow:hidden}
        @keyframes modalShow{
            0%{transform:translateY(18px);opacity:0}
            100%{transform:translateY(0);opacity:1}
        }
        .modal-backdrop{
            position: fixed; inset: 0;
            background: rgba(17,24,39,.60) !important;  /* tối nền */
            display: none; align-items: center; justify-content: center;
            z-index: 1200 !important; padding: 20px;
            opacity: 1 !important;              /* quan trọng: không mờ cây con */
            filter: none !important;
            backdrop-filter: none !important;
            -webkit-backdrop-filter: none !important;
        }
        .modal-backdrop.show{ display:flex; }
        .modal-card{
            position: relative;
            z-index: 1201 !important;               /* đứng trên overlay */
            background: #fff !important;
            color: var(--text);
            border: 1px solid rgba(148,163,184,.22);
            box-shadow: 0 28px 60px rgba(15,23,42,.35);

            /* Chống mờ từ ancestor */
            opacity: 1 !important;
            filter: none !important;
            backdrop-filter: none !important;
            -webkit-backdrop-filter: none !important;
            isolation: isolate;                     /* ngắt stacking context thấm xuống */

            /* Tránh render “đục” do layer hợp nhất */
            transform: translateZ(0);
            will-change: transform;
        }
        /* Set background cho modal card và các phần tử con, nhưng không override button */
        .modal-card{
            background-color:#fff !important;
        }
        .modal-card *{
            opacity: 1 !important;
            filter: none !important;
            mix-blend-mode: normal !important;
        }
        /* Đảm bảo nút trong modal-actions hiển thị đúng với màu nền riêng */
        .modal-actions{
            opacity: 1 !important;
            visibility: visible !important;
            display: flex !important;
            background: #fff !important;
        }
        .modal-actions button,
        .modal-actions .btn-primary,
        .modal-actions .btn-cancel{
            opacity: 1 !important;
            visibility: visible !important;
            display: inline-flex !important;
            background-color: initial !important; /* Reset về giá trị ban đầu */
        }
        .modal-actions .btn-primary{
            background: var(--primary) !important;
            background-color: var(--primary) !important;
            color: #fff !important;
        }
        .modal-actions .btn-cancel{
            background: #f3f4f6 !important;
            background-color: #f3f4f6 !important;
            color: #374151 !important;
        }
    </style>
</head>
<body>
<jsp:include page="../inc/header.jsp" />
<div class="layout">
    <% request.setAttribute("activePage", "manage-services"); %>

    <!-- Sidebar include (tá»± mang CSS cá»§a nÃ³) -->
    <jsp:include page="../inc/side-bar.jsp" />

    <main class="content">
        <div class="topbar">
            <div class="title-wrap">
                <h2>Manage Services</h2>
                <p class="subtitle">Add, update, or delete service information</p>
            </div>
            <button type="button" class="btn-add" id="btnAddService">
                <i class="ri-add-line"></i> Add Service
            </button>
        </div>

        <div id="addServiceModal" class="modal-backdrop" aria-hidden="true">
            <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="addServiceTitle">
                <form method="post" action="${pageContext.request.contextPath}/admin/service">
                    <div class="modal-header">
                        <div>
                            <h3 class="modal-title" id="addServiceTitle">Add New Service</h3>
                            <p class="modal-sub">Create a new service for your pet care business.</p>
                        </div>
                        <button type="button" class="modal-close" data-close-modal aria-label="Close">&times;</button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="create"/>
                        <div class="modal-grid">
                            <div class="modal-field">
                                <label for="serviceNameInput">Service Name</label>
                                <input type="text"
                                       id="serviceNameInput"
                                       name="serviceName"
                                       maxlength="100"
                                       required
                                       placeholder="e.g. Premium Grooming"/>
                            </div>
                            <div class="modal-field">
                                <label for="categorySelect">Category</label>
                                <select id="categorySelect" name="categoryId" required>
                                    <option value="" disabled selected>Select category</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.categoryId}">${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="modal-field">
                                <label for="durationInput">Duration (minutes)</label>
                                <input type="number"
                                       id="durationInput"
                                       name="durationMinutes"
                                       min="0"
                                       placeholder="e.g. 60"/>
                            </div>
                            <div class="modal-field">
                                <label for="priceInput">Price ($)</label>
                                <input type="number"
                                       id="priceInput"
                                       name="price"
                                       min="0.01"
                                       step="0.01"
                                       required
                                       placeholder="e.g. 49.99"/>
                            </div>
                            <div class="modal-field">
                                <label for="descriptionInput">Description</label>
                                <textarea id="descriptionInput"
                                          name="description"
                                          placeholder="Add a short description"></textarea>
                            </div>
                            <div class="modal-field">
                                <label for="statusSelect">Status</label>
                                <select id="statusSelect" name="status">
                                    <option value="active" selected>Active</option>
                                    <option value="inactive">Inactive</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-actions">
                            <button type="button" class="btn-cancel" data-close-modal>Cancel</button>
                            <button type="submit" class="btn-primary">Add Service</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <div id="editServiceModal" class="modal-backdrop" aria-hidden="true">
            <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="editServiceTitle">
                <form method="post" action="${pageContext.request.contextPath}/admin/service">
                    <div class="modal-header">
                        <div>
                            <h3 class="modal-title" id="editServiceTitle">Edit Service</h3>
                            <p class="modal-sub">Update service information and settings.</p>
                        </div>
                        <button type="button" class="modal-close" data-close-modal aria-label="Close">&times;</button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update"/>
                        <input type="hidden" id="editServiceId" name="serviceId"/>
                        <div class="modal-grid">
                            <div class="modal-field">
                                <label for="editServiceNameInput">Service Name</label>
                                <input type="text"
                                       id="editServiceNameInput"
                                       name="serviceName"
                                       maxlength="100"
                                       required
                                       placeholder="Service name"/>
                            </div>
                            <div class="modal-field">
                                <label for="editCategorySelect">Category</label>
                                <select id="editCategorySelect" name="categoryId" required>
                                    <option value="" disabled>Select category</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.categoryId}">${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="modal-field">
                                <label for="editDurationInput">Duration (minutes)</label>
                                <input type="number"
                                       id="editDurationInput"
                                       name="durationMinutes"
                                       min="0"
                                       placeholder="e.g. 60"/>
                            </div>
                            <div class="modal-field">
                                <label for="editPriceInput">Price ($)</label>
                                <input type="number"
                                       id="editPriceInput"
                                       name="price"
                                       min="0.01"
                                       step="0.01"
                                       required
                                       placeholder="e.g. 49.99"/>
                            </div>
                            <div class="modal-field">
                                <label for="editDescriptionInput">Description</label>
                                <textarea id="editDescriptionInput"
                                          name="description"
                                          placeholder="Describe the service"></textarea>
                            </div>
                            <div class="modal-field">
                                <label for="editStatusSelect">Status</label>
                                <select id="editStatusSelect" name="status">
                                    <option value="active">Active</option>
                                    <option value="inactive">Inactive</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-actions">
                            <button type="button" class="btn-cancel" data-close-modal>Cancel</button>
                            <button type="submit" class="btn-primary">Update Service</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <c:if test="${not empty editService}">
            <a id="autoEditTrigger"
               href="#"
               data-open-edit
               data-id="${editService.serviceId}"
               data-name="${fn:escapeXml(editService.serviceName)}"
               data-description="${editService.description != null ? fn:escapeXml(editService.description) : ''}"
               data-price="${editService.price}"
               data-duration="${editService.durationMinutes != null ? editService.durationMinutes : ''}"
               data-category-id="${editService.category != null ? editService.category.categoryId : ''}"
               data-active="${editService.active}"
               style="display:none;"></a>
        </c:if>

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
            <input type="text" name="keyword" placeholder="Search services..." value="${fn:escapeXml(filterKeyword)}"/>

            <select name="categoryId">
                <option value="">All categories</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.categoryId}" <c:if test="${selectedCategoryId == cat.categoryId}">selected</c:if>>${cat.name}</option>
                </c:forEach>
            </select>

            <select name="isActive">
                <option value="">All</option>
                <option value="true"  <c:if test="${selectedActiveValue == true}">selected</c:if>>Active</option>
                <option value="false" <c:if test="${selectedActiveValue == false}">selected</c:if>>Inactive</option>
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

            <label class="page-size-control">
                Show
                <select name="size" class="page-size-select" onchange="this.form.submit()">
                    <option value="5"  <c:if test="${pageSize == 5}">selected</c:if>>5</option>
                    <option value="10" <c:if test="${pageSize == 10}">selected</c:if>>10</option>
                    <option value="20" <c:if test="${pageSize == 20}">selected</c:if>>20</option>
                    <option value="50" <c:if test="${pageSize == 50}">selected</c:if>>50</option>
                </select>
                per page
            </label>

            <button class="icon-btn" type="submit" title="Apply filters"><i class="ri-filter-3-line"></i></button>
        </form>

        <!-- Data binding -->
        <c:set var="rows"
               value="${not empty requestScope.rows ? requestScope.rows : (not empty serviceList ? serviceList : services)}" />

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
                        <tr><td class="empty-row" colspan="6">No services found.</td></tr>
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
                                <td>
                                    <c:choose>
                                        <c:when test="${empty s.durationMinutes}">-</c:when>
                                        <c:otherwise><c:out value="${s.durationMinutes}"/> min</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatNumber value="${s.price}" type="currency" currencySymbol="$" minFractionDigits="2"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${s.active}"><span class="status active">active</span></c:when>
                                        <c:otherwise><span class="status inactive">inactive</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="actions">
                                    <a class="icon-btn"
                                       href="${pageContext.request.contextPath}/admin/service?action=edit&id=${s.serviceId}"
                                       title="Edit"
                                       data-open-edit
                                       data-id="${s.serviceId}"
                                       data-name="${fn:escapeXml(s.serviceName)}"
                                       data-description="${s.description != null ? fn:escapeXml(s.description) : ''}"
                                       data-price="${s.price}"
                                       data-duration="${s.durationMinutes != null ? s.durationMinutes : ''}"
                                       data-category-id="${s.category != null ? s.category.categoryId : ''}"
                                       data-active="${s.active}">
                                        <i class="ri-pencil-line"></i>
                                    </a>
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
            <c:if test="${totalItems > 0}">
                <c:set var="serviceActionName" value="${not empty serviceAction ? serviceAction : 'list'}" />
                <c:url var="prevUrl" value="/admin/service">
                    <c:param name="action" value="${serviceActionName}" />
                    <c:if test="${not empty filterKeyword}">
                        <c:param name="keyword" value="${filterKeyword}" />
                    </c:if>
                    <c:if test="${selectedCategoryId != null}">
                        <c:param name="categoryId" value="${selectedCategoryId}" />
                    </c:if>
                    <c:if test="${selectedActiveValue != null}">
                        <c:param name="isActive" value="${selectedActiveValue}" />
                    </c:if>
                    <c:if test="${not empty sortBy}">
                        <c:param name="sortBy" value="${sortBy}" />
                    </c:if>
                    <c:if test="${not empty sortOrder}">
                        <c:param name="sortOrder" value="${sortOrder}" />
                    </c:if>
                    <c:param name="size" value="${pageSize}" />
                    <c:param name="page" value="${currentPage - 1}" />
                </c:url>
                <c:url var="nextUrl" value="/admin/service">
                    <c:param name="action" value="${serviceActionName}" />
                    <c:if test="${not empty filterKeyword}">
                        <c:param name="keyword" value="${filterKeyword}" />
                    </c:if>
                    <c:if test="${selectedCategoryId != null}">
                        <c:param name="categoryId" value="${selectedCategoryId}" />
                    </c:if>
                    <c:if test="${selectedActiveValue != null}">
                        <c:param name="isActive" value="${selectedActiveValue}" />
                    </c:if>
                    <c:if test="${not empty sortBy}">
                        <c:param name="sortBy" value="${sortBy}" />
                    </c:if>
                    <c:if test="${not empty sortOrder}">
                        <c:param name="sortOrder" value="${sortOrder}" />
                    </c:if>
                    <c:param name="size" value="${pageSize}" />
                    <c:param name="page" value="${currentPage + 1}" />
                </c:url>
                <div class="pagination-bar">
                    <div class="pagination-info">
                        Showing <c:out value="${pageStart}" /> - <c:out value="${pageEnd}" /> of <c:out value="${totalItems}" />
                    </div>
                    <div class="pagination-controls">
                        <c:choose>
                            <c:when test="${hasPrevPage}">
                                <a class="pager-btn" href="${prevUrl}"><i class="ri-arrow-left-line"></i> Prev</a>
                            </c:when>
                            <c:otherwise>
                                <span class="pager-btn disabled"><i class="ri-arrow-left-line"></i> Prev</span>
                            </c:otherwise>
                        </c:choose>
                        <span class="pagination-info">Page <c:out value="${currentPage}" /> of <c:out value="${totalPages}" /></span>
                        <c:choose>
                            <c:when test="${hasNextPage}">
                                <a class="pager-btn" href="${nextUrl}">Next <i class="ri-arrow-right-line"></i></a>
                            </c:when>
                            <c:otherwise>
                                <span class="pager-btn disabled">Next <i class="ri-arrow-right-line"></i></span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>
        </div>
    </main>
</div>

<script>
    (function () {
        const modal = document.getElementById('addServiceModal');
        if (!modal) return;

        const openBtn = document.getElementById('btnAddService');
        const closeBtns = modal.querySelectorAll('[data-close-modal]');
        const form = modal.querySelector('form');
        const statusSelect = modal.querySelector('#statusSelect');
        const categorySelect = modal.querySelector('#categorySelect');
        const nameInput = modal.querySelector('#serviceNameInput');
        const shouldOpenOnLoad = '${openAddModal == true}' === 'true';

        const showModal = () => {
            if (form) {
                form.reset();
                if (statusSelect) statusSelect.value = 'active';
                if (categorySelect) categorySelect.selectedIndex = 0;
            }
            modal.classList.add('show');
            modal.setAttribute('aria-hidden', 'false');
            document.body.classList.add('modal-open');
            window.setTimeout(() => nameInput && nameInput.focus(), 70);
        };

        const hideModal = () => {
            modal.classList.remove('show');
            modal.setAttribute('aria-hidden', 'true');
            document.body.classList.remove('modal-open');
        };

        openBtn && openBtn.addEventListener('click', (event) => {
            event.preventDefault();
            showModal();
        });

        closeBtns.forEach(btn => btn.addEventListener('click', (event) => {
            event.preventDefault();
            hideModal();
        }));

        modal.addEventListener('click', (event) => {
            if (event.target === modal) {
                hideModal();
            }
        });

        document.addEventListener('keydown', (event) => {
            if (event.key === 'Escape' && modal.classList.contains('show')) {
                hideModal();
            }
        });

        if (shouldOpenOnLoad) {
            showModal();
        }
    })();

    (function () {
        const modal = document.getElementById('editServiceModal');
        if (!modal) return;

        const openButtons = document.querySelectorAll('[data-open-edit]');
        if (!openButtons.length) return;

        const closeButtons = modal.querySelectorAll('[data-close-modal]');
        const form = modal.querySelector('form');
        const idField = modal.querySelector('#editServiceId');
        const nameField = modal.querySelector('#editServiceNameInput');
        const categoryField = modal.querySelector('#editCategorySelect');
        const durationField = modal.querySelector('#editDurationInput');
        const priceField = modal.querySelector('#editPriceInput');
        const descriptionField = modal.querySelector('#editDescriptionInput');
        const statusField = modal.querySelector('#editStatusSelect');
        const shouldOpenOnLoad = '${openEditModal == true}' === 'true';

        const sanitize = (value) => (value == null ? '' : value);
        const applyDataToForm = (data) => {
            if (!data) return;
            if (form) form.reset();

            if (idField) idField.value = sanitize(data.id);
            if (nameField) nameField.value = sanitize(data.name);
            if (categoryField) categoryField.value = sanitize(data.categoryId);
            if (durationField) durationField.value = sanitize(data.duration);
            if (priceField) priceField.value = sanitize(data.price);
            if (descriptionField) descriptionField.value = sanitize(data.description).replace(/\r?\n/g, '\n');

            const rawStatus = sanitize(data.active).toString().toLowerCase();
            if (statusField) {
                statusField.value = (rawStatus === 'false' || rawStatus === 'inactive' || rawStatus === '0') ? 'inactive' : 'active';
            }
        };

        const showModal = (data) => {
            applyDataToForm(data);
            modal.classList.add('show');
            modal.setAttribute('aria-hidden', 'false');
            document.body.classList.add('modal-open');
            window.setTimeout(() => nameField && nameField.focus(), 70);
        };

        const hideModal = () => {
            modal.classList.remove('show');
            modal.setAttribute('aria-hidden', 'true');
            document.body.classList.remove('modal-open');
        };

        const collectDataset = (target) => {
            if (!target) return null;
            const dataset = target.dataset;
            return {
                id: dataset.id,
                name: dataset.name,
                categoryId: dataset.categoryId,
                duration: dataset.duration,
                price: dataset.price,
                description: dataset.description,
                active: dataset.active
            };
        };

        openButtons.forEach((btn) => {
            btn.addEventListener('click', (event) => {
                event.preventDefault();
                showModal(collectDataset(btn));
            });
        });

        closeButtons.forEach((btn) => btn.addEventListener('click', (event) => {
            event.preventDefault();
            hideModal();
        }));

        modal.addEventListener('click', (event) => {
            if (event.target === modal) {
                hideModal();
            }
        });

        document.addEventListener('keydown', (event) => {
            if (event.key === 'Escape' && modal.classList.contains('show')) {
                hideModal();
            }
        });

        if (shouldOpenOnLoad) {
            const autoTrigger = document.getElementById('autoEditTrigger');
            if (autoTrigger) {
                showModal(collectDataset(autoTrigger));
            }
        }
    })();
</script>

<jsp:include page="../inc/chatbox.jsp" />
<jsp:include page="../inc/footer.jsp" />
</body>
</html>

