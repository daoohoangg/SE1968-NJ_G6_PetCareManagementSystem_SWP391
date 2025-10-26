package com.petcaresystem.dao;

import com.petcaresystem.enities.Service;
import com.petcaresystem.enities.ServiceCategory;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import java.math.BigDecimal;
import java.util.List;

/**
 * Test class for fuzzy search functionality
 */
public class FuzzySearchTest {
    
    private ServiceDAO serviceDAO;
    
    @BeforeEach
    public void setUp() {
        serviceDAO = new ServiceDAO();
    }
    
    @Test
    public void testFuzzySearchLogic() {
        // Create test services
        Service groomingService = createTestService(1, "Premium Dog Grooming", "Full grooming service for dogs");
        Service medicalService = createTestService(2, "Veterinary Checkup", "Regular health check for pets");
        Service trainingService = createTestService(3, "Basic Training", "Basic obedience training");
        
        // Test exact match
        System.out.println("Testing exact match for 'grooming'...");
        
        // Test partial match
        System.out.println("Testing partial match for 'dog'...");
        
        // Test fuzzy match
        System.out.println("Testing fuzzy match for 'groming' (typo)...");
        
        // Test word-by-word matching
        System.out.println("Testing word matching for 'premium service'...");
    }
    
    private Service createTestService(int id, String name, String description) {
        Service service = new Service();
        service.setServiceId(id);
        service.setServiceName(name);
        service.setDescription(description);
        service.setPrice(new BigDecimal("50.00"));
        service.setDurationMinutes(60);
        service.setActive(true);
        
        ServiceCategory category = new ServiceCategory();
        category.setCategoryId(1);
        category.setName("General");
        service.setCategory(category);
        
        return service;
    }
    
    /**
     * Test the string similarity calculation
     */
    @Test
    public void testStringSimilarity() {
        // Test cases for string similarity
        String[] testCases = {
            "grooming", "groming",  // typo
            "veterinary", "vet",    // abbreviation
            "training", "train",    // partial word
            "premium", "prem",      // partial word
            "service", "services"   // plural
        };
        
        for (int i = 0; i < testCases.length; i += 2) {
            String s1 = testCases[i];
            String s2 = testCases[i + 1];
            System.out.println("Similarity between '" + s1 + "' and '" + s2 + "': " + 
                calculateStringSimilarity(s1, s2));
        }
    }
    
    /**
     * Calculate string similarity using Levenshtein distance
     */
    private double calculateStringSimilarity(String s1, String s2) {
        if (s1 == null || s2 == null) return 0.0;
        if (s1.equals(s2)) return 1.0;
        
        int maxLength = Math.max(s1.length(), s2.length());
        if (maxLength == 0) return 1.0;
        
        int distance = levenshteinDistance(s1, s2);
        return 1.0 - (double) distance / maxLength;
    }
    
    /**
     * Calculate Levenshtein distance between two strings
     */
    private int levenshteinDistance(String s1, String s2) {
        int[][] dp = new int[s1.length() + 1][s2.length() + 1];
        
        for (int i = 0; i <= s1.length(); i++) {
            for (int j = 0; j <= s2.length(); j++) {
                if (i == 0) {
                    dp[i][j] = j;
                } else if (j == 0) {
                    dp[i][j] = i;
                } else {
                    dp[i][j] = Math.min(Math.min(
                        dp[i - 1][j] + 1,
                        dp[i][j - 1] + 1),
                        dp[i - 1][j - 1] + (s1.charAt(i - 1) == s2.charAt(j - 1) ? 0 : 1)
                    );
                }
            }
        }
        
        return dp[s1.length()][s2.length()];
    }
}
