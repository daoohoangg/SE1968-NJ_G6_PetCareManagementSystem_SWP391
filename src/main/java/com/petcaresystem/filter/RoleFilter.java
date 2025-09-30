package com.petcaresystem.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebFilter("/*")
public class RoleFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());
        HttpSession session = req.getSession(false);
        String role = (session == null) ? null : (String) session.getAttribute("role");

        // Bỏ qua login và resource tĩnh
        // / để filter guest, cần vào home để filter lại đăng nhập
        if (path.startsWith("/login") || path.startsWith("/") || path.matches(".*\\.(css|js|png|jpg)$")) {
            chain.doFilter(request, response);
            return;
        }

        // Nếu chưa login
        if (role == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Quy tắc role → URL
        if (path.startsWith("/admin/") && !"ADMIN".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/exception/403.jsp");
            return;
        }
        if (path.startsWith("/staff/") && !(role.equals("STAFF") || role.equals("ADMIN"))) {
            res.sendRedirect(req.getContextPath() + "/exception/403.jsp");
            return;
        }
        // USER chỉ vào được /user/** hoặc public
        // bổ sung thêm quyền
        if (path.startsWith("/user/") && !(role.equals("USER") || role.equals("ADMIN"))) {
            res.sendRedirect(req.getContextPath() + "/exception/403.jsp");
            return;
        }

        // Nếu hợp lệ
        chain.doFilter(request, response);
    }
}


