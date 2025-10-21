package com.petcaresystem.controller.pet;

import com.petcaresystem.dao.PetServiceHistoryDAO;
import com.petcaresystem.enities.PetServiceHistory;
import com.petcaresystem.enities.Pet;
import com.petcaresystem.enities.Staff;
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
                request.getRequestDispatcher("/petdata/pet-service-history-add.jsp").forward(request, response);
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
        request.getRequestDispatcher("/petdata/pet-service-history.jsp").forward(request, response);
    }

    // ✅ Hiển thị lịch sử dịch vụ theo ID thú cưng
    private void viewByPet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idpet = Integer.parseInt(request.getParameter("idpet"));
        List<PetServiceHistory> histories = petServiceHistoryDAO.getHistoriesByPetId(idpet);
        request.setAttribute("historyList", histories);
        request.setAttribute("petId", idpet);
        request.getRequestDispatcher("/petdata/pet-service-history.jsp").forward(request, response);
    }

    // ✅ Thêm lịch sử dịch vụ
    private void addHistory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String serviceType = request.getParameter("serviceType");
            String serviceDate = request.getParameter("serviceDate");
            String description = request.getParameter("description");
            double cost = Double.parseDouble(request.getParameter("cost"));
            long idpet = Long.parseLong(request.getParameter("idpet"));
            
            String staffIdParam = request.getParameter("staffId");
            Long staffId = (staffIdParam != null && !staffIdParam.isEmpty()) ? Long.parseLong(staffIdParam) : null;

            Pet pet = new Pet();
            pet.setIdpet(idpet);

            PetServiceHistory newHistory = new PetServiceHistory();
            newHistory.setServiceType(serviceType);
            newHistory.setServiceDate(java.time.LocalDate.parse(serviceDate));
            newHistory.setDescription(description);
            newHistory.setCost(cost);
            newHistory.setPet(pet);
            
            if (staffId != null) {
                Staff staff = new Staff();
                staff.setAccountId(staffId);
                newHistory.setStaff(staff);
            }

            petServiceHistoryDAO.addHistory(newHistory);
            request.getSession().setAttribute("success", "Service history added successfully!");
            response.sendRedirect("petServiceHistory?action=list");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to add service history: " + e.getMessage());
            response.sendRedirect("petServiceHistory?action=add");
        }
    }

    // ✅ Xóa lịch sử dịch vụ
    private void deleteHistory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("idhistory"));
            petServiceHistoryDAO.deleteHistory(id);
            request.getSession().setAttribute("success", "Service history deleted successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to delete service history: " + e.getMessage());
        }
        response.sendRedirect("petServiceHistory?action=list");
    }
}
