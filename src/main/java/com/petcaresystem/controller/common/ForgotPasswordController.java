package com.petcaresystem.controller.common;

import com.petcaresystem.dao.AccountDAO;
import com.petcaresystem.enities.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/forgotpassword")
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("forgotpassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userInput = request.getParameter("userInput");

        AccountDAO dao = new AccountDAO();
        Account acc = dao.getAccountByEmailOrUsername(userInput);

        if (acc != null) {
            request.setAttribute("message", "Your password is: " + acc.getPassword());
        } else {
            request.setAttribute("message", "No account found with that email or username!");
        }

        request.getRequestDispatcher("forgotpassword.jsp").forward(request, response);
    }
}
