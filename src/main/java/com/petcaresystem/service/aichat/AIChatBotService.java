package com.petcaresystem.service.aichat;

import jakarta.servlet.http.*;
import java.util.*;

/**
 * Service for AI chatbot functionality
 * Handles AI interactions, suggestions, and recommendations for pet care
 */
public class AIChatBotService {
    
    /**
     * Generate AI-powered suggestions for customer based on their history
     * 
     * @param customerId Customer ID to generate suggestions for
     * @return Map containing calendar suggestions and service recommendations
     */
    public Map<String, Object> generateCustomerSuggestions(Integer customerId) {
        Map<String, Object> suggestions = new HashMap<>();
        
        try {
            // Generate calendar suggestions based on pet history patterns
            List<Map<String, Object>> calendarSuggestions = generateCalendarSuggestions(customerId);
            suggestions.put("calendarSuggestions", calendarSuggestions);
            
            // Generate personalized service recommendations
            List<Map<String, Object>> serviceRecommendations = generateServiceRecommendations(customerId);
            suggestions.put("serviceRecommendations", serviceRecommendations);
            
        } catch (Exception e) {
            e.printStackTrace();
            suggestions.put("error", "Failed to generate suggestions");
        }
        
        return suggestions;
    }

    /**
     * Generate calendar suggestions based on pet history and patterns
     * 
     * @param customerId Customer ID
     * @return List of appointment suggestions with dates and match percentages
     */
    private List<Map<String, Object>> generateCalendarSuggestions(Integer customerId) {
        List<Map<String, Object>> suggestions = new ArrayList<>();
        
        // Analyze typical appointment intervals for different services
        // In real implementation, would analyze actual customer history
        
        Map<String, Object> suggestion1 = new HashMap<>();
        suggestion1.put("service", "Cat Grooming");
        suggestion1.put("date", calculateNextDate(30));
        suggestion1.put("time", "9:30 AM");
        suggestion1.put("matchPercent", 91);
        suggestions.add(suggestion1);
        
        Map<String, Object> suggestion2 = new HashMap<>();
        suggestion2.put("service", "Pet Training");
        suggestion2.put("date", calculateNextDate(45));
        suggestion2.put("time", "3:30 PM");
        suggestion2.put("matchPercent", 86);
        suggestions.add(suggestion2);
        
        Map<String, Object> suggestion3 = new HashMap<>();
        suggestion3.put("service", "Vaccination");
        suggestion3.put("date", calculateNextDate(90));
        suggestion3.put("time", "1:00 PM");
        suggestion3.put("matchPercent", 82);
        suggestions.add(suggestion3);
        
        return suggestions;
    }

    /**
     * Generate personalized service recommendations based on pet characteristics
     * 
     * @param customerId Customer ID
     * @return List of recommended services with confidence scores
     */
    private List<Map<String, Object>> generateServiceRecommendations(Integer customerId) {
        List<Map<String, Object>> recommendations = new ArrayList<>();
        
        // Analyze customer preferences and pet characteristics
        // In real implementation, would use ML models or collaborative filtering
        
        Map<String, Object> rec1 = new HashMap<>();
        rec1.put("serviceName", "Senior Pet Care Package");
        rec1.put("description", "Suitable for older pets needing special attention");
        rec1.put("confidence", 89);
        recommendations.add(rec1);
        
        Map<String, Object> rec2 = new HashMap<>();
        rec2.put("serviceName", "Puppy Socialization");
        rec2.put("description", "High demand in your area");
        rec2.put("confidence", 77);
        recommendations.add(rec2);
        
        Map<String, Object> rec3 = new HashMap<>();
        rec3.put("serviceName", "Pet Photography");
        rec3.put("description", "Popular add-on service");
        rec3.put("confidence", 73);
        recommendations.add(rec3);
        
        return recommendations;
    }

    /**
     * Calculate next appointment date based on days from today
     * 
     * @param daysFromNow Number of days to add
     * @return Formatted date string (YYYY-MM-DD)
     */
    private String calculateNextDate(int daysFromNow) {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, daysFromNow);
        
        int year = cal.get(Calendar.YEAR);
        int month = cal.get(Calendar.MONTH) + 1;
        int day = cal.get(Calendar.DAY_OF_MONTH);
        
        return String.format("%04d-%02d-%02d", year, month, day);
    }

    /**
     * Analyze customer sentiment from chat conversations
     * Uses simple keyword-based sentiment analysis
     * 
     * @param messages List of conversation messages
     * @return Sentiment analysis result with score
     */
    public Map<String, Object> analyzeSentiment(List<String> messages) {
        Map<String, Object> sentiment = new HashMap<>();
        
        int positiveKeywords = 0;
        int negativeKeywords = 0;
        
        // Simple keyword-based sentiment analysis
        String[] positiveWords = {"good", "great", "excellent", "happy", "satisfied", "love", "perfect", "amazing"};
        String[] negativeWords = {"bad", "terrible", "awful", "disappointed", "hate", "worst", "poor", "horrible"};
        
        for (String message : messages) {
            String lowerMessage = message.toLowerCase();
            
            for (String word : positiveWords) {
                if (lowerMessage.contains(word)) positiveKeywords++;
            }
            
            for (String word : negativeWords) {
                if (lowerMessage.contains(word)) negativeKeywords++;
            }
        }
        
        String overallSentiment = "neutral";
        int total = positiveKeywords + negativeKeywords;
        
        if (total > 0) {
            if (positiveKeywords > negativeKeywords) {
                overallSentiment = "positive";
            } else if (negativeKeywords > positiveKeywords) {
                overallSentiment = "negative";
            }
        }
        
        sentiment.put("sentiment", overallSentiment);
        sentiment.put("confidence", calculateConfidence(positiveKeywords, negativeKeywords));
        
        return sentiment;
    }

    /**
     * Calculate confidence score for sentiment analysis
     * 
     * @param positive Number of positive indicators
     * @param negative Number of negative indicators
     * @return Confidence percentage
     */
    private double calculateConfidence(int positive, int negative) {
        int total = positive + negative;
        if (total == 0) return 0.0;
        
        double maxScore = Math.max(positive, negative);
        return (maxScore / total) * 100.0;
    }

    /**
     * Validate user prompt before sending to AI
     * 
     * @param prompt User input prompt
     * @return Validation result with error message if invalid
     */
    public Map<String, Object> validatePrompt(String prompt) {
        Map<String, Object> result = new HashMap<>();
        
        // Check for empty prompt
        if (prompt == null || prompt.trim().isEmpty()) {
            result.put("valid", false);
            result.put("error", "Prompt cannot be empty");
            return result;
        }
        
        // Check length limit
        if (prompt.length() > 5000) {
            result.put("valid", false);
            result.put("error", "Prompt too long (maximum 5000 characters)");
            return result;
        }
        
        // Check for potentially harmful content
        String[] restrictedWords = {"hack", "exploit", "bypass", "crack"};
        String lowerPrompt = prompt.toLowerCase();
        
        for (String word : restrictedWords) {
            if (lowerPrompt.contains(word)) {
                result.put("valid", false);
                result.put("error", "Prompt contains restricted content");
                return result;
            }
        }
        
        result.put("valid", true);
        return result;
    }

    /**
     * Get AI model configuration
     * 
     * @return Map containing model settings
     */
    public Map<String, Object> getModelConfig() {
        Map<String, Object> config = new HashMap<>();
        config.put("model", "gemini-2.0-flash");
        config.put("creativity", 40);
        config.put("responseLength", 1000);
        config.put("temperature", 0.7);
                return config;
    }
}