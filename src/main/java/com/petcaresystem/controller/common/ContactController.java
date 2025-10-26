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
            request.setAttribute("message", "Your message has been sent successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "An error occurred while sending the message. Please try again later.");
        }
        request.getRequestDispatcher("/inc/contact.jsp").forward(request, response);
    }
}