<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/inc/common-head.jspf" %>

    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background:#f5f5f5; }
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
        .message-box { margin:10px 0; padding: 12px; border-radius: 4px; border: 1px solid transparent; }
        .info { color:#0c5460; background-color:#d1ecf1; border-color:#bee5eb; }
        .success { color:#155724; background-color:#d4edda; border-color:#c3e6cb; }

        button { width:100%; padding:12px; border:0; border-radius:6px; cursor:pointer; font-size: 16px; font-weight: 600; }
        .btn-primary { background:#1976d2; color:#fff; }
        .btn-secondary { background:#f0f0f0; color:#333; border: 1px solid #ccc; }
        .btn-secondary:hover { background: #e0e0e0; }
        .error { color:#c62828; margin:10px 0; background: #ffebee; padding: 10px; border-radius: 4px; }
        .link-container { text-align:center; margin-top:20px; font-size: 14px; }
        .info-box { color:#0d5a21; margin:10px 0; background: #d1f7dc; padding: 10px; border-radius: 4px; border: 1px solid #a3e9b8; }
    </style>
</head>
<body>
<jsp:include page="/inc/header.jsp"/>
<div class="box">
    <h2>Login</h2>
    <%
        String status = request.getParameter("status");
        if ("registered".equals(status)) {
    %>
    <div class="message-box info">Registration successful! Please check your email to activate your account.</div>
    <%
    } else if ("verified_success".equals(status)) {
    %>
    <div class="message-box success">Account verification successful! Please log in.</div>
    <%
        }
    %>
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <div class="error"><%= error %></div>
    <% } %>
    <%
        String info = (String) request.getAttribute("info");
        if (info != null) {
    %>
    <div class="info-box"><%= info %></div>
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
    <div class="row" style="text-align:center; margin-top:15px; border-top: 1px solid #eee; padding-top: 15px;">
        <a href="<%= request.getContextPath() %>/home">Back to Home</a>
    </div>
</div>
<%@ include file="/inc/footer.jsp" %>
</body>
</html>

