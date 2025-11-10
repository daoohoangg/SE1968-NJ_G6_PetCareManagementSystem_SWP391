package com.petcaresystem.controller.checkin_out;

import com.petcaresystem.dao.AppointmentDAO;
import com.petcaresystem.enities.Appointment;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "CheckInController", urlPatterns = {"/reception/checkin"})
public class CheckInController extends HttpServlet {

    private AppointmentDAO appointmentDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            deleteAppointment(request, response);
            return;
        } else if ("view".equals(action)) {
            viewAppointment(request, response);
            return;
        }

        // Lấy ngày hiện tại
        LocalDate today = LocalDate.now();
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.atTime(LocalTime.MAX);

        // Lấy filter parameters
        String customerName = request.getParameter("customerName");
        String petName = request.getParameter("petName");

        // Lấy page parameters
        int page = 1;
        int pageSize = 10;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        // Lấy danh sách appointments có thể check-in với filter và paging
        List<Appointment> appointments = appointmentDAO.findCheckInEligibleWithFilter(
                startOfDay, endOfDay, customerName, petName, page, pageSize);

        // Đếm tổng số records
        long totalRecords = appointmentDAO.countCheckInEligible(startOfDay, endOfDay, customerName, petName);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // Format ngày giờ
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        for (Appointment a : appointments) {
            a.setFormattedDate(a.getAppointmentDate().format(formatter));
        }

        // Set attributes
        request.setAttribute("appointments", appointments);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("customerName", customerName != null ? customerName : "");
        request.setAttribute("petName", petName != null ? petName : "");

        request.getRequestDispatcher("/checkin_out/checkin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String action = request.getParameter("action");
        
        if ("update".equals(action)) {
            updateAppointment(request, response);
            return;
        }
        
        // Default action: check-in
        try {
            Long appointmentId = Long.parseLong(request.getParameter("appointmentId"));
            boolean success = appointmentDAO.checkIn(appointmentId);

            if (success) {
                request.getSession().setAttribute("success", "Check-in completed successfully!");
            } else {
                request.getSession().setAttribute("error", "Cannot check-in this appointment. It may already be checked-in or not eligible.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to check-in: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/reception/checkin");
    }

    private void viewAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long appointmentId = Long.parseLong(request.getParameter("id"));
            Appointment appointment = appointmentDAO.findById(appointmentId);
            
            if (appointment == null) {
                request.getSession().setAttribute("error", "Appointment not found.");
                response.sendRedirect(request.getContextPath() + "/reception/checkin");
                return;
            }
            
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            appointment.setFormattedDate(appointment.getAppointmentDate().format(formatter));
            
            request.setAttribute("appointment", appointment);
            request.getRequestDispatcher("/checkin_out/appointment-detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to view appointment: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/reception/checkin");
        }
    }

    private void updateAppointment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Long appointmentId = Long.parseLong(request.getParameter("appointmentId"));
            String notes = request.getParameter("notes");
            String appointmentDateStr = request.getParameter("appointmentDate");
            
            Appointment appointment = appointmentDAO.findById(appointmentId);
            if (appointment == null) {
                request.getSession().setAttribute("error", "Appointment not found.");
                response.sendRedirect(request.getContextPath() + "/reception/checkin");
                return;
            }
            
            // Update fields
            if (notes != null) {
                appointment.setNotes(notes);
            }
            
            if (appointmentDateStr != null && !appointmentDateStr.isEmpty()) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                LocalDateTime newDate = LocalDateTime.parse(appointmentDateStr, formatter);
                appointment.setAppointmentDate(newDate);
            }
            
            boolean success = appointmentDAO.updateAppointment(appointment);
            
            if (success) {
                request.getSession().setAttribute("success", "Appointment updated successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to update appointment.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to update appointment: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/reception/checkin");
    }

    private void deleteAppointment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Long appointmentId = Long.parseLong(request.getParameter("id"));
            boolean success = appointmentDAO.deleteAppointment(appointmentId);
            
            if (success) {
                request.getSession().setAttribute("success", "Appointment deleted successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to delete appointment.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to delete appointment: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/reception/checkin");
    }
}
