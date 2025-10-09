package com.petcaresystem.controller.customer;

import com.petcaresystem.dao.AccountDAO;
import com.petcaresystem.enities.Account;          // CHÚ Ý: enities (đúng theo main)
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

    // ------------------- Helpers -------------------

    private Account currentUser(HttpServletRequest request) {
        return (Account) request.getSession().getAttribute("user");
    }

    private void viewProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Account me = currentUser(request);
        if (me == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        // Làm tươi dữ liệu bằng username/email có sẵn (DAO của bạn đã có hàm này)
        Account fresh = accountDAO.getAccountByEmailOrUsername(me.getUsername());
        request.setAttribute("profile", fresh != null ? fresh : me);
        request.getRequestDispatcher("/views/customer/profile-view.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Account me = currentUser(request);
        if (me == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        Account fresh = accountDAO.getAccountByEmailOrUsername(me.getUsername());
        request.setAttribute("profile", fresh != null ? fresh : me);
        request.getRequestDispatcher("/views/customer/profile-edit.jsp").forward(request, response);
    }

    /** Cập nhật username/email/fullName/phone và (optional) password */
    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Account me = currentUser(request);
        if (me == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        String username = request.getParameter("username");
        String email    = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone    = request.getParameter("phone");
        String password = request.getParameter("password"); // có thể để trống nếu không đổi

        // Validate trùng username/email (dùng DAO đang có)
        if (username != null && !username.equals(me.getUsername())) {
            Account clash = accountDAO.getAccountByEmailOrUsername(username);
            if (clash != null) {
                request.getSession().setAttribute("flash", "Username already in use.");
                response.sendRedirect(request.getContextPath() + "/customer/profile?action=edit");
                return;
            }
        }
        if (email != null && !email.equals(me.getEmail())) {
            Account clash = accountDAO.getAccountByEmailOrUsername(email);
            if (clash != null) {
                request.getSession().setAttribute("flash", "Email already in use.");
                response.sendRedirect(request.getContextPath() + "/customer/profile?action=edit");
                return;
            }
        }

        // Cập nhật trực tiếp bằng Hibernate (phù hợp với abstract Account + JOINED)
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            Account db = s.get(Account.class, me.getAccountId()); // <-- dùng getAccountId()

            if (db != null) {
                if (username != null) db.setUsername(username);
                if (email    != null) db.setEmail(email);
                if (fullName != null) db.setFullName(fullName);
                if (phone    != null) db.setPhone(phone);
                if (password != null && !password.isBlank()) {
                    db.setPassword(password);
                }
                s.merge(db);
                request.getSession().setAttribute("user", db); // sync lại session
                request.getSession().setAttribute("flash", "Profile updated.");
            } else {
                request.getSession().setAttribute("flash", "Account not found.");
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            request.getSession().setAttribute("flash", "Update failed.");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/customer/profile?action=view");
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Account me = currentUser(request);
        if (me == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        String newPassword = request.getParameter("newPassword");
        boolean ok = accountDAO.changePassword(me.getAccountId().intValue(), newPassword);
        request.getSession().setAttribute("flash", ok ? "Password changed." : "Change password failed.");
        response.sendRedirect(request.getContextPath() + "/customer/profile?action=view");
    }

    private void deactivateAccount(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Account me = currentUser(request);
        if (me == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        // Nếu có DAO deactivate thì dùng; nếu chưa có, có thể tự set isActive=false tương tự như updateProfile
        Transaction tx = null;
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            tx = s.beginTransaction();
            Account db = s.get(Account.class, me.getAccountId());
            if (db != null) {
                db.setIsActive(false);
                s.merge(db);
                request.getSession().invalidate();
                response.sendRedirect(request.getContextPath() + "/");
            } else {
                request.getSession().setAttribute("flash", "Account not found.");
                response.sendRedirect(request.getContextPath() + "/customer/profile?action=view");
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            request.getSession().setAttribute("flash", "Deactivate failed.");
            response.sendRedirect(request.getContextPath() + "/customer/profile?action=view");
        }
    }
}
