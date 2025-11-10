package com.petcaresystem.controller.staff;

import com.petcaresystem.dao.AppointmentDAO;
import com.petcaresystem.dao.StaffDAO;
import com.petcaresystem.enities.Appointment;
import com.petcaresystem.enities.Staff;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "JobAssignmentController", urlPatterns = {"/staff/jobassignment"})
public class JobAssignmentController extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private StaffDAO staffDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
        staffDAO = new StaffDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("checkAvailability".equals(action)) {
            checkAvailability(request, response);
            return;
        } else if ("getAvailableStaff".equals(action)) {
            getAvailableStaff(request, response);
            return;
        }
        
        // Default: show job assignment page
        showJobAssignmentPage(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String action = request.getParameter("action");
        
        if ("assignStaff".equals(action)) {
            assignStaff(request, response);
        } else if ("autoAssign".equals(action)) {
            autoAssignStaff(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/jobassignment");
        }
    }

    // Show job assignment page with unassigned appointments
    private void showJobAssignmentPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get all appointments that need staff assignment
            List<Appointment> appointments = appointmentDAO.findCheckInEligible(
                    LocalDateTime.now().minusDays(1),
                    LocalDateTime.now().plusDays(7)
            );
            
            // Get all available staff
            List<Staff> availableStaff = staffDAO.getAvailableStaff();
            
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            for (Appointment a : appointments) {
                a.setFormattedDate(a.getAppointmentDate().format(formatter));
            }
            
            request.setAttribute("appointments", appointments);
            request.setAttribute("availableStaff", availableStaff);
            request.getRequestDispatcher("/staff/job-assignment.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to load job assignment page: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/");
        }
    }

    // Check staff/service availability before confirming booking
    private void checkAvailability(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            String specializationStr = request.getParameter("specialization");
            
            if (startTimeStr == null || endTimeStr == null) {
                response.setContentType("application/json");
                response.getWriter().write("{\"available\": false, \"message\": \"Invalid time parameters\"}");
                return;
            }
            
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime startTime = LocalDateTime.parse(startTimeStr, formatter);
            LocalDateTime endTime = LocalDateTime.parse(endTimeStr, formatter);
            
            List<Staff> availableStaff;
            if (specializationStr != null && !specializationStr.isEmpty()) {
                availableStaff = staffDAO.getAvailableStaffBySpecializationAndTime(
                        specializationStr, startTime, endTime);
            } else {
                availableStaff = staffDAO.getAvailableStaffAtTime(startTime, endTime);
            }
            
            response.setContentType("application/json");
            if (availableStaff.isEmpty()) {
                response.getWriter().write("{\"available\": false, \"message\": \"No staff available at this time\"}");
            } else {
                response.getWriter().write("{\"available\": true, \"count\": " + availableStaff.size() + 
                        ", \"message\": \"" + availableStaff.size() + " staff member(s) available\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write("{\"available\": false, \"message\": \"Error checking availability\"}");
        }
    }

    // Get list of available staff for specific time
    private void getAvailableStaff(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            
            if (startTimeStr == null || endTimeStr == null) {
                response.setContentType("application/json");
                response.getWriter().write("[]");
                return;
            }
            
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime startTime = LocalDateTime.parse(startTimeStr, formatter);
            LocalDateTime endTime = LocalDateTime.parse(endTimeStr, formatter);
            
            List<Staff> availableStaff = staffDAO.getAvailableStaffAtTime(startTime, endTime);
            
            // Build JSON response
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < availableStaff.size(); i++) {
                Staff s = availableStaff.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"id\":").append(s.getAccountId()).append(",");
                json.append("\"name\":\"").append(s.getFullName()).append("\",");
                json.append("\"specialization\":\"").append(s.getSpecialization() != null ? s.getSpecialization() : "").append("\"");
                json.append("}");
            }
            json.append("]");
            
            response.setContentType("application/json");
            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write("[]");
        }
    }

    // Assign specific staff to appointment
    private void assignStaff(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Long appointmentId = Long.parseLong(request.getParameter("appointmentId"));
            Long staffId = Long.parseLong(request.getParameter("staffId"));
            
            boolean success = appointmentDAO.assignStaffToAppointment(appointmentId, staffId);
            
            if (success) {
                request.getSession().setAttribute("success", "Staff assigned successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to assign staff. Staff may not be available at this time.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to assign staff: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/staff/jobassignment");
    }

    // Auto-assign best available staff
    private void autoAssignStaff(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Long appointmentId = Long.parseLong(request.getParameter("appointmentId"));
            
            boolean success = appointmentDAO.autoAssignStaff(appointmentId);
            
            if (success) {
                request.getSession().setAttribute("success", "Staff auto-assigned successfully!");
            } else {
                request.getSession().setAttribute("error", "No available staff found for this appointment.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to auto-assign staff: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/staff/jobassignment");
    }
}
