package com.petcaresystem.controller.admin;

import com.petcaresystem.dto.PagedResult;
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
        renderServiceList(req, resp, null, null, null, null, null, "list");
    }

    private void searchServices(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword   = trim(req.getParameter("keyword"));
        Integer categoryId = parseInt(req.getParameter("categoryId"));
        Boolean isActive = parseBool(req.getParameter("isActive"));
        String sortBy    = trim(req.getParameter("sortBy"));
        String sortOrder = trim(req.getParameter("sortOrder"));
        renderServiceList(req, resp, keyword, categoryId, isActive, sortBy, sortOrder, "search");
    }

    private void renderServiceList(HttpServletRequest req, HttpServletResponse resp,
                                   String keyword, Integer categoryId, Boolean isActive,
                                   String sortBy, String sortOrder, String action)
            throws ServletException, IOException {
        int page = parsePage(req.getParameter("page"));
        int size = parseSize(req.getParameter("size"));

        String effectiveKeyword = keyword != null ? keyword : trim(req.getParameter("keyword"));
        Integer effectiveCategory = categoryId != null ? categoryId : parseInt(req.getParameter("categoryId"));
        Boolean effectiveActive = isActive != null ? isActive : parseBool(req.getParameter("isActive"));
        String effectiveSortBy = sortBy != null ? sortBy : trim(req.getParameter("sortBy"));
        String effectiveSortOrder = sortOrder != null ? sortOrder : trim(req.getParameter("sortOrder"));

        PagedResult<Service> servicesPage = serviceManageService.getServicesPage(
                effectiveKeyword, effectiveCategory, effectiveActive, effectiveSortBy, effectiveSortOrder, page, size
        );
        List<ServiceCategory> categories = serviceManageService.getAllCategories();

        populateListAttributes(req, servicesPage, categories);
        req.setAttribute("filterKeyword", effectiveKeyword);
        req.setAttribute("selectedCategoryId", effectiveCategory);
        req.setAttribute("selectedActiveValue", effectiveActive);
        req.setAttribute("sortBy", effectiveSortBy);
        req.setAttribute("sortOrder", effectiveSortOrder);
        req.setAttribute("serviceAction", action);

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
        req.setAttribute("openAddModal", true);
        renderServiceList(req, resp, null, null, null, null, null, "list");
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
        req.setAttribute("editService", s);
        req.setAttribute("openEditModal", true);
        renderServiceList(req, resp, null, null, null, null, null, "list");
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
        boolean ok = (id != null) && serviceManageService.hardDeleteService(id);
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
    private int parsePage(String rawPage) {
        Integer parsed = parseInt(rawPage);
        if (parsed == null || parsed < 1) return 1;
        return parsed;
    }
    private int parseSize(String rawSize) {
        Integer parsed = parseInt(rawSize);
        if (parsed == null) return 10;
        int size = Math.max(parsed, 1);
        if (size < 5) size = 5;
        if (size > 50) size = 50;
        return size;
    }
    private void populateListAttributes(HttpServletRequest req, PagedResult<Service> pageData, List<ServiceCategory> categories) {
        List<Service> safeServices = pageData != null ? pageData.getItems() : Collections.emptyList();
        List<ServiceCategory> safeCategories = categories != null ? categories : Collections.emptyList();
        req.setAttribute("services", safeServices);
        req.setAttribute("serviceList", safeServices); // ensure JSP fallback works
        req.setAttribute("rows", safeServices);
        req.setAttribute("categories", safeCategories);

        int currentPage = pageData != null ? pageData.getPage() : 1;
        int pageSize = pageData != null ? pageData.getPageSize() : 10;
        int totalPages = pageData != null ? pageData.getTotalPages() : (safeServices.isEmpty() ? 0 : 1);
        long totalItems = pageData != null ? pageData.getTotalItems() : safeServices.size();
        int startIndex = pageData != null ? pageData.getStartIndex() : (safeServices.isEmpty() ? 0 : 1);
        int endIndex = pageData != null ? pageData.getEndIndex() : safeServices.size();

        req.setAttribute("currentPage", currentPage);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalItems", totalItems);
        req.setAttribute("pageStart", startIndex);
        req.setAttribute("pageEnd", endIndex);
        req.setAttribute("hasPrevPage", pageData != null && pageData.hasPrevious());
        req.setAttribute("hasNextPage", pageData != null && pageData.hasNext());
    }
}
