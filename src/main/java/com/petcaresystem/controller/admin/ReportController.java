package com.petcaresystem.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/admin/reports/*")
public class ReportController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/adminpage/reports.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");
        
        String path = req.getPathInfo();
        
        try {
            if (path != null && path.equals("/generate")) {
                handleGenerateReport(req, resp);
            } else if (path != null && path.equals("/stats")) {
                handleGetStats(req, resp);
            } else {
                resp.setStatus(404);
                writeErrorResponse(resp, "Invalid endpoint");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            writeErrorResponse(resp, "Internal server error: " + e.getMessage());
        }
    }
    
    /**
     * Handle report generation
     * POST /admin/reports/generate
     */
    private void handleGenerateReport(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        
        // Get date range parameters
        String startDateParam = req.getParameter("startDate");
        String endDateParam = req.getParameter("endDate");
        
        // Parse dates
        LocalDate startDate = startDateParam != null ? 
            LocalDate.parse(startDateParam) : LocalDate.now().minusDays(30);
        LocalDate endDate = endDateParam != null ? 
            LocalDate.parse(endDateParam) : LocalDate.now();
        
        // Generate report data
        Map<String, Object> reportData = new HashMap<>();
        
        // Financial data
        Map<String, Object> financialData = generateFinancialData(startDate, endDate);
        reportData.put("financial", financialData);
        
        // Operational data
        Map<String, Object> operationalData = generateOperationalData(startDate, endDate);
        reportData.put("operational", operationalData);
        
        // Summary stats
        Map<String, Object> summary = generateSummaryStats(startDate, endDate);
        reportData.put("summary", summary);
        
        // Return JSON response
        JSONObject response = new JSONObject()
                .put("success", true)
                .put("message", "Report generated successfully")
                .put("data", reportData)
                .put("startDate", startDate.toString())
                .put("endDate", endDate.toString());
        
        resp.getWriter().write(response.toString());
    }
    
    /**
     * Handle getting stats for date range
     * POST /admin/reports/stats
     */
    private void handleGetStats(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        
        String startDateParam = req.getParameter("startDate");
        String endDateParam = req.getParameter("endDate");
        
        LocalDate startDate = startDateParam != null ? 
            LocalDate.parse(startDateParam) : LocalDate.now().minusDays(30);
        LocalDate endDate = endDateParam != null ? 
            LocalDate.parse(endDateParam) : LocalDate.now();
        
        Map<String, Object> stats = generateSummaryStats(startDate, endDate);
        
        JSONObject response = new JSONObject()
                .put("success", true)
                .put("stats", stats);
        
        resp.getWriter().write(response.toString());
    }
    
    /**
     * Generate financial report data
     */
    private Map<String, Object> generateFinancialData(LocalDate start, LocalDate end) {
        Map<String, Object> financial = new HashMap<>();
        
        // Monthly revenue trend
        List<Map<String, Object>> monthlyRevenue = new ArrayList<>();
        LocalDate current = start.withDayOfMonth(1);
        int index = 0;
        
        while (!current.isAfter(end)) {
            Map<String, Object> month = new HashMap<>();
            month.put("month", current.format(DateTimeFormatter.ofPattern("MMM")));
            // Simulate revenue data - in real implementation, query from database
            month.put("revenue", 15000 + (index * 1200) + new Random().nextInt(2000));
            monthlyRevenue.add(month);
            
            current = current.plusMonths(1);
            index++;
        }
        financial.put("monthlyRevenue", monthlyRevenue);
        
        // Revenue by service
        List<Map<String, Object>> serviceRevenue = new ArrayList<>();
        
        Map<String, Object> service1 = new HashMap<>();
        service1.put("name", "Dog Grooming");
        service1.put("bookings", 35);
        service1.put("revenue", 8750);
        service1.put("avgPrice", 250.0);
        service1.put("percentage", 35);
        service1.put("growth", "+18%");
        serviceRevenue.add(service1);
        
        Map<String, Object> service2 = new HashMap<>();
        service2.put("name", "Cat Grooming");
        service2.put("bookings", 25);
        service2.put("revenue", 5500);
        service2.put("avgPrice", 220.0);
        service2.put("percentage", 25);
        service2.put("growth", "+12%");
        serviceRevenue.add(service2);
        
        Map<String, Object> service3 = new HashMap<>();
        service3.put("name", "Health Checkup");
        service3.put("bookings", 20);
        service3.put("revenue", 6300);
        service3.put("avgPrice", 315.0);
        service3.put("percentage", 20);
        service3.put("growth", "0%");
        serviceRevenue.add(service3);
        
        Map<String, Object> service4 = new HashMap<>();
        service4.put("name", "Vaccination");
        service4.put("bookings", 15);
        service4.put("revenue", 4800);
        service4.put("avgPrice", 320.0);
        service4.put("percentage", 15);
        service4.put("growth", "-6%");
        serviceRevenue.add(service4);
        
        financial.put("serviceRevenue", serviceRevenue);
        
        return financial;
    }
    
    /**
     * Generate operational report data
     */
    private Map<String, Object> generateOperationalData(LocalDate start, LocalDate end) {
        Map<String, Object> operational = new HashMap<>();
        
        // Service volume trends
        List<Map<String, Object>> serviceVolume = new ArrayList<>();
        LocalDate current = start.withDayOfMonth(1);
        int index = 0;
        
        while (!current.isAfter(end)) {
            Map<String, Object> month = new HashMap<>();
            month.put("month", current.format(DateTimeFormatter.ofPattern("MMM")));
            month.put("completed", 84 + (index * 7) + new Random().nextInt(10));
            serviceVolume.add(month);
            
            current = current.plusMonths(1);
            index++;
        }
        operational.put("serviceVolume", serviceVolume);
        
        // Customer acquisition
        List<Map<String, Object>> customerAcquisition = new ArrayList<>();
        current = start.withDayOfMonth(1);
        index = 0;
        
        while (!current.isAfter(end)) {
            Map<String, Object> month = new HashMap<>();
            month.put("month", current.format(DateTimeFormatter.ofPattern("MMM")));
            month.put("newCustomers", 24 + (index * 4) + new Random().nextInt(5));
            month.put("returningCustomers", 18 + (index * 3) + new Random().nextInt(5));
            customerAcquisition.add(month);
            
            current = current.plusMonths(1);
            index++;
        }
        operational.put("customerAcquisition", customerAcquisition);
        
        // Operational metrics
        Map<String, Object> metrics = new HashMap<>();
        metrics.put("appointmentUtilization", 87.3);
        metrics.put("onTimePerformance", 92.1);
        metrics.put("averageWaitTime", 12);
        metrics.put("staffProductivity", 94.5);
        metrics.put("customerSatisfaction", 4.8);
        
        operational.put("metrics", metrics);
        
        return operational;
    }
    
    /**
     * Generate summary statistics
     */
    private Map<String, Object> generateSummaryStats(LocalDate start, LocalDate end) {
        Map<String, Object> stats = new HashMap<>();
        
        // Total revenue
        double totalRevenue = 91000 + new Random().nextInt(10000);
        stats.put("totalRevenue", totalRevenue);
        stats.put("revenueGrowth", "+12.5%");
        
        // Total appointments
        int totalAppointments = 624 + new Random().nextInt(100);
        stats.put("totalAppointments", totalAppointments);
        stats.put("completionRate", 94.2);
        
        // Average transaction
        double avgTransaction = totalRevenue / totalAppointments;
        stats.put("avgTransaction", Math.round(avgTransaction * 100.0) / 100.0);
        stats.put("topService", "Dog Grooming");
        
        // Customer rating
        stats.put("customerRating", 4.7);
        stats.put("avgDuration", 67);
        
        return stats;
    }
    
    private void writeErrorResponse(HttpServletResponse resp, String message)
            throws IOException {
        JSONObject error = new JSONObject()
                .put("success", false)
                .put("error", message);
        resp.getWriter().write(error.toString());
    }
}