package com.petcaresystem.controller.billing;

import com.petcaresystem.service.billing.PaymentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "PaymentController", urlPatterns = {"/billing/payments/add"})
public class PaymentController extends HttpServlet {

    private PaymentService paymentService;

    @Override
    public void init() {
        paymentService = new PaymentService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long invoiceId = Long.valueOf(req.getParameter("invoiceId"));
        BigDecimal amount = new BigDecimal(req.getParameter("amount"));
        String method = req.getParameter("method");
        String notes = req.getParameter("notes");
        paymentService.addPayment(invoiceId, amount, method, notes);
        resp.sendRedirect(req.getContextPath() + "/billing/invoices/view?id=" + invoiceId);
    }
}
