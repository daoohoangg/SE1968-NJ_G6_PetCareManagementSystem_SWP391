package com.petcaresystem.controller.invoice;

import com.petcaresystem.dao.InvoiceDAO;
import com.petcaresystem.enities.Invoice;
import com.petcaresystem.enities.enu.InvoiceStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "InvoiceManagementController", urlPatterns = {"/invoices"})
public class InvoiceController extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private InvoiceDAO invoiceDAO;

    @Override
    public void init() throws ServletException {
        invoiceDAO = new InvoiceDAO();
    }

    // ------------------- XỬ LÝ GET -------------------
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "view":
                viewDetail(request, response);
                break;
            case "delete":
                deleteInvoice(request, response);
                break;
            default:
                listInvoices(request, response);
                break;
        }
    }

    // ------------------- XỬ LÝ POST -------------------
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "updateStatus":
                updateStatus(request, response);
                break;
            default:
                listInvoices(request, response);
                break;
        }
    }

    // ------------------- CÁC HÀM XỬ LÝ -------------------

    // ✅ List invoices with search/filter and pagination
    private void listInvoices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get pagination parameters
            int page = 1;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
            
            // Get search/filter parameters
            String searchTerm = request.getParameter("search");
            String statusParam = request.getParameter("status");
            InvoiceStatus status = null;
            
            if (statusParam != null && !statusParam.isEmpty() && !statusParam.equals("ALL")) {
                try {
                    status = InvoiceStatus.valueOf(statusParam);
                } catch (IllegalArgumentException e) {
                    // Ignore invalid status
                }
            }
            
            // Get filtered/searched results with pagination
            List<Invoice> invoices;
            long totalRecords;
            
            if ((searchTerm != null && !searchTerm.trim().isEmpty()) || status != null) {
                // Search/Filter mode
                invoices = invoiceDAO.searchAndFilter(searchTerm, status, page, PAGE_SIZE);
                totalRecords = invoiceDAO.countSearchAndFilter(searchTerm, status);
            } else {
                // Normal list mode
                invoices = invoiceDAO.findAll(page, PAGE_SIZE);
                totalRecords = invoiceDAO.countAll();
            }
            
            // Calculate pagination
            int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
            
            // Set attributes
            request.setAttribute("invoiceList", invoices);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("selectedStatus", statusParam);
            request.setAttribute("statuses", InvoiceStatus.values());
            
            request.getRequestDispatcher("/invoice/invoice-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to load invoices: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    // ✅ View invoice detail
    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            Invoice invoice = invoiceDAO.findById(id);
            
            if (invoice == null) {
                request.getSession().setAttribute("error", "Invoice not found.");
                response.sendRedirect("invoices");
                return;
            }
            
            request.setAttribute("invoice", invoice);
            request.getRequestDispatcher("/invoice/invoice-detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to load invoice detail: " + e.getMessage());
            response.sendRedirect("invoices");
        }
    }

    // ✅ Delete invoice
    private void deleteInvoice(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            invoiceDAO.delete(id);
            request.getSession().setAttribute("success", "Invoice deleted successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to delete invoice: " + e.getMessage());
        }
        response.sendRedirect("invoices");
    }

    // ✅ Update invoice status
    private void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            String statusParam = request.getParameter("status");
            
            Invoice invoice = invoiceDAO.findById(id);
            if (invoice == null) {
                request.getSession().setAttribute("error", "Invoice not found.");
                response.sendRedirect("invoices");
                return;
            }
            
            InvoiceStatus newStatus = InvoiceStatus.valueOf(statusParam);
            invoice.setStatus(newStatus);
            
            if (newStatus == InvoiceStatus.PAID) {
                invoice.markAsPaid();
            } else if (newStatus == InvoiceStatus.CANCELLED) {
                invoice.markAsCancelled();
            }
            
            invoiceDAO.update(invoice);
            request.getSession().setAttribute("success", "Invoice status updated successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to update status: " + e.getMessage());
        }
        response.sendRedirect("invoices");
    }
}
