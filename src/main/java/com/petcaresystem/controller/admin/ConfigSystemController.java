package com.petcaresystem.controller.admin;

import com.petcaresystem.dto.pageable.PagedResult;
import com.petcaresystem.enities.Voucher;
import com.petcaresystem.service.admin.IVoucherManageService;
import com.petcaresystem.service.admin.impl.VoucherManageServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/config")
public class ConfigSystemController extends HttpServlet {

    private static final int DEFAULT_VOUCHER_PAGE_SIZE = 5;
    private static final int MAX_VOUCHER_PAGE_SIZE = 20;

    private IVoucherManageService voucherService;

    @Override
    public void init() throws ServletException {
        super.init();
        voucherService = new VoucherManageServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String tab = sanitizeTab(req.getParameter("tab"));
        int voucherPage = parsePositiveInt(req.getParameter("voucherPage"), 1);
        int voucherSize = clampPageSize(parsePositiveInt(req.getParameter("voucherSize"), DEFAULT_VOUCHER_PAGE_SIZE));

        PagedResult<Voucher> voucherPaged = voucherService.getVoucherPage(voucherPage, voucherSize);

        req.setAttribute("activeTab", tab);
        req.setAttribute("vouchers", voucherPaged.getItems());
        req.setAttribute("voucherCurrentPage", voucherPaged.getPage());
        req.setAttribute("voucherTotalPages", voucherPaged.getTotalPages());
        req.setAttribute("voucherTotalItems", voucherPaged.getTotalItems());
        req.setAttribute("voucherPageSize", voucherPaged.getPageSize());
        req.setAttribute("voucherPageStart", voucherPaged.getStartIndex());
        req.setAttribute("voucherPageEnd", voucherPaged.getEndIndex());
        req.setAttribute("voucherHasPrev", voucherPaged.hasPrevious());
        req.setAttribute("voucherHasNext", voucherPaged.hasNext());

        req.getRequestDispatcher("/adminpage/config-system.jsp").forward(req, resp);
    }

    private int parsePositiveInt(String raw, int defaultValue) {
        if (raw == null || raw.isBlank()) return defaultValue;
        try {
            int value = Integer.parseInt(raw.trim());
            return value > 0 ? value : defaultValue;
        } catch (NumberFormatException ex) {
            return defaultValue;
        }
    }

    private int clampPageSize(int size) {
        if (size < 1) size = DEFAULT_VOUCHER_PAGE_SIZE;
        if (size < 5) size = 5;
        if (size > MAX_VOUCHER_PAGE_SIZE) size = MAX_VOUCHER_PAGE_SIZE;
        return size;
    }

    private String sanitizeTab(String tab) {
        if (tab == null || tab.isBlank()) return "schedule";
        String normalized = tab.trim().toLowerCase();
        return switch (normalized) {
            case "schedule", "vouchers", "email", "rules" -> normalized;
            default -> "schedule";
        };
    }
}
