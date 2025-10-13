<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%--
  QUAN TRỌNG: File này chỉ được chứa đoạn mã HTML của footer.
  KHÔNG được có thẻ <html>, <head>, <body> hay <style>.
--%>

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
            Khu Công Nghệ Cao Hòa Lạc,km29,Đại lộ Thăng Long,Hà Nội, Việt Nam | ☎️ +84 123 456 789 | ✉️ support@petcare.com
        </p>
        <div class="copyright">
            © 2025 Pet Care Management System — All Rights Reserved.
        </div>
    </div>
</footer>