package com.petcaresystem.controller.customer;

import com.petcaresystem.dao.AppointmentDAO;
import com.petcaresystem.enities.Account;
import com.petcaresystem.enities.Appointment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = "/customer/payments/mock")
public class VnPayMockController extends HttpServlet {
    private AppointmentDAO appointmentDAO;

    @Override public void init() { appointmentDAO = new AppointmentDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Account acc = (Account) req.getSession().getAttribute("account");
        if (acc == null) { resp.sendRedirect(req.getContextPath()+"/login"); return; }

        Long apptId = parseLong(req.getParameter("appointmentId"));
        if (apptId == null) { resp.sendError(400, "appointmentId required"); return; }

        Appointment appt = appointmentDAO.findById(apptId);
        if (appt == null || !appt.getCustomer().getAccountId().equals(acc.getAccountId())) {
            resp.sendError(403, "Not allowed"); return;
        }

        long amount = appt.getTotalAmount() == null ? 0L : appt.getTotalAmount().longValue();
        String txnRef = "MOCK-" + appt.getAppointmentId() + "-" + System.currentTimeMillis();

        // “Link thanh toán” giả – thực chất là link trả về của bạn
        String successUrl = req.getContextPath() + "/payment/mock_return?status=00"
                + "&txnRef=" + txnRef + "&amount=" + amount + "&appointmentId=" + apptId;
        String failUrl = req.getContextPath() + "/payment/mock_return?status=24"
                + "&txnRef=" + txnRef + "&amount=" + amount + "&appointmentId=" + apptId;

        req.setAttribute("appointment", appt);
        req.setAttribute("txnRef", txnRef);
        req.setAttribute("amount", amount);
        req.setAttribute("successUrl", successUrl);
        req.setAttribute("failUrl", failUrl);

        req.getRequestDispatcher("/payment/mock.jsp").forward(req, resp);
    }

    private Long parseLong(String s){ try { return (s==null||s.isBlank())?null:Long.valueOf(s); } catch(Exception e){ return null; } }
}
