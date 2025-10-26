package com.petcaresystem.controller.admin;

import com.petcaresystem.dto.pageable.PagedResult;
import com.petcaresystem.enities.RuleSet;
import com.petcaresystem.enities.Voucher;
import com.petcaresystem.enities.embeddable.DaySchedule;
import com.petcaresystem.enities.embeddable.EmailRule;
import com.petcaresystem.enities.embeddable.WeeklySchedule;
import com.petcaresystem.dao.RuleSetDAO;
import com.petcaresystem.dao.WeekDaysDAO;
import com.petcaresystem.service.admin.IVoucherManageService;
import com.petcaresystem.service.admin.impl.VoucherManageServiceImpl;
import com.petcaresystem.service.email.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

@WebServlet("/admin/config")
public class ConfigSystemController extends HttpServlet {

    private static final int DEFAULT_VOUCHER_PAGE_SIZE = 5;
    private static final int MAX_VOUCHER_PAGE_SIZE = 20;

    private IVoucherManageService voucherService;
    private WeekDaysDAO weekDaysDAO;
    private RuleSetDAO ruleSetDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        voucherService = new VoucherManageServiceImpl();
        weekDaysDAO = new WeekDaysDAO();
        ruleSetDAO = new RuleSetDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String tab = sanitizeTab(req.getParameter("tab"));
        int voucherPage = parsePositiveInt(req.getParameter("voucherPage"), 1);
        int voucherSize = clampPageSize(parsePositiveInt(req.getParameter("voucherSize"), DEFAULT_VOUCHER_PAGE_SIZE));

        PagedResult<Voucher> voucherPaged = voucherService.getVoucherPage(voucherPage, voucherSize);

        // Load schedule data for schedule tab
        Map<String, Map<String, Object>> scheduleData = new HashMap<>();
        if ("schedule".equals(tab)) {
            scheduleData = weekDaysDAO.getClinicSchedule();
        }

        // Load email configuration for email tab
        EmailRule emailRule = null;
        if ("email".equals(tab)) {
            RuleSet clinicRuleSet = ruleSetDAO.getRuleSetByOwner("CLINIC", 1L);
            if (clinicRuleSet != null && clinicRuleSet.getEmailRule() != null) {
                emailRule = clinicRuleSet.getEmailRule();
            }
        }

        // Load EmailService settings
        String smtpHost = EmailService.getSmtpHost();
        int smtpPort = EmailService.getSmtpPort();
        String fromEmail = EmailService.getFromEmail();
        String appPassword = EmailService.getAppPassword();

        req.setAttribute("activeTab", tab);
        req.setAttribute("emailRule", emailRule);
        req.setAttribute("smtpHost", smtpHost);
        req.setAttribute("smtpPort", smtpPort);
        req.setAttribute("fromEmail", fromEmail);
        req.setAttribute("appPassword", appPassword);
        req.setAttribute("scheduleData", scheduleData);
        req.setAttribute("vouchers", voucherPaged.getItems());
        req.setAttribute("voucherCurrentPage", voucherPaged.getPage());
        req.setAttribute("voucherTotalPages", voucherPaged.getTotalPages());
        req.setAttribute("voucherTotalItems", voucherPaged.getTotalItems());
        req.setAttribute("voucherPageSize", voucherPaged.getPageSize());
        req.setAttribute("voucherPageStart", voucherPaged.getStartIndex());
        req.setAttribute("voucherPageEnd", voucherPaged.getEndIndex());
        req.setAttribute("voucherHasPrev", voucherPaged.hasPrevious());
        req.setAttribute("voucherHasNext", voucherPaged.hasNext());

