package com.petcaresystem.controller.payment;

import com.petcaresystem.dao.*;
import com.petcaresystem.enities.*;
import com.petcaresystem.enities.enu.AppointmentStatus;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@WebServlet("/customer/payments/mark-paid")
public class CustomerPaymentMarkPaidServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");

        Account acc = (Account) req.getSession().getAttribute("account");
        if (acc == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"ok\":false,\"error\":\"UNAUTHORIZED\"}");
            return;
        }

        try {
            long appId = Long.parseLong(req.getParameter("appointmentId"));

            AppointmentDAO appDao = new AppointmentDAO();
            Appointment app = appDao.findById(appId);
            if (app == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"ok\":false,\"error\":\"APPOINTMENT_NOT_FOUND\"}");
                return;
            }

            // (Khuyến nghị) không cho thanh toán khi đã cancel/complete
            if (app.getStatus() == AppointmentStatus.CANCELLED || app.getStatus() == AppointmentStatus.COMPLETED) {
                resp.setStatus(HttpServletResponse.SC_CONFLICT);
                resp.getWriter().write("{\"ok\":false,\"error\":\"INVALID_STATE\"}");
                return;
            }

            // Lấy/tạo invoice nhưng KHÔNG cộng tiền
            InvoiceDAO invDao = new InvoiceDAO();
            Invoice invoice = invDao.findByAppointmentId(appId);
            if (invoice == null) {
                invoice = invDao.createForAppointment(
                        appId,
                        app.getTotalAmount(),
                        BigDecimal.ZERO,
                        BigDecimal.ZERO,
                        LocalDateTime.now().plusDays(7)
                );
            }

            // Amount: ưu tiên server; làm sạch nếu client gửi
            BigDecimal amount = app.getTotalAmount();
            String amountStr = req.getParameter("amount");
            if (amountStr != null && !amountStr.isBlank()) {
                String clean = amountStr.replaceAll("[^0-9.\\-]", "");
                if (!clean.isBlank()) amount = new BigDecimal(clean);
            }

            String method = req.getParameter("method");
            if (method == null || method.isBlank()) method = "MOCK_QR";

            // Tạo payment record (tùy bạn có PaymentStatus không; giữ logic cũ)
            PaymentDAO payDao = new PaymentDAO();
            payDao.create(
                    invoice.getInvoiceId(),
                    amount,
                    method,
                    "Paid(QR Mock)"
            );

            // 🔷 Cập nhật trạng thái lịch hẹn thành CONFIRMED
            appDao.updateStatus(appId, AppointmentStatus.CONFIRMED);

            // (Tuỳ chọn) cập nhật updatedAt nếu DAO chưa làm
            // app.setUpdatedAt(LocalDateTime.now());
            // appDao.merge(app);

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("{\"ok\":true,\"appointmentStatus\":\"CONFIRMED\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"ok\":false,\"error\":\"BAD_REQUEST\"}");
        }
    }
}
