<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Login</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background:#f5f5f5; }
        .box { width:360px; margin:80px auto; background:#fff; padding:24px; border-radius:8px; box-shadow:0 2px 12px rgba(0,0,0,.08); }
        .row { margin-bottom:16px; }
        label { display:block; margin-bottom:6px; font-weight:600; font-size: 14px; }
        input[type=text], input[type=email], input[type=password] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-sizing: border-box;
        }

        button { width:100%; padding:12px; border:0; border-radius:6px; cursor:pointer; font-size: 16px; font-weight: 600; }
        .btn-primary { background:#1976d2; color:#fff; }
        .btn-secondary { background:#f0f0f0; color:#333; border: 1px solid #ccc; }
        .btn-secondary:hover { background: #e0e0e0; }
        .error { color:#c62828; margin:10px 0; background: #ffebee; padding: 10px; border-radius: 4px; }
        .link-container { text-align:center; margin-top:20px; font-size: 14px; }
    </style>
</head>
<body>
<div class="box">
    <h2>Login</h2>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <div class="error"><%= error %></div>
    <% } %>

    <%
        String mode = request.getParameter("mode");
        if (mode == null) {
            mode = (String) request.getAttribute("mode");
        }

        if ("email".equals(mode)) {
    %>
    <form method="post" action="<%= request.getContextPath() %>/login">
        <input type="hidden" name="loginType" value="email" />
        <div class="row">
            <label>Email</label>
            <input type="email" name="email" required autofocus />
        </div>
        <div class="row">
            <label>Password</label>
            <input type="password" name="password" required />
        </div>
        <div class="row">
            <label>
                <input type="checkbox" name="remember" /> Remember Me
            </label>
        </div>
        <button type="submit" class="btn-primary">Login</button>
    </form>
    <div class="link-container">
        <a href="<%= request.getContextPath() %>/login">Back</a>
    </div>
    <%
    } else {
    %>
    <form method="post" action="<%= request.getContextPath() %>/login">
        <div class="row">
            <label>Username</label>
            <input type="text" name="username" required autofocus />
        </div>
        <div class="row">
            <label>Password</label>
            <input type="password" name="password" required />
        </div>
        <div class="row">
            <label>
                <input type="checkbox" name="remember" /> Remember Me
            </label>
        </div>
        <button type="submit" class="btn-primary">Login</button>
    </form>

    <div style="margin: 20px 0;"></div>

    <a href="<%= request.getContextPath() %>/login?mode=email" style="text-decoration: none;">
        <button type="button" class="btn-secondary">
            Login with Email
        </button>
    </a>
    <%
        }
    %>

    <div class="row" style="text-align:center; margin-top:10px;">
        <a href="<%= request.getContextPath() %>/register">Register</a> |
        <a href="<%= request.getContextPath() %>/forgotpassword">Forgot Password?</a>
    </div>
</div>
</body>
</html>
