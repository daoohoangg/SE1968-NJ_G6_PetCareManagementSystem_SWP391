<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="p" value="${requestScope.profile}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Customer Profile</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif; margin:24px; color:#222;}
        .container{max-width:880px;margin:0 auto}
        .header{display:flex;align-items:center;justify-content:space-between;margin-bottom:16px}
        .btn{display:inline-block;padding:8px 14px;border:1px solid #ddd;border-radius:8px;background:#fafafa;text-decoration:none;color:#111}
        .btn.primary{background:#111;color:#fff;border-color:#111}
        .btn.danger{background:#fee;border-color:#f99;color:#b00}
        .card{border:1px solid #eee;border-radius:12px;padding:16px;margin:12px 0;background:#fff}
        .row{display:grid;grid-template-columns:160px 1fr;gap:12px;padding:10px 0;border-bottom:1px dashed #eee}
        .row:last-child{border-bottom:none}
        .muted{color:#666;font-size:0.95rem}
        .alert{padding:10px 12px;border-radius:8px;background:#f6ffed;border:1px solid #b7eb8f;margin-bottom:14px}
        form.inline{display:inline}
        .section-title{margin:18px 0 8px;font-weight:700}
        input[type=password], input[type=text], input[type=email]{width:100%;padding:10px;border:1px solid #ddd;border-radius:8px}
    </style>
</head>
<body>
<div class="container">

    <div class="header">
        <h2>Customer Profile</h2>
        <a class="btn" href="${ctx}/customer/profile?action=edit">Edit</a>
    </div>

    <!-- Flash message -->
    <c:if test="${not empty sessionScope.flash}">
        <div class="alert">
            <c:out value="${sessionScope.flash}" />
        </div>
        <c:remove var="flash" scope="session" />
    </c:if>

    <!-- Thông tin hồ sơ -->
    <div class="card">
        <div class="row"><div>Username</div><div><c:out value="${p.username}" /></div></div>
        <div class="row"><div>Full name</div><div><c:out value="${p.fullName}" /></div></div>
        <div class="row"><div>Email</div><div><c:out value="${p.email}" /></div></div>
        <div class="row"><div>Phone</div><div><c:out value="${p.phone}" /></div></div>
        <div class="row"><div>Status</div>
            <div>
                <c:choose>
                    <c:when test="${p.isActive}">Active</c:when>
                    <c:otherwise>Inactive</c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Đổi mật khẩu -->
    <h3 class="section-title">Change password</h3>
    <div class="card">
        <form method="post" action="${ctx}/customer/profile">
            <input type="hidden" name="action" value="change-password" />
            <label class="muted" for="newPassword">New password</label>
            <input id="newPassword" name="newPassword" type="password" minlength="6" required />
            <div style="margin-top:12px">
                <button class="btn primary" type="submit">Update password</button>
            </div>
        </form>
        <p class="muted" style="margin-top:10px">Mật khẩu tối thiểu 6 ký tự.</p>
    </div>

    <!-- Vô hiệu hóa tài khoản -->
    <h3 class="section-title" style="color:#b00">Deactivate account</h3>
    <div class="card">
        <form method="post" action="${ctx}/customer/profile" class="inline" onsubmit="return confirm('Bạn chắc chắn muốn vô hiệu hóa tài khoản? Bạn sẽ bị đăng xuất.');">
            <input type="hidden" name="action" value="deactivate" />
            <button class="btn danger" type="submit">Deactivate</button>
        </form>
        <p class="muted" style="margin-top:8px">Tài khoản sẽ chuyển sang trạng thái Inactive và bạn sẽ được đăng xuất.</p>
    </div>

</div>
</body>
</html>
