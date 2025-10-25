package com.petcaresystem.controller.admin;

import com.petcaresystem.dto.pageable.PagedResult;
import com.petcaresystem.dto.account.AccountStats;
import com.petcaresystem.dto.pageable.OperationResult;
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
        System.out.println("searchAccounts called with keyword: " + keyword + ", role: " + role);
        renderAccountList(req, resp, keyword, role, "search");
    }

    private void renderAccountList(HttpServletRequest req, HttpServletResponse resp,
                                   String keyword, String role, String action)
            throws ServletException, IOException {
        System.out.println("renderAccountList called - Response committed: " + resp.isCommitted());
        try {
            int page = parsePage(req.getParameter("page"));
            int size = parseSize(req.getParameter("size"));
            
            System.out.println("Pagination params - page: " + page + ", size: " + size);

            String effectiveKeyword = keyword != null ? keyword : trim(req.getParameter("keyword"));
            String roleRaw = role != null ? role : req.getParameter("role");
            String normalizedRole = normalizeRole(roleRaw);
            
            System.out.println("Search params - keyword: " + effectiveKeyword + ", role: " + normalizedRole);

            System.out.println("Getting accounts page...");
            PagedResult<Account> pagedAccounts = accountService.getAccountsPage(
                    effectiveKeyword, normalizedRole, page, size);
            System.out.println("Getting account stats...");
            AccountStats stats = accountService.getAccountStats(effectiveKeyword, normalizedRole);

            System.out.println("Populating attributes...");
            populateAccountsAttributes(req, pagedAccounts, stats);
            req.setAttribute("accountAction", action);
            req.setAttribute("filterKeyword", effectiveKeyword);
            req.setAttribute("filterRole", normalizedRole == null ? "all" : normalizedRole);
            req.setAttribute("filterRoleRaw", roleRaw == null ? "all" : roleRaw);

            System.out.println("Forwarding to JSP - Response committed: " + resp.isCommitted());
            req.getRequestDispatcher("/adminpage/manage-accounts.jsp").forward(req, resp);
        } catch (Exception e) {
            System.err.println("Exception in renderAccountList: " + e.getMessage());
            e.printStackTrace();
            try {
                if (!resp.isCommitted()) {
                    req.setAttribute("error", "Error loading accounts: " + e.getMessage());
                    req.getRequestDispatcher("/adminpage/manage-accounts.jsp").forward(req, resp);
                } else {
                    System.err.println("Response already committed, writing error directly");
                    resp.getWriter().println("Error loading accounts: " + e.getMessage());
                }
            } catch (Exception ex) {
                System.err.println("Exception in error handling: " + ex.getMessage());
                ex.printStackTrace();
                if (!resp.isCommitted()) {
                    resp.getWriter().println("Error loading accounts: " + e.getMessage());
                }
            }
        }
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

        OperationResult res = accountService.createAccount(a);
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
        
        // Check if trying to edit admin account
        if (existing.getRole() == com.petcaresystem.enities.enu.AccountRoleEnum.ADMIN) {
            req.getSession().setAttribute("error", "Cannot edit admin accounts");
            resp.sendRedirect(req.getContextPath() + "/admin/accounts?action=list");
            return;
        }

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

        OperationResult res = accountService.updateAccount(existing);
        req.getSession().setAttribute(res.isSuccess() ? "success" : "error", res.getMessage());
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Failed to update account: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/accounts?action=list");
    }

    private void handleLock(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer id = parseInt(req.getParameter("id"));
        System.out.println("handleLock called with id: " + id);
        
        if (id != null) {
            Account account = accountService.getAccountById(id);
            System.out.println("Found account: " + (account != null ? account.getUsername() : "null"));
            
            if (account != null && account.getRole() == com.petcaresystem.enities.enu.AccountRoleEnum.ADMIN) {
                System.out.println("Cannot lock admin account");
                req.getSession().setAttribute("error", "Cannot lock admin accounts");
            } else if (account != null) {
                System.out.println("Locking account: " + account.getUsername());
                boolean success = accountService.lockAccount(id);
                System.out.println("Lock result: " + success);
                
                if (success) {
                    req.getSession().setAttribute("success", "Account locked successfully");
                } else {
                    req.getSession().setAttribute("error", "Failed to lock account");
                }
            } else {
                System.out.println("Account not found");
                req.getSession().setAttribute("error", "Account not found");
            }
        } else {
            System.out.println("No account ID provided");
            req.getSession().setAttribute("error", "No account ID provided");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/accounts?action=list");
    }

    private void handleUnlock(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer id = parseInt(req.getParameter("id"));
        System.out.println("handleUnlock called with id: " + id);
        
        if (id != null) {
            Account account = accountService.getAccountById(id);
            System.out.println("Found account: " + (account != null ? account.getUsername() : "null"));
            
            if (account != null && account.getRole() == com.petcaresystem.enities.enu.AccountRoleEnum.ADMIN) {
                System.out.println("Cannot unlock admin account");
                req.getSession().setAttribute("error", "Cannot unlock admin accounts");
            } else if (account != null) {
                System.out.println("Unlocking account: " + account.getUsername());
                boolean success = accountService.unlockAccount(id);
                System.out.println("Unlock result: " + success);
                
                if (success) {
                    req.getSession().setAttribute("success", "Account unlocked successfully");
                } else {
                    req.getSession().setAttribute("error", "Failed to unlock account");
                }
            } else {
                System.out.println("Account not found");
                req.getSession().setAttribute("error", "Account not found");
            }
        } else {
            System.out.println("No account ID provided");
            req.getSession().setAttribute("error", "No account ID provided");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/accounts?action=list");
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer id = parseInt(req.getParameter("id"));
        System.out.println("handleDelete called with id: " + id);
        
        if (id != null) {
            Account account = accountService.getAccountById(id);
            System.out.println("Found account: " + (account != null ? account.getUsername() : "null"));
            
            if (account != null && account.getRole() == com.petcaresystem.enities.enu.AccountRoleEnum.ADMIN) {
                System.out.println("Cannot delete admin account");
                req.getSession().setAttribute("error", "Cannot delete admin accounts");
            } else {
                System.out.println("Attempting to delete account with id: " + id);
                boolean success = accountService.hardDeleteAccount(id);
                System.out.println("Delete result: " + success);
                
                if (success) {
                    req.getSession().setAttribute("success", "Account deleted successfully");
                } else {
                    req.getSession().setAttribute("error", "Failed to delete account");
                }
            }
        } else {
            System.out.println("No account ID provided");
            req.getSession().setAttribute("error", "No account ID provided");
        }
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
        boolean hasPrevPage = pageData != null && pageData.hasPrevious();
        boolean hasNextPage = pageData != null && pageData.hasNext();
        
        System.out.println("Pagination debug - currentPage: " + currentPage + ", totalPages: " + totalPages + ", hasPrevPage: " + hasPrevPage + ", hasNextPage: " + hasNextPage);
        
        req.setAttribute("hasPrevPage", hasPrevPage);
        req.setAttribute("hasNextPage", hasNextPage);
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
