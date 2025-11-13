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
            // Load initial data for reports page - lấy từ appointments có status COMPLETED
            // Monthly Revenue Trend thống kê trong 1 tháng (tháng hiện tại)
            // Trục x: các ngày trong tháng (1, 2, 3, ..., 31)
            // Trục y: doanh thu (total_amount từ appointments COMPLETED)
            LocalDate now = LocalDate.now();
            LocalDate defaultStart = now.withDayOfMonth(1); // Đầu tháng hiện tại
            LocalDate defaultEnd = now; // Ngày hiện tại
            
            // Load daily revenue for current month - Monthly Revenue Trend
            List<Map<String, Object>> dailyRevenueRaw = appointmentDAO.getDailyRevenueByMonth(now.getYear(), now.getMonthValue());
            
            // Convert để frontend dễ sử dụng
            List<Map<String, Object>> initialDailyRevenue = new ArrayList<>();
            for (Map<String, Object> dayData : dailyRevenueRaw) {
                Map<String, Object> converted = new HashMap<>();
                converted.put("day", dayData.get("day"));
                
                Object revenueObj = dayData.get("revenue");
                double revenue = 0.0;
                if (revenueObj instanceof java.math.BigDecimal) {
                    revenue = ((java.math.BigDecimal) revenueObj).doubleValue();
                } else if (revenueObj instanceof Number) {
                    revenue = ((Number) revenueObj).doubleValue();
                }
                converted.put("revenue", revenue);
                initialDailyRevenue.add(converted);
            }
            
            System.out.println("=== ReportController - Loading daily revenue data ===");
            System.out.println("Month: " + now.getYear() + "-" + now.getMonthValue());
            System.out.println("Daily revenue data size: " + initialDailyRevenue.size());
            
            req.setAttribute("initialDailyRevenue", initialDailyRevenue);
            req.setAttribute("defaultStartDate", defaultStart.toString());
            req.setAttribute("defaultEndDate", defaultEnd.toString());
            
            // Load total revenue from completed appointments - tổng các total_amount của TẤT CẢ appointments có status COMPLETED
            // Không filter theo date range để hiển thị tổng tất cả
            BigDecimal totalRevenueAmount = appointmentDAO.getTotalRevenueFromAppointments(null, null);
            double totalRevenue = totalRevenueAmount != null ? totalRevenueAmount.doubleValue() : 0.0;
            req.setAttribute("totalRevenue", totalRevenue);
            
            // Load total appointments - tổng TẤT CẢ appointments ở mọi status (không filter theo thời gian)
            long totalAppointments = reportMetricsService.countAppointments(null, null);
            req.setAttribute("totalAppointments", totalAppointments);
            
            // Load completed appointments để tính completion rate và avg transaction
            // Completed appointments cũng lấy tất cả để tính completion rate chính xác
            long completedAppointments = reportMetricsService.countCompletedAppointments(null, null);
            double completionRate = totalAppointments > 0 
                    ? (completedAppointments * 100.0) / totalAppointments 
                    : 0.0;
            req.setAttribute("completionRate", Math.round(completionRate * 10.0) / 10.0);
            
            // Tính avg transaction = tổng tiền / số appointments đã hoàn thành (status COMPLETED)
            // Total revenue đã là tổng tất cả, completedAppointments cũng là tổng tất cả
            double avgTransaction = completedAppointments > 0 
                    ? totalRevenue / completedAppointments 
                    : 0.0;
            req.setAttribute("avgTransaction", Math.round(avgTransaction * 100.0) / 100.0);
            
            // Load revenue by service category - Detailed Financial Report
            // Thống kê doanh thu theo từng service category trong TOÀN BỘ thời gian (không filter theo date range)
            List<Map<String, Object>> serviceRevenueRaw = appointmentDAO.getRevenueByServiceCategory(null, null);
            
            // Tính tổng revenue để tính percentage
            double totalRevenueForPercentage = serviceRevenueRaw.stream()
                    .mapToDouble(s -> {
                        Object rev = s.get("revenue");
                        if (rev instanceof BigDecimal) {
                            return ((BigDecimal) rev).doubleValue();
                        } else if (rev instanceof Number) {
                            return ((Number) rev).doubleValue();
                        }
                        return 0.0;
                    })
                    .sum();
            
            // Convert và tính percentage
            List<Map<String, Object>> serviceRevenue = new ArrayList<>();
            for (Map<String, Object> raw : serviceRevenueRaw) {
                Map<String, Object> serviceData = new HashMap<>();
                serviceData.put("name", raw.get("name"));
                serviceData.put("bookings", raw.get("bookings"));
                
                Object revenueObj = raw.get("revenue");
                double revenue = 0.0;
                if (revenueObj instanceof BigDecimal) {
                    revenue = ((BigDecimal) revenueObj).doubleValue();
                } else if (revenueObj instanceof Number) {
                    revenue = ((Number) revenueObj).doubleValue();
                }
                serviceData.put("revenue", revenue);
                serviceData.put("avgPrice", raw.get("avgPrice"));
                
                // Tính percentage
                double percentage = totalRevenueForPercentage > 0 
                        ? (revenue / totalRevenueForPercentage) * 100 
                        : 0.0;
                serviceData.put("percentage", Math.round(percentage));
                
                serviceRevenue.add(serviceData);
            }
            
            System.out.println("=== ReportController - Service Revenue Data ===");
            System.out.println("Raw data size: " + serviceRevenueRaw.size());
            System.out.println("Processed data size: " + serviceRevenue.size());
            if (!serviceRevenue.isEmpty()) {
                System.out.println("First service: " + serviceRevenue.get(0));
            } else {
                System.out.println("WARNING: serviceRevenue is EMPTY!");
            }
            
            req.setAttribute("serviceRevenue", serviceRevenue);
            
            // Load service volume by month - số service được booking theo các tháng (12 tháng)
            List<Map<String, Object>> serviceVolumeRaw = appointmentDAO.getServiceVolumeByMonth(12);
            List<Map<String, Object>> initialServiceVolume = new ArrayList<>();
            for (Map<String, Object> monthData : serviceVolumeRaw) {
                Map<String, Object> converted = new HashMap<>();
                converted.put("month", monthData.get("month"));
                
                Object completedObj = monthData.get("completed");
                long completed = 0;
                if (completedObj instanceof Number) {
                    completed = ((Number) completedObj).longValue();
                }
                converted.put("completed", completed);
                initialServiceVolume.add(converted);
            }
            req.setAttribute("initialServiceVolume", initialServiceVolume);
            
            // Load staff performance statistics - thống kê năng suất và tổng doanh thu từ appointments
            List<Map<String, Object>> staffPerformance = dashboardMetricsService.getStaffPerformanceStats();
            req.setAttribute("staffPerformance", staffPerformance);
            
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
     * Lấy dữ liệu từ bảng appointments có status = 'COMPLETED'
     */
    private Map<String, Object> generateFinancialData(LocalDate start, LocalDate end) {
        Map<String, Object> financial = new HashMap<>();
        
        // Monthly revenue trend - lấy từ appointments.total_amount WHERE status = 'COMPLETED'
        // Data source: appointments table, total_amount column, only COMPLETED appointments
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
        
        // Revenue by service category - thống kê doanh thu theo từng service category trong TOÀN BỘ thời gian
        // Không filter theo date range để hiển thị tổng tất cả
        List<Map<String, Object>> serviceRevenueRaw = appointmentDAO.getRevenueByServiceCategory(null, null);
        
        // Tính tổng revenue để tính percentage
        double totalRevenueForPercentage = serviceRevenueRaw.stream()
                .mapToDouble(s -> {
                    Object rev = s.get("revenue");
                    if (rev instanceof BigDecimal) {
                        return ((BigDecimal) rev).doubleValue();
                    } else if (rev instanceof Number) {
                        return ((Number) rev).doubleValue();
                    }
                    return 0.0;
                })
                .sum();
        
        // Convert và tính percentage, growth (tạm thời để 0% vì cần so sánh với kỳ trước)
        List<Map<String, Object>> serviceRevenue = new ArrayList<>();
        for (Map<String, Object> raw : serviceRevenueRaw) {
            Map<String, Object> serviceData = new HashMap<>();
            serviceData.put("name", raw.get("name"));
            serviceData.put("bookings", raw.get("bookings"));
            
            Object revenueObj = raw.get("revenue");
            double revenue = 0.0;
            if (revenueObj instanceof BigDecimal) {
                revenue = ((BigDecimal) revenueObj).doubleValue();
            } else if (revenueObj instanceof Number) {
                revenue = ((Number) revenueObj).doubleValue();
            }
            serviceData.put("revenue", revenue);
            serviceData.put("avgPrice", raw.get("avgPrice"));
            
            // Tính percentage
            double percentage = totalRevenueForPercentage > 0 
                    ? (revenue / totalRevenueForPercentage) * 100 
                    : 0.0;
            serviceData.put("percentage", Math.round(percentage));
            
            // Growth tạm thời để 0% (cần so sánh với kỳ trước để tính)
            serviceData.put("growth", "0%");
            
            serviceRevenue.add(serviceData);
        }
        
        financial.put("serviceRevenue", serviceRevenue);
        
        return financial;
    }
    
    /**
     * Generate operational report data
     */
    private Map<String, Object> generateOperationalData(LocalDate start, LocalDate end) {
        Map<String, Object> operational = new HashMap<>();
        
        // Service volume trends - số service được booking theo các tháng (12 tháng)
        // Lấy từ database: đếm số service từ appointment_services của appointments COMPLETED
        List<Map<String, Object>> serviceVolumeRaw = appointmentDAO.getServiceVolumeByMonth(12);
        
        // Convert để frontend dễ sử dụng
        List<Map<String, Object>> serviceVolume = new ArrayList<>();
        for (Map<String, Object> monthData : serviceVolumeRaw) {
            Map<String, Object> converted = new HashMap<>();
            converted.put("month", monthData.get("month"));
            
            Object completedObj = monthData.get("completed");
            long completed = 0;
            if (completedObj instanceof Number) {
                completed = ((Number) completedObj).longValue();
            }
            converted.put("completed", completed);
            serviceVolume.add(converted);
        }
        
        operational.put("serviceVolume", serviceVolume);
        
        // Customer acquisition
        List<Map<String, Object>> customerAcquisition = new ArrayList<>();
        LocalDate current = start.withDayOfMonth(1);
        int index = 0;
        
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
        // Total Revenue = tổng các total_amount của TẤT CẢ appointments có status COMPLETED (không filter theo date range)
        BigDecimal revenueAmount = appointmentDAO.getTotalRevenueFromAppointments(null, null);
        double totalRevenue = revenueAmount != null ? revenueAmount.doubleValue() : 0.0;
        stats.put("totalRevenue", totalRevenue);
        stats.put("revenueGrowth", "+12.5%");

        // Total Appointments = tổng TẤT CẢ appointments ở mọi status (không filter theo thời gian)
        long totalAppointments = reportMetricsService.countAppointments(null, null);
        // Completed Appointments cũng lấy tất cả để tính completion rate chính xác
        long completedAppointments = reportMetricsService.countCompletedAppointments(null, null);
        stats.put("totalAppointments", totalAppointments);

        double completionRate = totalAppointments > 0
                ? (completedAppointments * 100.0) / totalAppointments
                : 0.0;
        stats.put("completionRate", Math.round(completionRate * 10.0) / 10.0);

        // Avg Transaction = tổng tiền / số appointments đã hoàn thành (status COMPLETED)
        double avgTransaction = completedAppointments > 0
                ? totalRevenue / completedAppointments
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
