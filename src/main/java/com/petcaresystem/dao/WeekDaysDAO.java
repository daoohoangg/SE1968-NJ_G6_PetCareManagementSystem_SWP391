package com.petcaresystem.dao;

import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class WeekDaysDAO {

    private static final Logger LOGGER = Logger.getLogger(WeekDaysDAO.class.getName());

    public Map<String, Map<String, Object>> getClinicSchedule() {
        Map<String, Map<String, Object>> scheduleMap = new HashMap<>();
        
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Query trực tiếp bảng rule_week_days
            Query<Object[]> query = session.createNativeQuery(
                "SELECT day_of_week, is_open, open_time, close_time " +
                "FROM rule_week_days rwd " +
                "JOIN rule_sets rs ON rwd.rule_set_id = rs.rule_set_id " +
                "WHERE rs.owner_type = 'CLINIC' AND rs.owner_id = 1"
            );
            
            for (Object[] row : query.list()) {
                String dayOfWeek = (String) row[0];
                Boolean isOpen = (Boolean) row[1];
                LocalTime openTime = row[2] != null ? ((java.sql.Time) row[2]).toLocalTime() : null;
                LocalTime closeTime = row[3] != null ? ((java.sql.Time) row[3]).toLocalTime() : null;
                
                Map<String, Object> dayData = new HashMap<>();
                dayData.put("open", isOpen);
                dayData.put("openTime", openTime);
                dayData.put("closeTime", closeTime);
                
                scheduleMap.put(dayOfWeek, dayData);
            }
            
            // Nếu chưa có data, tạo default schedule
            if (scheduleMap.isEmpty()) {
                LOGGER.info("No existing schedule data found. Creating default schedule...");
                for (DayOfWeek day : DayOfWeek.values()) {
                    boolean isOpen = day != DayOfWeek.SUNDAY;
                    LocalTime openTime = day == DayOfWeek.SATURDAY ? LocalTime.of(9, 0) : LocalTime.of(8, 0);
                    LocalTime closeTime = day == DayOfWeek.SATURDAY ? LocalTime.of(17, 0) : LocalTime.of(18, 0);
                    
                    Map<String, Object> dayData = new HashMap<>();
                    dayData.put("open", isOpen);
                    dayData.put("openTime", openTime);
                    dayData.put("closeTime", closeTime);
                    
                    scheduleMap.put(day.name(), dayData);
                }
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load clinic schedule", e);
        }
        
        return scheduleMap;
    }

    /**
     * Chỉ cập nhật trạng thái và thời gian của schedule có sẵn
     * Không tạo dữ liệu mới vào bảng rule_week_days
     */
    public boolean updateClinicSchedule(Map<String, Map<String, Object>> scheduleMap) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            
            try {
                // Lấy rule_set_id cho CLINIC
                Query<Long> ruleSetQuery = session.createNativeQuery(
                    "SELECT rule_set_id FROM rule_sets WHERE owner_type = 'CLINIC' AND owner_id = 1", 
                    Long.class
                );
                Long ruleSetId = ruleSetQuery.uniqueResult();
                LOGGER.info("Found rule_set_id: " + ruleSetId);
                
                if (ruleSetId == null) {
                    LOGGER.severe("No existing rule_set found for CLINIC. Please create schedule data first.");
                    tx.rollback();
                    return false;
                }
                
                // Cập nhật từng ngày trong schedule hiện có
                LOGGER.info("Updating existing schedule for rule_set_id: " + ruleSetId);
                LOGGER.info("Schedule map size: " + scheduleMap.size());
                
                String updateSql = "UPDATE rule_week_days SET is_open = :isOpen, open_time = :openTime, close_time = :closeTime " +
                                  "WHERE rule_set_id = :ruleSetId AND day_of_week = :dayOfWeek";
                
                int updatedRows = 0;
                for (Map.Entry<String, Map<String, Object>> entry : scheduleMap.entrySet()) {
                    String dayOfWeek = entry.getKey();
                    Map<String, Object> dayData = entry.getValue();
                    
                    if (dayData == null) {
                        LOGGER.warning("Day data is null for " + dayOfWeek);
                        continue;
                    }
                    
                    Boolean isOpen = (Boolean) dayData.get("open");
                    LocalTime openTime = (LocalTime) dayData.get("openTime");
                    LocalTime closeTime = (LocalTime) dayData.get("closeTime");
                    
                    // Validate data
                    if (isOpen == null) {
                        LOGGER.warning("isOpen is null for " + dayOfWeek + ", setting to false");
                        isOpen = false;
                    }
                    
                    LOGGER.info("Updating " + dayOfWeek + ": open=" + isOpen + ", time=" + openTime + "-" + closeTime);
                    
                    try {
                        // Debug: Kiểm tra dữ liệu trước khi update
                        Query<Object[]> debugQuery = session.createNativeQuery(
                            "SELECT day_of_week, is_open, open_time, close_time " +
                            "FROM rule_week_days WHERE rule_set_id = :ruleSetId AND day_of_week = :dayOfWeek"
                        );
                        debugQuery.setParameter("ruleSetId", ruleSetId);
                        debugQuery.setParameter("dayOfWeek", dayOfWeek);
                        
                        Object[] existingRow = (Object[]) debugQuery.uniqueResult();
                        if (existingRow != null) {
                            LOGGER.info("Found existing data for " + dayOfWeek + ": " + java.util.Arrays.toString(existingRow));
                        } else {
                            LOGGER.warning("No existing data found for " + dayOfWeek + " with ruleSetId=" + ruleSetId);
                        }
                        
                        Query<?> updateQuery = session.createNativeQuery(updateSql);
                        updateQuery.setParameter("isOpen", isOpen);
                        updateQuery.setParameter("openTime", openTime != null ? java.sql.Time.valueOf(openTime) : null);
                        updateQuery.setParameter("closeTime", closeTime != null ? java.sql.Time.valueOf(closeTime) : null);
                        updateQuery.setParameter("ruleSetId", ruleSetId);
                        updateQuery.setParameter("dayOfWeek", dayOfWeek);
                        
                        LOGGER.info("Update SQL: " + updateSql);
                        LOGGER.info("Parameters: ruleSetId=" + ruleSetId + ", dayOfWeek=" + dayOfWeek + ", isOpen=" + isOpen);
                        
                        int rowsAffected = updateQuery.executeUpdate();
                        if (rowsAffected > 0) {
                            updatedRows++;
                            LOGGER.info("Updated " + dayOfWeek + " (" + rowsAffected + " rows)");
                        } else {
                            LOGGER.warning("No rows updated for " + dayOfWeek + " - day may not exist in database");
                        }
                    } catch (Exception e) {
                        LOGGER.log(Level.SEVERE, "Failed to update " + dayOfWeek, e);
                        throw e; // Re-throw to trigger rollback
                    }
                }
                
                tx.commit();
                LOGGER.info("Successfully updated " + updatedRows + " days in clinic schedule");
                return updatedRows > 0;
                
            } catch (Exception e) {
                if (tx != null) {
                    try {
                        tx.rollback();
                    } catch (Exception rollbackEx) {
                        LOGGER.log(Level.SEVERE, "Failed to rollback transaction", rollbackEx);
                    }
                }
                LOGGER.log(Level.SEVERE, "WeekDaysDAO Error: " + e.getClass().getSimpleName() + " - " + e.getMessage(), e);
                throw e;
            }
        }
    }
}