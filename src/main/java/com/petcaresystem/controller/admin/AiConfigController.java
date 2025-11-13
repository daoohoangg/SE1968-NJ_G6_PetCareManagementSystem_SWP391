package com.petcaresystem.controller.admin;

import com.petcaresystem.enities.AiData;
import com.petcaresystem.service.aichat.AiDataService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/admin/ai/*")
public class AiConfigController extends HttpServlet {
    private AiDataService aiDataService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.aiDataService = new AiDataService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        
        // If no path info, show the JSP page
        if (path == null || path.equals("/")) {
            // Load current AI configuration from database to pass to JSP
            AiData currentConfig = aiDataService.getCurrentConfiguration();
            if (currentConfig != null) {
                req.setAttribute("aiConfig", currentConfig);
                req.setAttribute("systemPrompt", currentConfig.getPrompt() != null ? currentConfig.getPrompt() : "");
                req.setAttribute("creativityLevel", currentConfig.getCreativityLevel());
            } else {
                // Set default values if no configuration exists
                req.setAttribute("systemPrompt", "");
                req.setAttribute("creativityLevel", 40);
            }
            req.getRequestDispatcher("/adminpage/ai-features.jsp").forward(req, resp);
            return;
        }
        
        // Handle API endpoints
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            if (path.equals("/current")) {
                // Get current configuration
                AiData currentConfig = aiDataService.getCurrentConfiguration();
                JSONObject configJson = new JSONObject();
                if (currentConfig != null) {
                    configJson.put("id", currentConfig.getId() != null ? currentConfig.getId() : JSONObject.NULL);
                    configJson.put("prompt", currentConfig.getPrompt() != null ? currentConfig.getPrompt() : "");
                    configJson.put("creativityLevel", currentConfig.getCreativityLevel());
                } else {
                    // Return default values if no configuration exists
                    configJson.put("id", JSONObject.NULL);
                    configJson.put("prompt", "");
                    configJson.put("creativityLevel", 40);
                }
                resp.getWriter().write(new JSONObject()
                        .put("success", true)
                        .put("configuration", configJson)
                        .toString());
            } else if (path.equals("/stats")) {
                // Get configuration statistics
                var stats = aiDataService.getConfigurationStats();
                resp.getWriter().write(new JSONObject()
                        .put("success", true)
                        .put("stats", stats)
                        .toString());
            } else {
                resp.setStatus(404);
                resp.getWriter().write(new JSONObject()
                        .put("success", false)
                        .put("error", "Endpoint not found")
                        .toString());
            }
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().write(new JSONObject()
                    .put("success", false)
                    .put("error", "Internal server error: " + e.getMessage())
                    .toString());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            if (path == null || path.equals("/")) {
                // Create new AI data
                createAiData(req, resp);
            } else if (path.equals("/update-config")) {
                // Update current configuration
                updateConfiguration(req, resp);
            } else if (path.equals("/update-prompt")) {
                // Update only prompt
                updatePrompt(req, resp);
            } else if (path.equals("/update-creativity")) {
                // Update only creativity level
                updateCreativityLevel(req, resp);
            } else {
                resp.setStatus(404);
                resp.getWriter().write(new JSONObject()
                        .put("success", false)
                        .put("error", "Endpoint not found")
                        .toString());
            }
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().write(new JSONObject()
                    .put("success", false)
                    .put("error", "Internal server error: " + e.getMessage())
                    .toString());
        }
    }


    private void createAiData(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        // This method is not used in the simplified version
        resp.setStatus(404);
        resp.getWriter().write(new JSONObject()
                .put("success", false)
                .put("error", "Method not implemented")
                .toString());
    }

    private void updateConfiguration(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String prompt = req.getParameter("prompt");
        String creativityLevelStr = req.getParameter("creativityLevel");

        if (prompt == null || creativityLevelStr == null) {
            resp.setStatus(400);
            resp.getWriter().write(new JSONObject()
                    .put("success", false)
                    .put("error", "Missing required fields: prompt, creativityLevel")
                    .toString());
            return;
        }

        try {
            int creativityLevel = Integer.parseInt(creativityLevelStr);

            if (!aiDataService.isValidCreativityLevel(creativityLevel)) {
                resp.setStatus(400);
                resp.getWriter().write(new JSONObject()
                        .put("success", false)
                        .put("error", "Creativity level must be between 0 and 100")
                        .toString());
                return;
            }

            if (!aiDataService.isValidPrompt(prompt)) {
                resp.setStatus(400);
                resp.getWriter().write(new JSONObject()
                        .put("success", false)
                        .put("error", "Invalid prompt content")
                        .toString());
                return;
            }

            boolean success = aiDataService.updateConfiguration(prompt, creativityLevel);

            resp.getWriter().write(new JSONObject()
                    .put("success", success)
                    .put("message", success ? "Configuration updated successfully" : "Failed to update configuration")
                    .toString());
        } catch (NumberFormatException e) {
            resp.setStatus(400);
            resp.getWriter().write(new JSONObject()
                    .put("success", false)
                    .put("error", "Invalid creativity level format")
                    .toString());
        }
    }

    private void updatePrompt(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String prompt = req.getParameter("prompt");

        if (prompt == null) {
            resp.setStatus(400);
            resp.getWriter().write(new JSONObject()
                    .put("success", false)
                    .put("error", "Missing required field: prompt")
                    .toString());
            return;
        }

        if (!aiDataService.isValidPrompt(prompt)) {
            resp.setStatus(400);
            resp.getWriter().write(new JSONObject()
                    .put("success", false)
                    .put("error", "Invalid prompt content")
                    .toString());
            return;
        }

        // Get current configuration and update prompt
        AiData currentConfig = aiDataService.getCurrentConfiguration();
        currentConfig.setPrompt(prompt);
        boolean success = aiDataService.saveAiData(currentConfig);

        resp.getWriter().write(new JSONObject()
                .put("success", success)
                .put("message", success ? "Prompt updated successfully" : "Failed to update prompt")
                .toString());
    }

    private void updateCreativityLevel(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String creativityLevelStr = req.getParameter("creativityLevel");

        if (creativityLevelStr == null) {
            resp.setStatus(400);
            resp.getWriter().write(new JSONObject()
                    .put("success", false)
                    .put("error", "Missing required field: creativityLevel")
                    .toString());
            return;
        }

        try {
            int creativityLevel = Integer.parseInt(creativityLevelStr);

            if (!aiDataService.isValidCreativityLevel(creativityLevel)) {
                resp.setStatus(400);
                resp.getWriter().write(new JSONObject()
                        .put("success", false)
                        .put("error", "Creativity level must be between 0 and 100")
                        .toString());
                return;
            }

            // Get current configuration and update creativity level
            AiData currentConfig = aiDataService.getCurrentConfiguration();
            currentConfig.setCreativityLevel(creativityLevel);
            boolean success = aiDataService.saveAiData(currentConfig);

            resp.getWriter().write(new JSONObject()
                    .put("success", success)
                    .put("message", success ? "Creativity level updated successfully" : "Failed to update creativity level")
                    .toString());
        } catch (NumberFormatException e) {
            resp.setStatus(400);
            resp.getWriter().write(new JSONObject()
                    .put("success", false)
                    .put("error", "Invalid creativity level format")
                    .toString());
        }
    }
}