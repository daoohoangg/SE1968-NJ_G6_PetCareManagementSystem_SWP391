package com.petcaresystem.controller.common;
import com.petcaresystem.dao.AccountDAO;
import com.petcaresystem.enities.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private final AccountDAO accountDAO = new AccountDAO();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("common/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String password = req.getParameter("password");
        String remember = req.getParameter("remember");
        String loginType = req.getParameter("loginType");
        Account account = null;
        if ("email".equals(loginType)) {
            String email = req.getParameter("email");
            account = accountDAO.loginWithEmail(email, password);
        } else {
            String username = req.getParameter("username");
            account = accountDAO.login(username, password);
        }
        String errorMessage = null;
        String infoMessage = null;
        if (account == null) {
            errorMessage = "Sai thông tin đăng nhập!";
        }
        else if (!password.equals(account.getPassword())) {
                errorMessage = "Sai thông tin đăng nhập!";
        } else if (!account.getIsActive()) {
            errorMessage = "Tài khoản của bạn đã bị khóa!";
        } else if (!account.getIsVerified()) {
            infoMessage = "Bạn đã đăng ký thành công! Vui lòng kiểm tra email để kích hoạt tài khoản trước khi đăng nhập.";
        }
        if (errorMessage != null || infoMessage != null) {
            req.setAttribute("error", errorMessage);
            req.setAttribute("info", infoMessage);

            if ("email".equals(loginType)) {
                req.setAttribute("mode", "email");
            }
            req.getRequestDispatcher("/common/login.jsp").forward(req, resp);
            return;
        }
        // set session
        HttpSession session = req.getSession(true);
        session.setAttribute("account", account);
        session.setAttribute("role", account.getRole().name());
        // xử lý Remember Me
        if ("on".equals(remember)) {
            Cookie ckUser = new Cookie("username", account.getUsername());
            ckUser.setMaxAge(7 * 24 * 60 * 60); // 7 ngày
            resp.addCookie(ckUser);
        } else {
            Cookie ckUser = new Cookie("username", "");
            ckUser.setMaxAge(0);
            resp.addCookie(ckUser);
        }
        // điều hướng theo role
        switch (account.getRole()) {
            case ADMIN -> resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            case STAFF -> resp.sendRedirect(req.getContextPath() + "/staff/home");
            case CUSTOMER -> resp.sendRedirect(req.getContextPath() + "/home");
            default -> resp.sendRedirect(req.getContextPath() + "/home");
        }
    }

}

