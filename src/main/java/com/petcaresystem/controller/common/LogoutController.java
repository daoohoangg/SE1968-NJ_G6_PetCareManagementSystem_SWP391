package com.petcaresystem.controller.common;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
@WebServlet("/logout")
public class LogoutController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        Cookie ckUser = new Cookie("username", "");
        Cookie ckPass = new Cookie("password", "");
        ckUser.setMaxAge(0);
        ckPass.setMaxAge(0);
        resp.addCookie(ckUser);
        resp.addCookie(ckPass);
        resp.sendRedirect(req.getContextPath() + "/login");
    }
}
