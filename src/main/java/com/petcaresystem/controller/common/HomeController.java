package com.petcaresystem.controller.common;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
@WebServlet("/home")
public class HomeController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.setAttribute("username", session.getAttribute("user"));
        req.getRequestDispatcher("/home.jsp").forward(req, resp);
    }
}
