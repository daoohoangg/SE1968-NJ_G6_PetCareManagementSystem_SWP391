package com.petcaresystem.controller.aichat;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

import okhttp3.*;
import org.json.*;
import com.petcaresystem.service.aichat.AiDataService;

@WebServlet("/ai/gemini")
public class AIChatController extends HttpServlet {

    private final OkHttpClient client = new OkHttpClient.Builder()
            .callTimeout(Duration.ofSeconds(30))
            .connectTimeout(Duration.ofSeconds(10))
            .readTimeout(Duration.ofSeconds(30))
            .writeTimeout(Duration.ofSeconds(30))
            .build();

    private static final String MODEL = "gemini-2.0-flash";
    private final AiDataService aiDataService = new AiDataService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        try {
            // 1) Lấy API key từ ENV — KHÔNG hardcode
            String apiKey = "AIzaSyDfVy3S60vku_UkWQzpBGdyNSRAklc3mCM";
            if (apiKey == null || apiKey.isBlank()) {
                resp.setStatus(500);
                resp.getWriter().write("{\"error\":\"GEMINI_API_KEY is missing (set it on server)\"}");
                return;
            }

            // 2) Prompt
            String prompt = extractPrompt(req);
            if (prompt == null || prompt.isBlank()) {
                resp.setStatus(400);
                resp.getWriter().write("{\"error\":\"prompt is required\"}");
                return;
            }

            // 3) Username an toàn
            String username = "Guest";
            HttpSession session = req.getSession(false);
            if (session != null) {
                Object u = session.getAttribute("username");
                if (u != null) {
                    String s = String.valueOf(u);
                    if (!s.isBlank()) username = s;
                }
            }

            // Load system prompt from database
            String system = loadSystemPromptFromDatabase(username);

            String contextMsg = "Người dùng hiện tại tên là %s. Hãy xưng hô đúng tên trong mọi phản hồi."
                    .formatted(username);

            JSONObject body = new JSONObject()
                    .put("systemInstruction", new JSONObject()
                            .put("parts", new JSONArray().put(new JSONObject().put("text", system))))
                    .put("contents", new JSONArray()
                            .put(new JSONObject()
                                    .put("role", "user")
                                    .put("parts", new JSONArray().put(new JSONObject().put("text", contextMsg)))))
                    .append("contents", new JSONObject()
                            .put("role", "user")
                            .put("parts", new JSONArray().put(new JSONObject().put("text", prompt))));

            String url = "https://generativelanguage.googleapis.com/v1beta/models/"
                    + MODEL + ":generateContent?key=" + apiKey;

            Request request = new Request.Builder()
                    .url(url)
                    .post(RequestBody.create(body.toString(), MediaType.get("application/json")))
                    .build();

            try (Response r = client.newCall(request).execute()) {
                String raw = (r.body() != null) ? r.body().string() : "";

                if (!r.isSuccessful()) {
                    resp.setStatus(r.code());
                    JSONObject err = new JSONObject()
                            .put("error", "Upstream error")
                            .put("status", r.code())
                            .put("raw", slice(raw, 4000));
                    resp.getWriter().write(err.toString());
                    return;
                }

                JSONObject json = new JSONObject(raw);

                if (json.has("promptFeedback")) {
                    JSONObject pf = json.getJSONObject("promptFeedback");
                    String block = pf.optString("blockReason", "");
                    if (!block.isBlank()) {
                        resp.getWriter().write(new JSONObject()
                                .put("answer", "Nội dung bị chặn bởi chính sách. Hãy diễn đạt an toàn và thân thiện hơn.")
                                .put("feedback", pf).toString());
                        return;
                    }
                }

                String content = null;
                if (json.has("candidates")) {
                    JSONArray cands = json.getJSONArray("candidates");
                    if (cands.length() > 0) {
                        JSONObject c0 = cands.getJSONObject(0);
                        if (c0.has("content")) {
                            JSONArray parts = c0.getJSONObject("content").optJSONArray("parts");
                            if (parts != null && parts.length() > 0) {
                                content = parts.getJSONObject(0).optString("text", null);
                            }
                        }
                        if (content == null) content = c0.optString("output", null);
                    }
                }

                if (content == null) {
                    resp.getWriter().write(new JSONObject()
                            .put("answer", "(Không tìm thấy nội dung trong phản hồi)")
                            .put("raw", slice(raw, 4000))
                            .toString());
                } else {
                    resp.getWriter().write(new JSONObject().put("answer", content).toString());
                }
            }
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().write(new JSONObject()
                    .put("error", "Internal server error")
                    .put("message", e.getClass().getSimpleName() + ": " + e.getMessage())
                    .toString());
        }
    }

    /** Đọc prompt từ JSON hoặc form; giới hạn body để tránh DoS. */
    private static String extractPrompt(HttpServletRequest req) {
        String ct = req.getContentType();
        if (ct != null && ct.toLowerCase().contains("application/json")) {
            String body = safeReadBody(req, 64 * 1024, detectCharset(ct)); // 64KB
            if (body == null || body.isBlank()) return null;
            try {
                JSONObject json = new JSONObject(body);
                // Cho phép client gửi {"prompt":"..."} hoặc {"message":"..."}
                String p = json.optString("prompt", null);
                if (p == null || p.isBlank()) {
                    p = json.optString("message", null);
                }
                return (p != null && !p.isBlank()) ? p : null;
            } catch (JSONException ex) {
                return null;
            }
        }

        // form-urlencoded / multipart
        String p = req.getParameter("prompt");
        if (p == null || p.isBlank()) {
            p = req.getParameter("message");
        }
        return (p != null && !p.isBlank()) ? p : null;
    }

    /** Đọc body an toàn với giới hạn kích thước và charset. */
    private static String safeReadBody(HttpServletRequest req, int maxBytes, Charset cs) {
        try (InputStream in = req.getInputStream();
             ByteArrayOutputStream bos = new ByteArrayOutputStream()) {

            byte[] buf = new byte[4096];
            int read;
            int total = 0;
            while ((read = in.read(buf)) != -1) {
                total += read;
                if (total > maxBytes) {
                    // cắt sớm để tránh ngốn RAM
                    break;
                }
                bos.write(buf, 0, read);
            }
            return bos.toString(cs.name());
        } catch (IOException e) {
            return null;
        }
    }

    /** Bóc charset từ header Content-Type; mặc định UTF-8. */
    private static Charset detectCharset(String contentType) {
        try {
            String[] parts = contentType.split(";");
            for (String part : parts) {
                String s = part.trim().toLowerCase();
                if (s.startsWith("charset=")) {
                    String name = s.substring("charset=".length()).trim();
                    return Charset.forName(name);
                }
            }
        } catch (Exception ignore) {}
        return StandardCharsets.UTF_8;
    }

    private static String slice(String s, int max) {
        if (s == null) return "";
        return s.length() <= max ? s : s.substring(0, max) + "...";
    }
    
    /**
     * Load system prompt from database with username context
     */
    private String loadSystemPromptFromDatabase(String username) {
        try {
            String basePrompt = aiDataService.getFormattedPrompt();
            
            // Add username context to the prompt
            return String.format("""
                %s
                
                [User Context]
                - Current user: %s
                - Please address the user by their name when appropriate
                - Maintain a professional and caring tone
                """, basePrompt, username);
                
        } catch (Exception e) {
            // Fallback to default prompt if database fails
            return String.format("""
                [System Rules]
                - Bạn là trợ lý kỹ thuật hài hước, nói vừa phải, chính xác.
                - Tên người dùng là: %s.
                - Ưu tiên bảo mật & tính đúng đắn.
                """, username);
        }
    }
}
