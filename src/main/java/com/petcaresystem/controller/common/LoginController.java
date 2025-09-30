package com.petcaresystem.controller.common;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private final SimpleAuthService auth = new SimpleAuthService(); // demo

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // GET -> show form
        req.getRequestDispatcher("common/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        SimpleAuthService.User u = auth.check(username, password);
        if (u == null) {
            req.setAttribute("error", "Sai username hoặc password");
            req.getRequestDispatcher("common/login.jsp").forward(req, resp);
            return;
        }

        // set session
        HttpSession session = req.getSession(true);
        session.setAttribute("user", u);              // có thể là entity Account
        session.setAttribute("role", u.role());       // 'ADMIN' | 'STAFF' | 'USER'

        // điều hướng theo role
        switch (u.role()) {
            case "ADMIN" -> resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            case "STAFF" -> resp.sendRedirect(req.getContextPath() + "/staff/home");
            default      -> resp.sendRedirect(req.getContextPath() + "/user/home");
        }
    }

    // ===== Demo auth rất đơn giản (thay bằng DAO/Hibernate ở phần 3) =====
    static class SimpleAuthService {
        record User(int id, String username, String role) {}
        User check(String user, String pass) {
            if ("admin".equals(user) && "123".equals(pass)) return new User(1,"admin","ADMIN");
            if ("alice".equals(user) && "123".equals(pass)) return new User(2,"alice","STAFF");
            if ("bob".equals(user) && "123".equals(pass))   return new User(3,"bob","USER");
            return null;
        }
    }
}

