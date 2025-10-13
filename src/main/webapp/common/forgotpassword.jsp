<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Password</title>
    <style>
        body { font-family: sans-serif; background:#f5f5f5; }
        .box { width:320px; margin:80px auto; background:#fff; padding:24px; border-radius:8px; box-shadow:0 2px 12px rgba(0,0,0,.08); }
        .row { margin-bottom:12px; }
        label { display:block; margin-bottom:6px; font-weight:600; }
        input[type=text] { width:100%; padding:10px; border:1px solid #ddd; border-radius:6px; }
        button { width:100%; padding:10px; border:0; background:#1976d2; color:#fff; border-radius:6px; cursor:pointer; }
        .message { margin:12px 0; color:#c62828; }
    </style>
</head>
<body>
<div class="box">
    <h2>Forgot Password</h2>

    <form method="post" action="<%= request.getContextPath() %>/forgotpassword">
        <div class="row">
            <label>Email</label>
            <input type="text" name="userInput" required autofocus />
        </div>
        <button type="submit">Recover Password</button>
    </form>

    <div class="message">
        <%= request.getAttribute("message") != null ? request.getAttribute("message") : "" %>
    </div>

    <div class="row" style="text-align:center; margin-top:10px;">
        <a href="<%= request.getContextPath() %>/login">Back to Login</a>
    </div>
</div>
</body>
</html>