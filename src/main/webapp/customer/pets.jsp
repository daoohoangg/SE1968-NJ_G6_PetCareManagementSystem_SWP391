<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.petcaresystem.enities.Account" %>
<%@ page import="com.petcaresystem.enities.enu.AccountRoleEnum" %>
<%@ page import="com.petcaresystem.enities.Pet" %>

<%
    Account loggedInAccount = (Account) session.getAttribute("account");
    String ctx = request.getContextPath();

    @SuppressWarnings("unchecked")
    List<Pet> pets = (List<Pet>) request.getAttribute("pets"); // controller set vào
    if (pets == null) pets = Collections.emptyList();

    String flash = (String) session.getAttribute("flash");
    if (flash != null) {
        // xoá sau khi đọc để hiển thị 1 lần
        session.removeAttribute("flash");
    }
%>

<!-- ==================== HEADER GIỮ NGUYÊN ==================== -->
<jsp:include page="/inc/header.jsp" />

<!-- ==================== PHẦN QUẢN LÝ THÚ CƯNG ==================== -->
<div class="page-card bg-white shadow-sm" style="max-width:900px; margin:40px auto; border:1px solid #e9ecef; border-radius:12px;">
    <div class="page-head" style="padding:18px 22px; border-bottom:1px solid #e9ecef;">
        <h3 class="m-0 fw-bold">Quản Lý Thú Cưng</h3>
    </div>

    <div class="page-body" style="padding:18px 22px;">

        <div class="row-line header"
             style="display:grid; grid-template-columns:1.6fr 1.6fr 1.2fr 0.8fr; gap:16px; font-weight:600; margin-bottom:8px;">
            <div>Tên</div>
            <div>Giống loài</div>
            <div>Tình trạng sức khỏe</div>
            <div>Hành động</div>
        </div>

        <!-- Danh sách thú cưng -->
        <%
            for (Pet p : pets) {
                if (p == null) continue;
                String hs = p.getHealthStatus();
                if (hs == null) hs = "HEALTHY";
                String cls = "is-good";
                if ("AVERAGE".equalsIgnoreCase(hs)) cls = "is-average";
                else if ("SICK".equalsIgnoreCase(hs)) cls = "is-bad";
        %>
        <form class="row-line" method="post" action="<%= ctx %>/customer/pets"
              style="display:grid; grid-template-columns:1.6fr 1.6fr 1.2fr 0.8fr; gap:16px; align-items:center; margin-bottom:14px;">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= p.getIdpet() %>">

            <input name="name" class="form-control" type="text" value="<%= p.getName()==null? "": p.getName() %>" required>
            <input name="breed" class="form-control" type="text" value="<%= p.getBreed()==null? "": p.getBreed() %>">

            <select name="healthStatus" class="form-select <%= cls %>"
                    onchange="this.classList.remove('is-good','is-average','is-bad'); this.classList.add(this.selectedOptions[0].dataset.bg);">
                <option value="HEALTHY" data-bg="is-good" <%= "HEALTHY".equalsIgnoreCase(hs) ? "selected" : "" %>>Tốt</option>
                <option value="AVERAGE" data-bg="is-average" <%= "AVERAGE".equalsIgnoreCase(hs) ? "selected" : "" %>>Trung bình</option>
                <option value="SICK"    data-bg="is-bad"     <%= "SICK".equalsIgnoreCase(hs) ? "selected" : "" %>>Kém</option>
            </select>

            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-dark">Lưu</button>
                <button type="submit" name="action" value="delete" class="btn btn-danger"
                        onclick="return confirm('Xoá thú cưng này?');">Xoá</button>
            </div>
        </form>
        <%
            } // end for
        %>

        <!-- Dòng thêm mới -->
        <form class="row-line" method="post" action="<%= ctx %>/customer/pets"
              style="display:grid; grid-template-columns:1.6fr 1.6fr 1.2fr 0.8fr; gap:16px; align-items:center;">
            <input type="hidden" name="action" value="create">

            <input name="name"  class="form-control" type="text" placeholder="Tên" required>
            <input name="breed" class="form-control" type="text" placeholder="Giống loài">

            <select name="healthStatus" class="form-select is-good"
                    onchange="this.classList.remove('is-good','is-average','is-bad'); this.classList.add(this.selectedOptions[0].dataset.bg);">
                <option value="HEALTHY" data-bg="is-good" selected>Tốt</option>
                <option value="AVERAGE" data-bg="is-average">Trung bình</option>
                <option value="SICK"    data-bg="is-bad">Kém</option>
            </select>

            <div>
                <button type="submit" class="btn btn-primary">Thêm</button>
            </div>
        </form>

        <!-- Flash -->
        <%
            if (flash != null && !flash.isEmpty()) {
        %>
        <div class="alert alert-success mt-3 mb-0"><%= flash %></div>
        <%
            }
        %>

    </div>
</div>

<!-- ==================== CSS phụ ==================== -->
<style>
    select.form-select.is-good { background-color:#CFF9D5; }
    select.form-select.is-average { background-color:#FFEFA3; }
    select.form-select.is-bad { background-color:#FFD0D0; }
</style>
