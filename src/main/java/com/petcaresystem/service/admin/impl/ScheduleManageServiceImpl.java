package com.petcaresystem.service.admin.impl;

import com.petcaresystem.dao.RuleSetDAO;
import com.petcaresystem.enities.RuleSet;
import com.petcaresystem.enities.embeddable.DaySchedule;
import com.petcaresystem.enities.embeddable.WeeklySchedule;
import com.petcaresystem.service.admin.IScheduleManageService;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

public class ScheduleManageServiceImpl implements IScheduleManageService {

    private final RuleSetDAO ruleSetDAO = new RuleSetDAO();

    @Override
    public List<RuleSet> getAllRuleSets() {
        return ruleSetDAO.getAllRuleSets();
    }

    @Override
    public RuleSet getRuleSetById(Long ruleSetId) {
        return ruleSetDAO.getRuleSetById(ruleSetId);
    }

    @Override
    public RuleSet getRuleSetByOwner(String ownerType, Long ownerId) {
        return ruleSetDAO.getRuleSetByOwner(ownerType, ownerId);
    }

    @Override
    public boolean createRuleSet(String ownerType, Long ownerId, WeeklySchedule weeklySchedule, boolean active) {
        if (!validateSchedule(weeklySchedule)) {
            return false;
        }
        
        RuleSet ruleSet = RuleSet.builder()
                .ownerType(ownerType)
                .ownerId(ownerId)
                .weeklySchedule(weeklySchedule)
                .active(active)
                .build();
        
        return ruleSetDAO.createRuleSet(ruleSet);
    }

    @Override
    public boolean updateRuleSet(Long ruleSetId, WeeklySchedule weeklySchedule, boolean active) {
        if (!validateSchedule(weeklySchedule)) {
            return false;
        }
        
        RuleSet existingRuleSet = ruleSetDAO.getRuleSetById(ruleSetId);
        if (existingRuleSet == null) {
            return false;
        }
        
        existingRuleSet.setWeeklySchedule(weeklySchedule);
        existingRuleSet.setActive(active);
        
        return ruleSetDAO.updateRuleSet(existingRuleSet);
    }

    @Override
    public boolean deleteRuleSet(Long ruleSetId) {
        return ruleSetDAO.deleteRuleSet(ruleSetId);
    }

    @Override
    public boolean isOpenOnDay(String ownerType, Long ownerId, DayOfWeek dayOfWeek) {
        RuleSet ruleSet = getRuleSetByOwner(ownerType, ownerId);
        if (ruleSet == null || !ruleSet.isActive()) {
            return false;
        }
        
        Optional<DaySchedule> daySchedule = ruleSet.getWeeklySchedule().get(dayOfWeek);
        return daySchedule.isPresent() && daySchedule.get().isOpen();
    }

    @Override
    public boolean isAvailableAtTime(String ownerType, Long ownerId, DayOfWeek dayOfWeek, LocalTime time) {
        RuleSet ruleSet = getRuleSetByOwner(ownerType, ownerId);
        if (ruleSet == null || !ruleSet.isActive()) {
            return false;
        }
        
        Optional<DaySchedule> daySchedule = ruleSet.getWeeklySchedule().get(dayOfWeek);
        if (!daySchedule.isPresent() || !daySchedule.get().isOpen()) {
            return false;
        }
        
        DaySchedule schedule = daySchedule.get();
        return !time.isBefore(schedule.getOpenTime()) && !time.isAfter(schedule.getCloseTime());
    }

    @Override
    public boolean validateSchedule(WeeklySchedule weeklySchedule) {
        if (weeklySchedule == null || weeklySchedule.getDays() == null) {
            return false;
        }
        
        // Validate each day schedule
        for (DaySchedule daySchedule : weeklySchedule.getDays()) {
            if (!daySchedule.isTimeValid()) {
                return false;
            }
        }
        
        return true;
    }
}
