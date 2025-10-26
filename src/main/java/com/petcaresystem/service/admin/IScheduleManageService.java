package com.petcaresystem.service.admin;

import com.petcaresystem.enities.RuleSet;
import com.petcaresystem.enities.embeddable.WeeklySchedule;

import java.util.List;

public interface IScheduleManageService {
    
    // CRUD operations
    List<RuleSet> getAllRuleSets();
    RuleSet getRuleSetById(Long ruleSetId);
    RuleSet getRuleSetByOwner(String ownerType, Long ownerId);
    
    boolean createRuleSet(String ownerType, Long ownerId, WeeklySchedule weeklySchedule, boolean active);
    boolean updateRuleSet(Long ruleSetId, WeeklySchedule weeklySchedule, boolean active);
    boolean deleteRuleSet(Long ruleSetId);
    
    // Business operations
    boolean isOpenOnDay(String ownerType, Long ownerId, java.time.DayOfWeek dayOfWeek);
    boolean isAvailableAtTime(String ownerType, Long ownerId, java.time.DayOfWeek dayOfWeek, java.time.LocalTime time);
    
    // Validation
    boolean validateSchedule(WeeklySchedule weeklySchedule);
}
