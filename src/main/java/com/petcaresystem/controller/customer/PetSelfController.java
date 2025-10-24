package com.petcaresystem.controller.customer;

import com.petcaresystem.dao.PetDAO;
import com.petcaresystem.enities.Account;
import com.petcaresystem.enities.enu.AccountRoleEnum;
import com.petcaresystem.enities.Pet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

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
}
