package com.petcaresystem.service.dashboard;

import com.petcaresystem.dao.AccountDAO;
import com.petcaresystem.dao.AppointmentDAO;
import com.petcaresystem.dao.PetDAO;

import java.time.LocalDate;

public class DashboardMetricsService {

    private final AccountDAO accountDAO = new AccountDAO();
    private final PetDAO petDAO = new PetDAO();
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

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
}
