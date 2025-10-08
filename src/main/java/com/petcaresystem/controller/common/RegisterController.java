package com.petcaresystem.controller.common;
import com.petcaresystem.dao.AccountDAO;
import com.petcaresystem.enities.Account;

import com.petcaresystem.enities.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import static com.petcaresystem.enities.enu.AccountRoleEnum.CUSTOMER;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị form đăng ký
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate
        String errorMessage = null;
        if (username == null || username.isEmpty()) {
            errorMessage = "Username is required!";
        } else if (password == null || password.isEmpty()) {
            errorMessage = "Password is required!";
        } else if (!password.equals(confirmPassword)) {
            errorMessage = "Passwords do not match!";
        }

        if (errorMessage != null) {
            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Tạo account mới
        Customer account = new Customer();
        account.setUsername(username);
        account.setPassword(password);
        account.setRole(CUSTOMER);

        // Lưu DB
        boolean success = accountDAO.register(account);

        if (success) {
            // Đăng ký thành công -> chuyển về trang login
            response.sendRedirect("login.jsp");
        } else {
            // Thất bại -> báo lỗi
            request.setAttribute("error", "Registration failed! Username might already exist.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}