<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Login</title>
    <style>
        body { font-family: sans-serif; background:#f5f5f5; }
        .box { width:320px; margin:80px auto; background:#fff; padding:24px; border-radius:8px; box-shadow:0 2px 12px rgba(0,0,0,.08); }
        .row { margin-bottom:12px; }
        label { display:block; margin-bottom:6px; font-weight:600; }
        input[type=text], input[type=password] { width:100%; padding:10px; border:1px solid #ddd; border-radius:6px; }
        button { width:100%; padding:10px; border:0; background:#1976d2; color:#fff; border-radius:6px; cursor:pointer; }
        .error { color:#c62828; margin:10px 0; }
    </style>
</head>
<body>
<div class="box">
    <h2>Sign in</h2>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <div class="error"><%= error %></div>
    <% } %>

    <form method="post" action="<%= request.getContextPath() %>/login">
        <div class="row">
            <label>Username</label>
            <input type="text" name="username" required autofocus />
        </div>
        <div class="row">
            <label>Password</label>
            <input type="password" name="password" required />
        </div>
        <button type="submit">Login</button>
    </form>
</div>
</body>
</html>
