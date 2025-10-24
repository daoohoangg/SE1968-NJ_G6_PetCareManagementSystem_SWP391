package com.petcaresystem.controller.common;
import com.petcaresystem.dao.AccountDAO;
import com.petcaresystem.enities.Account;
import java.util.UUID;
import com.petcaresystem.enities.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.petcaresystem.service.email.EmailService;
import static com.petcaresystem.enities.enu.AccountRoleEnum.CUSTOMER;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/common/register.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String errorMessage = null;
        if (fullName == null || fullName.isEmpty()) {
            errorMessage = "Full name is required!";
        } else if (username == null || username.isEmpty()) {
            errorMessage = "Username is required!";
        } else if (email == null || email.isEmpty()) {
            errorMessage = "Email is required!";
        } else if (phone == null || phone.isEmpty()) {
            errorMessage = "Phone number is required!";
        } else if (password == null || password.isEmpty()) {
            errorMessage = "Password is required!";
        } else if (!password.equals(confirmPassword)) {
            errorMessage = "Passwords do not match!";
        }

        if (accountDAO.getAccountByEmailOrUsername(username) != null) {
            errorMessage = "Username or Email already exists!";
        }

        if (errorMessage != null) {
            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("/common/register.jsp").forward(request, response);
            return;
        }
        String token = UUID.randomUUID().toString();
        Customer account = new Customer();
        account.setFullName(fullName);
        account.setUsername(username);
        account.setEmail(email);
        account.setPhone(phone);
        account.setPassword(password);
        account.setRole(CUSTOMER);
        account.setVerificationToken(token);
        boolean success = accountDAO.register(account);

        if (success) {
            String verificationLink = "http://localhost:8080" + request.getContextPath() + "/verify?token=" + token;
            System.out.println("Verification Link (in case email fails): " + verificationLink);
            try {
                String contextPath = request.getContextPath();
                EmailService.sendVerificationEmail(account.getEmail(), token, contextPath);
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/login?status=registered");

        } else {
            request.setAttribute("error", "Registration failed! Username might already exist.");
            request.getRequestDispatcher("/common/register.jsp").forward(request, response);
        }
    }
}