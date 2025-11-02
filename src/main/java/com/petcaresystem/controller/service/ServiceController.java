package com.petcaresystem.controller.service;
import com.petcaresystem.dao.ServiceDAO;
import com.petcaresystem.enities.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ServiceController", urlPatterns = {"/services"})
public class ServiceController extends HttpServlet {

    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        this.serviceDAO = new ServiceDAO();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String serviceIdParam = request.getParameter("id");

        if (serviceIdParam == null || serviceIdParam.isEmpty()) {
            showServiceListPage(request, response);
        } else {
            showServiceDetailPage(request, response, serviceIdParam);
        }
    }
    private void showServiceListPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Service> serviceList = serviceDAO.getActiveServices();
            request.setAttribute("serviceList", serviceList);
            request.getRequestDispatcher("/customer/services.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private void showServiceDetailPage(HttpServletRequest request, HttpServletResponse response, String serviceIdParam)
            throws ServletException, IOException {
        try {
            int serviceId = Integer.parseInt(serviceIdParam);
            Service service = serviceDAO.getServiceById(serviceId);

            if (service != null && service.isActive()) {
                request.setAttribute("service", service);
                request.getRequestDispatcher("/customer/service-detail.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Service not found or is no longer available.");
                showServiceListPage(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid service ID.");
            showServiceListPage(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while fetching service details.");
            showServiceListPage(request, response);
        }
    }
}