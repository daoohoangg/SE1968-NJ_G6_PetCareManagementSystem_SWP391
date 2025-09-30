package com.petcaresystem.controller;

import java.io.*;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home",""})
public class HelloServlet extends HttpServlet {


    @Override
    public void init() throws ServletException {
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String name = request.getParameter("name");
            out.println("<html>");
            out.println("<head><title>HomeServlet</title></head>");
            out.println("<body>");
            out.println("<h1>Hello, " + (name != null ? name : "Guest") + " from POST in HomeServlet</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
}