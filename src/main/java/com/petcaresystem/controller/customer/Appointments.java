package com.petcaresystem.controller.customer;

import com.petcaresystem.dao.AppointmentDAO;
import com.petcaresystem.dao.PetDAO;
import com.petcaresystem.dao.ServiceDAO;
import com.petcaresystem.dao.StaffDAO;
import com.petcaresystem.dao.WeekDaysDAO;
import com.petcaresystem.enities.Account;
import com.petcaresystem.enities.Pet;
import com.petcaresystem.enities.Staff;
import com.petcaresystem.service.admin.IScheduleManageService;
import com.petcaresystem.service.admin.impl.ScheduleManageServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name = "CustomerAppointments", urlPatterns = {"/customer/appointments"})
public class Appointments extends HttpServlet {

    private static final String VIEW = "/customer/appointments.jsp";
    private static final DateTimeFormatter ISO_LOCAL = DateTimeFormatter.ISO_LOCAL_DATE_TIME; // "yyyy-MM-dd'T'HH:mm"

    private AppointmentDAO appointmentDAO;
    private PetDAO petDAO;
    private ServiceDAO serviceDAO;
    private StaffDAO staffDAO;
    private IScheduleManageService scheduleManageService;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
        petDAO = new PetDAO();
        serviceDAO = new ServiceDAO();
        staffDAO = new StaffDAO();
        scheduleManageService = new ScheduleManageServiceImpl();
    }

    /* ===================== Helpers ===================== */

    private Account currentUser(HttpServletRequest req) {
        HttpSession ss = req.getSession(false);
        Object o = (ss != null) ? ss.getAttribute("account") : null;
        return (o instanceof Account) ? (Account) o : null;
    }

    /** Returns accounts.account_id (== customers.account_id) */
    private Long currentCustomerAccountId(HttpServletRequest req) {
        Account u = currentUser(req);
        return (u != null) ? u.getAccountId() : null;
    }

    /** Load data for JSP (pets/services/appointments) – DAOs should use openSession() */
    private void loadModel(HttpServletRequest req, Long customerAccountId) {
        req.setAttribute("pets",         petDAO.findByCustomerId(customerAccountId)); // Note: this method needs to filter by account_id
        req.setAttribute("services",     serviceDAO.getActiveServices());
        req.setAttribute("appointments", appointmentDAO.findByCustomer(customerAccountId));
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    /* ===================== GET ===================== */

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        Long customerAid = currentCustomerAccountId(req);
        if (customerAid == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = Optional.ofNullable(req.getParameter("action")).orElse("list");

        switch (action) {
            case "checkTime": {
                // API endpoint to check if time is valid
                checkTimeAvailability(req, resp);
                return;
            }
            case "cancel": {
                String idStr = req.getParameter("id");
                if (idStr != null && !idStr.isBlank()) {
                    try {
                        long apptId = Long.parseLong(idStr);
                        appointmentDAO.cancelIfOwnedBy(apptId, customerAid);
                    } catch (NumberFormatException ignored) {
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/customer/appointments?cancelled=1");
                return;
            }
            case "list":
            default: {
                loadModel(req, customerAid);
                forward(req, resp);
            }
        }
    }

    /* ===================== POST (Create Appointment) ===================== */

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        Long customerAid = currentCustomerAccountId(req);
        if (customerAid == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            /* --- 1) Get & verify pet belongs to customer --- */
            String petIdStr = req.getParameter("petId");
            if (petIdStr == null || petIdStr.isBlank()) {
                req.setAttribute("error", "Please select a pet.");
                loadModel(req, customerAid); forward(req, resp); return;
            }
            Long petId = Long.parseLong(petIdStr);

            boolean ownsPet = petDAO.findByCustomerId(customerAid)
                    .stream()
                    .filter(Objects::nonNull)
                    // NOTE: use the correct ID getter for your entity (getIdpet() or getPetId())
                    .map(Pet::getIdpet)
                    .anyMatch(id -> id != null && id.equals(petId));

            if (!ownsPet) {
                req.setAttribute("error", "Pet does not belong to your account.");
                loadModel(req, customerAid); forward(req, resp); return;
            }

            /* --- 2) Get list of serviceIds --- */
            String[] serviceIdsParam = req.getParameterValues("serviceIds");
            if (serviceIdsParam == null || serviceIdsParam.length == 0) {
                req.setAttribute("error", "You must select at least one service.");
                loadModel(req, customerAid); forward(req, resp); return;
            }
            List<Long> serviceIds = Arrays.stream(serviceIdsParam)
                    .filter(Objects::nonNull)
                    .map(String::trim)
                    .filter(s -> !s.isEmpty())
                    .map(Long::parseLong)
                    .collect(Collectors.toList());

            /* --- 3) Parse start time (input datetime-local: yyyy-MM-dd'T'HH:mm) --- */
            // Time selection must be provided and must be valid
            String startAtStr = req.getParameter("startAt");
            if (startAtStr == null || startAtStr.isBlank()) {
                req.setAttribute("error", "Please select appointment date & time.");
                loadModel(req, customerAid); forward(req, resp); return;
            }

            LocalDateTime startAt;
            try {
                startAt = LocalDateTime.parse(startAtStr.trim(), ISO_LOCAL);
            } catch (Exception e) {
                req.setAttribute("error", "Invalid date/time format. Please try again.");
                loadModel(req, customerAid); forward(req, resp); return;
            }

            LocalDateTime now = LocalDateTime.now();
            if (startAt.isBefore(now)) {
                req.setAttribute("error", "Cannot book appointment in the past. Please select a future time.");
                loadModel(req, customerAid); forward(req, resp); return;
            }

            String scheduleError = validateClinicSchedule(startAt);
            if (scheduleError != null) {
                req.setAttribute("error", scheduleError);
                loadModel(req, customerAid); forward(req, resp); return;
            }

            // If 'end' is not currently input, set to null; can be calculated based on total service duration later
            LocalDateTime endAt = null;

            /* --- 4) Notes --- */
            String notes = Optional.ofNullable(req.getParameter("notes")).orElse(null);

            /* --- 5) Get voucherId if available --- */
            Long voucherId = null;
            String voucherIdStr = req.getParameter("voucherId");
            if (voucherIdStr != null && !voucherIdStr.isBlank()) {
                try {
                    voucherId = Long.parseLong(voucherIdStr.trim());
                } catch (NumberFormatException ignored) {
                    // If voucherId is invalid, ignore
                }
            }

            /* --- 6) Save to DB: pass account_id (NOT customer_id PK) --- */
            boolean success = appointmentDAO.create(customerAid, petId, serviceIds, startAt, endAt, notes, voucherId);

            if (!success) {
                req.setAttribute("error", "Cannot create appointment. Please try again.");
                loadModel(req, customerAid); forward(req, resp); return;
            }

            /* --- 6) Success --- */
            resp.sendRedirect(req.getContextPath() + "/customer/appointments?created=1");

        } catch (IllegalArgumentException iae) {
            // Error from validation in DAO (customer/pet/service/time)
            req.setAttribute("error", iae.getMessage());
            loadModel(req, customerAid);
            forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            String msg = (e.getMessage() != null && !e.getMessage().isBlank())
                    ? e.getMessage()
                    : "Cannot process request. Please check your data and try again.";
            req.setAttribute("error", msg);
            loadModel(req, customerAid);
            forward(req, resp);
        }

    }

    /**
     * API endpoint to check if time is valid according to rule_week_day
     * Returns JSON: {"valid": true/false, "message": "..."}
     */
    private void checkTimeAvailability(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        PrintWriter out = resp.getWriter();
        
        try {
            String dateStr = req.getParameter("date");
            String timeStr = req.getParameter("time");
            
            if (dateStr == null || dateStr.isBlank() || timeStr == null || timeStr.isBlank()) {
                out.print("{\"valid\": false, \"message\": \"Please select both date and time.\"}");
                return;
            }
            
            // Parse date and time
            LocalDateTime selectedDateTime;
            try {
                String dateTimeStr = dateStr + "T" + timeStr;
                selectedDateTime = LocalDateTime.parse(dateTimeStr, ISO_LOCAL);
            } catch (Exception e) {
                out.print("{\"valid\": false, \"message\": \"Invalid date/time format.\"}");
                return;
            }
            
            // Check that time is not in the past
            LocalDateTime now = LocalDateTime.now();
            if (selectedDateTime.isBefore(now)) {
                out.print("{\"valid\": false, \"message\": \"Cannot book appointment in the past.\"}");
                return;
            }
            
            String scheduleError = validateClinicSchedule(selectedDateTime);
            if (scheduleError != null) {
                out.print("{\"valid\": false, \"message\": \"" + jsonEscape(scheduleError) + "\"}");
                return;
            }
            
            // Time is valid
            out.print("{\"valid\": true, \"message\": \"Time is valid! You can book the appointment.\"}");
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"valid\": false, \"message\": \"Error checking time: " + 
                     e.getMessage() + "\"}");
        }
    }
    
    private String validateClinicSchedule(LocalDateTime selectedDateTime) {
        DayOfWeek dayOfWeek = selectedDateTime.getDayOfWeek();
        LocalTime time = selectedDateTime.toLocalTime();
        
        boolean isOpen = scheduleManageService.isOpenOnDay("CLINIC", 1L, dayOfWeek);
        if (!isOpen) {
            return "Clinic is closed on " + getDayName(dayOfWeek) + ".";
        }
        
        boolean isAvailable = scheduleManageService.isAvailableAtTime("CLINIC", 1L, dayOfWeek, time);
        if (!isAvailable) {
            WeekDaysDAO weekDaysDAO = new WeekDaysDAO();
            Map<String, Map<String, Object>> schedule = weekDaysDAO.getClinicSchedule();
            Map<String, Object> daySchedule = schedule.get(dayOfWeek.name());
            
            if (daySchedule != null) {
                LocalTime openTime = (LocalTime) daySchedule.get("openTime");
                LocalTime closeTime = (LocalTime) daySchedule.get("closeTime");
                
                if (openTime != null && closeTime != null) {
                    return "Invalid time. Business hours: " + formatTime(openTime) + " - " + formatTime(closeTime) + ".";
                }
            }
            return "Invalid time.";
        }
        
        return null;
    }
    
    private String jsonEscape(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\").replace("\"", "\\\"");
    }
    
    private String getDayName(DayOfWeek dayOfWeek) {
        switch (dayOfWeek) {
            case MONDAY: return "Monday";
            case TUESDAY: return "Tuesday";
            case WEDNESDAY: return "Wednesday";
            case THURSDAY: return "Thursday";
            case FRIDAY: return "Friday";
            case SATURDAY: return "Saturday";
            case SUNDAY: return "Sunday";
            default: return dayOfWeek.name();
        }
    }
    
    private String formatTime(LocalTime time) {
        return String.format("%02d:%02d", time.getHour(), time.getMinute());
    }

}
