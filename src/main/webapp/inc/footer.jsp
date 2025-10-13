<style>
    .footer {
        background-color: #1976d2;
        color: #fff;
        padding: 25px 0;
        font-family: sans-serif;
        text-align: center;
        border-top: 4px solid #1565c0;
        margin-top: 40px;
    }
    .footer .footer-content { max-width: 1000px; margin: auto; }
    .footer h3 { margin: 0; font-size: 20px; font-weight: 600; }
    .footer p { margin: 6px 0; font-size: 14px;
        color: #e3f2fd;
    }

    .footer .links a {
        color: #bbdefb;
        text-decoration: none;
        margin: 0 10px;
        transition: color 0.2s;
    }

    .footer .links a:hover {
        color: #fff;
        text-decoration: underline;
    }

    .footer .copyright {
        margin-top: 10px;
        font-size: 13px;
        color: #e0e0e0;
    }
</style>
<footer class="footer">
    <div class="footer-content">
        <h3>Pet Care Management System</h3>
        <p>Your trusted partner in pet health, grooming, and care.</p>
        <div class="links">
            <a href="<%= request.getContextPath() %>/home">Home</a>
            <a href="<%= request.getContextPath() %>/inc/about.jsp">About Us</a>
            <a href="<%= request.getContextPath() %>/login">Login</a>
            <a href="<%= request.getContextPath() %>/register">Register</a>
        </div>
        <p style="margin-top:10px; font-size:13px;">
            Hoa Lac Hi-Tech Park, Km29, Thang Long Avenue, Hanoi, Vietnam | ☎ +84 123 456 789 | ✉ support@petcare.com
        </p>
        <div class="copyright">
            © 2025 Pet Care Management System
        </div>
    </div>
</footer>