package com.petcaresystem.controller.aichat;

import com.petcaresystem.dao.AccountDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.time.Duration;
import okhttp3.*;
import org.json.*;

@WebServlet("/ai/gemini")
public class AIChatController extends HttpServlet {

    // OkHttp với timeout hợp lý để tránh treo request
    private final OkHttpClient client = new OkHttpClient.Builder()
            .callTimeout(Duration.ofSeconds(30))
            .connectTimeout(Duration.ofSeconds(10))
            .readTimeout(Duration.ofSeconds(30))
            .writeTimeout(Duration.ofSeconds(30))
            .build();

    private static final String MODEL = "gemini-2.0-flash";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        String apiKey = "AIzaSyDfVy3S60vku_UkWQzpBGdyNSRAklc3mCM";
        AccountDAO accountDAO = new AccountDAO();
//        System.getenv("GEMINI_API_KEY")"";
        if (apiKey == null || apiKey.isBlank()) {
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":\"GEMINI_API_KEY is missing (set it on server)\"}");
            return;
        }

        // Lấy prompt từ form hoặc JSON
        String prompt = extractPrompt(req);
        if (prompt == null || prompt.isBlank()) {
            resp.setStatus(400);
            resp.getWriter().write("{\"error\":\"prompt is required\"}");
            return;
        }

        // Endpoint đúng cú pháp: ...:generateContent?key=API_KEY
        String url = "https://generativelanguage.googleapis.com/v1beta/models/"
                + MODEL + ":generateContent?key=" + apiKey;
//        String username =req.getSession().getAttribute("username").toString();
        String username = accountDAO.getAccount().get(0).getUsername();
        String system = """
                        [System Rules]
                        - Bạn là trợ lý kỹ thuật hài hước, nói vừa phải, chính xác.
                        - Tên người dùng là: %s.
                        - Ưu tiên bảo mật & tính đúng đắn.
                        """.formatted(accountDAO.getAccount().get(0).getUsername());

        // BODY trả về
        String contextMsg = "Người dùng hiện tại tên là %s. Hãy xưng hô đúng tên trong mọi phản hồi."
                .formatted(username);

        // 4) BODY: systemInstruction + 2 contents: (a) context, (b) prompt
        JSONObject body = new JSONObject()
                .put("systemInstruction", new JSONObject()
                        .put("parts", new JSONArray()
                                .put(new JSONObject().put("text", system))))
                .put("contents", new JSONArray()
                        // context đứng trước
                        .put(new JSONObject()
                                .put("role", "user")
                                .put("parts", new JSONArray()
                                        .put(new JSONObject().put("text", contextMsg))))
                        // prompt gốc của người dùng
                        .put(new JSONObject()
                                .put("role", "user")
                                .put("parts", new JSONArray()
                                        .put(new JSONObject().put("text", prompt)))
                        )
                );
        Request request = new Request.Builder()
                .url(url)
                .post(RequestBody.create(body.toString(), MediaType.get("application/json")))
                .build();

        try (Response r = client.newCall(request).execute()) {
            String raw = r.body() != null ? r.body().string() : "";

            if (!r.isSuccessful()) {
                // Trả nguyên lỗi từ upstream để dễ debug (dev). Prod thì nên chuẩn hóa thông điệp.
                resp.setStatus(r.code());
                resp.getWriter().write(raw.isBlank()
                        ? "{\"error\":\"Upstream error with empty body\"}"
                        : raw);
                return;
            }

            // Parse an toàn: candidates[0].content.parts[0].text
            try {
                JSONObject json = new JSONObject(raw);
                String content = json
                        .getJSONArray("candidates").getJSONObject(0)
                        .getJSONObject("content")
                        .getJSONArray("parts").getJSONObject(0)
                        .getString("text");

                resp.getWriter().write(new JSONObject().put("answer", content).toString());
            } catch (Exception parseErr) {
                // Nếu schema thay đổi, trả thẳng raw để bạn thấy và điều chỉnh
                System.err.println("[GeminiParseError] " + parseErr);
                resp.setStatus(502);
                resp.getWriter().write(new JSONObject()
                        .put("error", "Failed to parse Gemini response")
                        .put("raw", raw)
                        .toString());
            }
        } catch (Exception callErr) {
            System.err.println("[GeminiCallError] " + callErr);
            resp.setStatus(502);
            resp.getWriter().write(new JSONObject()
                    .put("error", "Failed to call Gemini")
                    .put("message", callErr.getMessage())
                    .toString());
        }
    }

    // Hỗ trợ cả form-urlencoded và JSON
    private String extractPrompt(HttpServletRequest req) throws IOException {
        String ct = req.getContentType();
        if (ct != null && ct.contains("application/json")) {
            StringBuilder sb = new StringBuilder();
            try (BufferedReader br = req.getReader()) {
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
            }
            try {
                JSONObject j = new JSONObject(sb.toString());
                return j.optString("prompt", null);
            } catch (Exception e) {
                return null;
            }
        } else {
            return req.getParameter("prompt");
        }
    }
}
