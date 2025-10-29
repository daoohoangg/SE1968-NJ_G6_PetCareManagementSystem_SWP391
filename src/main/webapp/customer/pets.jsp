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

<!-- Reusable header -->
<jsp:include page="/inc/header.jsp" />

<div class="page-card">
    <div class="page-head">
        <h3 class="m-0 fw-bold">My Pets</h3>
        <div class="text-muted mt-1" style="font-size:14px;">
            Account owner:
            <strong><%= (loggedInAccount != null && loggedInAccount.getFullName()!=null) ? loggedInAccount.getFullName() : "" %></strong>
        </div>
    </div>

    <div class="page-body">

        <div class="row-line header">
            <div>Name</div>
            <div>Breed</div>
            <div>Health</div>
        </div>

        <%
            if (pets.isEmpty()) {
        %>
        <div class="alert alert-warning m-0">You don’t have any pets yet.</div>
        <%
        } else {
            for (Pet p : pets) {
                if (p == null) continue;
                String hs = p.getHealthStatus();
                if (hs == null) hs = "HEALTHY";

                String cls   = "is-good";
                String label = "Good";
                if ("AVERAGE".equalsIgnoreCase(hs)) { cls = "is-average"; label = "Average"; }
                else if ("SICK".equalsIgnoreCase(hs)) { cls = "is-bad"; label = "Poor"; }
        %>
        <div class="row-line" style="align-items:center;">
            <input class="form-control" type="text" value="<%= p.getName()==null? "" : p.getName() %>" readonly>
            <input class="form-control" type="text" value="<%= p.getBreed()==null? "" : p.getBreed() %>" readonly>

            <select class="form-select <%= cls %>" disabled>
                <option><%= label %></option>
            </select>
        </div>
        <%
                } // end for
            } // end else
        %>
    </div>
</div>

</body>
</html>
