<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="p" value="${requestScope.profile}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Edit Profile</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif; margin:24px; color:#222;}
        .container{max-width:880px;margin:0 auto}
        .header{display:flex;align-items:center;justify-content:space-between;margin-bottom:16px}
        .btn{display:inline-block;padding:8px 14px;border:1px solid #ddd;border-radius:8px;background:#fafafa;text-decoration:none;color:#111}
        .btn.primary{background:#111;color:#fff;border-color:#111}
        .btn.ghost{background:transparent}
        .card{border:1px solid #eee;border-radius:12px;padding:16px;margin:12px 0;background:#fff}
        .grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
        label{font-size:0.92rem;color:#444;margin-bottom:6px;display:block}
        input[type=text], input[type=email], input[type=tel], input[type=password]{width:100%;padding:10px;border:1px solid #ddd;border-radius:8px}
        .muted{color:#666;font-size:0.95rem}
        .actions{display:flex;gap:10px;margin-top:14px}
        .alert{padding:10px 12px;border-radius:8px;background:#fff7e6;border:1px solid #ffd591;margin-bottom:14px}
    </style>
</head>
<body>
<div class="container">

    <div class="header">
        <h2>Edit Profile</h2>
        <a class="btn" href="${ctx}/customer/profile?action=view">Back</a>
    </div>

    <!-- Flash (nếu có lỗi từ lần submit trước) -->
    <c:if test="${not empty sessionScope.flash}">
        <div class="alert"><c:out value="${sessionScope.flash}" /></div>
        <c:remove var="flash" scope="session" />
    </c:if>

    <form method="post" action="${ctx}/customer/profile" onsubmit="return validateForm();">
        <input type="hidden" name="action" value="update" />

        <div class="card">
            <div class="grid">
                <div>
                    <label for="username">Username *</label>
                    <input id="username" name="username" type="text" maxlength="50" required
                           value="<c:out value='${p.username}'/>" />
                </div>

                <div>
                    <label for="fullName">Full name</label>
                    <input id="fullName" name="fullName" type="text" maxlength="100"
                           value="<c:out value='${p.fullName}'/>" />
                </div>

                <div>
                    <label for="email">Email *</label>
                    <input id="email" name="email" type="email" maxlength="120" required
                           value="<c:out value='${p.email}'/>" />
                </div>

                <div>
                    <label for="phone">Phone</label>
                    <input id="phone" name="phone" type="tel" maxlength="20"
                           pattern="[0-9+()\\-\\s]{6,20}"
                           title="6–20 ký tự, chỉ gồm số và ký tự + ( ) - khoảng trắng"
                           value="<c:out value='${p.phone}'/>" />
                </div>

                <div>
                    <label for="password">Password (để trống nếu không đổi)</label>
                    <input id="password" name="password" type="password" minlength="6" />
                    <p class="muted">Không bắt buộc. Điền để thay đổi mật khẩu ngay trong lần cập nhật này.</p>
                </div>
            </div>

            <div class="actions">
                <button class="btn primary" type="submit">Save changes</button>
                <a class="btn ghost" href="${ctx}/customer/profile?action=view">Cancel</a>
            </div>
        </div>
    </form>

</div>

<script>
    function validateForm(){
        const email = document.getElementById('email').value.trim();
        const username = document.getElementById('username').value.trim();
        if(!username){ alert('Username là bắt buộc'); return false; }
        if(!email){ alert('Email là bắt buộc'); return false; }
        return true;
    }
</script>
</body>
</html>
