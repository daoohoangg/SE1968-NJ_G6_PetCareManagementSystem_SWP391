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
    <title>Job Assignment</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        :root{--primary:#2563eb;--text:#1f2937;--muted:#6b7280;--line:#e5e7eb;--bg:#f7f9fc;--table-head:#f3f4f6;--success:#10b981;--warning:#f59e0b}
        *{box-sizing:border-box}
        html,body{height:100%}
        body{margin:0;font-family:Inter,system-ui,Segoe UI,Roboto,Arial,Helvetica,sans-serif;color:var(--text);background:var(--bg)}
        .layout{display:flex;min-height:100vh}
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
        .status.assigned{background:#d1fae5;color:#065f46}
        .status.unassigned{background:#fee2e2;color:#991b1b}
        .btn{display:inline-flex;align-items:center;gap:6px;padding:8px 14px;border-radius:8px;font-weight:600;cursor:pointer;border:none;font-size:13px;text-decoration:none}
        .btn-primary{background:var(--primary);color:#fff}
        .btn-primary:hover{filter:brightness(.96)}
        .btn-success{background:var(--success);color:#fff}
        .btn-success:hover{filter:brightness(.96)}
        .empty{padding:40px;text-align:center;color:#6b7280;border:1px dashed #ddd;border-radius:8px;margin:20px 0}
        .modal{display:none;position:fixed;z-index:1000;left:0;top:0;width:100%;height:100%;background:rgba(0,0,0,.5);align-items:center;justify-content:center}
        .modal.show{display:flex}
        .modal-content{background:#fff;border-radius:14px;padding:24px;max-width:500px;width:90%;box-shadow:0 20px 25px -5px rgba(0,0,0,.1)}
        .modal-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px}
        .modal-header h3{margin:0;font-size:20px}
        .modal-close{background:none;border:none;font-size:24px;cursor:pointer;color:#6b7280;padding:0;width:32px;height:32px;display:flex;align-items:center;justify-content:center;border-radius:6px}
        .modal-close:hover{background:#f3f4f6}
        .modal-body{margin-bottom:20px}
        .form-field{margin-bottom:16px}
        .form-field label{display:block;font-size:14px;font-weight:600;color:#374151;margin-bottom:6px}
        .form-field select{width:100%;padding:10px 12px;border:1px solid var(--line);border-radius:8px;font-size:14px;font-family:inherit}
        .form-field select:focus{outline:none;border-color:var(--primary);box-shadow:0 0 0 3px rgba(37,99,235,.1)}
        .modal-footer{display:flex;gap:10px;justify-content:flex-end}
        .btn-modal{padding:10px 20px;border-radius:8px;font-weight:600;cursor:pointer;font-size:14px;border:none}
        .btn-modal.primary{background:var(--primary);color:#fff}
        .btn-modal.primary:hover{filter:brightness(.96)}
        .btn-modal.secondary{background:#f3f4f6;color:#374151;border:1px solid var(--line)}
        .btn-modal.secondary:hover{background:#e5e7eb}
    </style>
</head>
<body>
<jsp:include page="../inc/header.jsp" />
<div class="layout">
    <% request.setAttribute("activePage", "job-assignment"); %>
    <jsp:include page="../inc/staff-sidebar.jsp" />

    <main class="content">
        <div class="topbar">
            <div class="title-wrap">
                <h2>Job Assignment</h2>
                <p class="subtitle">Assign tasks (grooming, examination, care) to appropriate staff</p>
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
                    <th>ID</th>
                    <th>Customer</th>
                    <th>Pet</th>
                    <th>Date & Time</th>
                    <th>Services</th>
                    <th>Assigned Staff</th>
                    <th>Status</th>
                    <th style="width:200px">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty appointments}">
                        <tr><td colspan="8" class="empty">No appointments found.</td></tr>
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
                                <td>
                                    <c:choose>
                                        <c:when test="${apt.staff != null}">
                                            ${apt.staff.fullName}
                                            <c:if test="${apt.staff.specialization != null}">
                                                <br/><small style="color:#6b7280">${apt.staff.specialization}</small>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color:#991b1b;font-weight:600">Not Assigned</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="status ${apt.staff != null ? 'assigned' : 'unassigned'}">
                                        ${apt.staff != null ? 'Assigned' : 'Unassigned'}
                                    </span>
                                </td>
                                <td>
                                    <button class="btn btn-primary" onclick="openAssignModal(${apt.appointmentId})">
                                        <i class="ri-user-add-line"></i> Assign
                                    </button>
                                    <form method="post" action="${pageContext.request.contextPath}/staff/jobassignment" style="display:inline;margin-left:4px">
                                        <input type="hidden" name="action" value="autoAssign"/>
                                        <input type="hidden" name="appointmentId" value="${apt.appointmentId}"/>
                                        <button type="submit" class="btn btn-success">
                                            <i class="ri-magic-line"></i> Auto
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

<!-- Assign Staff Modal -->
<div id="assignModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Assign Staff to Appointment</h3>
            <button class="modal-close" onclick="closeAssignModal()">×</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/staff/jobassignment">
            <input type="hidden" name="action" value="assignStaff"/>
            <input type="hidden" name="appointmentId" id="assignAppointmentId"/>
            <div class="modal-body">
                <div class="form-field">
                    <label for="assignStaffId">Select Staff</label>
                    <select id="assignStaffId" name="staffId" required>
                        <option value="">-- Select Staff --</option>
                        <c:forEach var="staff" items="${availableStaff}">
                            <option value="${staff.accountId}">
                                ${staff.fullName} 
                                <c:if test="${staff.specialization != null}">
                                    - ${staff.specialization}
                                </c:if>
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-modal secondary" onclick="closeAssignModal()">Cancel</button>
                <button type="submit" class="btn-modal primary">Assign Staff</button>
            </div>
        </form>
    </div>
</div>

<script>
function openAssignModal(appointmentId) {
    document.getElementById('assignAppointmentId').value = appointmentId;
    document.getElementById('assignModal').classList.add('show');
}

function closeAssignModal() {
    document.getElementById('assignModal').classList.remove('show');
}

document.getElementById('assignModal').addEventListener('click', function(e) {
    if (e.target === this) {
        closeAssignModal();
    }
});
</script>

<jsp:include page="../inc/chatbox.jsp" />
<jsp:include page="../inc/footer.jsp" />
</body>
</html>
