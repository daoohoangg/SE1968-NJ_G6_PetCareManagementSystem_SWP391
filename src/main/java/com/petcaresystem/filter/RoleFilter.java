package com.petcaresystem.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebFilter(urlPatterns = {"/admin/*", "/staff/*", "/user/*"})
public class RoleFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        String role = (session == null) ? null : (String) session.getAttribute("role");
        String path = req.getRequestURI().substring(req.getContextPath().length());

        if (role == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (path.startsWith("/admin/") && !"ADMIN".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/exception/403.jsp");
            return;
        }
        if (path.startsWith("/staff/") && !( "STAFF".equals(role) || "ADMIN".equals(role) )) {
            res.sendRedirect(req.getContextPath() + "/exception/403.jsp");
            return;
        }
        if (path.startsWith("/user/") && !( "USER".equals(role) || "ADMIN".equals(role) )) {
            res.sendRedirect(req.getContextPath() + "/exception/403.jsp");
            return;
        }

        chain.doFilter(request, response);
    }
}


