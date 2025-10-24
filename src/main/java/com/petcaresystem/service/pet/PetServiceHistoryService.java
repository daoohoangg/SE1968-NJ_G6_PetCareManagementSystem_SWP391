package com.petcaresystem.service.pet;

import com.petcaresystem.dao.PetServiceHistoryDAO;
import com.petcaresystem.enities.PetServiceHistory;
import java.util.List;

public class PetServiceHistoryService {

    private final PetServiceHistoryDAO petServiceHistoryDAO;

    public PetServiceHistoryService() {
        this.petServiceHistoryDAO = new PetServiceHistoryDAO();
    }

    // ------------------- LẤY TOÀN BỘ -------------------
    public List<PetServiceHistory> getAllHistories() {
        return petServiceHistoryDAO.getAllHistories();
    }

    // ------------------- LẤY THEO ID PET -------------------
    public List<PetServiceHistory> getHistoriesByPetId(int petId) {
        if (petId <= 0) return null;
        return petServiceHistoryDAO.getHistoriesByPetId(petId);
    }

    // ------------------- LẤY THEO ID LỊCH SỬ -------------------
    public PetServiceHistory getHistoryById(int id) {
        if (id <= 0) return null;
        return petServiceHistoryDAO.getHistoryById(id);
    }

    // ------------------- THÊM MỚI -------------------
    public boolean addHistory(PetServiceHistory history) {
        if (history == null) return false;
        petServiceHistoryDAO.addHistory(history);
        return true;
    }
    

    // ------------------- XÓA -------------------
    public boolean deleteHistory(int id) {
        if (id <= 0) return false;
        petServiceHistoryDAO.deleteHistory(id);
        return true;
    }
}
