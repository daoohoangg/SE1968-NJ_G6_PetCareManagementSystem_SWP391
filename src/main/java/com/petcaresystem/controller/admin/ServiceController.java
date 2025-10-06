package com.petcaresystem.controller.admin;

import com.petcaresystem.enities.Service;
import com.petcaresystem.service.admin.IServiceManageService;
import com.petcaresystem.service.admin.impl.ServiceManageServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
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
        
        if (action == null) {
            action = "list";
        }
        
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
            case "delete":
                deleteService(req, resp);
                break;
            default:
                listServices(req, resp);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/service");
            return;
        }
        
        switch (action) {
            case "create":
                createService(req, resp);
                break;
            case "update":
                updateService(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/service");
                break;
        }
    }
    
    // List all services
    private void listServices(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Service> services = serviceManageService.getAllServices();
        List<String> categories = serviceManageService.getAllCategories();
        
        req.setAttribute("services", services);
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/adminpage/manage-services.jsp").forward(req, resp);
    }
    
    // Search, sort, and filter services
    private void searchServices(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String category = req.getParameter("category");
        String activeStr = req.getParameter("isActive");
        String sortBy = req.getParameter("sortBy");
        String sortOrder = req.getParameter("sortOrder");
        
        Boolean isActive = null;
        if (activeStr != null && !activeStr.isEmpty()) {
            isActive = Boolean.parseBoolean(activeStr);
        }
        
        List<Service> services = serviceManageService.searchServices(keyword, category, isActive, sortBy, sortOrder);
        List<String> categories = serviceManageService.getAllCategories();
        
        req.setAttribute("services", services);
        req.setAttribute("categories", categories);
        req.setAttribute("keyword", keyword);
        req.setAttribute("selectedCategory", category);
        req.setAttribute("selectedActive", activeStr);
        req.setAttribute("sortBy", sortBy);
        req.setAttribute("sortOrder", sortOrder);
        
        req.getRequestDispatcher("/adminpage/manage-services.jsp").forward(req, resp);
    }
    
    // View service details
    private void viewService(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int serviceId = Integer.parseInt(req.getParameter("id"));
            Service service = serviceManageService.getServiceById(serviceId);
            
            if (service != null) {
                req.setAttribute("service", service);
                req.getRequestDispatcher("/adminpage/view-service.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Service not found");
                listServices(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid service ID");
            listServices(req, resp);
        }
    }
    
    // Show add service form
    private void showAddForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<String> categories = serviceManageService.getAllCategories();
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/adminpage/add-service.jsp").forward(req, resp);
    }
    
    // Show edit service form
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int serviceId = Integer.parseInt(req.getParameter("id"));
            Service service = serviceManageService.getServiceById(serviceId);
            
            if (service != null) {
                List<String> categories = serviceManageService.getAllCategories();
                req.setAttribute("service", service);
                req.setAttribute("categories", categories);
                req.getRequestDispatcher("/adminpage/edit-service.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Service not found");
                listServices(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid service ID");
            listServices(req, resp);
        }
    }
    
    // Create new service
    private void createService(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String serviceName = req.getParameter("serviceName");
            String description = req.getParameter("description");
            BigDecimal price = new BigDecimal(req.getParameter("price"));
            String durationStr = req.getParameter("durationMinutes");
            String category = req.getParameter("category");
            boolean isActive = req.getParameter("isActive") != null;
            
            Integer durationMinutes = null;
            if (durationStr != null && !durationStr.isEmpty()) {
                durationMinutes = Integer.parseInt(durationStr);
            }
            
            Service service = new Service();
            service.setServiceName(serviceName);
            service.setDescription(description);
            service.setPrice(price);
            service.setDurationMinutes(durationMinutes);
            service.setCategory(category);
            service.setActive(isActive);
            
            boolean success = serviceManageService.createService(service);
            
            if (success) {
                req.setAttribute("success", "Service created successfully");
            } else {
                req.setAttribute("error", "Failed to create service");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error creating service: " + e.getMessage());
        }
        
        listServices(req, resp);
    }
    
    // Update service
    private void updateService(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int serviceId = Integer.parseInt(req.getParameter("serviceId"));
            String serviceName = req.getParameter("serviceName");
            String description = req.getParameter("description");
            BigDecimal price = new BigDecimal(req.getParameter("price"));
            String durationStr = req.getParameter("durationMinutes");
            String category = req.getParameter("category");
            boolean isActive = req.getParameter("isActive") != null;
            
            Integer durationMinutes = null;
            if (durationStr != null && !durationStr.isEmpty()) {
                durationMinutes = Integer.parseInt(durationStr);
            }
            
            Service service = serviceManageService.getServiceById(serviceId);
            if (service != null) {
                service.setServiceName(serviceName);
                service.setDescription(description);
                service.setPrice(price);
                service.setDurationMinutes(durationMinutes);
                service.setCategory(category);
                service.setActive(isActive);
                
                boolean success = serviceManageService.updateService(service);
                
                if (success) {
                    req.setAttribute("success", "Service updated successfully");
                } else {
                    req.setAttribute("error", "Failed to update service");
                }
            } else {
                req.setAttribute("error", "Service not found");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error updating service: " + e.getMessage());
        }
        
        listServices(req, resp);
    }
    
    // Delete service (soft delete)
    private void deleteService(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int serviceId = Integer.parseInt(req.getParameter("id"));
            boolean success = serviceManageService.deleteService(serviceId);
            
            if (success) {
                req.setAttribute("success", "Service deleted successfully");
            } else {
                req.setAttribute("error", "Failed to delete service");
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid service ID");
        }
        
        listServices(req, resp);
    }
}
