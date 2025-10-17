package com.petcaresystem.controller.common;
import com.petcaresystem.dao.AccountDAO;
import com.petcaresystem.enities.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
@WebServlet("/verify")
public class VerificationController extends HttpServlet {
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String token = request.getParameter("token");
        if (token == null || token.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login?error=invalid_token");
            return;
        }

        Account account = accountDAO.findByVerificationToken(token);

        if (account != null && !account.getIsVerified()) {
            account.setIsVerified(true);
            account.setVerificationToken(null); // Invalidate the token
            accountDAO.updateAccount(account);

            response.sendRedirect(request.getContextPath() + "/login?status=verified_success");
        } else {
            response.sendRedirect(request.getContextPath() + "/login?error=invalid_token");
        }
    }
}

