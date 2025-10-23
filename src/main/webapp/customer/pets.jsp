<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.petcaresystem.enities.Account" %>
<%@ page import="com.petcaresystem.enities.Pet" %>
<%
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

<!-- Header tái dụng -->
<jsp:include page="/inc/header.jsp" />

<div class="page-card bg-white shadow-sm" style="max-width:900px; margin:40px auto; border:1px solid #e9ecef; border-radius:12px;">
    <div class="page-head" style="padding:18px 22px; border-bottom:1px solid #e9ecef;">
        <h3 class="m-0 fw-bold">Quản Lý Thú Cưng</h3>
        <div class="text-muted mt-1" style="font-size:14px;">
            Hiển thị thú cưng của tài khoản:
            <strong><%= loggedInAccount != null ? loggedInAccount.getFullName() : "" %></strong>
        </div>
    </div>

    <div class="page-body" style="padding:18px 22px;">

        <div class="row-line header"
             style="display:grid; grid-template-columns:1.6fr 1.6fr 1.2fr; gap:16px; font-weight:600; margin-bottom:8px;">
            <div>Tên</div>
            <div>Giống loài</div>
            <div>Tình trạng sức khỏe</div>
        </div>

        <%
            if (pets.isEmpty()) {
        %>
        <div class="alert alert-warning m-0">Bạn chưa có thú cưng nào.</div>
        <%
        } else {
            for (Pet p : pets) {
                if (p == null) continue;
                String hs = p.getHealthStatus();
                if (hs == null) hs = "HEALTHY";
                String cls = "is-good";
                String label = "Tốt";
                if ("AVERAGE".equalsIgnoreCase(hs)) { cls = "is-average"; label = "Trung bình"; }
                else if ("SICK".equalsIgnoreCase(hs)) { cls = "is-bad"; label = "Kém"; }
        %>
        <div class="row-line" style="display:grid; grid-template-columns:1.6fr 1.6fr 1.2fr; gap:16px; align-items:center; margin-bottom:12px;">
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

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
<style>
    select.form-select.is-good    { background-color:#CFF9D5; }
    select.form-select.is-average { background-color:#FFEFA3; }
    select.form-select.is-bad     { background-color:#FFD0D0; }
</style>
