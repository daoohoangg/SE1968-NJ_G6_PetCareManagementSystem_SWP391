<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Sign Up</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: #f5f5f5;
        }
        .box {
            width: 360px;
            margin: 60px auto;
            background: #fff;
            padding: 24px;
            border-radius: 8px;
            box-shadow: 0 2px 12px rgba(0,0,0,.08);
        }
        .row {
            margin-bottom: 16px;
        }
        label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            font-size: 14px;
        }
        input[type=text],
        input[type=password],
        input[type=email],
        input[type=tel] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-sizing: border-box;
        }
        button {
            width: 100%;
            padding: 12px;
            border: 0;
            background: #1976d2;
            color: #fff;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
        }
        .error {
            color: #c62828;
            margin-bottom: 15px;
            background: #ffebee;
            padding: 10px;
            border-radius: 4px;
        }
        .login-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }
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
        <button type="submit">Register</button>
    </form>

    <div class="row" style="text-align:center; margin-top:10px;">
        Already have an account?
        <a href="<%= request.getContextPath() %>/login">Sign in</a>
    </div>
</div>
</body>
</html>
