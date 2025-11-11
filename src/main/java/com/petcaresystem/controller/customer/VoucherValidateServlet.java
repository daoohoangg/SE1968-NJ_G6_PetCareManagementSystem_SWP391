package com.petcaresystem.controller.customer;

import com.petcaresystem.dao.VoucherDAO;
import com.petcaresystem.enities.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@WebServlet(name = "VoucherValidateServlet", urlPatterns = {"/customer/vouchers/validate"})
public class VoucherValidateServlet extends HttpServlet {

    private VoucherDAO voucherDAO;

    @Override
    public void init() {
        voucherDAO = new VoucherDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            String code = req.getParameter("code");
            String subtotalStr = req.getParameter("subtotal");

            if (code == null || code.trim().isEmpty()) {
                sendError(resp, "Voucher code is required");
                return;
            }

            BigDecimal subtotal = null;
            if (subtotalStr != null && !subtotalStr.trim().isEmpty()) {
                try {
                    subtotal = new BigDecimal(subtotalStr.trim());
                } catch (NumberFormatException e) {
                    sendError(resp, "Invalid subtotal value");
                    return;
                }
            }

            // Tìm voucher theo code
            Voucher voucher = voucherDAO.findByCode(code.trim());

            if (voucher == null) {
                sendError(resp, "Voucher code not found");
                return;
            }

            // Kiểm tra voucher có active không
            if (!voucher.isActive()) {
                sendError(resp, "This voucher is no longer active");
                return;
            }

            // Kiểm tra expiry date
            if (voucher.getExpiryDate() != null && LocalDateTime.now().isAfter(voucher.getExpiryDate())) {
                sendError(resp, "This voucher has expired");
                return;
            }

            // Kiểm tra max uses
            if (voucher.getMaxUses() != null && voucher.getTimesUsed() != null
                    && voucher.getTimesUsed() >= voucher.getMaxUses()) {
                sendError(resp, "This voucher has reached its maximum usage limit");
                return;
            }

            // Tính toán discount để kiểm tra
            BigDecimal discount = calculateDiscount(subtotal != null ? subtotal : BigDecimal.ZERO, voucher);

            // Trả về thông tin voucher
            JSONObject response = new JSONObject();
            response.put("success", true);
            response.put("message", "Voucher is valid");

            JSONObject voucherJson = new JSONObject();
            voucherJson.put("voucherId", voucher.getVoucherId());
            voucherJson.put("code", voucher.getCode());
            voucherJson.put("discountType", voucher.getDiscountType());
            voucherJson.put("discountValue", voucher.getDiscountValue().toString());
            voucherJson.put("discount", discount.toString());

            response.put("voucher", voucherJson);
            resp.getWriter().write(response.toString());

        } catch (Exception e) {
            e.printStackTrace();
            sendError(resp, "Error validating voucher: " + e.getMessage());
        }
    }

    private BigDecimal calculateDiscount(BigDecimal subtotal, Voucher voucher) {
        if (voucher == null || !voucher.isActive()) {
            return BigDecimal.ZERO;
        }

        // Kiểm tra expiry date
        if (voucher.getExpiryDate() != null && LocalDateTime.now().isAfter(voucher.getExpiryDate())) {
            return BigDecimal.ZERO;
        }

        // Kiểm tra max uses
        if (voucher.getMaxUses() != null && voucher.getTimesUsed() != null
                && voucher.getTimesUsed() >= voucher.getMaxUses()) {
            return BigDecimal.ZERO;
        }

        String discountType = voucher.getDiscountType();
        BigDecimal discountValue = voucher.getDiscountValue();

        if ("PERCENTAGE".equalsIgnoreCase(discountType)) {
            // Discount theo phần trăm
            BigDecimal discount = subtotal.multiply(discountValue)
                    .divide(BigDecimal.valueOf(100), 2, java.math.RoundingMode.HALF_UP);
            // Đảm bảo discount không vượt quá subtotal
            return discount.compareTo(subtotal) > 0 ? subtotal : discount;
        } else if ("FIXED".equalsIgnoreCase(discountType)) {
            // Discount cố định
            return discountValue.compareTo(subtotal) > 0 ? subtotal : discountValue;
        }

        return BigDecimal.ZERO;
    }

    private void sendError(HttpServletResponse resp, String message) throws IOException {
        JSONObject response = new JSONObject();
        response.put("success", false);
        response.put("message", message);
        resp.getWriter().write(response.toString());
    }
}

