package com.petcaresystem.controller.pet;

import com.petcaresystem.dao.PetServiceHistoryDAO;
import com.petcaresystem.dao.PetDAO;
import com.petcaresystem.dao.StaffDAO;
import com.petcaresystem.enities.PetServiceHistory;
import com.petcaresystem.enities.Pet;
import com.petcaresystem.enities.Staff;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "PetServiceHistoryController", urlPatterns = {"/petServiceHistory"})
public class PetServiceHistoryController extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private PetServiceHistoryDAO historyDAO;
    private PetServiceHistoryDAO petServiceHistoryDAO;
    private PetDAO petDAO;
    private StaffDAO staffDAO;

    @Override
    public void init() throws ServletException {
        historyDAO = new PetServiceHistoryDAO();
        petServiceHistoryDAO = new PetServiceHistoryDAO();
        petDAO = new PetDAO();
        staffDAO = new StaffDAO();
    }

    // ------------------- XỬ LÝ GET -------------------
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "view":
                viewDetail(request, response); // UC-PD-04
                break;
            case "delete":
                deleteHistory(request, response);
                break;
            case "viewByPet":
                viewByPet(request, response);
                break;
            case "export":
                exportRecords(request, response); // UC-PD-05
                break;
            default:
                listHistories(request, response); // UC-PD-01, UC-PD-02
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

    // ✅ UC-PD-01 & UC-PD-02: List with Search/Filter and Pagination
    private void listHistories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get pagination parameters
        int page = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        
        // Get search/filter parameters
        String searchTerm = request.getParameter("search");
        String serviceType = request.getParameter("serviceType");
        String petIdParam = request.getParameter("petId");
        Integer petId = null;
        
        if (petIdParam != null && !petIdParam.isEmpty()) {
            try {
                petId = Integer.parseInt(petIdParam);
            } catch (NumberFormatException e) {
                // Ignore invalid petId
            }
        }
        
        // Get filtered/searched results with pagination
        List<PetServiceHistory> histories;
        long totalRecords;
        
        if ((searchTerm != null && !searchTerm.trim().isEmpty()) || 
            (serviceType != null && !serviceType.equals("All")) ||
            (petId != null && petId > 0)) {
            // Search/Filter mode
            histories = historyDAO.searchAndFilter(searchTerm, serviceType, petId, page, PAGE_SIZE);
            totalRecords = historyDAO.countSearchAndFilter(searchTerm, serviceType, petId);
        } else {
            // Normal list mode
            histories = historyDAO.getAllHistories(page, PAGE_SIZE);
            totalRecords = historyDAO.countAllHistories();
        }
        
        // Calculate pagination
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        
        // Get service types for filter dropdown
        List<String> serviceTypes = historyDAO.getDistinctServiceTypes();
        
        // Set attributes
        request.setAttribute("historyList", histories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("serviceTypes", serviceTypes);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("selectedServiceType", serviceType);
        request.setAttribute("selectedPetId", petId);
        
        request.getRequestDispatcher("/petdata/pet-service-history.jsp").forward(request, response);
    }

    // ✅ UC-PD-01: View by Pet with Pagination
    private void viewByPet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int petId = Integer.parseInt(request.getParameter("idpet"));
            
            // Get pagination
            int page = 1;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null) page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
            
            List<PetServiceHistory> histories = historyDAO.getHistoriesByPetId(petId, page, PAGE_SIZE);
            long totalRecords = historyDAO.countHistoriesByPetId(petId);
            int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
            
            Pet pet = petDAO.getPetById((long) petId);
            
            request.setAttribute("historyList", histories);
            request.setAttribute("selectedPet", pet);
            request.setAttribute("selectedPetId", petId);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            
            request.getRequestDispatcher("/petdata/pet-service-history.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to load pet history: " + e.getMessage());
            response.sendRedirect("petServiceHistory");
        }
    }
    
    // ✅ UC-PD-04: View Record Detail
    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            PetServiceHistory history = historyDAO.getHistoryById(id);
            
            if (history == null) {
                request.getSession().setAttribute("error", "Record not found.");
                response.sendRedirect("petServiceHistory");
                return;
            }
            
            request.setAttribute("history", history);
            request.getRequestDispatcher("/petdata/record-detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to load record detail: " + e.getMessage());
            response.sendRedirect("petServiceHistory");
        }
    }
    
    // ✅ Show add form with pet and staff lists
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Pet> pets = petDAO.getAllPets();
            List<Staff> staffList = staffDAO.getAllStaff();
            List<String> serviceTypes = historyDAO.getDistinctServiceTypes();
            
            request.setAttribute("pets", pets);
            request.setAttribute("staffList", staffList);
            request.setAttribute("serviceTypes", serviceTypes);
            
            request.getRequestDispatcher("/petdata/pet-service-history-add.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to load form: " + e.getMessage());
            response.sendRedirect("petServiceHistory");
        }
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
                //Staff staff = new Staff();
               // staff.setAccountId(staffId);
               // newHistory.setStaff(staff);
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

    // Xóa lịch sử dịch vụ
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
    
    // UC-PD-05: Export Records (Placeholder)
    private void exportRecords(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String searchTerm = request.getParameter("search");
            String serviceType = request.getParameter("serviceType");
            String petIdParam = request.getParameter("petId");
            Integer petId = null;
            
            if (petIdParam != null && !petIdParam.isEmpty()) {
                petId = Integer.parseInt(petIdParam);
            }
            
            List<PetServiceHistory> histories;
            if ((searchTerm != null && !searchTerm.trim().isEmpty()) || 
                (serviceType != null && !serviceType.equals("All")) ||
                (petId != null && petId > 0)) {
                histories = historyDAO.searchAndFilter(searchTerm, serviceType, petId, 1, Integer.MAX_VALUE);
            } else {
                histories = historyDAO.getAllHistories(1, Integer.MAX_VALUE);
            }
            
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=\"pet_service_history.csv\"");
            
            var writer = response.getWriter();
            writer.println("ID,Pet Name,Service Type,Description,Service Date,Cost,Staff,Rating,Notes");
            
            for (PetServiceHistory h : histories) {
                writer.printf("%d,\"%s\",\"%s\",\"%s\",%s,%.2f,\"%s\",%s,\"%s\"%n",
                    h.getId(),
                    h.getPet().getName(),
                    h.getServiceType(),
                    h.getDescription() != null ? h.getDescription().replace("\"", "\"\"") : "",
                    h.getFormattedDate(),
                    h.getCost(),
                    h.getStaff() != null ? h.getStaff().getFullName() : "N/A",
                    h.getRating() != null ? h.getRating() : "N/A",
                    h.getNotes() != null ? h.getNotes().replace("\"", "\"\"") : ""
                );
            }
            
            writer.flush();
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to export records: " + e.getMessage());
            response.sendRedirect("petServiceHistory");
        }
    }
}
