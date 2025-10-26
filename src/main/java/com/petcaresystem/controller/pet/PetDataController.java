package com.petcaresystem.controller.pet;

import com.petcaresystem.dao.PetDAO;
import com.petcaresystem.dao.PetServiceHistoryDAO;
import com.petcaresystem.dao.StaffDAO;
import com.petcaresystem.enities.Pet;
import com.petcaresystem.enities.PetServiceHistory;
import com.petcaresystem.enities.Staff;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "PetDataController", urlPatterns = {"/petServiceData"})
public class PetDataController extends HttpServlet {

    private PetServiceHistoryDAO historyDAO;
    private PetDAO petDAO;
    private StaffDAO staffDAO;

    @Override
    public void init() {
        historyDAO = new PetServiceHistoryDAO();
        petDAO = new PetDAO();
        staffDAO = new StaffDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "view":
                viewRecordDetail(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "export":
                exportRecords(request, response);
                break;
            default:
                listRecords(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addRecord(request, response);
        } else if ("delete".equals(action)) {
            deleteRecord(request, response);
        }
    }

    // UC-PD-01: View Records & UC-PD-02: Search & Filter
    private void listRecords(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String searchTerm = request.getParameter("search");
        String serviceType = request.getParameter("serviceType");
        
        List<PetServiceHistory> records;
        
        // Search and filter
        if ((searchTerm != null && !searchTerm.trim().isEmpty()) || 
            (serviceType != null && !serviceType.equals("All Services"))) {
            records = historyDAO.searchAndFilter(searchTerm, serviceType);
        } else {
            records = historyDAO.getAllHistories();
        }
        
        // Get distinct service types for filter dropdown
        List<String> serviceTypes = historyDAO.getDistinctServiceTypes();
        
        request.setAttribute("records", records);
        request.setAttribute("serviceTypes", serviceTypes);
        request.setAttribute("currentSearch", searchTerm);
        request.setAttribute("currentServiceType", serviceType);
        
        request.getRequestDispatcher("/petdata/pet-data.jsp").forward(request, response);
    }

    // UC-PD-04: View Record Detail
    private void viewRecordDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int recordId = Integer.parseInt(request.getParameter("id"));
            PetServiceHistory record = historyDAO.getHistoryById(recordId);
            
            if (record != null) {
                request.setAttribute("record", record);
                request.getRequestDispatcher("/petdata/record-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/petServiceHistory?error=notfound");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/petServiceHistory?error=invalid");
        }
    }

    // UC-PD-03: Add Record - Show Form
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Load pets and staff for dropdowns
        List<Pet> pets = petDAO.getAllPets();
        List<Staff> staffList = staffDAO.getAllStaff();
        
        request.setAttribute("pets", pets);
        request.setAttribute("staffList", staffList);
        
        request.getRequestDispatcher("/petdata/add-record.jsp").forward(request, response);
    }

    // UC-PD-03: Add Record - Process Form
    private void addRecord(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        try {
            long petId = Integer.parseInt(request.getParameter("petId"));
            int staffId = Integer.parseInt(request.getParameter("staffId"));
            String serviceType = request.getParameter("serviceType");
            String description = request.getParameter("description");
            LocalDate serviceDate = LocalDate.parse(request.getParameter("serviceDate"));
            double cost = Double.parseDouble(request.getParameter("cost"));
            String notes = request.getParameter("notes");
            
            Integer rating = null;
            String ratingParam = request.getParameter("rating");
            if (ratingParam != null && !ratingParam.trim().isEmpty()) {
                rating = Integer.parseInt(ratingParam);
            }
            
            Pet pet = petDAO.getPetById(petId);
            Staff staff = staffDAO.getStaffById((long) staffId);
            
            if (pet != null && staff != null) {
                PetServiceHistory history = new PetServiceHistory();
                history.setPet(pet);
                history.setStaff(staff);
                history.setServiceType(serviceType);
                history.setDescription(description);
                history.setServiceDate(serviceDate);
                history.setCost(cost);
                history.setNotes(notes);
                history.setRating(rating);
                
                historyDAO.addHistory(history);
                
                request.getSession().setAttribute("success", "Service record added successfully!");
            } else {
                request.getSession().setAttribute("error", "Pet or Staff not found!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to add record: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/petServiceHistory");
    }

    // Delete Record
    private void deleteRecord(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        try {
            int recordId = Integer.parseInt(request.getParameter("id"));
            historyDAO.deleteHistory(recordId);
            request.getSession().setAttribute("success", "Record deleted successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Failed to delete record: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/petServiceHistory");
    }

    // UC-PD-05: Export Records (placeholder - will implement with library)
    private void exportRecords(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String format = request.getParameter("format");
        
        if ("pdf".equals(format)) {
            // TODO: Implement PDF export
            request.getSession().setAttribute("info", "PDF export feature coming soon!");
        } else if ("excel".equals(format)) {
            // TODO: Implement Excel export
            request.getSession().setAttribute("info", "Excel export feature coming soon!");
        }
        
        response.sendRedirect(request.getContextPath() + "/petServiceHistory");
    }
}
