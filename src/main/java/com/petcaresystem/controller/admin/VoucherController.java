package com.petcaresystem.controller.admin;

import com.petcaresystem.dto.OperationResult;
import com.petcaresystem.enities.Voucher;
import com.petcaresystem.service.admin.IVoucherManageService;
import com.petcaresystem.service.admin.impl.VoucherManageServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@WebServlet({"/admin/vouchers", "/admin/voucher"})
public class VoucherController extends HttpServlet {

    private IVoucherManageService voucherService;

    @Override
    public void init() throws ServletException {
        super.init();
        voucherService = new VoucherManageServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/admin/config" + buildRedirectSuffix(req));
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = trim(req.getParameter("action"));
        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/config" + buildRedirectSuffix(req));
            return;
        }

        OperationResult result;
        switch (action) {
            case "create":
                result = handleCreate(req);
                break;
            case "update-status":
                result = handleStatusUpdate(req);
                break;
            case "delete":
                result = handleDelete(req);
                break;
            default:
                result = new OperationResult(false, "Unsupported action");
        }

        storeFlashMessage(req.getSession(), result);
        resp.sendRedirect(req.getContextPath() + "/admin/config" + buildRedirectSuffix(req));
    }

    private OperationResult handleCreate(HttpServletRequest req) {
        String code = trim(req.getParameter("code"));
        String discountType = trim(req.getParameter("discountType"));
        BigDecimal discountValue = parseBigDecimal(trim(req.getParameter("discountValue")));
        LocalDateTime expiry = parseExpiryDate(trim(req.getParameter("expiryDate")));
        Integer maxUses = parseInteger(trim(req.getParameter("maxUses")));

        Voucher voucher = new Voucher();
        voucher.setCode(code);
        voucher.setDiscountType(discountType);
        voucher.setDiscountValue(discountValue);
        voucher.setExpiryDate(expiry);
        voucher.setMaxUses(maxUses);
        return voucherService.createVoucher(voucher);
    }

    private OperationResult handleStatusUpdate(HttpServletRequest req) {
        Long voucherId = parseLong(trim(req.getParameter("voucherId")));
        Boolean targetStatus = parseBoolean(trim(req.getParameter("targetStatus")));
        if (voucherId == null || targetStatus == null) {
            return new OperationResult(false, "Voucher id and status are required");
        }
        return voucherService.setVoucherActive(voucherId, targetStatus);
    }

    private OperationResult handleDelete(HttpServletRequest req) {
        Long voucherId = parseLong(trim(req.getParameter("voucherId")));
        if (voucherId == null) {
            return new OperationResult(false, "Voucher id is required");
        }
        return voucherService.deleteVoucher(voucherId);
    }

    private void storeFlashMessage(HttpSession session, OperationResult result) {
        if (result == null) return;
        if (result.isSuccess()) {
            session.setAttribute("success", result.getMessage());
            session.removeAttribute("error");
        } else {
            session.setAttribute("error", result.getMessage());
            session.removeAttribute("success");
        }
    }

    private static String trim(String value) {
        if (value == null) return null;
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private static BigDecimal parseBigDecimal(String value) {
        if (value == null) return null;
        try {
            return new BigDecimal(value);
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private static Long parseLong(String value) {
        if (value == null) return null;
        try {
            return Long.valueOf(value);
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private static Integer parseInteger(String value) {
        if (value == null) return null;
        try {
            return Integer.valueOf(value);
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private static Boolean parseBoolean(String value) {
        if (value == null) return null;
        return "true".equalsIgnoreCase(value) || "on".equalsIgnoreCase(value);
    }

    private String buildRedirectSuffix(HttpServletRequest req) {
        StringBuilder sb = new StringBuilder("?tab=vouchers");
        String page = trim(req.getParameter("voucherPage"));
        String size = trim(req.getParameter("voucherSize"));
        if (page != null) { sb.append("&voucherPage=").append(page); }
        if (size != null) { sb.append("&voucherSize=").append(size); }
        return sb.toString();
    }
    private static LocalDateTime parseExpiryDate(String value) {
        if (value == null) return null;
        try {
            LocalDate date = LocalDate.parse(value);
            // set to end of day to make voucher valid throughout the selected date
            return date.atTime(23, 59, 59);
        } catch (Exception ex) {
            return null;
        }
    }
}

