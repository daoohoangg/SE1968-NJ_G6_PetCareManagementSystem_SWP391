package com.petcaresystem.controller.pet;

import com.petcaresystem.dao.PetDAO;
import com.petcaresystem.dao.PetServiceHistoryDAO;
import com.petcaresystem.enities.Pet;
import com.petcaresystem.enities.Account;
import com.petcaresystem.enities.PetServiceHistory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "PetController", urlPatterns = {"/pet"})
public class PetController extends HttpServlet {

    private PetDAO petDAO;
    private PetServiceHistoryDAO historyDAO;

    @Override
    public void init() throws ServletException {
        petDAO = new PetDAO();
        historyDAO = new PetServiceHistoryDAO();
    }

    // ------------------- XỬ LÝ GET -------------------
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                request.getRequestDispatcher("/views/pet-add.jsp").forward(request, response);
                break;
            case "delete":
                deletePet(request, response);
                break;
            case "view": // 🆕 Xem chi tiết hồ sơ thú cưng
                viewPetProfile(request, response);
                break;
            default:
                listPet(request, response);
                break;
        }
    }

    // ------------------- XỬ LÝ POST -------------------
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                addPet(request, response);
                break;
            default:
                listPet(request, response);
                break;
        }
    }

    // ------------------- CÁC HÀM XỬ LÝ -------------------

    private void listPet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Pet> pets = petDAO.getPet();
        request.setAttribute("petList", pets);
        request.getRequestDispatcher("/views/pet-list.jsp").forward(request, response);
    }

    private void addPet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String name = request.getParameter("name");
        String breed = request.getParameter("breed");
        int age = Integer.parseInt(request.getParameter("age"));
        String healthStatus = request.getParameter("healthStatus");

        // 🔸 Giả lập lấy chủ sở hữu (owner) từ session hoặc tạo tạm
        Account owner = new Account();
        owner.setIdaccount(1); // sau này thay bằng user đang đăng nhập

        Pet newPet = new Pet();
        newPet.setName(name);
        newPet.setBreed(breed);
        newPet.setAge(age);
        newPet.setHealthStatus(healthStatus);
        newPet.setOwner(owner);

        petDAO.addPet(newPet);
        response.sendRedirect("pet?action=list");
    }

    private void deletePet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        petDAO.deletePet(id);
        response.sendRedirect("pet?action=list");
    }

    // ------------------- 🆕 XEM HỒ SƠ THÚ CƯNG -------------------
    private void viewPetProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int petId = Integer.parseInt(request.getParameter("id"));
        Pet pet = petDAO.getPetById(petId);
        List<PetServiceHistory> histories = historyDAO.getHistoriesByPetId(petId);

        request.setAttribute("pet", pet);
        request.setAttribute("historyList", histories);

        // Chuyển đến trang xem hồ sơ chi tiết
        request.getRequestDispatcher("/views/pet-profile.jsp").forward(request, response);
    }
}
