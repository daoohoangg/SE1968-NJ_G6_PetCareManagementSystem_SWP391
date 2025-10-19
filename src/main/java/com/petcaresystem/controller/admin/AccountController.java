package com.petcaresystem.controller.admin;

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
        List<Account> accounts = accountService.getAllAccounts();
        populateAccountsAttributes(req, accounts);
        req.getRequestDispatcher("/adminpage/manage-accounts.jsp").forward(req, resp);
    }

    private void searchAccounts(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = trim(req.getParameter("keyword"));
        String role = trim(req.getParameter("role"));
        List<Account> accounts = accountService.searchAccounts(keyword, role);
        populateAccountsAttributes(req, accounts);
        req.setAttribute("keyword", keyword);
        req.setAttribute("selectedRole", role);
        req.getRequestDispatcher("/adminpage/manage-accounts.jsp").forward(req, resp);
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("openAddModal", true);
        listAccounts(req, resp);
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
        listAccounts(req, resp);
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

    private void populateAccountsAttributes(HttpServletRequest req, List<Account> accounts) {
        List<Account> safeAccounts = accounts != null ? accounts : Collections.emptyList();
        req.setAttribute("accounts", safeAccounts);

        long total = safeAccounts.size();
        long active = safeAccounts.stream()
                .filter(acc -> acc != null && Boolean.TRUE.equals(acc.getIsActive()))
                .count();
        long locked = total - active;
        long admins = safeAccounts.stream()
                .filter(acc -> acc != null && acc.getRole() == com.petcaresystem.enities.enu.AccountRoleEnum.ADMIN)
                .count();
        long staff = safeAccounts.stream()
                .filter(acc -> acc != null && acc.getRole() == com.petcaresystem.enities.enu.AccountRoleEnum.STAFF)
                .count();
        long customers = safeAccounts.stream()
                .filter(acc -> acc != null && acc.getRole() == com.petcaresystem.enities.enu.AccountRoleEnum.CUSTOMER)
                .count();

        req.setAttribute("accountsTotal", total);
        req.setAttribute("accountsActive", active);
        req.setAttribute("accountsLocked", locked);
        req.setAttribute("accountsAdmin", admins);
        req.setAttribute("accountsStaff", staff);
        req.setAttribute("accountsCustomer", customers);
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
