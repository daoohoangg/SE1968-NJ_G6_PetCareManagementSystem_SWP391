package com.petcaresystem.controller.payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = "/payment/mock_return")
public class VnPayMockReturnController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String status = req.getParameter("status"); // "00" = success
        String txnRef = req.getParameter("txnRef");
        String amount = req.getParameter("amount");

        boolean ok = "00".equals(status);
        req.setAttribute("paySuccess", ok);
        req.setAttribute("message", ok ? "Thanh toán (giả lập) thành công" : "Thanh toán (giả lập) thất bại");
        req.setAttribute("txnRef", txnRef);
        req.setAttribute("amount", amount);

        req.getRequestDispatcher("/payment/result.jsp").forward(req, resp);
    }
}
