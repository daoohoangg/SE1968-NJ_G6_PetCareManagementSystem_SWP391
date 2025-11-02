package com.petcaresystem.service.report;

import com.petcaresystem.dao.AppointmentDAO;
import java.time.LocalDate;

public class ReportMetricsService {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    public long countCompletedAppointments(LocalDate startDate, LocalDate endDate) {
        return appointmentDAO.countCompletedAppointments(startDate, endDate);
    }

    public long countAppointments(LocalDate startDate, LocalDate endDate) {
        return appointmentDAO.countAppointments(startDate, endDate);
    }
}
