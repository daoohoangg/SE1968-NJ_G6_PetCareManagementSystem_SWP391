package com.petcaresystem.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;
import java.math.BigDecimal;
import com.petcaresystem.service.billing.PaymentService;
import com.petcaresystem.service.report.ReportMetricsService;
import com.petcaresystem.service.dashboard.DashboardMetricsService;
import com.petcaresystem.dao.AppointmentDAO;

@WebServlet("/admin/reports/*")
public class ReportController extends HttpServlet {

    private final PaymentService paymentService = new PaymentService();
    private final ReportMetricsService reportMetricsService = new ReportMetricsService();
    private final DashboardMetricsService dashboardMetricsService = new DashboardMetricsService();
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        
        if (path != null && path.equals("/export")) {
            // Handle export via GET
            try {
                handleExport(req, resp);
            } catch (Exception e) {
                e.printStackTrace();
                resp.setStatus(500);
                writeErrorResponse(resp, "Internal server error: " + e.getMessage());
            }
        } else {
            req.getRequestDispatcher("/adminpage/reports.jsp").forward(req, resp);
        }
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
            } else if (path != null && path.equals("/export")) {
                handleExport(req, resp);
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
        LocalDate requestedStart = (startDateParam != null && !startDateParam.isBlank())
                ? LocalDate.parse(startDateParam)
                : null;
        LocalDate requestedEnd = (endDateParam != null && !endDateParam.isBlank())
                ? LocalDate.parse(endDateParam)
                : null;

        LocalDate effectiveStart = requestedStart != null ? requestedStart : LocalDate.now().minusDays(30);
        LocalDate effectiveEnd = requestedEnd != null ? requestedEnd : LocalDate.now();

        // Generate report data
        Map<String, Object> reportData = new HashMap<>();

        // Financial data
        Map<String, Object> financialData = generateFinancialData(effectiveStart, effectiveEnd);
        reportData.put("financial", financialData);

        // Operational data
        Map<String, Object> operationalData = generateOperationalData(effectiveStart, effectiveEnd);
        reportData.put("operational", operationalData);

        // Summary stats
        Map<String, Object> summary = generateSummaryStats(requestedStart, requestedEnd);
        reportData.put("summary", summary);

        // Return JSON response
        JSONObject response = new JSONObject()
                .put("success", true)
                .put("message", "Report generated successfully")
                .put("data", reportData)
                .put("startDate", effectiveStart.toString())
                .put("endDate", effectiveEnd.toString());
        
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
        
        LocalDate requestedStart = (startDateParam != null && !startDateParam.isBlank())
                ? LocalDate.parse(startDateParam)
                : null;
        LocalDate requestedEnd = (endDateParam != null && !endDateParam.isBlank())
                ? LocalDate.parse(endDateParam)
                : null;

        // If no dates provided, use default range (last 6 months)
        LocalDate effectiveStart = requestedStart != null ? requestedStart : LocalDate.now().minusMonths(5).withDayOfMonth(1);
        LocalDate effectiveEnd = requestedEnd != null ? requestedEnd : LocalDate.now();

        Map<String, Object> stats = generateSummaryStats(effectiveStart, effectiveEnd);
        
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
        
        // Monthly revenue trend - use real data from database
        List<Map<String, Object>> monthlyRevenueRaw = appointmentDAO.getMonthlyRevenueByDateRange(start, end);
        List<Map<String, Object>> monthlyRevenue = new ArrayList<>();
        for (Map<String, Object> monthData : monthlyRevenueRaw) {
            Map<String, Object> converted = new HashMap<>();
            converted.put("month", monthData.get("month"));
            
            Object revenueObj = monthData.get("revenue");
            double revenue = 0.0;
            if (revenueObj instanceof java.math.BigDecimal) {
                revenue = ((java.math.BigDecimal) revenueObj).doubleValue();
            } else if (revenueObj instanceof Number) {
                revenue = ((Number) revenueObj).doubleValue();
            }
            converted.put("revenue", revenue);
            monthlyRevenue.add(converted);
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

        // Get total revenue from appointments with status COMPLETED
        BigDecimal revenueAmount = appointmentDAO.getTotalRevenueFromAppointments(start, end);
        double totalRevenue = revenueAmount != null ? revenueAmount.doubleValue() : 0.0;
        stats.put("totalRevenue", totalRevenue);
        stats.put("revenueGrowth", "+12.5%");

        long totalAppointments = reportMetricsService.countAppointments(start, end);
        long completedAppointments = reportMetricsService.countCompletedAppointments(start, end);
        stats.put("totalAppointments", totalAppointments);

        double completionRate = totalAppointments > 0
                ? (completedAppointments * 100.0) / totalAppointments
                : 0.0;
        stats.put("completionRate", Math.round(completionRate * 10.0) / 10.0);

        double avgTransaction = totalAppointments > 0
                ? totalRevenue / totalAppointments
                : 0.0;
        stats.put("avgTransaction", Math.round(avgTransaction * 100.0) / 100.0);
        stats.put("topService", "Dog Grooming");
        
        // Customer rating
        stats.put("customerRating", 4.7);
        stats.put("avgDuration", 67);
        
        return stats;
    }
    
    /**
     * Handle export request (PDF or Excel)
     * GET /admin/reports/export?format=pdf|excel&startDate=...&endDate=...
     */
    private void handleExport(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String format = req.getParameter("format");
        if (format == null || format.isBlank()) {
            format = "excel"; // Default to Excel
        }
        
        String startDateParam = req.getParameter("startDate");
        String endDateParam = req.getParameter("endDate");
        
        LocalDate startDate = (startDateParam != null && !startDateParam.isBlank())
                ? LocalDate.parse(startDateParam)
                : LocalDate.now().minusMonths(5).withDayOfMonth(1);
        LocalDate endDate = (endDateParam != null && !endDateParam.isBlank())
                ? LocalDate.parse(endDateParam)
                : LocalDate.now();
        
        // Get report data
        Map<String, Object> financialData = generateFinancialData(startDate, endDate);
        Map<String, Object> summary = generateSummaryStats(startDate, endDate);
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> monthlyRevenue = (List<Map<String, Object>>) financialData.get("monthlyRevenue");
        
        if ("pdf".equalsIgnoreCase(format)) {
            exportToPDF(resp, monthlyRevenue, summary, startDate, endDate);
        } else if ("excel".equalsIgnoreCase(format) || "xlsx".equalsIgnoreCase(format)) {
            exportToExcel(resp, monthlyRevenue, summary, startDate, endDate);
        } else {
            resp.setStatus(400);
            writeErrorResponse(resp, "Invalid format. Use 'pdf' or 'excel'");
        }
    }
    
    /**
     * Export monthly revenue trend to PDF
     */
    private void exportToPDF(HttpServletResponse resp, List<Map<String, Object>> monthlyRevenue,
                            Map<String, Object> summary, LocalDate startDate, LocalDate endDate)
            throws IOException {
        try {
            resp.setContentType("application/pdf");
            resp.setHeader("Content-Disposition", 
                "attachment; filename=\"Monthly_Revenue_Report_" + 
                startDate.toString() + "_to_" + endDate.toString() + ".pdf\"");
            
            com.lowagie.text.Document document = new com.lowagie.text.Document();
            OutputStream out = resp.getOutputStream();
            com.lowagie.text.pdf.PdfWriter.getInstance(document, out);
            
            document.open();
            
            // Title
            com.lowagie.text.Font titleFont = new com.lowagie.text.Font(
                com.lowagie.text.Font.HELVETICA, 18, com.lowagie.text.Font.BOLD);
            com.lowagie.text.Paragraph title = new com.lowagie.text.Paragraph(
                "Monthly Revenue Trend Report", titleFont);
            title.setSpacingAfter(10);
            document.add(title);
            
            // Date range
            com.lowagie.text.Font normalFont = new com.lowagie.text.Font(
                com.lowagie.text.Font.HELVETICA, 12);
            document.add(new com.lowagie.text.Paragraph(
                "Period: " + startDate.toString() + " to " + endDate.toString(), normalFont));
            document.add(new com.lowagie.text.Paragraph(" "));
            
            // Summary
            document.add(new com.lowagie.text.Paragraph("Summary:", normalFont));
            document.add(new com.lowagie.text.Paragraph(
                "Total Revenue: $" + String.format("%.2f", summary.get("totalRevenue")), normalFont));
            document.add(new com.lowagie.text.Paragraph(" "));
            
            // Table
            com.lowagie.text.pdf.PdfPTable table = new com.lowagie.text.pdf.PdfPTable(2);
            table.setWidthPercentage(100);
            table.setWidths(new float[]{1, 2});
            
            // Header
            com.lowagie.text.Font headerFont = new com.lowagie.text.Font(
                com.lowagie.text.Font.HELVETICA, 12, com.lowagie.text.Font.BOLD);
            table.addCell(new com.lowagie.text.pdf.PdfPCell(
                new com.lowagie.text.Phrase("Month", headerFont)));
            table.addCell(new com.lowagie.text.pdf.PdfPCell(
                new com.lowagie.text.Phrase("Revenue ($)", headerFont)));
            
            // Data rows
            for (Map<String, Object> month : monthlyRevenue) {
                table.addCell(new com.lowagie.text.pdf.PdfPCell(
                    new com.lowagie.text.Phrase(month.get("month").toString(), normalFont)));
                double revenue = ((Number) month.get("revenue")).doubleValue();
                table.addCell(new com.lowagie.text.pdf.PdfPCell(
                    new com.lowagie.text.Phrase(String.format("$%.2f", revenue), normalFont)));
            }
            
            document.add(table);
            document.close();
            out.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            writeErrorResponse(resp, "Error generating PDF: " + e.getMessage());
        }
    }
    
    /**
     * Export monthly revenue trend to Excel
     */
    private void exportToExcel(HttpServletResponse resp, List<Map<String, Object>> monthlyRevenue,
                               Map<String, Object> summary, LocalDate startDate, LocalDate endDate)
            throws IOException {
        try {
            resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            resp.setHeader("Content-Disposition", 
                "attachment; filename=\"Monthly_Revenue_Report_" + 
                startDate.toString() + "_to_" + endDate.toString() + ".xlsx\"");
            
            org.apache.poi.ss.usermodel.Workbook workbook = new org.apache.poi.xssf.usermodel.XSSFWorkbook();
            org.apache.poi.ss.usermodel.Sheet sheet = workbook.createSheet("Monthly Revenue");
            
            // Title row
            org.apache.poi.ss.usermodel.Row titleRow = sheet.createRow(0);
            org.apache.poi.ss.usermodel.Cell titleCell = titleRow.createCell(0);
            titleCell.setCellValue("Monthly Revenue Trend Report");
            org.apache.poi.ss.usermodel.CellStyle titleStyle = workbook.createCellStyle();
            org.apache.poi.ss.usermodel.Font titleFont = workbook.createFont();
            titleFont.setBold(true);
            titleFont.setFontHeightInPoints((short) 14);
            titleStyle.setFont(titleFont);
            titleCell.setCellStyle(titleStyle);
            
            // Date range
            org.apache.poi.ss.usermodel.Row dateRow = sheet.createRow(1);
            dateRow.createCell(0).setCellValue("Period: " + startDate.toString() + " to " + endDate.toString());
            
            // Summary
            org.apache.poi.ss.usermodel.Row summaryRow = sheet.createRow(3);
            summaryRow.createCell(0).setCellValue("Total Revenue:");
            summaryRow.createCell(1).setCellValue(((Number) summary.get("totalRevenue")).doubleValue());
            
            // Header row
            org.apache.poi.ss.usermodel.Row headerRow = sheet.createRow(5);
            org.apache.poi.ss.usermodel.CellStyle headerStyle = workbook.createCellStyle();
            org.apache.poi.ss.usermodel.Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(org.apache.poi.ss.usermodel.IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(org.apache.poi.ss.usermodel.FillPatternType.SOLID_FOREGROUND);
            
            headerRow.createCell(0).setCellValue("Month");
            headerRow.createCell(1).setCellValue("Revenue ($)");
            headerRow.getCell(0).setCellStyle(headerStyle);
            headerRow.getCell(1).setCellStyle(headerStyle);
            
            // Data rows
            int rowNum = 6;
            for (Map<String, Object> month : monthlyRevenue) {
                org.apache.poi.ss.usermodel.Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(month.get("month").toString());
                double revenue = ((Number) month.get("revenue")).doubleValue();
                row.createCell(1).setCellValue(revenue);
            }
            
            // Auto-size columns
            sheet.autoSizeColumn(0);
            sheet.autoSizeColumn(1);
            
            workbook.write(resp.getOutputStream());
            workbook.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            writeErrorResponse(resp, "Error generating Excel: " + e.getMessage());
        }
    }
    
    private void writeErrorResponse(HttpServletResponse resp, String message)
            throws IOException {
        JSONObject error = new JSONObject()
                .put("success", false)
                .put("error", message);
        resp.getWriter().write(error.toString());
    }
}
