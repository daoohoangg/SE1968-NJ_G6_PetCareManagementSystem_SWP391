package com.petcaresystem.controller.admin;

import com.petcaresystem.enities.Service;
import com.petcaresystem.enities.ServiceCategory;
import com.petcaresystem.service.admin.IServiceManageService;
import com.petcaresystem.service.admin.impl.ServiceManageServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

@WebServlet("/admin/service")
public class ServiceController extends HttpServlet {

    private IServiceManageService serviceManageService;

    @Override
    public void init() throws ServletException {
        super.init();
        serviceManageService = new ServiceManageServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                listServices(req, resp);
                break;
            case "search":
                searchServices(req, resp);
                break;
            case "view":
                viewService(req, resp);
                break;
            case "add":
                showAddForm(req, resp);
                break;
            case "edit":
                showEditForm(req, resp);
                break;
            default:
                listServices(req, resp);
        }
    }

    private void listServices(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Service> services = serviceManageService.getAllServices();
        List<ServiceCategory> categories = serviceManageService.getAllCategories();
        populateListAttributes(req, services, categories);
        req.getRequestDispatcher("/adminpage/manage-services.jsp").forward(req, resp);
    }

    private void searchServices(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword   = trim(req.getParameter("keyword"));
        Integer categoryId = parseInt(req.getParameter("categoryId"));
        Boolean isActive = parseBool(req.getParameter("isActive"));
        String sortBy    = trim(req.getParameter("sortBy"));
        String sortOrder = trim(req.getParameter("sortOrder"));

        List<Service> services = serviceManageService.searchServices(
                keyword, categoryId, isActive, sortBy, sortOrder
        );
        List<ServiceCategory> categories = serviceManageService.getAllCategories();

        populateListAttributes(req, services, categories);
        req.setAttribute("keyword", keyword);
        req.setAttribute("selectedCategoryId", categoryId);
        req.setAttribute("selectedActive", req.getParameter("isActive"));
        req.setAttribute("sortBy", sortBy);
        req.setAttribute("sortOrder", sortOrder);

        req.getRequestDispatcher("/adminpage/manage-services.jsp").forward(req, resp);
    }

    private void viewService(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        Integer id = parseInt(req.getParameter("id"));
        if (id == null) {
            flash(req, "error", "Invalid service ID");
            resp.sendRedirect(req.getContextPath() + "/admin/service");
            return;
        }
        Service s = serviceManageService.getServiceById(id);
        if (s == null) {
            flash(req, "error", "Service not found");
            resp.sendRedirect(req.getContextPath() + "/admin/service");
            return;
        }
        req.setAttribute("service", s);
        req.getRequestDispatcher("/adminpage/view-service.jsp").forward(req, resp);
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Service> services = serviceManageService.getAllServices();
        List<ServiceCategory> categories = serviceManageService.getAllCategories();
        populateListAttributes(req, services, categories);
        req.setAttribute("openAddModal", true);
        req.getRequestDispatcher("/adminpage/manage-services.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        Integer id = parseInt(req.getParameter("id"));
        if (id == null) {
            flash(req, "error", "Invalid service ID");
            resp.sendRedirect(req.getContextPath() + "/admin/service");
            return;
        }
        Service s = serviceManageService.getServiceById(id);
        if (s == null) {
            flash(req, "error", "Service not found");
            resp.sendRedirect(req.getContextPath() + "/admin/service");
            return;
        }
        req.setAttribute("service", s);
        req.setAttribute("categories", serviceManageService.getAllCategories());
        req.getRequestDispatcher("/adminpage/edit-service.jsp").forward(req, resp);
    }

    // ---------------- POST (PRG) ----------------
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String action = req.getParameter("action");
        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/service");
            return;
        }
        switch (action) {
            case "create":
                handleCreate(req, resp);
                break;
            case "update":
                handleUpdate(req, resp);
                break;
            case "delete":
                handleDelete(req, resp); // Delete qua POST
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/service");
        }
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String name       = trim(req.getParameter("serviceName"));
        String desc       = trim(req.getParameter("description"));
        BigDecimal price  = parseMoney(req.getParameter("price"));
        Integer duration  = parseInt(req.getParameter("durationMinutes"));
        Integer categoryId= parseInt(req.getParameter("categoryId"));
        boolean isActive  = parseActiveFlag(req);

        boolean ok = serviceManageService.createService(
                name, desc, price, duration, categoryId, isActive
        );
        flash(req, ok ? "success" : "error",
                ok ? "Service created successfully" : "Failed to create service");

        resp.sendRedirect(req.getContextPath() + "/admin/service?action=list");
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        Integer serviceId = parseInt(req.getParameter("serviceId"));
        if (serviceId == null) {
            flash(req, "error", "Invalid service ID");
            resp.sendRedirect(req.getContextPath() + "/admin/service");
            return;
        }
        String name       = trim(req.getParameter("serviceName"));
        String desc       = trim(req.getParameter("description"));
        BigDecimal price  = parseMoney(req.getParameter("price"));
        Integer duration  = parseInt(req.getParameter("durationMinutes"));
        Integer categoryId= parseInt(req.getParameter("categoryId"));
        boolean isActive  = parseActiveFlag(req);

        boolean ok = serviceManageService.updateService(
                serviceId, name, desc, price, duration, categoryId, isActive
        );
        flash(req, ok ? "success" : "error",
                ok ? "Service updated successfully" : "Failed to update service");

        resp.sendRedirect(req.getContextPath() + "/admin/service?action=list");
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        Integer id = parseInt(req.getParameter("id"));
        boolean ok = (id != null) && serviceManageService.deleteService(id);
        flash(req, ok ? "success" : "error",
                ok ? "Service deleted successfully" : "Failed to delete service");
        resp.sendRedirect(req.getContextPath() + "/admin/service?action=list");
    }

    // -------------- utilities --------------
    private static String trim(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
    private static Integer parseInt(String s) {
        try { return trim(s) == null ? null : Integer.valueOf(s.trim()); }
        catch (Exception e) { return null; }
    }
    private static BigDecimal parseMoney(String s) {
        try { return trim(s) == null ? null : new BigDecimal(s.trim()); }
        catch (Exception e) { return null; }
    }
    private static Boolean parseBool(String s) {
        if (s == null || s.isBlank()) return null;
        return Boolean.parseBoolean(s);
    }
    private static boolean parseActiveFlag(HttpServletRequest req) {
        String[] keys = {"status", "serviceStatus", "isActive", "active"};
        for (String key : keys) {
            String raw = trim(req.getParameter(key));
            if (raw == null) continue;
            switch (raw.toLowerCase()) {
                case "true":
                case "1":
                case "on":
                case "active":
                case "yes":
                    return true;
                case "false":
                case "0":
                case "off":
                case "inactive":
                case "no":
                    return false;
            }
        }
        return req.getParameter("isActive") != null;
    }
    private static void flash(HttpServletRequest req, String key, String msg) {
        req.getSession().setAttribute(key, msg);
    }
    private void populateListAttributes(HttpServletRequest req, List<Service> services, List<ServiceCategory> categories) {
        List<Service> safeServices = services != null ? services : Collections.emptyList();
        List<ServiceCategory> safeCategories = categories != null ? categories : Collections.emptyList();
        req.setAttribute("services", safeServices);
        req.setAttribute("serviceList", safeServices); // ensure JSP fallback works
        req.setAttribute("rows", safeServices);
        req.setAttribute("categories", safeCategories);
    }
}