        req.getRequestDispatcher("/adminpage/config-system.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/config");
            return;
        }

        switch (action) {
            case "update-schedule":
                handleUpdateSchedule(req, resp);
                break;
            case "update-email":
                handleUpdateEmailConfig(req, resp);
                break;
            case "update-smtp":
                handleUpdateSmtpConfig(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/config");
        }
    }

    private void handleUpdateSchedule(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Map<String, Map<String, Object>> scheduleMap = buildScheduleMap(req);
            
            boolean success = weekDaysDAO.updateClinicSchedule(scheduleMap);
            
            if (success) {
                req.getSession().setAttribute("success", "Business hours updated successfully");
            } else {
                req.getSession().setAttribute("error", "Failed to update business hours");
            }
            
        } catch (Exception e) {
            // Log the full exception for debugging
            System.err.println("Error updating business hours: " + e.getClass().getSimpleName() + " - " + e.getMessage());
            e.printStackTrace();
            
            String errorMessage = "Error updating business hours";
            if (e.getMessage() != null && e.getMessage().contains("closed")) {
                errorMessage += ": Database connection issue. Please try again.";
            } else {
                errorMessage += ": " + e.getMessage();
            }
            
            req.getSession().setAttribute("error", errorMessage);
        }
        
        resp.sendRedirect(req.getContextPath() + "/admin/config?tab=schedule");
    }

    private Map<String, Map<String, Object>> buildScheduleMap(HttpServletRequest req) {
        Map<String, Map<String, Object>> scheduleMap = new HashMap<>();
        
        for (DayOfWeek day : DayOfWeek.values()) {
            String dayName = day.name().toLowerCase();
            boolean isOpen = "on".equals(req.getParameter(dayName + "Open"));
            
            Map<String, Object> dayData = new HashMap<>();
            dayData.put("open", isOpen);
            
            if (isOpen) {
                LocalTime openTime = parseTime(req.getParameter(dayName + "OpenTime"));
                LocalTime closeTime = parseTime(req.getParameter(dayName + "CloseTime"));
                
                if (openTime != null && closeTime != null && closeTime.isAfter(openTime)) {
                    dayData.put("openTime", openTime);
                    dayData.put("closeTime", closeTime);
                } else {
                    // Default times if invalid
                    dayData.put("openTime", LocalTime.of(8, 0));
                    dayData.put("closeTime", LocalTime.of(18, 0));
                }
            } else {
                dayData.put("openTime", null);
                dayData.put("closeTime", null);
            }
            
            scheduleMap.put(day.name(), dayData);
        }
        
        return scheduleMap;
    }

    private LocalTime parseTime(String timeStr) {
        if (timeStr == null || timeStr.trim().isEmpty()) {
            return null;
        }
        try {
            return LocalTime.parse(timeStr.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private int parsePositiveInt(String raw, int defaultValue) {
        if (raw == null || raw.isBlank()) return defaultValue;
        try {
            int value = Integer.parseInt(raw.trim());
            return value > 0 ? value : defaultValue;
        } catch (NumberFormatException ex) {
            return defaultValue;
        }
    }

    private int clampPageSize(int size) {
        if (size < 1) size = DEFAULT_VOUCHER_PAGE_SIZE;
        if (size < 5) size = 5;
        if (size > MAX_VOUCHER_PAGE_SIZE) size = MAX_VOUCHER_PAGE_SIZE;
        return size;
    }

    private void handleUpdateEmailConfig(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            boolean appointmentConfirmation = "on".equals(req.getParameter("appointmentConfirmation"));
            boolean reminderNotify = "on".equals(req.getParameter("reminderNotify"));
            boolean promotionalEmail = "on".equals(req.getParameter("promotionalEmail"));
            String reminderHoursStr = req.getParameter("reminderHours");
            Integer reminderHours = null;
            if (reminderHoursStr != null && !reminderHoursStr.isBlank()) {
                try {
                    reminderHours = Integer.parseInt(reminderHoursStr);
                    if (reminderHours < 1 || reminderHours > 23) {
                        reminderHours = 24; // default
                    }
                } catch (NumberFormatException e) {
                    reminderHours = 24; // default
                }
            } else if (reminderNotify) {
                reminderHours = 24; // default if enabled but no value provided
            }

            // Get or create CLINIC RuleSet
            RuleSet clinicRuleSet = ruleSetDAO.getRuleSetByOwner("CLINIC", 1L);
            if (clinicRuleSet == null) {
                // Create new RuleSet for CLINIC
                EmailRule emailRule = EmailRule.builder()
                        .appointmentConfirmation(appointmentConfirmation)
                        .reminderNotify(reminderNotify)
                        .promotionalEmail(promotionalEmail)
                        .reminderHours(reminderHours)
                        .build();
                
                clinicRuleSet = RuleSet.builder()
                        .ownerType("CLINIC")
                        .ownerId(1L)
                        .emailRule(emailRule)
                        .active(true)
                        .build();
                
                boolean created = ruleSetDAO.createRuleSet(clinicRuleSet);
                if (created) {
                    req.getSession().setAttribute("success", "Email configuration created successfully");
                } else {
                    req.getSession().setAttribute("error", "Failed to create email configuration");
                }
            } else {
                // Update existing EmailRule
                EmailRule emailRule = clinicRuleSet.getEmailRule();
                if (emailRule == null) {
                    emailRule = EmailRule.builder()
                            .appointmentConfirmation(appointmentConfirmation)
                            .reminderNotify(reminderNotify)
                            .promotionalEmail(promotionalEmail)
                            .reminderHours(reminderHours)
                            .build();
                } else {
                    emailRule.setAppointmentConfirmation(appointmentConfirmation);
                    emailRule.setReminderNotify(reminderNotify);
                    emailRule.setPromotionalEmail(promotionalEmail);
                    emailRule.setReminderHours(reminderHours);
                }
                clinicRuleSet.setEmailRule(emailRule);
                
                boolean updated = ruleSetDAO.updateRuleSet(clinicRuleSet);
                if (updated) {
                    req.getSession().setAttribute("success", "Email configuration updated successfully");
                } else {
                    req.getSession().setAttribute("error", "Failed to update email configuration");
                }
            }
            
        } catch (Exception e) {
            System.err.println("Error updating email configuration: " + e.getMessage());
            e.printStackTrace();
            req.getSession().setAttribute("error", "Error updating email configuration: " + e.getMessage());
        }
        
        resp.sendRedirect(req.getContextPath() + "/admin/config?tab=email");
    }

    private void handleUpdateSmtpConfig(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String smtpHost = req.getParameter("smtpHost");
            String smtpPortStr = req.getParameter("smtpPort");
            String fromEmail = req.getParameter("fromEmail");
            String appPassword = req.getParameter("appPassword");

            if (smtpHost != null && !smtpHost.isBlank()) {
                EmailService.setSmtpHost(smtpHost);
            }
            
            if (smtpPortStr != null && !smtpPortStr.isBlank()) {
                try {
                    int port = Integer.parseInt(smtpPortStr);
                    EmailService.setSmtpPort(port);
                } catch (NumberFormatException e) {
                    req.getSession().setAttribute("error", "Invalid SMTP port");
                    resp.sendRedirect(req.getContextPath() + "/admin/config?tab=email");
                    return;
                }
            }
            
            if (fromEmail != null && !fromEmail.isBlank()) {
                EmailService.setFromEmail(fromEmail);
            }
            
            if (appPassword != null && !appPassword.isBlank()) {
                EmailService.setAppPassword(appPassword);
            }
            
            req.getSession().setAttribute("success", "SMTP configuration updated successfully");
            
        } catch (Exception e) {
            System.err.println("Error updating SMTP configuration: " + e.getMessage());
            e.printStackTrace();
            req.getSession().setAttribute("error", "Error updating SMTP configuration: " + e.getMessage());
        }
        
        resp.sendRedirect(req.getContextPath() + "/admin/config?tab=email");
    }

    private String sanitizeTab(String tab) {
        if (tab == null || tab.isBlank()) return "schedule";
        String normalized = tab.trim().toLowerCase();
        return switch (normalized) {
            case "schedule", "vouchers", "email", "rules" -> normalized;
            default -> "schedule";
        };
    }
}
