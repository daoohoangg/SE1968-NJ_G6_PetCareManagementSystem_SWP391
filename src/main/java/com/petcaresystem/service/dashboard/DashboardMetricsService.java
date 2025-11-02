package com.petcaresystem.service.dashboard;

import com.petcaresystem.dao.AccountDAO;
import com.petcaresystem.dao.AppointmentDAO;
import com.petcaresystem.dao.PetDAO;
import com.petcaresystem.dao.PetServiceHistoryDAO;
import com.petcaresystem.dto.dashboard.RecentActivityView;
import com.petcaresystem.dto.dashboard.ScheduleItemView;
import com.petcaresystem.enities.Appointment;
import com.petcaresystem.enities.Customer;
import com.petcaresystem.enities.Pet;
import com.petcaresystem.enities.PetServiceHistory;
import com.petcaresystem.enities.Service;
import com.petcaresystem.enities.Staff;
import com.petcaresystem.enities.enu.AppointmentStatus;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Locale;

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
        List<PetServiceHistory> histories = petServiceHistoryDAO.getRecentHistories(effectiveLimit);
        if (histories == null || histories.isEmpty()) {
            return Collections.emptyList();
        }

        List<RecentActivityView> activities = new ArrayList<>(histories.size());
        for (PetServiceHistory history : histories) {
            activities.add(toRecentActivity(history));
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
}
