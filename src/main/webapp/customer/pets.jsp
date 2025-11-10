<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.petcaresystem.enities.Account" %>
<%@ page import="com.petcaresystem.enities.Pet" %>

<%
    // Require prepared data from controller; otherwise send to pet list page
    if (request.getAttribute("pets") == null) {
        response.sendRedirect(request.getContextPath() + "/customer/pets");
        return;
    }
%>

<%
    Account loggedInAccount = (Account) session.getAttribute("account");
    String ctx = request.getContextPath();

    @SuppressWarnings("unchecked")
    List<Pet> pets = (List<Pet>) request.getAttribute("pets");
    if (pets == null) pets = Collections.emptyList();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/inc/common-head.jspf" %>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Pets</title>

    <!-- Inter Variable + fallbacks -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400..700&display=swap" rel="stylesheet">
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        :root { --pc-border:#e9ecef; --pc-shadow:0 6px 16px rgba(0,0,0,.06); }
        html { -webkit-text-size-adjust:100%; }
        body {
            font-family:'Inter', system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
            -webkit-font-smoothing:antialiased; -moz-osx-font-smoothing:grayscale;
            background:#f7f9fc;
        }
        .page-card {
            max-width:900px; margin:40px auto; border:1px solid var(--pc-border);
            border-radius:12px; background:#fff; box-shadow:var(--pc-shadow);
        }
        .page-head { padding:18px 22px; border-bottom:1px solid var(--pc-border); }
        .page-body { padding:18px 22px; }
        .row-line { display:grid; grid-template-columns:1.6fr 1.6fr 1.2fr; gap:16px; }
        .row-line.header { font-weight:600; margin-bottom:8px; color:#34495e; }
        .row-line + .row-line { margin-top:12px; }

        /* Health color tags (read-only select for quick visual) */
        select.form-select.is-good    { background-color:#CFF9D5; }
        select.form-select.is-average { background-color:#FFEFA3; }
        select.form-select.is-bad     { background-color:#FFD0D0; }
    </style>
</head>
<body>
<jsp:include page="/inc/header.jsp" />

<div class="page-card">
    <div class="page-head d-flex justify-content-between align-items-center">
        <div>
            <h3 class="m-0 fw-bold">My Pets</h3>
            <div class="text-muted mt-1" style="font-size:14px;">
                Account owner:
                <strong><%= (loggedInAccount != null && loggedInAccount.getFullName()!=null) ? loggedInAccount.getFullName() : "" %></strong>
            </div>
        </div>

        <!-- Add Pet -->
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalAddPet">
            + Add Pet
        </button>
    </div>

    <div class="page-body">
        <div class="row-line header">
            <div>Name</div><div>Breed</div><div>Health</div>
        </div>

        <%
            if (pets.isEmpty()) {
        %>
        <div class="alert alert-warning m-0">You don’t have any pets yet.</div>
        <%
        } else {
            for (Pet p : pets) {
                if (p == null) continue;
                String hs = p.getHealthStatus(); if (hs==null) hs="HEALTHY";
                String cls="is-good", label="Good";
                if ("AVERAGE".equalsIgnoreCase(hs)) { cls="is-average"; label="Average"; }
                else if ("SICK".equalsIgnoreCase(hs)) { cls="is-bad"; label="Poor"; }
        %>

        <div class="row-line align-items-center">
            <input class="form-control" type="text"
                   value="<%= p.getName()==null? "" : p.getName() %>" readonly>
            <input class="form-control" type="text"
                   value="<%= p.getBreed()==null? "" : p.getBreed() %>" readonly>

            <div class="d-flex align-items-center" style="gap:8px;">
                <% if ("AVERAGE".equalsIgnoreCase(hs)) { %>
                <span class="badge bg-warning text-dark px-3 py-2">Average</span>
                <% } else if ("SICK".equalsIgnoreCase(hs)) { %>
                <span class="badge bg-danger px-3 py-2">Sick</span>
                <% } else { %>
                <span class="badge bg-success px-3 py-2">Healthy</span>
                <% } %>

                <!-- Edit -->
                <button
                        class="btn btn-sm btn-outline-secondary"
                        data-bs-toggle="modal" data-bs-target="#modalEditPet"
                        data-id="<%= p.getIdpet() %>"
                        data-name="<%= p.getName()==null? "" : p.getName() %>"
                        data-breed="<%= p.getBreed()==null? "" : p.getBreed() %>"
                        data-health="<%= hs %>">
                    Edit
                </button>

                <!-- Delete -->
                <form method="post" action="<%= ctx %>/customer/pets"
                      onsubmit="return confirm('Delete this pet?');">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="petId" value="<%= p.getIdpet() %>">
                    <button class="btn btn-sm btn-outline-danger" type="submit">Delete</button>
                </form>
            </div>
        </div>


        <%
                } // end for
            } // end else
        %>
    </div>
</div>

<!-- ========== MODAL: ADD ========== -->
<div class="modal fade" id="modalAddPet" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog"><div class="modal-content">
        <form method="post" action="<%= ctx %>/customer/pets">
            <input type="hidden" name="action" value="create">
            <div class="modal-header"><h5 class="modal-title">Add Pet</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Name *</label>
                    <input name="name" class="form-control" maxlength="50" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Breed</label>
                    <input name="breed" class="form-control" maxlength="50">
                </div>
                <div class="mb-3">
                    <label class="form-label">Health Status</label>
                    <select name="health" class="form-select">
                        <option value="HEALTHY">Healthy</option>
                        <option value="AVERAGE">Average</option>
                        <option value="SICK">Sick</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Cancel</button>
                <button class="btn btn-primary" type="submit">Save</button>
            </div>
        </form>
    </div></div>
</div>

<!-- ========== MODAL: EDIT ========== -->
<div class="modal fade" id="modalEditPet" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog"><div class="modal-content">
        <form method="post" action="<%= ctx %>/customer/pets">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="petId" id="edit-petId">
            <div class="modal-header"><h5 class="modal-title">Edit Pet</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Name *</label>
                    <input name="name" id="edit-name" class="form-control" maxlength="50" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Breed</label>
                    <input name="breed" id="edit-breed" class="form-control" maxlength="50">
                </div>
                <div class="mb-3">
                    <label class="form-label">Health Status</label>
                    <select name="health" id="edit-health" class="form-select">
                        <option value="HEALTHY">Healthy</option>
                        <option value="AVERAGE">Average</option>
                        <option value="SICK">Sick</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Cancel</button>
                <button class="btn btn-primary" type="submit">Update</button>
            </div>
        </form>
    </div></div>
</div>

<!-- Bootstrap JS & tiny script để đổ data vào Edit modal -->
<script>
    const editModal = document.getElementById('modalEditPet');
    editModal.addEventListener('show.bs.modal', function (event) {
        const btn = event.relatedTarget;
        document.getElementById('edit-petId').value = btn.getAttribute('data-id');
        document.getElementById('edit-name').value = btn.getAttribute('data-name') || '';
        document.getElementById('edit-breed').value = btn.getAttribute('data-breed') || '';
        document.getElementById('edit-health').value = (btn.getAttribute('data-health') || 'HEALTHY').toUpperCase();
    });
</script>
</body>
</html>