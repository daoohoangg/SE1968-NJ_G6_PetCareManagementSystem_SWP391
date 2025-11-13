package com.petcaresystem.service.dashboard;

import com.petcaresystem.dao.AccountDAO;
import com.petcaresystem.dao.AppointmentDAO;
import com.petcaresystem.dao.PetDAO;
import com.petcaresystem.dao.PetServiceHistoryDAO;
import com.petcaresystem.dto.dashboard.RecentActivityView;
import com.petcaresystem.dto.dashboard.ScheduleItemView;
import com.petcaresystem.enities.*;
import com.petcaresystem.enities.enu.AppointmentStatus;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.time.temporal.ChronoUnit;
import java.util.*;

public class DashboardMetricsService {

    private static final int DEFAULT_ACTIVITY_LIMIT = 5;
    private static final int DEFAULT_SCHEDULE_LIMIT = 5;
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("h:mm a");
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd MMM");

    private final AccountDAO accountDAO = new AccountDAO();
    private final PetDAO petDAO = new PetDAO();
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final PetServiceHistoryDAO petServiceHistoryDAO = new PetServiceHistoryDAO();

    public long countCustomers() {
        return accountDAO.countCustomers();
    }

    public long countHappyPets() {
        return petDAO.countAllPets();
    }

    public long countPendingAppointments() {
        return appointmentDAO.countPendingAppointments();
    }

    public long countPetsInCareToday() {
        return appointmentDAO.countPetsInCareOn(LocalDate.now());
    }

    /**
     * Get emergency contact admin account
     * Returns admin account for emergency contact display
     */
    public Account getEmergencyContactAdmin() {
        return accountDAO.getEmergencyContactAdmin();
    }

    /**
     * Get service distribution by category (percentage of total services)
     * Returns list of maps with category name, count, and percentage
     */
    public List<Map<String, Object>> getServiceDistributionByCategory() {
        com.petcaresystem.dao.ServiceDAO serviceDAO = new com.petcaresystem.dao.ServiceDAO();
        return serviceDAO.getServiceDistributionByCategory();
    }

    public double getTodayWeatherCelsius() {
        double baseTemperature = 27.0;
        double seasonalVariation = Math.sin(LocalDate.now().getDayOfYear() / 365.0 * 2 * Math.PI) * 4;
        double computed = baseTemperature + seasonalVariation;
        return Math.round(computed * 10.0) / 10.0;
    }

    public String getWeatherSummary() {
        return "Comfortable conditions for outdoor activities";
    }

    public List<RecentActivityView> getRecentActivities() {
        return getRecentActivities(DEFAULT_ACTIVITY_LIMIT);
    }

    public List<RecentActivityView> getRecentActivities(int limit) {
        int effectiveLimit = limit <= 0 ? DEFAULT_ACTIVITY_LIMIT : limit;
        // Lấy appointments gần nhất thay vì PetServiceHistory
        List<Appointment> appointments = appointmentDAO.findRecentAppointments(effectiveLimit);
        if (appointments == null || appointments.isEmpty()) {
            return Collections.emptyList();
        }

        List<RecentActivityView> activities = new ArrayList<>(appointments.size());
        for (Appointment appointment : appointments) {
            activities.add(toRecentActivityFromAppointment(appointment));
        }
        return activities;
    }

    public List<ScheduleItemView> getUpcomingSchedule() {
        return getUpcomingSchedule(DEFAULT_SCHEDULE_LIMIT);
    }

    public List<ScheduleItemView> getUpcomingSchedule(int limit) {
        int effectiveLimit = limit <= 0 ? DEFAULT_SCHEDULE_LIMIT : limit;
        List<Appointment> appointments = appointmentDAO.findUpcomingAppointments(effectiveLimit);
        if (appointments == null || appointments.isEmpty()) {
            return Collections.emptyList();
        }

        List<ScheduleItemView> items = new ArrayList<>(appointments.size());
        for (Appointment appointment : appointments) {
            items.add(toScheduleItem(appointment));
        }
        return items;
    }

