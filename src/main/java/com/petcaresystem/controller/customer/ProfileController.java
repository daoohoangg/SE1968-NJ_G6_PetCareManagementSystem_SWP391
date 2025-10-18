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
import java.util.Objects;

@WebServlet(name = "ProfileController", urlPatterns = {"/customer/profile"})
public class ProfileController extends HttpServlet {

    private AccountDAO accountDAO;

    @Override
    public void init() throws ServletException {
        accountDAO = new AccountDAO();
    }

    /* ===== Helpers ===== */

    private Account currentUser(HttpServletRequest req) {
        Object o = req.getSession().getAttribute("account");
        if (o == null) o = req.getSession().getAttribute("user");
        return (Account) o;
    }

    private void flash(HttpServletRequest req, String msg) {
        req.getSession().setAttribute("flash", msg);
    }

    private void syncSessionUser(HttpServletRequest req, Account acc) {
        req.getSession().setAttribute("account", acc);
        req.getSession().setAttribute("user", acc);
    }

    private static String trim(String s) { return s == null ? null : s.trim(); }

    /* ===== GET ===== */

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "view";

        switch (action) {
            case "edit":
                showEdit(req, resp);
                break;
            default:
                view(req, resp);
        }
    }

    private void view(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Account me = currentUser(req);
        if (me == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            Account fresh = s.get(Account.class, me.getAccountId());
            req.setAttribute("profile", fresh != null ? fresh : me);
        }
        req.getRequestDispatcher("/home.jsp").forward(req, resp);
    }

    private void showEdit(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Account me = currentUser(req);
        if (me == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            Account fresh = s.get(Account.class, me.getAccountId());
            req.setAttribute("profile", fresh != null ? fresh : me);
        }
        req.getRequestDispatcher("/customer/profile-edit.jsp").forward(req, resp);
    }

    /* ===== POST ===== */

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "update";

        switch (action) {
            case "change-password":
                changePassword(req, resp);
                break;
            case "update":
            default:
                updateProfile(req, resp);
        }
    }

    private void updateProfile(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        Account me = currentUser(req);
        if (me == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String username = trim(req.getParameter("username"));
        String email    = trim(req.getParameter("email"));
        String fullName = trim(req.getParameter("fullName"));
        String phone    = trim(req.getParameter("phone"));
        String password = trim(req.getParameter("password"));

        if (username == null || username.isEmpty() || email == null || email.isEmpty()) {
            flash(req, "Username và Email là bắt buộc.");
            resp.sendRedirect(req.getContextPath() + "/customer/profile?action=edit");
            return;
        }

        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();

            Account db = s.get(Account.class, me.getAccountId());
            if (db == null) {
                flash(req, "Account không tồn tại.");
                resp.sendRedirect(req.getContextPath() + "/customer/profile?action=edit");
                return;
            }

            boolean changed = false;


            if (!Objects.equals(username, db.getUsername())) {
                Account clash = accountDAO.getAccountByEmailOrUsername(username);
                if (clash != null && !clash.getAccountId().equals(db.getAccountId())) {
                    flash(req, "Username đã được sử dụng.");
                    resp.sendRedirect(req.getContextPath() + "/customer/profile?action=edit");
                    return;
                }
                db.setUsername(username);
                changed = true;
            }


            if (!Objects.equals(email, db.getEmail())) {
                Account clash = accountDAO.getAccountByEmailOrUsername(email);
                if (clash != null && !clash.getAccountId().equals(db.getAccountId())) {
                    flash(req, "Email đã được sử dụng.");
                    resp.sendRedirect(req.getContextPath() + "/customer/profile?action=edit");
                    return;
                }
                db.setEmail(email);
                changed = true;
            }

            if (!Objects.equals(fullName, db.getFullName())) {
                db.setFullName(fullName);
                changed = true;
            }
            if (!Objects.equals(phone, db.getPhone())) {
                db.setPhone(phone);
                changed = true;
            }


            if (password != null && !password.isBlank()) {
                boolean ok = accountDAO.changePassword(db.getAccountId().intValue(), password);
                if (!ok) {
                    if (tx != null) tx.rollback();
                    flash(req, "Đổi mật khẩu thất bại.");
                    resp.sendRedirect(req.getContextPath() + "/customer/profile?action=edit");
                    return;
                }

                db = s.get(Account.class, me.getAccountId());
                changed = true;
            }

            if (!changed) {
                flash(req, "Không có thay đổi nào để lưu.");
                resp.sendRedirect(req.getContextPath() + "/customer/profile?action=edit");
                return;
            }


            s.merge(db);
            s.flush();
            tx.commit();


            syncSessionUser(req, db);
            flash(req, "Cập nhật thành công.");
            resp.sendRedirect(req.getContextPath() + "/customer/profile?action=view");

        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            flash(req, "Cập nhật thất bại.");
            resp.sendRedirect(req.getContextPath() + "/customer/profile?action=edit");
        }
    }

    private void changePassword(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        Account me = currentUser(req);
        if (me == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String newPassword = trim(req.getParameter("password"));
        String redirect = req.getParameter("redirect");

        if (newPassword == null || newPassword.isBlank()) {
            flash(req, "Password không được để trống.");
            resp.sendRedirect(req.getContextPath() + "/customer/profile?action=edit");
            return;
        }

        boolean ok = accountDAO.changePassword(me.getAccountId().intValue(), newPassword);
        if (!ok) {
            flash(req, "Đổi mật khẩu thất bại.");
            resp.sendRedirect(req.getContextPath() + "/customer/profile?action=edit");
            return;
        }


        Account fresh = accountDAO.findById(me.getAccountId().intValue());
        if (fresh != null) syncSessionUser(req, fresh);

        flash(req, "Đổi mật khẩu thành công.");
        if ("home".equalsIgnoreCase(redirect)) {
            resp.sendRedirect(req.getContextPath() + "/home");
        } else {
            resp.sendRedirect(req.getContextPath() + "/customer/profile?action=view");
        }
    }
}
