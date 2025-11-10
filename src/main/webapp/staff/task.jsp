<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.petcaresystem.enities.Appointment" %>
<%@ page import="com.petcaresystem.enities.Service" %>
<%@ page import="com.petcaresystem.enities.enu.AppointmentStatus" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    List<Appointment> taskList = (List<Appointment>) request.getAttribute("taskList");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/inc/common-head.jspf" %>

    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>My Tasks</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">

    <style>
        :root{--primary:#2563eb; --text:#1f2937; --muted:#6b7280; --line:#e5e7eb; --bg:#f7f9fc; --table-head:#f3f4f6;}
        *{box-sizing:border-box}
        html, body { min-height: 100vh; display: flex; flex-direction: column; }
        body > .layout { flex: 1 0 auto; }
        .layout{display:flex;}
        .content{flex:1;padding:28px 36px}
        .topbar{display:flex;align-items:center;gap:16px;margin-bottom:18px}
        h2{margin:0 0 2px 0;font-size:24px}
        .subtitle{margin:0;color:var(--muted);font-size:14px}
        .card{background:#fff;border:1px solid var(--line);border-radius:14px;overflow:hidden;box-shadow:0 1px 3px rgba(15,23,42,.04);margin-top:20px}
        table{width:100%;border-collapse:separate;border-spacing:0}
        thead th{background:var(--table-head);text-align:left;padding:14px 18px;font-size:13px;color:#4b5563;font-weight:600;border-bottom:1px solid var(--line)}
        tbody td{padding:16px 18px;vertical-align:top;border-top:1px solid var(--line)}
        tbody tr:hover{background:#fafafa}
        .empty{padding:40px;text-align:center;color:#6b7280;}
        .task-form textarea {
            width: 100%; min-height: 60px; border: 1px solid #ddd;
            border-radius: 8px; padding: 8px; font-size: 14px; margin-bottom: 8px;
        }
        .task-form button {
            border: none; padding: 8px 12px; border-radius: 8px;
            font-weight: 600; cursor: pointer; font-size: 14px;
        }
        .btn-start { background: #2563eb; color: white; }
        .btn-complete { background: #10b981; color: white; }
        .alert { padding: 10px; border-radius: 8px; margin: 8px 0; }
        .alert-success { color: #065f46; background: #d1fae5; border: 1px solid #a7f3d0; }
        .alert-error { color: #991b1b; background: #fee2e2; border: 1px solid #fecaca; }
        .modal-body .info-grid {
            display: grid; grid-template-columns: 120px 1fr;
            gap: 8px 16px;
        }
        .modal-body .info-grid dt { font-weight: 600; color: var(--muted); }
    </style>
</head>
<body>
<jsp:include page="/inc/header.jsp" />

<div class="layout">
    <% request.setAttribute("activePage", "my-tasks"); %>
    <jsp:include page="/inc/staff-sidebar.jsp" />

    <main class="content">
        <div class="topbar">
            <div>
                <h2>My Assigned Tasks</h2>
                <p class="subtitle">Appointments assigned to you by the Receptionist.</p>
            </div>
        </div>
        <% String success = (String) session.getAttribute("success");
            if (success != null) { %>
        <div class="alert alert-success"><%= success %></div>
        <% session.removeAttribute("success"); } %>

        <% String error = (String) session.getAttribute("error");
            if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
        <% session.removeAttribute("error"); } %>


        <div class="card">
            <table>
                <thead>
                <tr>
                    <th>Appointment</th>
                    <th>Customer</th>
                    <th>Pet</th>
                    <th>Service(s)</th>
                    <th>Status</th>
                    <th>Action (F_38)</th>
                </tr>
                </thead>
                <tbody>
                <% if (taskList == null || taskList.isEmpty()) { %>
                <tr><td colspan="6" class="empty">You have no pending tasks.</td></tr>
                <% } else {
                    for (Appointment app : taskList) {
                        AppointmentStatus status = app.getStatus();
                        String modalId = "completeModal-" + app.getAppointmentId();
                %>
                <tr>
                    <td><%= app.getAppointmentDate().format(dtf) %></td>
                    <td><%= app.getCustomer().getFullName() %></td>
                    <td><%= app.getPet().getName() %></td>
                    <td>
                        <% for (Service s : app.getServices()) { %>
                        <span>- <%= s.getServiceName() %></span><br>
                        <% } %>
                    </td>
                    <td>
                        <strong style="color: <%= (status == AppointmentStatus.IN_PROGRESS) ? "#db7c22" : "#2563eb" %>">
                            <%= status.name() %>
                        </strong>
                    </td>
                    <td>
                        <form method="post" action="<%= request.getContextPath() %>/staff/task" class="task-form">
                            <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">

                            <% if (status == AppointmentStatus.CONFIRMED || status == AppointmentStatus.SCHEDULED || status == AppointmentStatus.CHECKED_IN) { %>
                            <label>Notes (Start):</label>
                            <textarea name="notes" placeholder="Update progress, pet condition..."><%= (app.getNotes() != null) ? app.getNotes() : "" %></textarea>
                            <button type="submit" name="action" value="start" class="btn-start">
                                <i class="ri-play-line"></i> Start
                            </button>
                            <% } else if (status == AppointmentStatus.IN_PROGRESS) { %>
                            <label>Notes (In Progress):</label>
                            <textarea name="notes" placeholder="Update progress..."><%= (app.getNotes() != null) ? app.getNotes() : "" %></textarea>
                            <button type="submit" name="action" value="start" class="btn-start" style="background-color: #6b7280;">
                                <i class="ri-save-line"></i> Save Note
                            </button>
                            <button type="button" class="btn-complete"
                                    data-bs-toggle="modal"
                                    data-bs-target="#<%= modalId %>">
                                <i class="ri-check-line"></i> Complete
                            </button>
                            <% } %>
                        </form>
                    </td>
                </tr>
                <%     }
                }
                %>
                </tbody>
            </table>
        </div>
    </main>
</div>
<% if (taskList != null) {
    for (Appointment app : taskList) {
        if (app.getStatus() == AppointmentStatus.IN_PROGRESS) {
            String modalId = "completeModal-" + app.getAppointmentId();
%>
<div class="modal fade" id="<%= modalId %>" tabindex="-1" aria-labelledby="<%= modalId %>Label" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form method="post" action="<%= request.getContextPath() %>/staff/task">
                <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                <input type="hidden" name="action" value="complete">

                <div class="modal-header">
                    <h5 class="modal-title" id="<%= modalId %>Label">Confirm Task Completion #<%= app.getAppointmentId() %></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <p>Please enter the <strong>final note</strong> before completing the service.</p>
                    <dl class="info-grid">
                        <dt>Customer:</dt>
                        <dd><%= app.getCustomer().getFullName() %></dd>

                        <dt>Pet:</dt>
                        <dd><%= app.getPet().getName() %></dd>

                        <dt>Service:</dt>
                        <dd>
                            <% for (Service s : app.getServices()) { %>
                            <%= s.getServiceName() %><br>
                            <% } %>
                        </dd>
                    </dl>
                    <hr>
                    <div class="form-group">
                        <label for="notes-<%= app.getAppointmentId() %>" class="form-label" style="font-weight: 600;">Final Note (Optional):</label>
                        <textarea name="notes" id="notes-<%= app.getAppointmentId() %>" class="form-control" rows="4"
                                  placeholder="Pet condition after service, instructions for owner..."><%= (app.getNotes() != null) ? app.getNotes() : "" %></textarea>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success">
                        <i class="ri-check-double-line"></i> Save & Complete
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<%      }
}
}
%>
<jsp:include page="/inc/chatbox.jsp" />
<jsp:include page="/inc/footer.jsp" />

</body>
</html>