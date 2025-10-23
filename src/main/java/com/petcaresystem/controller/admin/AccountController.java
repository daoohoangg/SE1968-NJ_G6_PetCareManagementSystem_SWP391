package com.petcaresystem.controller.admin;

import com.petcaresystem.dto.PagedResult;
import com.petcaresystem.dto.account.AccountStats;
import com.petcaresystem.enities.Account;
import com.petcaresystem.service.admin.IAccountManageService;
import com.petcaresystem.service.admin.impl.AccountManageServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet({"/admin/accounts", "/admin/account"})
public class AccountController extends HttpServlet {

    private IAccountManageService accountService;

    @Override
    public void init() throws ServletException {
        super.init();
        accountService = new AccountManageServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                listAccounts(req, resp);
                break;
            case "search":
                searchAccounts(req, resp);
                break;
            case "add":
                showAddForm(req, resp);
                break;
            case "edit":
                showEditForm(req, resp);
                break;
            default:
                listAccounts(req, resp);
        }
    }

    private void listAccounts(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        renderAccountList(req, resp, null, null, "list");
    }

    private void searchAccounts(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = trim(req.getParameter("keyword"));
        String role = trim(req.getParameter("role"));
        renderAccountList(req, resp, keyword, role, "search");
    }

    private void renderAccountList(HttpServletRequest req, HttpServletResponse resp,
                                   String keyword, String role, String action)
            throws ServletException, IOException {
        int page = parsePage(req.getParameter("page"));
        int size = parseSize(req.getParameter("size"));

        String effectiveKeyword = keyword != null ? keyword : trim(req.getParameter("keyword"));
        String roleRaw = role != null ? role : req.getParameter("role");
        String normalizedRole = normalizeRole(roleRaw);

        PagedResult<Account> pagedAccounts = accountService.getAccountsPage(
                effectiveKeyword, normalizedRole, page, size);
        AccountStats stats = accountService.getAccountStats(effectiveKeyword, normalizedRole);

        populateAccountsAttributes(req, pagedAccounts, stats);
        req.setAttribute("accountAction", action);
        req.setAttribute("filterKeyword", effectiveKeyword);
        req.setAttribute("filterRole", normalizedRole == null ? "all" : normalizedRole);
        req.setAttribute("filterRoleRaw", roleRaw == null ? "all" : roleRaw);

        req.getRequestDispatcher("/adminpage/manage-accounts.jsp").forward(req, resp);
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("openAddModal", true);
        renderAccountList(req, resp, null, null, "list");
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer id = parseInt(req.getParameter("id"));
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/accounts");
            return;
        }
        Account a = accountService.getAccountById(id);
        if (a == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/accounts");
            return;
        }
        req.setAttribute("editAccount", a);
        req.setAttribute("openEditModal", true);
        renderAccountList(req, resp, null, null, "list");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/accounts");
            return;
        }
        switch (action) {
            case "create":
                handleCreate(req, resp);
                break;
            case "update":
                handleUpdate(req, resp);
                break;
            case "lock":
                handleLock(req, resp);
                break;
            case "unlock":
                handleUnlock(req, resp);
                break;
            case "delete":
                handleDelete(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/accounts");
        }
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String role = trim(req.getParameter("role"));
        String username = trim(req.getParameter("username"));
        String password = trim(req.getParameter("password"));
        String fullName = trim(req.getParameter("fullName"));
        String email = trim(req.getParameter("email"));
        String phone = trim(req.getParameter("phone"));

        Account a = null;
        try {
            if ("ADMIN".equalsIgnoreCase(role)) {
                a = new com.petcaresystem.enities.Administration();
                a.setRole(com.petcaresystem.enities.enu.AccountRoleEnum.ADMIN);
            } else if ("STAFF".equalsIgnoreCase(role)) {
                a = new com.petcaresystem.enities.Staff();
                a.setRole(com.petcaresystem.enities.enu.AccountRoleEnum.STAFF);
            } else {
                a = new com.petcaresystem.enities.Customer();
                a.setRole(com.petcaresystem.enities.enu.AccountRoleEnum.CUSTOMER);
            }

            a.setUsername(username);
            a.setPassword(password); // existing project stores plain password; follow existing pattern
            a.setFullName(fullName);
            a.setEmail(email);
            a.setPhone(phone);

        com.petcaresystem.dto.OperationResult res = accountService.createAccount(a);
        req.getSession().setAttribute(res.isSuccess() ? "success" : "error", res.getMessage());
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Failed to create account: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/accounts?action=list");
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer id = parseInt(req.getParameter("accountId"));
        if (id == null) { resp.sendRedirect(req.getContextPath() + "/admin/accounts?action=list"); return; }
        Account existing = accountService.getAccountById(id);
        if (existing == null) { resp.sendRedirect(req.getContextPath() + "/admin/accounts?action=list"); return; }

        String username = trim(req.getParameter("username"));
        String fullName = trim(req.getParameter("fullName"));
        String email = trim(req.getParameter("email"));
        String phone = trim(req.getParameter("phone"));
        String password = trim(req.getParameter("password"));
        String role = trim(req.getParameter("role"));

        try {
            existing.setUsername(username != null ? username : existing.getUsername());
            if (password != null && !password.isBlank()) existing.setPassword(password);
            existing.setFullName(fullName != null ? fullName : existing.getFullName());
            existing.setEmail(email != null ? email : existing.getEmail());
            existing.setPhone(phone != null ? phone : existing.getPhone());
            if (role != null) {
                existing.setRole(com.petcaresystem.enities.enu.AccountRoleEnum.valueOf(role));
            }

        com.petcaresystem.dto.OperationResult res = accountService.updateAccount(existing);
        req.getSession().setAttribute(res.isSuccess() ? "success" : "error", res.getMessage());
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Failed to update account: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/accounts?action=list");
    }

    private void handleLock(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer id = parseInt(req.getParameter("id"));
        if (id != null) accountService.lockAccount(id);
        resp.sendRedirect(req.getContextPath() + "/admin/accounts?action=list");
    }

    private void handleUnlock(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer id = parseInt(req.getParameter("id"));
        if (id != null) accountService.unlockAccount(id);
        resp.sendRedirect(req.getContextPath() + "/admin/accounts?action=list");
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer id = parseInt(req.getParameter("id"));
        if (id != null) accountService.hardDeleteAccount(id);
        resp.sendRedirect(req.getContextPath() + "/admin/accounts?action=list");
    }

    private int parsePage(String rawPage) {
        Integer parsed = parseInt(rawPage);
        if (parsed == null || parsed < 1) return 1;
        return parsed;
    }

    private int parseSize(String rawSize) {
        Integer parsed = parseInt(rawSize);
        if (parsed == null) return 10;
        int size = Math.max(parsed, 1);
        if (size < 5) size = 5;
        if (size > 50) size = 50;
        return size;
    }

    private String normalizeRole(String role) {
        if (role == null) return null;
        String trimmed = role.trim();
        if (trimmed.isEmpty() || "all".equalsIgnoreCase(trimmed)) {
            return null;
        }
        return trimmed.toUpperCase();
    }

    private void populateAccountsAttributes(HttpServletRequest req, PagedResult<Account> pageData, AccountStats stats) {
        List<Account> safeAccounts = pageData != null ? pageData.getItems() : Collections.emptyList();
        req.setAttribute("accounts", safeAccounts);

        long total = stats != null ? stats.getTotal() : safeAccounts.size();
        long active = stats != null ? stats.getActive() : safeAccounts.stream()
                .filter(acc -> acc != null && Boolean.TRUE.equals(acc.getIsActive()))
                .count();
        long admins = stats != null ? stats.getAdmin() : safeAccounts.stream()
                .filter(acc -> acc != null && acc.getRole() == com.petcaresystem.enities.enu.AccountRoleEnum.ADMIN)
                .count();
        long staff = stats != null ? stats.getStaff() : safeAccounts.stream()
                .filter(acc -> acc != null && acc.getRole() == com.petcaresystem.enities.enu.AccountRoleEnum.STAFF)
                .count();
        long customers = stats != null ? stats.getCustomer() : safeAccounts.stream()
                .filter(acc -> acc != null && acc.getRole() == com.petcaresystem.enities.enu.AccountRoleEnum.CUSTOMER)
                .count();
        long locked = stats != null ? stats.getLocked() : (total - active);

        req.setAttribute("accountsTotal", total);
        req.setAttribute("accountsActive", active);
        req.setAttribute("accountsLocked", locked);
        req.setAttribute("accountsAdmin", admins);
        req.setAttribute("accountsStaff", staff);
        req.setAttribute("accountsCustomer", customers);

        int currentPage = pageData != null ? pageData.getPage() : 1;
        int pageSize = pageData != null ? pageData.getPageSize() : 10;
        int totalPages = pageData != null ? pageData.getTotalPages() : (safeAccounts.isEmpty() ? 0 : 1);
        long totalItems = pageData != null ? pageData.getTotalItems() : safeAccounts.size();
        int startIndex = pageData != null ? pageData.getStartIndex() : (safeAccounts.isEmpty() ? 0 : 1);
        int endIndex = pageData != null ? pageData.getEndIndex() : safeAccounts.size();

        req.setAttribute("currentPage", currentPage);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalItems", totalItems);
        req.setAttribute("pageStart", startIndex);
        req.setAttribute("pageEnd", endIndex);
        req.setAttribute("hasPrevPage", pageData != null && pageData.hasPrevious());
        req.setAttribute("hasNextPage", pageData != null && pageData.hasNext());
    }

    private static String trim(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
    private static Integer parseInt(String s) {
        try { return trim(s) == null ? null : Integer.valueOf(s.trim()); }
        catch (Exception e) { return null; }
    }
}