    /**
     * Convert Appointment to RecentActivityView for Recent Activities section
     * Chuyển đổi Appointment thành RecentActivityView để hiển thị trong Recent Activities
     */
    private RecentActivityView toRecentActivityFromAppointment(Appointment appointment) {
        if (appointment == null) {
            return RecentActivityView.builder()
                    .icon("ri-calendar-event-line")
                    .primaryText("Appointment update")
                    .secondaryText(null)
                    .badgeClass("in-progress")
                    .badgeLabel("Pending")
                    .timeLabel("Date pending")
                    .urgent(false)
                    .build();
        }

        // Lấy thông tin service
        String serviceName = deriveServiceName(appointment.getServices());
        String title = !serviceName.isEmpty() ? serviceName : "Appointment";

        // Lấy thông tin pet và customer
        Pet pet = appointment.getPet();
        String petName = pet != null ? safeText(pet.getName()) : "";
        String petSpecies = pet != null ? safeText(pet.getSpecies()) : "";
        Customer customer = appointment.getCustomer();
        String ownerName = customer != null ? safeText(customer.getFullName()) : "";

        // Lấy thông tin staff
        Staff staff = appointment.getStaff();
        String staffName = staff != null ? safeText(staff.getFullName()) : "";

        // Tạo secondary text
        StringBuilder secondary = new StringBuilder();
        if (!ownerName.isEmpty()) {
            secondary.append(ownerName);
        }
        if (!petName.isEmpty()) {
            if (secondary.length() > 0) {
                secondary.append(" - ");
            }
            secondary.append(petName);
            if (!petSpecies.isEmpty()) {
                secondary.append(" (").append(petSpecies).append(")");
            }
        }
        if (!staffName.isEmpty()) {
            if (secondary.length() > 0) {
                secondary.append(" · Staff: ").append(staffName);
            } else {
                secondary.append("Staff: ").append(staffName);
            }
        }

        // Xác định badge và icon dựa trên status
        AppointmentStatus status = appointment.getStatus();
        String badgeClass = determineActivityBadgeClassFromStatus(status);
        String badgeLabel = determineActivityBadgeLabelFromStatus(status);
        String icon = resolveActivityIconFromAppointment(serviceName, status);

        // Format time
        LocalDateTime appointmentDate = appointment.getAppointmentDate();
        String timeLabel = humanizeDateTime(appointmentDate);

        return RecentActivityView.builder()
                .icon(icon)
                .primaryText(title)
                .secondaryText(secondary.length() > 0 ? secondary.toString() : null)
                .badgeClass(badgeClass)
                .badgeLabel(badgeLabel)
                .timeLabel(timeLabel)
                .urgent(status == AppointmentStatus.CANCELLED || status == AppointmentStatus.NO_SHOW)
                .build();
    }

    private RecentActivityView toRecentActivity(PetServiceHistory history) {
        if (history == null) {
            return RecentActivityView.builder()
                    .icon("ri-calendar-event-line")
                    .primaryText("Service update")
                    .secondaryText(null)
                    .badgeClass("in-progress")
                    .badgeLabel("Pending")
                    .timeLabel("Date pending")
                    .urgent(false)
                    .build();
        }

        String serviceType = safeText(history.getServiceType());
        String description = safeText(history.getDescription());
        String title = !description.isEmpty() ? description : (!serviceType.isEmpty() ? serviceType : "Service update");

        Pet pet = history.getPet();
        String petName = pet != null ? safeText(pet.getName()) : "";
        String petSpecies = pet != null ? safeText(pet.getSpecies()) : "";
        Customer customer = pet != null ? pet.getCustomer() : null;
        String ownerName = customer != null ? safeText(customer.getFullName()) : "";

        Staff staff = history.getStaff();
        String staffName = staff != null ? safeText(staff.getFullName()) : "";

        StringBuilder secondary = new StringBuilder();
        if (!ownerName.isEmpty()) {
            secondary.append(ownerName);
        }
        if (!petName.isEmpty()) {
            if (secondary.length() > 0) {
                secondary.append(" - ");
            }
            secondary.append(petName);
            if (!petSpecies.isEmpty()) {
                secondary.append(" (").append(petSpecies).append(")");
            }
        }
        if (!staffName.isEmpty()) {
            if (secondary.length() > 0) {
                secondary.append(" · Staff: ").append(staffName);
            } else {
                secondary.append("Staff: ").append(staffName);
            }
        }

        LocalDate serviceDate = history.getServiceDate();
        boolean urgent = isUrgent(serviceType, description, history.getNotes());
        String badgeClass = determineActivityBadgeClass(serviceDate, urgent);
        String badgeLabel = determineActivityBadgeLabel(serviceDate, urgent);

        return RecentActivityView.builder()
                .icon(resolveActivityIcon(serviceType, urgent))
                .primaryText(title)
                .secondaryText(secondary.length() > 0 ? secondary.toString() : null)
                .badgeClass(badgeClass)
                .badgeLabel(badgeLabel)
                .timeLabel(humanizeDate(serviceDate))
                .urgent(urgent)
                .build();
    }

