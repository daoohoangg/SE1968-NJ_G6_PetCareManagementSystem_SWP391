package com.petcaresystem.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.petcaresystem.service.aichat.AIChatBotService;
import com.petcaresystem.controller.admin.AiConfigController;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/admin/ai/*")
public class AIAdminController extends HttpServlet {
    
    private AIChatBotService aiService;

    @Override
    public void init() throws ServletException {
        super.init();
        aiService = new AIChatBotService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        
        // Route to existing AiConfigController for page rendering
        if (path == null || path.equals("/") || path.equals("/features")) {
            AiConfigController configController = new AiConfigController();
            configController.doGet(req, resp);
            return;
        }
        
        // Handle other GET requests
        resp.setStatus(404);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        String path = req.getPathInfo();
        
        try {
            if (path != null && path.equals("/generate-suggestions")) {
                handleGenerateSuggestions(req, resp);
            } else if (path != null && path.equals("/model-config")) {
                handleGetModelConfig(req, resp);
            } else {
                resp.setStatus(404);
                writeErrorResponse(resp, "Invalid endpoint");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            writeErrorResponse(resp, "Internal server error: " + e.getMessage());
        }
    }

    /**
     * Handle generation of AI suggestions
     * GET /admin/ai/generate-suggestions
     */
    private void handleGenerateSuggestions(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        
        // Get optional customer ID from request
        String customerIdParam = req.getParameter("customerId");
        Integer customerId = customerIdParam != null ? Integer.parseInt(customerIdParam) : 1;
        
        // Generate suggestions using service
        Map<String, Object> suggestions = aiService.generateCustomerSuggestions(customerId);
        
        // Convert to JSON response
        JSONObject response = new JSONObject()
                .put("success", true)
                .put("message", "Suggestions generated successfully");
        
        // Add calendar suggestions
        if (suggestions.containsKey("calendarSuggestions")) {
            JSONArray calendarArray = new JSONArray();
            for (Map<String, Object> suggestion : (java.util.List<Map<String, Object>>) suggestions.get("calendarSuggestions")) {
                JSONObject item = new JSONObject()
                        .put("service", suggestion.get("service"))
                        .put("date", suggestion.get("date"))
                        .put("time", suggestion.get("time"))
                        .put("matchPercent", suggestion.get("matchPercent"));
                calendarArray.put(item);
            }
            response.put("calendarSuggestions", calendarArray);
        }
        
        // Add service recommendations
        if (suggestions.containsKey("serviceRecommendations")) {
            JSONArray serviceArray = new JSONArray();
            for (Map<String, Object> rec : (java.util.List<Map<String, Object>>) suggestions.get("serviceRecommendations")) {
                JSONObject item = new JSONObject()
                        .put("serviceName", rec.get("serviceName"))
                        .put("description", rec.get("description"))
                        .put("confidence", rec.get("confidence"));
                serviceArray.put(item);
            }
            response.put("serviceRecommendations", serviceArray);
        }
        
        try (PrintWriter out = resp.getWriter()) {
            out.print(response.toString());
        }
    }

    /**
     * Handle getting AI model configuration
     * GET /admin/ai/model-config
     */
    private void handleGetModelConfig(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        
        Map<String, Object> config = aiService.getModelConfig();
        
        JSONObject response = new JSONObject()
                .put("success", true)
                .put("model", config.get("model"))
                .put("creativity", config.get("creativity"))
                .put("responseLength", config.get("responseLength"))
                .put("temperature", config.get("temperature"));
        
        try (PrintWriter out = resp.getWriter()) {
            out.print(response.toString());
        }
    }

    private void writeErrorResponse(HttpServletResponse resp, String message) throws IOException {
        JSONObject errorResponse = new JSONObject()
                .put("success", false)
                .put("error", message);

        try (PrintWriter out = resp.getWriter()) {
            out.print(errorResponse.toString());
        }
    }
}
