package com.petcaresystem.controller.customer;

import com.petcaresystem.dao.AccountDAO;
import com.petcaresystem.enities.Account;
import com.petcaresystem.utils.HibernateUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.io.IOException;

@WebServlet(name = "ProfileController", urlPatterns = {"/customer/profile"})
public class ProfileController extends HttpServlet {

    private AccountDAO accountDAO;

    @Override
    public void init() throws ServletException {
        accountDAO = new AccountDAO();
    }

    // ------------------- Helpers -------------------
    /** Đọc user từ session: dùng khóa "account" cho đồng nhất với header.jsp */
    private Account currentUser(HttpServletRequest request) {
        Object obj = request.getSession().getAttribute("account");
        if (obj == null) obj = request.getSession().getAttribute("user");
        return (Account) obj;
    }

    /** Lưu user vào session với cả 2 khóa để tương thích */
    private void syncSessionUser(HttpServletRequest request, Account acc) {
        request.getSession().setAttribute("account", acc);
        request.getSession().setAttribute("user", acc);
    }

    private void flash(HttpServletRequest req, String msg) {
        req.getSession().setAttribute("flash", msg);
    }

    // ------------------- GET -------------------
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "view";

        switch (action) {
            case "edit":
                showEditForm(request, response);
                break;
            default: // view
                viewProfile(request, response);
                break;
        }
    }

    private void viewProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Account me = currentUser(request);
        if (me == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }


        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            Account fresh = s.get(Account.class, me.getAccountId());
            request.setAttribute("profile", fresh != null ? fresh : me);
        }
        // ĐÚNG đường dẫn theo cây thư mục thực tế
        request.getRequestDispatcher("/customer/profile-view.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Account me = currentUser(request);
        if (me == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            Account fresh = s.get(Account.class, me.getAccountId());
            request.setAttribute("profile", fresh != null ? fresh : me);
        }
        request.getRequestDispatcher("/customer/profile-edit.jsp").forward(request, response);
    }

    // ------------------- POST -------------------
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "update";

        switch (action) {
            case "update":
                updateProfile(request, response);
                break;
            case "change-password":
                changePassword(request, response);
                break;
            case "deactivate":
                deactivateAccount(request, response);
                break;
            default:
                viewProfile(request, response);
                break;
        }
    }

    /** Cập nhật username/email/fullName/phone và (optional) password */
    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Account me = currentUser(request);
        if (me == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String username = trim(request.getParameter("username"));
        String email    = trim(request.getParameter("email"));
        String fullName = trim(request.getParameter("fullName"));
        String phone    = trim(request.getParameter("phone"));
        String password = trim(request.getParameter("password")); // có thể trống

        // Bắt buộc tối thiểu
        if (username == null || username.isEmpty() || email == null || email.isEmpty()) {
            request.getSession().setAttribute("flash", "Username và Email là bắt buộc.");
            response.sendRedirect(request.getContextPath() + "/customer/profile?action=edit");
            return;
        }

        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();

            Account db = s.get(Account.class, me.getAccountId());
            if (db == null) {
                request.getSession().setAttribute("flash", "Account not found.");
                response.sendRedirect(request.getContextPath() + "/customer/profile?action=edit");
                return;
            }

            boolean changed = false;

            // Nếu thay đổi username -> kiểm tra trùng
            if (!safeEquals(username, db.getUsername())) {
                Account clash = accountDAO.getAccountByEmailOrUsername(username);
                if (clash != null && !clash.getAccountId().equals(db.getAccountId())) {
                    request.getSession().setAttribute("flash", "Username đã được sử dụng.");
                    response.sendRedirect(request.getContextPath() + "/customer/profile?action=edit");
                    return;
                }
                db.setUsername(username);
                changed = true;
            }

            // Nếu thay đổi email -> kiểm tra trùng
            if (!safeEquals(email, db.getEmail())) {
                Account clash = accountDAO.getAccountByEmailOrUsername(email);
                if (clash != null && !clash.getAccountId().equals(db.getAccountId())) {
                    request.getSession().setAttribute("flash", "Email đã được sử dụng.");
                    response.sendRedirect(request.getContextPath() + "/customer/profile?action=edit");
                    return;
                }
                db.setEmail(email);
                changed = true;
            }

            // Full name
            if (!safeEquals(fullName, db.getFullName())) {
                db.setFullName(fullName);
                changed = true;
            }

            // Phone
            if (!safeEquals(phone, db.getPhone())) {
                db.setPhone(phone);
                changed = true;
            }

            // Password (nếu có nhập)
            if (password != null && !password.isBlank()) {
                db.setPassword(password); // TODO: hash nếu cần
                changed = true;
            }

            // Không thay đổi gì → quay lại trang edit
            if (!changed) {
                request.getSession().setAttribute("flash", "Không có thay đổi nào để lưu.");
                response.sendRedirect(request.getContextPath() + "/customer/profile?action=edit");
                return;
            }

            s.merge(db);
            tx.commit();

            // Cập nhật lại session để hiển thị dữ liệu mới
            request.getSession().setAttribute("user", db);
            request.getSession().setAttribute("account", db);
            request.getSession().setAttribute("flash", "Cập nhật thành công.");

            // Muốn về home thì đổi dòng dưới thành: response.sendRedirect(ctx + "/home");
            response.sendRedirect(request.getContextPath() + "/customer/profile?action=view");

        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            request.getSession().setAttribute("flash", "Cập nhật thất bại.");
            response.sendRedirect(request.getContextPath() + "/customer/profile?action=edit");
        }
    }

    // Helpers nhỏ
    private static String trim(String s) {
        return (s == null) ? null : s.trim();
    }
    private static boolean safeEquals(Object a, Object b) {
        return java.util.Objects.equals(a, b);
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Account me = currentUser(request);
        if (me == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        String newPassword = request.getParameter("password");
        String redirect = request.getParameter("redirect");

        if (newPassword == null || newPassword.isBlank()) {

            flash(request, "Password cannot be empty.");
            response.sendRedirect(request.getContextPath() + "/customer/profile?action=view");
            return;
        }


        flash(request, "Password changed.");
        if ("home".equalsIgnoreCase(redirect)) {
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            response.sendRedirect(request.getContextPath() + "/customer/profile?action=view");
        }
    }

    private void deactivateAccount(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Account me = currentUser(request);
        if (me == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            Account db = s.get(Account.class, me.getAccountId());
            if (db != null) {
                db.setIsActive(false);
                s.merge(db);
                tx.commit();
                request.getSession().invalidate();
                response.sendRedirect(request.getContextPath() + "/");
            } else {
                if (tx != null) tx.rollback();
                flash(request, "Account not found.");
                response.sendRedirect(request.getContextPath() + "/customer/profile?action=view");
            }
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            flash(request, "Deactivate failed.");
            response.sendRedirect(request.getContextPath() + "/customer/profile?action=view");
        }
    }
}