    private ScheduleItemView toScheduleItem(Appointment appointment) {
        if (appointment == null) {
            return ScheduleItemView.builder()
                    .icon("ri-calendar-event-line")
                    .primaryText("Appointment")
                    .secondaryText(null)
                    .timeLabel("Time pending")
                    .badgeClass("upcoming")
                    .badgeLabel("Scheduled")
                    .build();
        }

        Pet pet = appointment.getPet();
        String petName = pet != null ? safeText(pet.getName()) : "";
        String serviceName = deriveServiceName(appointment.getServices());
        String title = !serviceName.isEmpty() ? serviceName : "Appointment";
        if (!petName.isEmpty()) {
            title = title + " \u2013 " + petName;
        }

        Customer customer = appointment.getCustomer();
        String ownerName = customer != null ? safeText(customer.getFullName()) : "";
        String secondary = ownerName.isEmpty() ? null : "Owner: " + ownerName;

        AppointmentStatus status = appointment.getStatus();
        String badgeClass = determineScheduleBadgeClass(status);
        String badgeLabel = determineScheduleBadgeLabel(status);
        LocalDateTime appointmentDate = appointment.getAppointmentDate();

        return ScheduleItemView.builder()
                .icon(resolveScheduleIcon(serviceName, status))
                .primaryText(title)
                .secondaryText(secondary)
                .timeLabel(formatScheduleTime(appointmentDate))
                .badgeClass(badgeClass)
                .badgeLabel(badgeLabel)
                .build();
    }

    private boolean isUrgent(String serviceType, String description, String notes) {
        if (containsKeyword(serviceType, "emergency", "urgent", "critical")) {
            return true;
        }
        return containsKeyword(description, "urgent", "emergency") || containsKeyword(notes, "urgent", "emergency");
    }

    private String determineActivityBadgeClass(LocalDate date, boolean urgent) {
        if (urgent) {
            return "urgent";
        }
        if (date == null) {
            return "in-progress";
        }
        LocalDate today = LocalDate.now();
        if (date.isAfter(today)) {
            return "upcoming";
        }
        if (date.isEqual(today)) {
            return "in-progress";
        }
        return "success";
    }

    private String determineActivityBadgeLabel(LocalDate date, boolean urgent) {
        if (urgent) {
            return "Urgent";
        }
        if (date == null) {
            return "Pending";
        }
        LocalDate today = LocalDate.now();
        if (date.isAfter(today)) {
            return "Upcoming";
        }
        if (date.isEqual(today)) {
            return "Today";
        }
        return "Completed";
    }

    private String determineScheduleBadgeClass(AppointmentStatus status) {
        if (status == null) {
            return "upcoming";
        }
        switch (status) {
            case IN_PROGRESS:
            case CHECKED_IN:
                return "in-progress";
            case CONFIRMED:
            case SCHEDULED:
                return "upcoming";
            case COMPLETED:
                return "success";
            case CANCELLED:
            case NO_SHOW:
                return "urgent";
            default:
                return "upcoming";
        }
    }

    private String determineScheduleBadgeLabel(AppointmentStatus status) {
        if (status == null) {
            return "Scheduled";
        }
        switch (status) {
            case IN_PROGRESS:
                return "In Progress";
            case CHECKED_IN:
                return "Checked-in";
            case CONFIRMED:
                return "Confirmed";
            case SCHEDULED:
                return "Scheduled";
            case COMPLETED:
                return "Completed";
            case CANCELLED:
                return "Cancelled";
            case NO_SHOW:
                return "No Show";
            default:
                return "Scheduled";
        }
    }

    /**
     * Determine badge class for appointment status in Recent Activities
     */
    private String determineActivityBadgeClassFromStatus(AppointmentStatus status) {
        if (status == null) {
            return "in-progress";
        }
        switch (status) {
            case IN_PROGRESS:
            case CHECKED_IN:
                return "in-progress";
            case CONFIRMED:
            case SCHEDULED:
                return "upcoming";
            case COMPLETED:
                return "success";
            case CANCELLED:
            case NO_SHOW:
                return "urgent";
            default:
                return "in-progress";
        }
    }

    /**
     * Determine badge label for appointment status in Recent Activities
     */
    private String determineActivityBadgeLabelFromStatus(AppointmentStatus status) {
        if (status == null) {
            return "Pending";
        }
        switch (status) {
            case IN_PROGRESS:
                return "In Progress";
            case CHECKED_IN:
                return "Checked-in";
            case CONFIRMED:
                return "Confirmed";
            case SCHEDULED:
                return "Scheduled";
            case COMPLETED:
                return "Completed";
            case CANCELLED:
                return "Cancelled";
            case NO_SHOW:
                return "No Show";
            default:
                return "Pending";
        }
    }

