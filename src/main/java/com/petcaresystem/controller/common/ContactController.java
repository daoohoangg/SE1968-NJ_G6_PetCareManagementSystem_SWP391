package com.petcaresystem.controller.common;

import com.petcaresystem.service.email.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/contact")
public class ContactController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/inc/contact.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String messageContent = request.getParameter("message");
        try {
            EmailService.sendContactFormEmail(name, email, subject, messageContent);
            request.setAttribute("message", "Tin nhắn của bạn đã được gửi thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Đã xảy ra lỗi khi gửi tin nhắn. Vui lòng thử lại sau.");
        }
        request.getRequestDispatcher("/inc/contact.jsp").forward(request, response);
    }
}