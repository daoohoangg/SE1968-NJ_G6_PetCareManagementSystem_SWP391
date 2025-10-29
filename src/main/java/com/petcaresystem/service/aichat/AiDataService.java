package com.petcaresystem.service.aichat;

import com.petcaresystem.dao.AiDataDAO;
import com.petcaresystem.enities.AiData;

import java.util.List;
import java.util.Optional;

public class AiDataService {
    
    private final AiDataDAO aiDataDAO;
    
    public AiDataService() {
        this.aiDataDAO = new AiDataDAO();
    }
    
    /**
     * Save or update AI data
     */
    public boolean saveAiData(AiData aiData) {
        return aiDataDAO.saveOrUpdate(aiData);
    }
    
    /**
     * Get AI data by ID
     */
    public Optional<AiData> getAiDataById(Long id) {
        return aiDataDAO.findById(id);
    }
    
    /**
     * Get all AI data
     */
    public List<AiData> getAllAiData() {
        return aiDataDAO.findAll();
    }
    
    /**
     * Get AI data by creativity level
     */
    public List<AiData> getAiDataByCreativityLevel(int creativityLevel) {
        return aiDataDAO.findByCreativityLevel(creativityLevel);
    }
    
    /**
     * Search AI data by prompt content
     */
    public List<AiData> searchAiDataByPrompt(String prompt) {
        return aiDataDAO.findByPromptContaining(prompt);
    }
    
    /**
     * Get the first AI data (default configuration)
     */
    public Optional<AiData> getDefaultAiData() {
        return aiDataDAO.getFirst();
    }
    
    /**
     * Get the latest AI data
     */
    public Optional<AiData> getLatestAiData() {
        return aiDataDAO.getLatest();
    }
    
    /**
     * Delete AI data by ID
     */
    public boolean deleteAiData(Long id) {
        return aiDataDAO.deleteById(id);
    }
    
    /**
     * Get total count of AI data
     */
    public long getTotalCount() {
        return aiDataDAO.getTotalCount();
    }
    
    /**
     * Get count by creativity level
     */
    public long getCountByCreativityLevel(int creativityLevel) {
        return aiDataDAO.getCountByCreativityLevel(creativityLevel);
    }
    
    /**
     * Check if AI data exists
     */
    public boolean exists(Long id) {
        return aiDataDAO.exists(id);
    }
    
    /**
     * Update only the prompt content
     */
    public boolean updatePrompt(Long id, String newPrompt) {
        return aiDataDAO.updatePrompt(id, newPrompt);
    }
    
    /**
     * Update only the creativity level
     */
    public boolean updateCreativityLevel(Long id, int newCreativityLevel) {
        return aiDataDAO.updateCreativityLevel(id, newCreativityLevel);
    }
    
    /**
     * Create new AI data
     */
    public AiData createAiData(String prompt, int creativityLevel) {
        AiData aiData = new AiData();
        aiData.setPrompt(prompt);
        aiData.setCreativityLevel(creativityLevel);
        return aiData;
    }
    
    /**
     * Get current AI configuration (latest or default)
     */
    public AiData getCurrentConfiguration() {
        // Try to get the latest configuration first
        Optional<AiData> latest = getLatestAiData();
        if (latest.isPresent()) {
            return latest.get();
        }
        
        // Fallback to default configuration
        Optional<AiData> defaultConfig = getDefaultAiData();
        if (defaultConfig.isPresent()) {
            return defaultConfig.get();
        }
        
        // Create a default configuration if none exists
        AiData defaultAiData = createDefaultConfiguration();
        saveAiData(defaultAiData);
        return defaultAiData;
    }
    
    /**
     * Create default AI configuration
     */
    private AiData createDefaultConfiguration() {
        String defaultPrompt = """
            You are a helpful AI assistant for a pet care management system. 
            Provide professional, caring, and accurate advice about pet care services, 
            scheduling, and customer support. Always prioritize pet welfare and customer satisfaction.
            
            Guidelines:
            - Be friendly and professional
            - Provide accurate pet care information
            - Help with appointment scheduling
            - Offer service recommendations
            - Maintain a caring and supportive tone
            """;
        
        return createAiData(defaultPrompt, 40);
    }
    
    /**
     * Update AI configuration
     */
    public boolean updateConfiguration(String prompt, int creativityLevel) {
        // Get current configuration
        AiData currentConfig = getCurrentConfiguration();
        
        if (currentConfig.getId() != null) {
            // Update existing configuration
            currentConfig.setPrompt(prompt);
            currentConfig.setCreativityLevel(creativityLevel);
            return saveAiData(currentConfig);
        } else {
            // Create new configuration
            AiData newConfig = createAiData(prompt, creativityLevel);
            return saveAiData(newConfig);
        }
    }
    
    /**
     * Get formatted prompt for AI usage
     */
    public String getFormattedPrompt() {
        AiData config = getCurrentConfiguration();
        return config.getPrompt();
    }
    
    /**
     * Get current creativity level
     */
    public int getCurrentCreativityLevel() {
        AiData config = getCurrentConfiguration();
        return config.getCreativityLevel();
    }
    
    /**
     * Validate creativity level
     */
    public boolean isValidCreativityLevel(int level) {
        return level >= 0 && level <= 100;
    }
    
    /**
     * Validate prompt content
     */
    public boolean isValidPrompt(String prompt) {
        return prompt != null && !prompt.trim().isEmpty() && prompt.length() <= 10000;
    }
    
    /**
     * Get AI configuration statistics
     */
    public java.util.Map<String, Object> getConfigurationStats() {
        java.util.Map<String, Object> stats = new java.util.HashMap<>();
        
        stats.put("totalConfigurations", getTotalCount());
        stats.put("currentCreativityLevel", getCurrentCreativityLevel());
        
        // Count by creativity level ranges
        stats.put("lowCreativity", getCountByCreativityLevel(0) + getCountByCreativityLevel(25));
        stats.put("mediumCreativity", getCountByCreativityLevel(50));
        stats.put("highCreativity", getCountByCreativityLevel(75) + getCountByCreativityLevel(100));
        
        return stats;
    }
}

