<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.petcaresystem.enities.Account" %>

<%-- ===== Helpers: escape HTML an toàn khi in ra ===== --%>
<%!
    private String escape(String s){
        if (s == null) return "";
        StringBuilder sb = new StringBuilder(s.length());
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '&': sb.append("&amp;"); break;
                case '<': sb.append("&lt;"); break;
                case '>': sb.append("&gt;"); break;
                case '"': sb.append("&quot;"); break;
                case '\'': sb.append("&#39;"); break;
                default: sb.append(c);
            }
        }
        return sb.toString();
    }
%>

<%
    String ctx = request.getContextPath();


    Account profile = (Account) request.getAttribute("profile");
    if (profile == null) {
        profile = (Account) session.getAttribute("account");
        if (profile == null) profile = (Account) session.getAttribute("user");
    }


    if (profile == null) {
        response.sendRedirect(ctx + "/login");
        return;
    }


    String flash = (String) session.getAttribute("flash");
    if (flash != null) session.removeAttribute("flash");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Edit Profile - PetCare</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />


    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">


    <style>
        body { background-color:#f5f7fb; font-family:'Segoe UI', system-ui, -apple-system, Roboto, Arial, sans-serif; }
        .page-container { max-width:950px; margin:36px auto; }
        .card { border:none; border-radius:14px; box-shadow:0 6px 16px rgba(0,0,0,.08); }
        .card-header { background:#e9f2ff; color:#0d6efd; font-weight:700; border-top-left-radius:14px; border-top-right-radius:14px; }
        .form-label { font-weight:600; color:#333; }
        .btn-primary { background-color:#0d6efd; border-color:#0d6efd; font-weight:600; }
        .btn-primary:hover { background-color:#0b5ed7; }
        .btn-outline-secondary { font-weight:600; }
        .alert { border-radius:12px; }
        .required::after { content:"*"; color:#dc3545; margin-left:4px; }
    </style>
</head>
<body>

<!-- Header chung -->
<jsp:include page="/inc/header.jsp"/>

<div class="page-container">

    <!-- Tiêu đề + Back -->
    <div class="d-flex align-items-center justify-content-between mb-3">
        <h2 class="m-0 fw-bold text-primary">Edit Profile</h2>
        <a class="btn btn-outline-secondary btn-sm" href="<%= ctx %>/home">Back</a>
    </div>

    <% if (flash != null && !flash.isEmpty()) { %>
    <div class="alert alert-warning border-0"><%= escape(flash) %></div>
    <% } %>

    <div class="card">
        <div class="card-header">Thông tin tài khoản</div>
        <div class="card-body">

            <form id="profileForm" method="post" action="<%= ctx %>/customer/profile" onsubmit="return routeSubmit();">
                <input type="hidden" name="accountId" value="<%= profile.getAccountId() %>"/>

                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="username" class="form-label required">Username</label>
                        <input id="username" name="username" type="text" maxlength="50" required
                               class="form-control"
                               value="<%= escape(profile.getUsername()) %>">
                    </div>

                    <div class="col-md-6">
                        <label for="fullName" class="form-label">Full name</label>
                        <input id="fullName" name="fullName" type="text" maxlength="100"
                               class="form-control"
                               value="<%= escape(profile.getFullName()) %>">
                    </div>

                    <div class="col-md-6">
                        <label for="email" class="form-label required">Email</label>
                        <input id="email" name="email" type="email" maxlength="120" required
                               class="form-control"
                               value="<%= escape(profile.getEmail()) %>">
                    </div>

                    <div class="col-md-6">
                        <label for="phone" class="form-label">Phone</label>
                        <input id="phone" name="phone" type="tel" maxlength="20"
                               class="form-control"
                               pattern="[0-9+()\\-\\s]{6,20}"
                               title="6–20 ký tự, chỉ gồm số và ký tự + ( ) - khoảng trắng"
                               value="<%= escape(profile.getPhone()) %>">
                    </div>

                    <div class="col-12">
                        <label for="password" class="form-label">Password (để trống nếu không đổi)</label>
                        <input id="password" name="password" type="password" minlength="6" class="form-control">
                        <div class="form-text">Điền mật khẩu mới nếu muốn đổi. Nếu có mật khẩu, hệ thống sẽ đổi mật khẩu và đưa bạn về trang Home.</div>
                    </div>
                </div>

                <div class="mt-4 d-flex gap-2">
                    <button class="btn btn-primary" type="submit">
                        <i class="bi bi-save2 me-1"></i> Save
                    </button>
                    <a class="btn btn-outline-secondary" href="<%= ctx %>/home">Cancel</a>
                </div>
            </form>
        </div>
    </div>

</div>

<script>

    function routeSubmit(){
        var f = document.getElementById('profileForm');
        var email = document.getElementById('email').value.trim();
        var username = document.getElementById('username').value.trim();
        var pwd = document.getElementById('password').value.trim();

        if(!username){ alert('Username là bắt buộc'); return false; }
        if(!email){ alert('Email là bắt buộc'); return false; }

        var base = '<%= ctx %>/customer/profile';
        if(pwd){
            f.action = base + '?action=change-password&redirect=home';
        }else{
            f.action = base + '?action=update';
        }
        return true;
    }
    function validateForm(){
        var username = document.getElementById('username').value.trim();
        var email    = document.getElementById('email').value.trim();
        if(!username){ alert('Username là bắt buộc'); return false; }
        if(!email){ alert('Email là bắt buộc'); return false; }
        return true;
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
