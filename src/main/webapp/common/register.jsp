<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/inc/common-head.jspf" %>

    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
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
        input:invalid {
            border-color: #c62828;
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
        .input-hint {
            font-size: 12px;
            color: #6c757d;
            margin-top: 4px;
            display: block;
        }
        .password-rules {
            display: none;
            margin-top: 8px;
            font-size: 12px;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 4px;
        }
        .password-rules small {
            display: block;
            margin-bottom: 4px;
            color: #c62828;
        }
        .password-rules small.valid {
            color: #2e7d32;
            text-decoration: line-through;
        }
        .password-rules small::before {
            content: 'âœ– ';
            display: inline-block;
            font-weight: bold;
        }
        .password-rules small.valid::before {
            content: 'âœ” ';
            font-weight: bold;
        }
        .static-rules {
            display: none;
            margin-top: 8px;
            font-size: 12px;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 4px;
            color: #555;
        }
        .static-rules small {
            display: block;
            margin-bottom: 4px;
        }
        .static-rules small::before {
            content: 'â€¢ ';
            color: #0d6efd;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="box">
    <h2>Register</h2>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <div class="error"><%= error %></div>
    <% } %>


    <form method="post" action="<%= request.getContextPath() %>/register">
        <div class="row">
            <label>Full Name</label>
            <input type="text" name="fullName" id="fullNameInput" required
                   pattern="^[\p{L}\s]+$"
                   title="Must contain only letters and spaces.">
            <div id="fullNameRules" class="static-rules">
                <small>Only contains letters.</small>
                <small>Spaces are allowed.</small>
                <small>Does not contain numbers or special characters.</small>
            </div>
        </div>
        <div class="row">
            <label>Username</label>
            <input type="text" name="username" id="usernameInput" required
                   pattern="^\S+$"
                   title="Cannot contain spaces.">
            <div id="usernameRules" class="static-rules">
                <small>Must not contain spaces.</small>
                <small>Allow letters, numbers, and special characters (e.g., user_name_123).</small>
            </div>
        </div>
        <div class="row">
            <label>Email</label>
            <input type="email" name="email" placeholder="example@example.com" required />
        </div>
        <div class="row">
            <label>Phone</label>
            <input type="tel" name="phone" id="phoneInput" required
                   pattern="0[0-9]{9}"
                   title="Must be a 10-digit number.">
            <div id="phoneRules" class="static-rules">
                <small>Must be a 10-digit number.</small>
            </div>
        </div>
        <div class="row">
            <label>Password</label>
            <input type="password" name="password" id="passwordInput" required />
            <div id="passwordRules" class="password-rules">
                <small id="pass-length">Must be at least 6 characters long.</small>
                <small id="pass-lower">Must contain one lowercase letter.</small>
                <small id="pass-upper">Must contain one uppercase letter.</small>
                <small id="pass-number">Must contain one number.</small>
            </div>
        </div>
        <div class="row">
            <label>Confirm Password</label>
            <input type="password" name="confirmPassword" required />
        </div>
        <button type="submit">Create Account</button>
    </form>

    <div class="row" style="text-align:center; margin-top:10px;">
        Already have an account?
        <a href="<%= request.getContextPath() %>/login">Login</a>
    </div>
</div>
<script>
    var passInput = document.getElementById("passwordInput");
    var rulesBox = document.getElementById("passwordRules");
    var ruleLength = document.getElementById("pass-length");
    var ruleLower = document.getElementById("pass-lower");
    var ruleUpper = document.getElementById("pass-upper");
    var ruleNumber = document.getElementById("pass-number");
    var lowerCaseRegex = /[a-z]/;
    var upperCaseRegex = /[A-Z]/;
    var numberRegex = /[0-9]/;

    passInput.onfocus = function() {
        rulesBox.style.display = "block";
    }
    passInput.onkeyup = function() {
        var pass = passInput.value;
        if(pass.length >= 6) {
            ruleLength.classList.add("valid");
        } else {
            ruleLength.classList.remove("valid");
        }
        if(pass.match(lowerCaseRegex)) {
            ruleLower.classList.add("valid");
        } else {
            ruleLower.classList.remove("valid");
        }
        if(pass.match(upperCaseRegex)) {
            ruleUpper.classList.add("valid");
        } else {
            ruleUpper.classList.remove("valid");
        }
        if(pass.match(numberRegex)) {
            ruleNumber.classList.add("valid");
        } else {
            ruleNumber.classList.remove("valid");
        }
    }
    passInput.onblur = function() {
        var allValid = ruleLength.classList.contains("valid") &&
            ruleLower.classList.contains("valid") &&
            ruleUpper.classList.contains("valid") &&
            ruleNumber.classList.contains("valid");

        if (allValid) {
            rulesBox.style.display = "none";
        }
    }
    function setupStaticHintValidation(inputId, rulesId) {
        var input = document.getElementById(inputId);
        var rules = document.getElementById(rulesId);
        input.onfocus = function() {
            rules.style.display = "block";
        }
        input.onblur = function() {
            if (input.checkValidity()) {
                rules.style.display = "none";
            }
        }
    }
    setupStaticHintValidation("fullNameInput", "fullNameRules");
    setupStaticHintValidation("usernameInput", "usernameRules");
    setupStaticHintValidation("phoneInput", "phoneRules");

</script>
</body>
</html>

