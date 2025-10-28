package com.petcaresystem.controller.customer;

import com.petcaresystem.dao.AppointmentDAO;
import com.petcaresystem.dao.PetDAO;
import com.petcaresystem.dao.ServiceDAO;
import com.petcaresystem.enities.Account;
import com.petcaresystem.enities.Pet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name = "CustomerAppointments", urlPatterns = {"/customer/appointments"})
public class Appointments extends HttpServlet {

    private static final String VIEW = "/customer/appointments.jsp";

    private AppointmentDAO appointmentDAO;
    private PetDAO petDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
        petDAO = new PetDAO();
        serviceDAO = new ServiceDAO();
    }

    /* ===================== Helpers ===================== */

    private Account currentUser(HttpServletRequest req) {
        HttpSession ss = req.getSession(false);
        Object o = (ss != null) ? ss.getAttribute("account") : null;
        return (o instanceof Account) ? (Account) o : null;
    }

    private Long currentCustomerId(HttpServletRequest req) {
        Account u = currentUser(req);
        return (u != null) ? u.getAccountId() : null; // customers.account_id == accounts.account_id
    }

    private void loadModel(HttpServletRequest req, Long customerId) {
        req.setAttribute("pets",         petDAO.findByCustomerId(customerId));
        req.setAttribute("services",     serviceDAO.getActiveServices());
        req.setAttribute("appointments", appointmentDAO.findByCustomer(customerId));
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

        Long customerId = currentCustomerId(req);
        if (customerId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "cancel": {
                String idStr = req.getParameter("id");
                if (idStr != null && !idStr.isBlank()) {
                    try {
                        long apptId = Long.parseLong(idStr);
                        appointmentDAO.cancelIfOwnedBy(apptId, customerId);
                    } catch (NumberFormatException ignored) { }
                }
                resp.sendRedirect(req.getContextPath() + "/customer/appointments?cancelled=1");
                return;
            }
            case "list":
            default: {
                loadModel(req, customerId);
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

        Long customerId = currentCustomerId(req);
        if (customerId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            /* --- 1) Xác thực thú cưng thuộc customer --- */
            Long petId = Long.parseLong(req.getParameter("petId"));
            boolean ownsPet = petDAO.findByCustomerId(customerId)
                    .stream()
                    .filter(Objects::nonNull)
                    .map(Pet::getIdpet)
                    .anyMatch(id -> id.equals(petId));
            if (!ownsPet) {
                req.setAttribute("error", "Thú cưng không thuộc tài khoản của bạn.");
                loadModel(req, customerId);
                forward(req, resp);
                return;
            }

            /* --- 2) Lấy danh sách dịch vụ --- */
            String[] serviceIdsParam = req.getParameterValues("serviceIds");
            List<Long> serviceIds = (serviceIdsParam == null)
                    ? Collections.emptyList()
                    : Arrays.stream(serviceIdsParam)
                    .filter(Objects::nonNull)
                    .map(Long::parseLong)
                    .collect(Collectors.toList());

            if (serviceIds.isEmpty()) {
                req.setAttribute("error", "Bạn phải chọn ít nhất một dịch vụ.");
                loadModel(req, customerId);
                forward(req, resp);
                return;
            }

            /* --- 3) Parse thời gian --- */
            DateTimeFormatter fmt = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
            String startAtStr = req.getParameter("startAt");
            LocalDateTime startAt = LocalDateTime.parse(startAtStr, fmt);

            // endAt = null, DAO sẽ tự tính hoặc lưu nguyên startAt
            LocalDateTime endAt = null;

            /* --- 4) Ghi chú --- */
            String notes = req.getParameter("notes");

            /* --- 5) Lưu xuống DB --- */
            boolean success = appointmentDAO.create(customerId, petId, serviceIds, startAt, endAt, notes);

            if (!success) {
                req.setAttribute("error", "Không thể tạo lịch hẹn. Vui lòng thử lại.");
                loadModel(req, customerId);
                forward(req, resp);
                return;
            }

            /* --- 6) Thành công: redirect về trang chính --- */
            resp.sendRedirect(req.getContextPath() + "/customer/appointments?created=1");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Dữ liệu không hợp lệ hoặc lỗi hệ thống: " + e.getMessage());
            loadModel(req, customerId);
            forward(req, resp);
        }
    }
}
