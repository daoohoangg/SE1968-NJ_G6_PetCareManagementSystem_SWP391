package com.petcaresystem.controller.common;

import com.petcaresystem.dao.AccountDAO;
import com.petcaresystem.enities.Account;
import jakarta.servlet.ServletException;
import com.petcaresystem.service.email.EmailService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.SecureRandom;
@WebServlet("/forgotpassword")
public class ForgotPasswordController extends HttpServlet {
    private final AccountDAO accountDAO = new AccountDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/common/forgotpassword.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userInput = request.getParameter("userInput");
        Account acc = accountDAO.getAccountByEmailOrUsername(userInput);

        if (acc != null) {
            String newPassword = generateRandomPassword(8);
            acc.setPassword(newPassword);
            boolean updated = accountDAO.updateAccount(acc);

            if (updated) {
                try {
                    EmailService.sendNewPasswordEmail(acc.getEmail(), newPassword);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        request.setAttribute("message", "A new password has been sent to your email.");
        request.getRequestDispatcher("/common/forgotpassword.jsp").forward(request, response);
    }
    private String generateRandomPassword(int length) {
        final String CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            int randomIndex = random.nextInt(CHARS.length());
            sb.append(CHARS.charAt(randomIndex));
        }
        return sb.toString();
    }
}
