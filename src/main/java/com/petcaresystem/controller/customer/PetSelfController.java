package com.petcaresystem.controller.customer;

import com.petcaresystem.dao.PetDAO;
import com.petcaresystem.enities.Account;
import com.petcaresystem.enities.Pet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Objects;

@WebServlet(name = "PetSelfController", urlPatterns = {"/customer/pets"})
public class PetSelfController extends HttpServlet {

    private PetDAO petDAO;

    @Override
    public void init() { petDAO = new PetDAO(); }

    private Account currentUser(HttpServletRequest req) {
        Object o = req.getSession().getAttribute("account");
        return (o instanceof Account) ? (Account) o : null;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Account u = currentUser(req);
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<Pet> pets = petDAO.findByCustomerId(u.getAccountId());
        req.setAttribute("pets", pets);
        req.getRequestDispatcher("/customer/pets.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        Account u = currentUser(req);
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = value(req.getParameter("action"));
        try {
            switch (action) {
                case "create": {
                    String name = value(req.getParameter("name"));
                    String breed = emptyToNull(req.getParameter("breed"));
                    String health = safeHealth(req.getParameter("health"));

                    if (name.isEmpty()) throw new IllegalArgumentException("Pet name is required.");

                    Pet p = new Pet();
                    p.setName(name);
                    p.setBreed(breed);
                    p.setHealthStatus(health);

                    // sẽ set Customer theo accountId bên DAO
                    petDAO.createForCustomer(u.getAccountId(), p);
                    break;
                }

                case "update": {
                    Long petId = parseLong(req.getParameter("petId"));
                    if (petId == null) throw new IllegalArgumentException("Pet id is required.");

                    Pet p = petDAO.findById(petId);
                    // chặn sửa pet của người khác
                    if (p == null || p.getCustomer() == null ||
                            !Objects.equals(p.getCustomer().getAccountId(), u.getAccountId())) {
                        throw new IllegalArgumentException("Not allowed to update this pet.");
                    }

                    String name = value(req.getParameter("name"));
                    String breed = emptyToNull(req.getParameter("breed"));
                    String health = safeHealth(req.getParameter("health"));
                    if (name.isEmpty()) throw new IllegalArgumentException("Pet name is required.");

                    p.setName(name);
                    p.setBreed(breed);
                    p.setHealthStatus(health);
                    petDAO.update(p);
                    break;
                }

                case "delete": {
                    Long petId = parseLong(req.getParameter("petId"));
                    if (petId == null) throw new IllegalArgumentException("Pet id is required.");

                    Pet p = petDAO.findById(petId);
                    if (p == null || p.getCustomer() == null ||
                            !Objects.equals(p.getCustomer().getAccountId(), u.getAccountId())) {
                        throw new IllegalArgumentException("Not allowed to delete this pet.");
                    }
                    petDAO.softDelete(petId); // hoặc hardDelete nếu bạn muốn
                    break;
                }

                default:
                    // không có action => bỏ qua
                    break;
            }

            // thành công -> quay lại danh sách
            resp.sendRedirect(req.getContextPath() + "/customer/pets");

        } catch (Exception ex) {
            // có lỗi -> hiển thị lại trang cùng thông báo
            req.setAttribute("error", ex.getMessage());
            doGet(req, resp);
        }
    }

    /* ================= helpers ================= */

    private String value(String s) { return s == null ? "" : s.trim(); }

    private String emptyToNull(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }

    private Long parseLong(String s) {
        try { return (s == null || s.isBlank()) ? null : Long.valueOf(s.trim()); }
        catch (NumberFormatException e) { return null; }
    }

    /** Chỉ chấp nhận HEALTHY / AVERAGE / SICK; mặc định HEALTHY */
    private String safeHealth(String v) {
        if (v == null) return "HEALTHY";
        String up = v.trim().toUpperCase();
        switch (up) {
            case "HEALTHY":
            case "AVERAGE":
            case "SICK":
                return up;
            default:
                return "HEALTHY";
        }
    }
}
