package com.petcaresystem.controller.customer;

import com.petcaresystem.dao.PetDAO;
import com.petcaresystem.enities.Account;
import com.petcaresystem.enities.Customer;
import com.petcaresystem.enities.Pet;
import com.petcaresystem.utils.HibernateUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "PetSelfController", urlPatterns = {"/customer/pets"})
public class PetSelfController extends HttpServlet {

    private PetDAO petDAO;

    @Override
    public void init() throws ServletException {
        petDAO = new PetDAO();
    }

    /* ------------ helpers ------------ */

    /** Lấy accountId (Long) từ user trong session (có thể là Customer hoặc Account) */
    private Long currentAccountId(HttpServletRequest req) {
        Object u = req.getSession().getAttribute("user");
        if (u == null) return null;
        if (u instanceof Customer c) return c.getAccountId();
        if (u instanceof Account a)  return a.getAccountId();
        return null;
    }

    /** Lấy Customer từ session (nên lưu Customer khi login) */
    private Customer currentCustomer(HttpServletRequest req) {
        Object u = req.getSession().getAttribute("user");
        return (u instanceof Customer) ? (Customer) u : null;
    }

    private boolean isBlank(String s) { return s == null || s.isBlank(); }

    /** Lấy Pet theo id (DAO của bạn chưa có findById(Long) nên dùng Hibernate trực tiếp) */
    private Pet getPetById(Long id) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            return s.get(Pet.class, id);
        }
    }

    /* ------------ GET ------------ */

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Long accountId = currentAccountId(req);
        if (accountId == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                req.getRequestDispatcher("/views/customer/pet-add.jsp").forward(req, resp);
                break;

            case "edit": {
                Long petId = Long.valueOf(req.getParameter("id"));
                Pet p = getPetById(petId);
                if (p == null || p.getCustomer() == null ||
                        !accountId.equals(p.getCustomer().getAccountId())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                req.setAttribute("pet", p);
                req.getRequestDispatcher("/views/customer/pet-edit.jsp").forward(req, resp);
                break;
            }

            default:
                list(req, resp, accountId);
        }
    }

    /* ------------ POST ------------ */

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Long accountId = currentAccountId(req);
        if (accountId == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "create": create(req, resp); break;
            case "update": update(req, resp, accountId); break;
            case "delete": delete(req, resp, accountId); break;
            default:       list(req, resp, accountId);
        }
    }

    /* ------------ handlers ------------ */

    private void list(HttpServletRequest req, HttpServletResponse resp, Long customerAccountId)
            throws ServletException, IOException {
        List<Pet> pets = petDAO.findByCustomerId(customerAccountId);
        req.setAttribute("pets", pets);
        req.getRequestDispatcher("/views/customer/pet-list.jsp").forward(req, resp);
    }

    private void create(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        Customer customer = currentCustomer(req);
        if (customer == null) {

            req.getSession().setAttribute("flash", "Cannot create pet: user is not a Customer.");
            resp.sendRedirect(req.getContextPath() + "/customer/pets?action=list");
            return;
        }

        Pet p = new Pet();
        p.setCustomer(customer);

        p.setName(req.getParameter("name"));
        p.setSpecies(req.getParameter("species"));
        p.setBreed(req.getParameter("breed"));
        p.setGender(req.getParameter("gender"));
        p.setHealthStatus(req.getParameter("healthStatus"));
        p.setMedicalNotes(req.getParameter("medicalNotes"));

        String age = req.getParameter("age");
        p.setAge(isBlank(age) ? null : Integer.valueOf(age));

        String dob = req.getParameter("dateOfBirth");
        p.setDateOfBirth(isBlank(dob) ? null : LocalDate.parse(dob));

        String weight = req.getParameter("weight");
        p.setWeight(isBlank(weight) ? null : new BigDecimal(weight));

        petDAO.addPet(p);
        resp.sendRedirect(req.getContextPath() + "/customer/pets?action=list");
    }

    private void update(HttpServletRequest req, HttpServletResponse resp, Long accountId)
            throws IOException {
        Long petId = Long.valueOf(req.getParameter("id"));
        Pet p = getPetById(petId);
        if (p == null || p.getCustomer() == null ||
                !accountId.equals(p.getCustomer().getAccountId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        p.setName(req.getParameter("name"));
        p.setSpecies(req.getParameter("species"));
        p.setBreed(req.getParameter("breed"));
        p.setGender(req.getParameter("gender"));
        p.setHealthStatus(req.getParameter("healthStatus"));
        p.setMedicalNotes(req.getParameter("medicalNotes"));

        String age = req.getParameter("age");
        p.setAge(isBlank(age) ? null : Integer.valueOf(age));

        String dob = req.getParameter("dateOfBirth");
        p.setDateOfBirth(isBlank(dob) ? null : LocalDate.parse(dob));

        String weight = req.getParameter("weight");
        p.setWeight(isBlank(weight) ? null : new BigDecimal(weight));

        petDAO.updatePet(p);
        resp.sendRedirect(req.getContextPath() + "/customer/pets?action=list");
    }

    private void delete(HttpServletRequest req, HttpServletResponse resp, Long accountId)
            throws IOException {
        Long petId = Long.valueOf(req.getParameter("id"));
        petDAO.deleteOwned(petId, accountId);
        resp.sendRedirect(req.getContextPath() + "/customer/pets?action=list");
    }
}
