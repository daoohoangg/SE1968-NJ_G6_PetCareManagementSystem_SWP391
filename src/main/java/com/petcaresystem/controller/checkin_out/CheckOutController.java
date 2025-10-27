package com.petcaresystem.controller.checkin_out;

import com.petcaresystem.dao.AppointmentDAO;
import com.petcaresystem.enities.Appointment;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "CheckOutController", urlPatterns = {"/reception/checkout"})
public class CheckOutController extends HttpServlet {

    private AppointmentDAO appointmentDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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

        // Lấy danh sách appointments đã check-in với filter và paging
        List<Appointment> appointments = appointmentDAO.findCheckedInWithFilter(
                customerName, petName, page, pageSize);

        // Đếm tổng số records
        long totalRecords = appointmentDAO.countCheckedIn(customerName, petName);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // Format ngày giờ
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        for (Appointment a : appointments) {
            a.setFormattedDate(a.getAppointmentDate().format(formatter));
            if (a.getUpdatedAt() != null) {
                a.setFormattedUpdatedAt(a.getUpdatedAt().format(formatter));
            }
        }

        // Set attributes
        request.setAttribute("appointments", appointments);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("customerName", customerName != null ? customerName : "");
        request.setAttribute("petName", petName != null ? petName : "");

        RequestDispatcher dispatcher = request.getRequestDispatcher("/checkin_out/checkout.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Long appointmentId = Long.parseLong(request.getParameter("appointmentId"));
            boolean success = appointmentDAO.checkOut(appointmentId);

            if (success) {
                request.getSession().setAttribute("success", "Check-out completed successfully! Invoice has been generated.");
            } else {
                request.getSession().setAttribute("error", "Cannot check-out this appointment. It may not be checked-in yet.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to check-out: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/reception/checkout");
    }
}
