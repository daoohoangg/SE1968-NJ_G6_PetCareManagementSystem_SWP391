package com.petcaresystem.controller.pet;

import com.petcaresystem.dao.PetServiceHistoryDAO;
import com.petcaresystem.enities.PetServiceHistory;
import com.petcaresystem.enities.Pet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "PetServiceHistoryController", urlPatterns = {"/petServiceHistory"})
public class PetServiceHistoryController extends HttpServlet {

    private PetServiceHistoryDAO petServiceHistoryDAO;

    @Override
    public void init() throws ServletException {
        petServiceHistoryDAO = new PetServiceHistoryDAO();
    }

    // ------------------- XỬ LÝ GET -------------------
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                request.getRequestDispatcher("/views/pet_service_history_add.jsp").forward(request, response);
                break;
            case "delete":
                deleteHistory(request, response);
                break;
            case "viewByPet":
                viewByPet(request, response);
                break;
            default:
                listHistories(request, response);
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
                addHistory(request, response);
                break;
            default:
                listHistories(request, response);
                break;
        }
    }

    // ------------------- CÁC HÀM XỬ LÝ -------------------

    // ✅ Hiển thị toàn bộ lịch sử dịch vụ
    private void listHistories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<PetServiceHistory> histories = petServiceHistoryDAO.getAllHistories();
        request.setAttribute("historyList", histories);
        request.getRequestDispatcher("/views/pet_service_history_list.jsp").forward(request, response);
    }

    // ✅ Hiển thị lịch sử dịch vụ theo ID thú cưng
    private void viewByPet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idpet = Integer.parseInt(request.getParameter("idpet"));
        List<PetServiceHistory> histories = petServiceHistoryDAO.getHistoriesByPetId(idpet);
        request.setAttribute("historyList", histories);
        request.setAttribute("petId", idpet);
        request.getRequestDispatcher("/views/pet_service_history_list.jsp").forward(request, response);
    }

    // ✅ Thêm lịch sử dịch vụ
    private void addHistory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String serviceType = request.getParameter("serviceType");
        String serviceDate = request.getParameter("serviceDate");
        String notes = request.getParameter("notes");
        int idpet = Integer.parseInt(request.getParameter("idpet"));

        Pet pet = new Pet();
        pet.setIdpet(idpet);

        PetServiceHistory newHistory = new PetServiceHistory();
        newHistory.setServiceType(serviceType);
        //newHistory.setServiceDate(Date.valueOf(serviceDate));
        //newHistory.setNotes(notes);
        newHistory.setPet(pet);

        petServiceHistoryDAO.addHistory(newHistory);
        response.sendRedirect("petServiceHistory?action=viewByPet&idpet=" + idpet);
    }

    // ✅ Xóa lịch sử dịch vụ
    private void deleteHistory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("idhistory"));
        petServiceHistoryDAO.deleteHistory(id);
        response.sendRedirect("petServiceHistory?action=list");
    }
}
