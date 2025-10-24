package com.petcaresystem.controller.billing;

import com.petcaresystem.enities.Invoice;
import com.petcaresystem.service.billing.InvoiceService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "InvoiceController", urlPatterns = {"/billing/invoices", "/billing/invoices/create", "/billing/invoices/view"})
public class                                                              InvoiceController extends HttpServlet {

    private InvoiceService invoiceService;

    @Override
    public void init() {
        invoiceService = new InvoiceService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/billing/invoices".equals(path)) {
            List<Invoice> invoices = invoiceService.listAll();
            req.setAttribute("invoices", invoices);
            RequestDispatcher rd = req.getRequestDispatcher("/billing/invoices-list.jsp");
            rd.forward(req, resp);
        } else if ("/billing/invoices/view".equals(path)) {
            Long id = Long.valueOf(req.getParameter("id"));
            Invoice inv = invoiceService.get(id);
            req.setAttribute("invoice", inv);
            RequestDispatcher rd = req.getRequestDispatcher("/billing/invoice-detail.jsp");
            rd.forward(req, resp);
        } else if ("/billing/invoices/create".equals(path)) {
            // create from appointment
            req.getRequestDispatcher("/billing/invoice-create.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String path = req.getServletPath();
        if ("/billing/invoices/create".equals(path)) {
            Long appointmentId = Long.valueOf(req.getParameter("appointmentId"));
            BigDecimal subtotal = req.getParameter("subtotal") != null && !req.getParameter("subtotal").isEmpty()
                    ? new BigDecimal(req.getParameter("subtotal")) : null;
            BigDecimal tax = req.getParameter("tax") != null && !req.getParameter("tax").isEmpty()
                    ? new BigDecimal(req.getParameter("tax")) : null;
            BigDecimal discount = req.getParameter("discount") != null && !req.getParameter("discount").isEmpty()
                    ? new BigDecimal(req.getParameter("discount")) : null;
            LocalDateTime due = LocalDateTime.now().plusDays(7);
            invoiceService.createForAppointment(appointmentId, subtotal, tax, discount, due);
            resp.sendRedirect(req.getContextPath() + "/billing/invoices");
        }
    }
}