    /**
     * Humanize date time for Recent Activities display
     */
    private String humanizeDateTime(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "Date pending";
        }
        LocalDateTime now = LocalDateTime.now();
        LocalDate today = LocalDate.now();
        LocalDate date = dateTime.toLocalDate();
        
        if (date.isEqual(today)) {
            return "Today · " + dateTime.format(TIME_FORMATTER);
        }
        if (date.isEqual(today.plusDays(1))) {
            return "Tomorrow · " + dateTime.format(TIME_FORMATTER);
        }
        if (date.isAfter(today) && date.isBefore(today.plusDays(7))) {
            return date.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.ENGLISH) +
                    " · " + dateTime.format(TIME_FORMATTER);
        }
        
        long days = ChronoUnit.DAYS.between(date, today);
        if (days > 0) {
            return days == 1 ? "1 day ago" : days + " days ago";
        }
        
        long ahead = Math.abs(days);
        if (ahead == 1) {
            return "In 1 day";
        }
        return "In " + ahead + " days";
    }

    /**
     * Resolve icon for appointment in Recent Activities
     */
    private String resolveActivityIconFromAppointment(String serviceName, AppointmentStatus status) {
        if (status == AppointmentStatus.CANCELLED || status == AppointmentStatus.NO_SHOW) {
            return "ri-close-circle-line";
        }
        if (status == AppointmentStatus.COMPLETED) {
            return "ri-check-double-line";
        }
        if (status == AppointmentStatus.IN_PROGRESS || status == AppointmentStatus.CHECKED_IN) {
            return "ri-time-line";
        }
        return resolveScheduleIcon(serviceName, status);
    }

    private String humanizeDate(LocalDate date) {
        if (date == null) {
            return "Date pending";
        }
        LocalDate today = LocalDate.now();
        long days = ChronoUnit.DAYS.between(date, today);
        if (days == 0) {
            return "Today";
        }
        if (days > 0) {
            return days == 1 ? "1 day ago" : days + " days ago";
        }

        long ahead = Math.abs(days);
        if (ahead == 1) {
            return "In 1 day";
        }
        return "In " + ahead + " days";
    }

    private String formatScheduleTime(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "Time pending";
        }
        LocalDate today = LocalDate.now();
        LocalDate date = dateTime.toLocalDate();
        if (date.isEqual(today)) {
            return "Today · " + dateTime.format(TIME_FORMATTER);
        }
        if (date.isEqual(today.plusDays(1))) {
            return "Tomorrow · " + dateTime.format(TIME_FORMATTER);
        }
        if (date.isAfter(today) && date.isBefore(today.plusDays(7))) {
            return date.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.ENGLISH) +
                    " · " + dateTime.format(TIME_FORMATTER);
        }
        return dateTime.format(DATE_FORMATTER) + " · " + dateTime.format(TIME_FORMATTER);
    }

    private String resolveActivityIcon(String serviceType, boolean urgent) {
        if (urgent) {
            return "ri-alert-fill";
        }
        String normalized = safeText(serviceType).toLowerCase(Locale.ENGLISH);
        if (normalized.contains("groom")) {
            return "ri-scissors-cut-line";
        }
        if (normalized.contains("vet") || normalized.contains("clinic") || normalized.contains("medical")) {
            return "ri-stethoscope-line";
        }
        if (normalized.contains("train")) {
            return "ri-run-line";
        }
        if (normalized.contains("board")) {
            return "ri-home-8-line";
        }
        if (normalized.contains("daycare") || normalized.contains("day care")) {
            return "ri-sun-line";
        }
        if (normalized.contains("vaccin")) {
            return "ri-shield-cross-line";
        }
        return "ri-heart-pulse-line";
    }

    private String resolveScheduleIcon(String serviceName, AppointmentStatus status) {
        String normalized = safeText(serviceName).toLowerCase(Locale.ENGLISH);
        if (normalized.contains("groom")) {
            return "ri-scissors-2-line";
        }
        if (normalized.contains("vet") || normalized.contains("clinic") || normalized.contains("checkup") || normalized.contains("medical")) {
            return "ri-stethoscope-line";
        }
        if (normalized.contains("train")) {
            return "ri-run-line";
        }
        if (normalized.contains("board")) {
            return "ri-home-8-line";
        }
        if (normalized.contains("day")) {
            return "ri-sun-line";
        }
        if (normalized.contains("vacc")) {
            return "ri-shield-cross-line";
        }
        if (status == AppointmentStatus.IN_PROGRESS || status == AppointmentStatus.CHECKED_IN) {
            return "ri-time-line";
        }
        if (status == AppointmentStatus.COMPLETED) {
            return "ri-check-double-line";
        }
        if (status == AppointmentStatus.CANCELLED || status == AppointmentStatus.NO_SHOW) {
            return "ri-close-circle-line";
        }
        return "ri-calendar-event-line";
    }

    private String deriveServiceName(List<Service> services) {
        if (services == null) {
            return "";
        }
        for (Service service : services) {
            if (service == null) {
                continue;
            }
            String name = safeText(service.getServiceName());
            if (!name.isEmpty()) {
                return name;
            }
            String description = safeText(service.getDescription());
            if (!description.isEmpty()) {
                return description;
            }
        }
        return "";
    }

    private boolean containsKeyword(String value, String... keywords) {
        String normalized = safeText(value).toLowerCase(Locale.ENGLISH);
        if (normalized.isEmpty()) {
            return false;
        }
        for (String keyword : keywords) {
            if (keyword != null && normalized.contains(keyword.toLowerCase(Locale.ENGLISH))) {
                return true;
            }
        }
        return false;
    }

    private String safeText(String value) {
        return value == null ? "" : value.trim();
    }

    /**
     * Get revenue trends for the last 6 months from completed appointments
     * Lấy doanh thu từ cột total_amount trong bảng appointments
     * Chỉ tính các appointments có status = 'COMPLETED' và total_amount IS NOT NULL
     * 
     * Returns a list of maps with "month" (String) and "revenue" (Double)
     */
    public List<Map<String, Object>> getRevenueTrendsLast6Months() {
        try {
            // Lấy dữ liệu từ AppointmentDAO - query từ bảng appointments.total_amount
            List<Map<String, Object>> monthlyRevenue = appointmentDAO.getMonthlyRevenueLast6Months();
            
            // Debug: Log dữ liệu nhận được
            System.out.println("=== DashboardMetricsService.getRevenueTrendsLast6Months ===");
            System.out.println("Raw data size: " + monthlyRevenue.size());
            
            // Convert BigDecimal to Double for easier use in JSP
            List<Map<String, Object>> result = new ArrayList<>();
            for (Map<String, Object> monthData : monthlyRevenue) {
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
                
                System.out.println("Converted - Month: " + converted.get("month") + ", Revenue: " + revenue);
                result.add(converted);
            }
            
            System.out.println("Final result size: " + result.size());
            return result;
        } catch (Exception e) {
            System.err.println("ERROR in getRevenueTrendsLast6Months: " + e.getMessage());
            e.printStackTrace();
            // Return empty list with 6 months structure để chart vẫn hiển thị
            return createEmptyRevenueTrends();
        }
    }
    
    /**
     * Tạo dữ liệu rỗng cho 6 tháng gần nhất (để chart vẫn hiển thị)
     */
    private List<Map<String, Object>> createEmptyRevenueTrends() {
        List<Map<String, Object>> empty = new ArrayList<>();
        LocalDate now = LocalDate.now();
        java.time.format.DateTimeFormatter monthFormatter = java.time.format.DateTimeFormatter.ofPattern("MMM", java.util.Locale.ENGLISH);
        
        for (int i = 5; i >= 0; i--) {
            LocalDate month = now.minusMonths(i);
            Map<String, Object> monthData = new HashMap<>();
            monthData.put("month", month.format(monthFormatter));
            monthData.put("revenue", 0.0);
            empty.add(monthData);
        }
        return empty;
    }

    /**
     * Get staff performance statistics
     * Returns a list of maps with staff info, completed appointment count, and total revenue
     */
    public List<Map<String, Object>> getStaffPerformanceStats() {
        List<Map<String, Object>> staffStats = appointmentDAO.getStaffPerformanceStats();
        
        // Convert BigDecimal to Double for easier use in JSP
        List<Map<String, Object>> result = new ArrayList<>();
        for (Map<String, Object> staffData : staffStats) {
            Map<String, Object> converted = new HashMap<>();
            converted.put("staffId", staffData.get("staffId"));
            converted.put("fullName", staffData.get("fullName"));
            converted.put("specialization", staffData.get("specialization"));
            converted.put("completedCount", staffData.get("completedCount"));
            
            Object revenueObj = staffData.get("totalRevenue");
            double totalRevenue = 0.0;
            if (revenueObj instanceof java.math.BigDecimal) {
                totalRevenue = ((java.math.BigDecimal) revenueObj).doubleValue();
            } else if (revenueObj instanceof Number) {
                totalRevenue = ((Number) revenueObj).doubleValue();
            }
            converted.put("totalRevenue", totalRevenue);
            
            result.add(converted);
        }
        
        return result;
    }
}
