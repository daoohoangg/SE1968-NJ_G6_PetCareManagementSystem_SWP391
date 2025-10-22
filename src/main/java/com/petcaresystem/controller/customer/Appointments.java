package com.petcaresystem.controller.customer;

import com.petcaresystem.dao.AppointmentDAO;
import com.petcaresystem.dao.PetDAO;
import com.petcaresystem.dao.ServiceDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "CustomerAppointments", urlPatterns = {"/customer/appointments"})
public class Appointments extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private PetDAO petDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
        petDAO = new PetDAO();
        serviceDAO = new ServiceDAO();
    }

    /* ---------- Helpers ---------- */


    private Long getCustomerId(HttpServletRequest req) {
        HttpSession ss = req.getSession(false);
        return (ss != null) ? (Long) ss.getAttribute("customerId") : null;
    }

    private void requireLoginOrRedirect(Long customerId, HttpServletResponse resp, HttpServletRequest req) throws IOException {
        if (customerId == null) {
            // có thể set flash message tại đây
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }

    /* ---------- GET ---------- */

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        Long customerId = getCustomerId(req);
        if (customerId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        switch (action) {
            case "new":
                showCreateForm(req, resp, customerId);
                break;

            case "cancel":
                cancelAppointment(req, resp, customerId);
                break;

            case "list":
            default:
                listAppointments(req, resp, customerId);
        }
    }

    private void listAppointments(HttpServletRequest req, HttpServletResponse resp, Long customerId)
            throws ServletException, IOException {

        var appts = appointmentDAO.findByCustomer(customerId);
        req.setAttribute("appointments", appts);

        req.setAttribute("pets", petDAO.getPet());
        req.setAttribute("services", serviceDAO.getActiveServices());

        req.getRequestDispatcher("/WEB-INF/views/customer/appointments.jsp").forward(req, resp);
    }



    private void showCreateForm(HttpServletRequest req, HttpServletResponse resp, Long customerId)
            throws ServletException, IOException {


        req.setAttribute("pets", petDAO.getPet());


        req.setAttribute("services", serviceDAO.getAllServices());


        req.getRequestDispatcher("/WEB-INF/views/customer/appointment_new.jsp").forward(req, resp);
    }

    private void cancelAppointment(HttpServletRequest req, HttpServletResponse resp, Long customerId)
            throws IOException {

        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                Long appointmentId = Long.parseLong(idStr);
                appointmentDAO.cancelIfOwnedBy(appointmentId, customerId);
            } catch (NumberFormatException ignored) {

            }
        }
        resp.sendRedirect(req.getContextPath() + "/customer/appointments?cancelled=1");
    }

    /* ---------- POST ---------- */

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Long customerId = getCustomerId(req);
        if (customerId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Lấy dữ liệu từ form
        try {
            Long petId = Long.parseLong(req.getParameter("petId"));

            String[] serviceIdsParam = req.getParameterValues("serviceIds");
            List<Long> serviceIds = (serviceIdsParam == null) ? List.of()
                    : Arrays.stream(serviceIdsParam).map(Long::parseLong).collect(Collectors.toList());

            String startAt = req.getParameter("startAt");  // input type="datetime-local"
            String endAt   = req.getParameter("endAt");    // optional
            String notes   = req.getParameter("notes");

            DateTimeFormatter f = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
            LocalDateTime start = LocalDateTime.parse(startAt, f);
            LocalDateTime end   = (endAt == null || endAt.isEmpty()) ? null : LocalDateTime.parse(endAt, f);

            boolean ok = appointmentDAO.create(customerId, petId, serviceIds, start, end, notes);
            if (!ok) {
                req.setAttribute("error", "Không tạo được lịch hẹn. Vui lòng thử lại.");
                showCreateForm(req, resp, customerId);
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/customer/appointments?created=1");

        } catch (Exception e) {

            req.setAttribute("error", "Dữ liệu không hợp lệ: " + e.getMessage());
            showCreateForm(req, resp, customerId);
        }
    }
}
