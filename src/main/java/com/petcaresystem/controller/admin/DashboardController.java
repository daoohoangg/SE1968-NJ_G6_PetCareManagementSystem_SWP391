package com.petcaresystem.controller.admin;

import com.petcaresystem.service.dashboard.DashboardMetricsService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/dashboard")
public class DashboardController extends HttpServlet {

    private final DashboardMetricsService dashboardMetricsService = new DashboardMetricsService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("totalCustomers", dashboardMetricsService.countCustomers());
        req.setAttribute("happyPets", dashboardMetricsService.countHappyPets());
        req.setAttribute("pendingAppointments", dashboardMetricsService.countPendingAppointments());
        req.setAttribute("weatherTemperatureC", dashboardMetricsService.getTodayWeatherCelsius());
        req.setAttribute("weatherSummary", dashboardMetricsService.getWeatherSummary());

        req.getRequestDispatcher("/adminpage/dashbroad.jsp").forward(req, resp);
    }
}
