package com.petcaresystem.controller.customer;

import com.petcaresystem.dao.AppointmentDAO;
import com.petcaresystem.dao.PetDAO;
import com.petcaresystem.dao.ServiceDAO;
import com.petcaresystem.dao.StaffDAO;
import com.petcaresystem.enities.Account;
import com.petcaresystem.enities.Pet;
import com.petcaresystem.enities.Staff;

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
    private static final DateTimeFormatter ISO_LOCAL = DateTimeFormatter.ISO_LOCAL_DATE_TIME; // "yyyy-MM-dd'T'HH:mm"

    private AppointmentDAO appointmentDAO;
    private PetDAO petDAO;
    private ServiceDAO serviceDAO;
    private StaffDAO staffDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
        petDAO = new PetDAO();
        serviceDAO = new ServiceDAO();
        staffDAO = new StaffDAO();
    }

    /* ===================== Helpers ===================== */

    private Account currentUser(HttpServletRequest req) {
        HttpSession ss = req.getSession(false);
        Object o = (ss != null) ? ss.getAttribute("account") : null;
        return (o instanceof Account) ? (Account) o : null;
    }

    /** Trả về accounts.account_id (== customers.account_id) */
    private Long currentCustomerAccountId(HttpServletRequest req) {
        Account u = currentUser(req);
        return (u != null) ? u.getAccountId() : null;
    }

    /** Nạp dữ liệu cho JSP (pets/services/appointments) – các DAO nên dùng openSession() */
    private void loadModel(HttpServletRequest req, Long customerAccountId) {
        req.setAttribute("pets",         petDAO.findByCustomerId(customerAccountId)); // chú ý: hàm này cần lọc theo account_id
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
            case "checkAvailability": {
                checkAvailability(req, resp);
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
            /* --- 1) Lấy & kiểm tra pet thuộc về customer --- */
            String petIdStr = req.getParameter("petId");
            if (petIdStr == null || petIdStr.isBlank()) {
                req.setAttribute("error", "Vui lòng chọn thú cưng.");
                loadModel(req, customerAid); forward(req, resp); return;
            }
            Long petId = Long.parseLong(petIdStr);

            boolean ownsPet = petDAO.findByCustomerId(customerAid)
                    .stream()
                    .filter(Objects::nonNull)
                    // NOTE: dùng getter ID đúng với entity của bạn (getIdpet() hoặc getPetId())
                    .map(Pet::getIdpet)
                    .anyMatch(id -> id != null && id.equals(petId));

            if (!ownsPet) {
                req.setAttribute("error", "Thú cưng không thuộc tài khoản của bạn.");
                loadModel(req, customerAid); forward(req, resp); return;
            }

            /* --- 2) Lấy danh sách serviceIds --- */
            String[] serviceIdsParam = req.getParameterValues("serviceIds");
            if (serviceIdsParam == null || serviceIdsParam.length == 0) {
                req.setAttribute("error", "Bạn phải chọn ít nhất một dịch vụ.");
                loadModel(req, customerAid); forward(req, resp); return;
            }
            List<Long> serviceIds = Arrays.stream(serviceIdsParam)
                    .filter(Objects::nonNull)
                    .map(String::trim)
                    .filter(s -> !s.isEmpty())
                    .map(Long::parseLong)
                    .collect(Collectors.toList());

            /* --- 3) Parse thời gian bắt đầu (input datetime-local: yyyy-MM-dd'T'HH:mm) --- */
            String startAtStr = req.getParameter("startAt");
            if (startAtStr == null || startAtStr.isBlank()) {
                req.setAttribute("error", "Vui lòng chọn thời gian bắt đầu.");
                loadModel(req, customerAid); forward(req, resp); return;
            }
            LocalDateTime startAt = LocalDateTime.parse(startAtStr.trim(), ISO_LOCAL);

            // Nếu hiện tại bạn chưa cho nhập 'end', để null; có thể tính theo tổng duration service sau
            LocalDateTime endAt = null;

            /* --- 4) Ghi chú --- */
            String notes = Optional.ofNullable(req.getParameter("notes")).orElse(null);

            /* --- 5) Lấy voucherId nếu có --- */
            Long voucherId = null;
            String voucherIdStr = req.getParameter("voucherId");
            if (voucherIdStr != null && !voucherIdStr.isBlank()) {
                try {
                    voucherId = Long.parseLong(voucherIdStr.trim());
                } catch (NumberFormatException ignored) {
                    // Nếu voucherId không hợp lệ, bỏ qua
                }
            }

            /* --- 6) Lưu DB: truyền vào account_id (NOT customer_id PK) --- */
            boolean success = appointmentDAO.create(customerAid, petId, serviceIds, startAt, endAt, notes, voucherId);

            if (!success) {
                req.setAttribute("error", "Không thể tạo lịch hẹn. Vui lòng thử lại.");
                loadModel(req, customerAid); forward(req, resp); return;
            }

            /* --- 6) Thành công --- */
            resp.sendRedirect(req.getContextPath() + "/customer/appointments?created=1");

        } catch (IllegalArgumentException iae) {
            // Lỗi do validate trong DAO (customer/pet/service/time)
            req.setAttribute("error", iae.getMessage());
            loadModel(req, customerAid);
            forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            String msg = (e.getMessage() != null && !e.getMessage().isBlank())
                    ? e.getMessage()
                    : "Không thể xử lý yêu cầu. Vui lòng kiểm tra lại dữ liệu và thử lại.";
            req.setAttribute("error", msg);
            loadModel(req, customerAid);
            forward(req, resp);
        }

    }

    /* ===================== Check Availability ===================== */
    
    private void checkAvailability(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            String startTimeStr = req.getParameter("startTime");
            String endTimeStr = req.getParameter("endTime");
            
            if (startTimeStr == null || endTimeStr == null) {
                resp.setContentType("application/json");
                resp.getWriter().write("{\"available\": false, \"message\": \"Invalid time parameters\"}");
                return;
            }
            
            LocalDateTime startTime = LocalDateTime.parse(startTimeStr, ISO_LOCAL);
            LocalDateTime endTime = endTimeStr.isEmpty() ? startTime.plusHours(2) : LocalDateTime.parse(endTimeStr, ISO_LOCAL);
            
            // Check if there are available staff at this time
            List<Staff> availableStaff = staffDAO.getAvailableStaffAtTime(startTime, endTime);
            
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            
            if (availableStaff.isEmpty()) {
                resp.getWriter().write("{\"available\": false, \"message\": \"No staff available at this time. Please choose another time.\"}");
            } else {
                resp.getWriter().write("{\"available\": true, \"count\": " + availableStaff.size() + 
                        ", \"message\": \"" + availableStaff.size() + " staff member(s) available for your booking.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setContentType("application/json");
            resp.getWriter().write("{\"available\": false, \"message\": \"Error checking availability\"}");
        }
    }
}
