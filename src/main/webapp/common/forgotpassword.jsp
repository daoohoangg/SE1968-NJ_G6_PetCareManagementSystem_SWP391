<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password</title>
    <link rel="stylesheet" href="css/style.css"/>
</head>
<body>
<div class="container">
    <h2>Forgot Password</h2>
    <form action="forgotpassword" method="POST">
        <label>Email or Username:</label><br/>
        <input type="text" name="userInput" placeholder="Enter your email or username" required/><br/><br/>
        <input type="submit" value="Recover Password"/><br/><br/>

        <% String message = (String) request.getAttribute("message");
            if (message != null) { %>
        <p style="color:red;"><%= message %></p>
        <% } %>

        <a href="login.jsp">Back to Login</a>
    </form>
</div>
</body>
</html>