<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<style>
    :root{
        --primary:#2563eb;
        --primary-soft:#eef2ff;
        --success:#16a34a;
        --danger:#dc2626;
        --warning:#f97316;
        --muted:#6b7280;
        --text:#111827;
        --line:#e5e7eb;
        --bg:#f7f9fc;
        --surface:#ffffff;
        --shadow:0 18px 40px rgba(15,23,42,.08);
    }
    .accounts-page{
        display:flex;
        background:var(--bg);
        font-family:Inter,system-ui,Segoe UI,Roboto,Arial,sans-serif;
        color:var(--text);
        width:100%;
    }
    .accounts-main{
        flex:1;
        padding:32px 40px;
        display:flex;
        flex-direction:column;
        gap:28px;
    }
    .accounts-header{
        display:flex;
        align-items:flex-start;
        justify-content:space-between;
        gap:18px;
        flex-wrap:wrap;
    }
    .accounts-header h1{
        margin:0;
        font-size:28px;
        font-weight:600;
    }
    .accounts-header p{
        margin:8px 0 0;
        color:var(--muted);
        font-size:14px;
    }
    .add-account-btn{
        display:inline-flex;
        align-items:center;
        gap:8px;
        background:var(--primary);
        color:#fff;
        padding:10px 18px;
        border-radius:12px;
        text-decoration:none;
        font-weight:600;
        font-size:14px;
        border:none;
        cursor:pointer;
        box-shadow:0 12px 28px rgba(37,99,235,.25);
        transition:filter .18s, transform .18s;
    }
    .add-account-btn:hover{filter:brightness(.95);transform:translateY(-1px)}
    .stats-row{
        display:grid;
        gap:18px;
        grid-template-columns:repeat(auto-fit,minmax(160px,1fr));
    }
    .stat-card{
        background:var(--surface);
        border:1px solid rgba(148,163,184,.25);
        border-radius:18px;
        padding:20px 22px;
        box-shadow:var(--shadow);
        display:flex;
        flex-direction:column;
        gap:6px;
        min-height:0;
    }
    .stat-title{
        font-size:13px;
        color:var(--muted);
        text-transform:uppercase;
        letter-spacing:.05em;
        font-weight:600;
    }
    .stat-value{
        font-size:26px;
        font-weight:700;
    }
    .filters{
        display:flex;
        align-items:center;
        gap:14px;
        flex-wrap:wrap;
        background:var(--surface);
        border:1px solid var(--line);
        border-radius:14px;
        padding:12px 16px;
        box-shadow:0 8px 20px rgba(15,23,42,.05);
    }
    .page-size-select{
        border:1px solid var(--line);
        border-radius:12px;
        padding:8px 12px;
        font-size:14px;
        background:#fff;
        color:var(--text);
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
        margin-top:18px;
        background:var(--surface);
        border:1px solid var(--line);
        border-radius:14px;
        padding:12px 18px;
        box-shadow:0 6px 14px rgba(15,23,42,.05);
    }
    .pagination-info{
        font-size:13px;
        color:var(--muted);
    }
    .pagination-controls{
        display:flex;
        align-items:center;
        gap:8px;
    }
    .pager-btn{
        border:1px solid var(--line);
        background:#fff;
        color:var(--text);
        border-radius:10px;
        padding:6px 14px;
        font-size:13px;
        font-weight:600;
        text-decoration:none;
        display:inline-flex;
        align-items:center;
        gap:6px;
        transition:.18s;
    }
    .pager-btn:hover{border-color:#cbd5f5;color:var(--primary)}
    .pager-btn.disabled{
        opacity:.5;
        pointer-events:none;
        cursor:default;
    }
    .search-field{
        flex:1;
        display:flex;
        align-items:center;
        gap:10px;
        background:var(--primary-soft);
        border-radius:12px;
        padding:10px 14px;
    }
    .search-field i{color:var(--primary)}
    .search-field input{
        border:none;
        background:transparent;
        outline:none;
        font-size:14px;
        color:var(--text);
        width:100%;
    }
    .role-filter{
        border:1px solid var(--line);
        border-radius:12px;
        padding:10px 12px;
        min-width:160px;
        font-size:14px;
        color:var(--text);
        background:#fff;
    }
    .accounts-table{
        width:100%;
        border-collapse:separate;
        border-spacing:0;
        background:var(--surface);
        border:1px solid rgba(148,163,184,.26);
        border-radius:18px;
        overflow:hidden;
        box-shadow:var(--shadow);
    }
    .accounts-table thead th{
        background:#f3f4f6;
        text-align:left;
        padding:16px 20px;
        font-size:12px;
        font-weight:700;
        text-transform:uppercase;
        color:#6b7280;
        letter-spacing:.05em;
    }
    .accounts-table tbody td{
        padding:18px 20px;
        border-top:1px solid var(--line);
        vertical-align:middle;
    }
    .empty-row{
        text-align:center;
        padding:24px 16px;
        color:var(--muted);
        font-size:14px;
    }
    .user-cell{
        display:flex;
        align-items:flex-start;
        gap:14px;
    }
    .avatar{
        width:42px;
        height:42px;
        border-radius:14px;
        background:var(--primary-soft);
        color:var(--primary);
        font-weight:700;
        display:flex;
        align-items:center;
        justify-content:center;
    }
    .user-meta strong{
        display:block;
        font-size:15px;
        margin-bottom:4px;
    }
    .user-meta span{
        display:flex;
        align-items:center;
        gap:8px;
        color:var(--muted);
        font-size:13px;
    }
    .user-meta span i{color:var(--muted)}
    .role-pill{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        padding:6px 12px;
        border-radius:999px;
        font-size:12px;
        font-weight:600;
        min-width:70px;
    }
    .role-admin{background:rgba(220,38,38,.1);color:var(--danger);}
    .role-staff{background:rgba(59,130,246,.15);color:#2563eb;}
    .role-customer{background:rgba(16,185,129,.15);color:#047857;}
    .status-pill{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        padding:6px 12px;
        border-radius:999px;
        font-size:12px;
        font-weight:600;
        text-transform:uppercase;
        letter-spacing:.04em;
    }
    .status-active{background:rgba(16,185,129,.15);color:#047857;}
    .status-locked{background:rgba(220,38,38,.15);color:var(--danger);}
    .status-pending{background:rgba(249,115,22,.18);color:var(--warning);}
    .actions-cell{
        display:flex;
        gap:10px;
    }
    .icon-btn{
        width:36px;
        height:36px;
        border-radius:10px;
        border:1px solid var(--line);
        background:#fff;
        display:inline-flex;
        align-items:center;
        justify-content:center;
        color:#4b5563;
        cursor:pointer;
        transition:.18s;
    }
    .icon-btn:hover{
        background:var(--primary-soft);
        color:var(--primary);
        border-color:rgba(37,99,235,.35);
    }
    .modal-backdrop{
        position:fixed;
        inset:0;
        background:rgba(15,23,42,.7);
        display:none;
        align-items:center;
        justify-content:center;
        padding:20px;
        z-index:1300;
        backdrop-filter: none !important;
        -webkit-backdrop-filter: none !important;
    }
    .modal-backdrop.show{display:flex;}
    .modal-card{
        width:100%;
        max-width:420px;
        background:#fff !important;
        border-radius:18px;
        border:1px solid rgba(148,163,184,.18);
        box-shadow:0 30px 65px rgba(15,23,42,.25);
        padding:26px 30px 30px;
        display:flex;
        flex-direction:column;
        gap:18px;
        animation:modalFade .22s ease-out;
        font-family:inherit;
        opacity: 1 !important;
        filter: none !important;
        backdrop-filter: none !important;
        -webkit-backdrop-filter: none !important;
    }
    .modal-card form{
        background:#fff !important;
        opacity: 1 !important;
    }
    .modal-header{
        display:flex;
        justify-content:space-between;
        align-items:flex-start;
        gap:14px;
        background:#fff !important;
        opacity: 1 !important;
    }
    .modal-header h2{
        margin:0;
        font-size:22px;
        font-weight:600;
        opacity: 1 !important;
        color:var(--text) !important;
    }
    .modal-header p{
        margin:6px 0 0;
        color:var(--muted);
        font-size:13px;
        opacity: 1 !important;
    }
    .close-btn{
        background:none;
        border:none;
        color:#9ca3af;
        font-size:22px;
        cursor:pointer;
    }
    .modal-body{
        display:flex;
        flex-direction:column;
        gap:14px;
        background:#fff !important;
        opacity: 1 !important;
    }
    .modal-field label{
        display:block;
        font-size:13px;
        font-weight:600;
        color:var(--text);
        margin-bottom:6px;
        opacity: 1 !important;
        background:transparent !important;
    }
    .modal-field input,
    .modal-field select{
        width:100%;
        border:1px solid var(--line);
        border-radius:12px;
        padding:11px 12px;
        font-size:14px;
        color:var(--text);
        background:#fff !important;
        opacity: 1 !important;
        transition:border-color .18s, box-shadow .18s;
    }
    .modal-field input:focus,
    .modal-field select:focus{
        border-color:var(--primary);
        box-shadow:0 0 0 3px rgba(37,99,235,.18);
        outline:none;
    }
    .modal-actions{
        display:flex;
        justify-content:flex-end;
        gap:12px;
        margin-top:6px;
        background:#fff !important;
        opacity: 1 !important;
    }
    .btn-outline,
    .btn-primary{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        padding:10px 18px;
        border-radius:12px;
        font-weight:600;
        font-size:14px;
        border:1px solid transparent;
        cursor:pointer;
        transition:.18s;
    }
    .btn-outline{
        border-color:var(--line);
        background:#fff;
        color:var(--text);
    }
    .btn-outline:hover{border-color:#cbd5f5;background:#f8fafc;}
    .btn-primary{
        background:var(--primary);
        color:#fff;
        box-shadow:0 12px 26px rgba(37,99,235,.25);
    }
    .btn-primary:hover{filter:brightness(.95);transform:translateY(-1px);}
    body.modal-open{overflow:hidden;}
    @media (max-width:992px){
        .accounts-main{padding:28px;}
    }
    @media (max-width:768px){
        .accounts-main{padding:24px 18px;}
        .filters{flex-direction:column;align-items:stretch;}
        .role-filter{width:100%;}
    }
    @keyframes modalFade{
        from{opacity:0;transform:translateY(10px);}
        to{opacity:1;transform:translateY(0);}
    }
</style>

<jsp:include page="../inc/header.jsp" />
<main class="content-wrapper">
    <section class="page accounts-page">
        <jsp:include page="../inc/side-bar.jsp" />
        <div class="accounts-main">
            <div class="accounts-header">
                <div>
                    <h1>Account Management</h1>
                    <p>Create accounts with different roles and manage authorization</p>
                </div>
                <button class="add-account-btn" type="button" data-open-modal="addAccountModal">
                    <i class="ri-add-line"></i>Add Account
                </button>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" style="margin: 20px 0; padding: 15px; background: #fee; border: 1px solid #fcc; border-radius: 5px; color: #c33;">
                    <strong>Error:</strong> <c:out value="${error}"/>
                </div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div class="alert alert-success" style="margin: 20px 0; padding: 15px; background: #efe; border: 1px solid #cfc; border-radius: 5px; color: #363;">
                    <strong>Success:</strong> <c:out value="${success}"/>
                </div>
            </c:if>

            <div class="stats-row">
                <div class="stat-card">
                    <span class="stat-title">Total</span>
                    <span class="stat-value"><c:out value="${accountsTotal}" default="0"/></span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Active</span>
                    <span class="stat-value"><c:out value="${accountsActive}" default="0"/></span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Locked</span>
                    <span class="stat-value"><c:out value="${accountsLocked}" default="0"/></span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Admins</span>
                    <span class="stat-value"><c:out value="${accountsAdmin}" default="0"/></span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Staff</span>
                    <span class="stat-value"><c:out value="${accountsStaff}" default="0"/></span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Customers</span>
                    <span class="stat-value"><c:out value="${accountsCustomer}" default="0"/></span>
                </div>
            </div>

            <form class="filters" method="get" action="${pageContext.request.contextPath}/admin/accounts">
                <input type="hidden" name="action" value="search" />
                <c:set var="keywordValue" value="${not empty filterKeyword ? filterKeyword : param.keyword}" />
                <c:set var="roleValue" value="${not empty filterRoleRaw ? filterRoleRaw : (empty param.role ? 'all' : param.role)}" />
                <div class="search-field">
                    <i class="ri-search-line"></i>
                    <input name="keyword" type="text" placeholder="Search accounts..." value="${fn:escapeXml(keywordValue)}" />
                </div>
                <select name="role" class="role-filter">
                    <option value="all" <c:if test="${empty roleValue || roleValue == 'all'}">selected</c:if>>All Roles</option>
                    <option value="ADMIN" <c:if test="${roleValue == 'ADMIN'}">selected</c:if>>Admin</option>
                    <option value="STAFF" <c:if test="${roleValue == 'STAFF'}">selected</c:if>>Staff</option>
                    <option value="CUSTOMER" <c:if test="${roleValue == 'CUSTOMER'}">selected</c:if>>Customer</option>
                </select>
                <label class="page-size-control">
                    Show
                    <select name="size" class="page-size-select" onchange="this.form.submit()">
                        <option value="5" <c:if test="${pageSize == 5}">selected</c:if>>5</option>
                        <option value="10" <c:if test="${pageSize == 10}">selected</c:if>>10</option>
                        <option value="20" <c:if test="${pageSize == 20}">selected</c:if>>20</option>
                        <option value="50" <c:if test="${pageSize == 50}">selected</c:if>>50</option>
                    </select>
                    per page
                </label>
                <button class="add-account-btn" type="submit" style="margin-left:8px">Search</button>
            </form>

            <table class="accounts-table">
                <thead>
                <tr>
                    <th>User</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Last Login</th>
                    <th>Created</th>
                    <th style="text-align:center;">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:if test="${empty accounts}">
                    <tr>
                        <td class="empty-row" colspan="6">No accounts found.</td>
                    </tr>
                </c:if>
                <c:forEach var="acc" items="${requestScope.accounts}">
                    <tr>
                        <td>
                            <div class="user-cell">
                                <div class="avatar"><c:out value="${fn:substring(acc.fullName,0,2)}" default="U"/></div>
                                <div class="user-meta">
                                    <strong><c:out value="${acc.fullName}"/></strong>
                                    <span><i class="ri-mail-line"></i><c:out value="${acc.email}"/></span>
                                    <span><i class="ri-phone-line"></i><c:out value="${acc.phone}"/></span>
                                </div>
                            </div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${acc.role eq 'ADMIN'}"><span class="role-pill role-admin">Admin</span></c:when>
                                <c:when test="${acc.role eq 'STAFF'}"><span class="role-pill role-staff">Staff</span></c:when>
                                <c:otherwise><span class="role-pill role-customer">Customer</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not acc.isActive}">
                                    <span class="status-pill status-locked">locked</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-pill status-active">active</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><c:out value="${acc.lastLogin}"/></td>
                        <td><c:out value="${acc.createdAt}"/></td>
                        <td>
                            <div class="actions-cell">
                                <!-- Edit button - disabled for admin accounts -->
                                <c:choose>
                                    <c:when test="${acc.role eq 'ADMIN'}">
                                        <span class="icon-btn" style="opacity: 0.5; cursor: not-allowed;" title="Cannot edit admin accounts">
                                            <i class="ri-pencil-line"></i>
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="icon-btn" href="${pageContext.request.contextPath}/admin/accounts?action=edit&id=${acc.accountId}" title="Edit">
                                            <i class="ri-pencil-line"></i>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                                
                                <!-- Lock/Unlock button - disabled for admin accounts -->
                                <c:choose>
                                    <c:when test="${acc.role eq 'ADMIN'}">
                                        <span class="icon-btn" style="opacity: 0.5; cursor: not-allowed;" title="Cannot lock admin accounts">
                                            <i class="ri-lock-line"></i>
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/accounts" style="display:inline">
                                            <input type="hidden" name="action" value="${acc.isActive ? 'lock' : 'unlock'}" />
                                            <input type="hidden" name="id" value="${acc.accountId}" />
                                            <button class="icon-btn" type="submit" title="${acc.isActive ? 'Lock' : 'Unlock'}">
                                                <i class="${acc.isActive ? 'ri-lock-line' : 'ri-lock-unlock-line'}"></i>
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                                
                                <!-- Delete button - disabled for admin accounts -->
                                <c:choose>
                                    <c:when test="${acc.role eq 'ADMIN'}">
                                        <span class="icon-btn" style="opacity: 0.5; cursor: not-allowed;" title="Cannot delete admin accounts">
                                            <i class="ri-delete-bin-line"></i>
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/accounts" style="display:inline" onsubmit="return confirm('Delete this account?');">
                                            <input type="hidden" name="action" value="delete" />
                                            <input type="hidden" name="id" value="${acc.accountId}" />
                                            <button class="icon-btn" type="submit" title="Delete">
                                                <i class="ri-delete-bin-line"></i>
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <!-- Debug pagination: currentPage=${currentPage}, totalPages=${totalPages}, hasNextPage=${hasNextPage}, totalItems=${totalItems} -->
            <c:if test="${totalItems > 0}">
                <c:set var="accountActionName" value="${not empty accountAction ? accountAction : 'search'}" />
                <c:url var="prevUrl" value="/admin/accounts">
                    <c:param name="action" value="${accountActionName}" />
                    <c:if test="${not empty filterKeyword}">
                        <c:param name="keyword" value="${filterKeyword}" />
                    </c:if>
                    <c:if test="${not empty filterRoleRaw && filterRoleRaw != 'all'}">
                        <c:param name="role" value="${filterRoleRaw}" />
                    </c:if>
                    <c:param name="size" value="${pageSize}" />
                    <c:param name="page" value="${currentPage - 1}" />
                </c:url>
                <c:url var="nextUrl" value="/admin/accounts">
                    <c:param name="action" value="${accountActionName}" />
                    <c:if test="${not empty filterKeyword}">
                        <c:param name="keyword" value="${filterKeyword}" />
                    </c:if>
                    <c:if test="${not empty filterRoleRaw && filterRoleRaw != 'all'}">
                        <c:param name="role" value="${filterRoleRaw}" />
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
                                <a class="pager-btn" href="${prevUrl}">
                                    <i class="ri-arrow-left-line"></i> Prev
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="pager-btn disabled"><i class="ri-arrow-left-line"></i> Prev</span>
                            </c:otherwise>
                        </c:choose>
                        <span class="pagination-info">Page <c:out value="${currentPage}" /> of <c:out value="${totalPages}" /></span>
                        <c:choose>
                            <c:when test="${hasNextPage}">
                                <a class="pager-btn" href="${nextUrl}">
                                    Next <i class="ri-arrow-right-line"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="pager-btn disabled">Next <i class="ri-arrow-right-line"></i></span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>
        </div>
        </div>
    </section>
</main>

<div class="modal-backdrop" id="addAccountModal" aria-hidden="true">
    <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="addAccountTitle">
        <form method="post" action="${pageContext.request.contextPath}/admin/accounts">
            <div class="modal-header">
                <div>
                    <h2 id="addAccountTitle">Add New Account</h2>
                    <p>Create a new user account with role-based access.</p>
                </div>
                <button class="close-btn" type="button" data-close-modal>&times;</button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="action" value="create" />
                <div class="modal-field">
                    <label for="addFullName">Full Name</label>
                    <input id="addFullName" name="fullName" type="text" placeholder="Full name" required />
                </div>
                <div class="modal-field">
                    <label for="addUsername">Username</label>
                    <input id="addUsername" name="username" type="text" placeholder="username" required />
                </div>
                <div class="modal-field">
                    <label for="addEmail">Email</label>
                    <input id="addEmail" name="email" type="email" placeholder="name@example.com" required />
                </div>
                <div class="modal-field">
                    <label for="addPhone">Phone</label>
                    <input id="addPhone" name="phone" type="tel" placeholder="+1 (555) 000-0000" />
                </div>
                <div class="modal-field">
                    <label for="addRole">Role</label>
                    <select id="addRole" name="role">
                        <option value="CUSTOMER">Customer</option>
                        <option value="STAFF">Staff</option>
                        <option value="ADMIN">Admin</option>
                    </select>
                </div>
                <div class="modal-field">
                    <label for="addPassword">Password</label>
                    <input id="addPassword" name="password" type="password" placeholder="••••••••" required />
                </div>
            </div>
            <div class="modal-actions">
                <button class="btn-outline" type="button" data-close-modal>Cancel</button>
                <button class="btn-primary" type="submit">Create Account</button>
            </div>
        </form>
    </div>
</div>

<div class="modal-backdrop" id="editAccountModal" aria-hidden="true">
    <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="editAccountTitle">
        <form method="post" action="${pageContext.request.contextPath}/admin/accounts">
            <div class="modal-header">
                <div>
                    <h2 id="editAccountTitle">Edit Account</h2>
                    <p>Update account details and permissions.</p>
                </div>
                <button class="close-btn" type="button" data-close-modal>&times;</button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="action" value="update" />
                <input type="hidden" id="editAccountId" name="accountId" />
                <div class="modal-field">
                    <label for="editFullName">Full Name</label>
                    <input id="editFullName" name="fullName" type="text" />
                </div>
                <div class="modal-field">
                    <label for="editUsername">Username</label>
                    <input id="editUsername" name="username" type="text" />
                </div>
                <div class="modal-field">
                    <label for="editEmail">Email</label>
                    <input id="editEmail" name="email" type="email" />
                </div>
                <div class="modal-field">
                    <label for="editPhone">Phone</label>
                    <input id="editPhone" name="phone" type="tel" />
                </div>
                <div class="modal-field">
                    <label for="editRole">Role</label>
                    <select id="editRole" name="role">
                        <option value="CUSTOMER">Customer</option>
                        <option value="STAFF">Staff</option>
                        <option value="ADMIN">Admin</option>
                    </select>
                </div>
                <div class="modal-field">
                    <label for="editPassword">Password (leave blank to keep)</label>
                    <input id="editPassword" name="password" type="password" />
                </div>
            </div>
            <div class="modal-actions">
                <button class="btn-outline" type="button" data-close-modal>Cancel</button>
                <button class="btn-primary" type="submit">Update Account</button>
            </div>
        </form>
    </div>
</div>

<script>
    (function () {
        const body = document.body;
        const openButtons = document.querySelectorAll('[data-open-modal]');
        const closeButtons = document.querySelectorAll('[data-close-modal]');

        const showModal = (modalId) => {
            const modal = document.getElementById(modalId);
            if (!modal) return;
            modal.classList.add('show');
            modal.setAttribute('aria-hidden', 'false');
            body.classList.add('modal-open');
            const focusable = modal.querySelector('input, select, button');
            window.setTimeout(() => focusable && focusable.focus(), 70);
        };

        const hideModal = (modal) => {
            modal.classList.remove('show');
            modal.setAttribute('aria-hidden', 'true');
            body.classList.remove('modal-open');
        };

        openButtons.forEach(btn => {
            btn.addEventListener('click', () => showModal(btn.getAttribute('data-open-modal')));
        });

        closeButtons.forEach(btn => {
            btn.addEventListener('click', () => hideModal(btn.closest('.modal-backdrop')));
        });

        document.querySelectorAll('.modal-backdrop').forEach(backdrop => {
            backdrop.addEventListener('click', (event) => {
                if (event.target === backdrop) {
                    hideModal(backdrop);
                }
            });
        });

        document.addEventListener('keydown', (event) => {
            if (event.key === 'Escape') {
                document.querySelectorAll('.modal-backdrop.show').forEach(hideModal);
            }
        });
    })();
</script>
<c:if test="${not empty editAccount}">
    <script>
        (function () {
            const modal = document.getElementById('editAccountModal');
            if (!modal) return;
            const idField = modal.querySelector('#editAccountId');
            const nameField = modal.querySelector('#editFullName');
            const usernameField = modal.querySelector('#editUsername');
            const emailField = modal.querySelector('#editEmail');
            const phoneField = modal.querySelector('#editPhone');
            const roleField = modal.querySelector('#editRole');

            if (idField) idField.value = '${editAccount.accountId}';
            if (nameField) nameField.value = '${fn:escapeXml(editAccount.fullName)}';
            if (usernameField) usernameField.value = '${fn:escapeXml(editAccount.username)}';
            if (emailField) emailField.value = '${fn:escapeXml(editAccount.email)}';
            if (phoneField) phoneField.value = '${fn:escapeXml(editAccount.phone)}';
            <c:choose>
                <c:when test="${not empty editAccount.role}">
                    if (roleField) roleField.value = '${editAccount.role.name()}';
                </c:when>
                <c:otherwise>
                    if (roleField) roleField.value = '';
                </c:otherwise>
            </c:choose>

            modal.classList.add('show');
            modal.setAttribute('aria-hidden', 'false');
            document.body.classList.add('modal-open');
            window.setTimeout(() => nameField && nameField.focus(), 70);
        })();
    </script>
</c:if>
<jsp:include page="../inc/chatbox.jsp" />
<jsp:include page="../inc/footer.jsp" />
