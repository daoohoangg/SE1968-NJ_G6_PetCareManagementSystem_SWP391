<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Sign Up</title>
    <style>
        body { font-family: sans-serif; background:#f5f5f5; }
        .box { width:360px; margin:80px auto; background:#fff; padding:24px; border-radius:8px; box-shadow:0 2px 12px rgba(0,0,0,.08); }
        .row { margin-bottom:12px; }
        label { display:block; margin-bottom:6px; font-weight:600; }
        input[type=text], input[type=password], input[type=email] {
            width:100%; padding:10px; border:1px solid #ddd; border-radius:6px;
        }
        button { width:100%; padding:10px; border:0; background:#388e3c; color:#fff; border-radius:6px; cursor:pointer; }
        .error { color:#c62828; margin:10px 0; }
    </style>
</head>
<body>
<div class="box">
    <h2>Create Account</h2>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <div class="error"><%= error %></div>
    <% } %>

    <form method="post" action="<%= request.getContextPath() %>/register">
        <div class="row">
            <label>Full Name</label>
            <input type="text" name="fullName" required />
        </div>
        <div class="row">
            <label>Username</label>
            <input type="text" name="username" required />
        </div>
        <div class="row">
            <label>Email</label>
            <input type="email" name="email" required />
        </div>
        <div class="row">
            <label>Phone</label>
            <input type="text" name="phone" required />
        </div>
        <div class="row">
            <label>Password</label>
            <input type="password" name="password" required />
        </div>
        <div class="row">
            <label>Confirm Password</label>
            <input type="password" name="confirmPassword" required />
        </div>
        <button type="submit">Sign Up</button>
    </form>

    <div class="row" style="text-align:center; margin-top:10px;">
        Already have an account?
        <a href="<%= request.getContextPath() %>/login">Sign in</a>
    </div>
</div>
</body>
</html>
