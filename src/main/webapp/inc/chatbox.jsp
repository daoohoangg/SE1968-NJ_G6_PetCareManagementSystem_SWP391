<%@ page contentType="text/html; charset=UTF-8" %>
<style>
    .ai-chat-launcher{position:fixed;right:20px;bottom:20px;z-index:9998;border:none;border-radius:999px;padding:12px 16px;box-shadow:0 6px 18px rgba(0,0,0,.15);cursor:pointer;background:#1f6feb;color:#fff}
    .ai-chat-panel{position:fixed;right:20px;bottom:80px;width:340px;max-height:60vh;background:#fff;border:1px solid #e5e7eb;border-radius:14px;overflow:hidden;display:none;flex-direction:column;z-index:9999;box-shadow:0 10px 28px rgba(0,0,0,.18)}
    .ai-chat-header{padding:10px 12px;background:#0d1117;color:#fff;display:flex;justify-content:space-between;align-items:center}
    .ai-chat-body{padding:10px;height:320px;overflow:auto;background:#f8fafc}
    .ai-bubble{max-width:80%;margin:8px 0;padding:8px 10px;border-radius:10px;line-height:1.35;font-size:14px}
    .ai-bubble.user{background:#e0f2fe;color:#0c4a6e;margin-left:auto}
    .ai-bubble.bot{background:#eef2ff;color:#1e1b4b;margin-right:auto}
    .ai-chat-input{display:flex;gap:6px;padding:8px;border-top:1px solid #e5e7eb;background:#fff}
    .ai-chat-input input{flex:1;padding:10px;border:1px solid #d1d5db;border-radius:10px}
    .ai-chat-input button{padding:10px 14px;border:none;border-radius:10px;background:#1f6feb;color:white;cursor:pointer}
</style>

<button id="aiChatOpenBtn" class="ai-chat-launcher">Chat AI</button>

<div id="aiChatPanel" class="ai-chat-panel" aria-live="polite">
    <div class="ai-chat-header">
        <strong>AI Assistant</strong>
        <button id="aiChatCloseBtn" title="Close" style="background:none;border:none;color:#fff;cursor:pointer">&times;</button>
    </div>
    <div id="aiChatBody" class="ai-chat-body">
        <div class="ai-bubble bot">Xin chào 👋 Mình là trợ lý AI. Hỏi gì cũng được!</div>
    </div>
    <form id="aiChatForm" class="ai-chat-input">
        <input id="aiChatInput" type="text" placeholder="Nhập câu hỏi..." autocomplete="off" />
        <button type="submit">Gửi</button>
    </form>
</div>

<script>
    (function(){
        // ... phần setup, addBubble, toggle giữ nguyên ...

        function safeText(x) {
            // Trả về chuỗi chắc chắn để hiển thị
            if (x == null) return ' (không có nội dung) ';
            if (typeof x === 'string') return x;
            try { return JSON.stringify(x); } catch { return String(x); }
        }

        document.getElementById('aiChatForm').addEventListener('submit', async (e)=>{
            e.preventDefault();
            const q = aiChatInput.value.trim();
            if(!q) return;

            addBubble(q,'user');
            aiChatInput.value = '';

            const loading = document.createElement('div');
            loading.className = 'ai-bubble bot';
            loading.textContent = 'Đang suy nghĩ...';
            aiChatBody.appendChild(loading);
            aiChatBody.scrollTop = aiChatBody.scrollHeight;

            try{
                const res = await fetch('<%= request.getContextPath() %>/ai/gemini', {
                    method:'POST',
                    headers:{'Content-Type':'application/json'},
                    body: JSON.stringify({ prompt: q })
                });

                // Dù server có trả string hay object, ta vẫn parse thành object
                let data;
                try {
                    data = await res.json();
                    // Nếu server lỡ trả một JSON dạng string (double-encoded), parse thêm lần nữa
                    if (typeof data === 'string') data = JSON.parse(data);
                } catch {
                    data = { error: 'Phản hồi không phải JSON hợp lệ.' };
                }

                loading.remove();

                if (!res.ok) {
                    addBubble(safeText(data.error || data.message || data), 'bot');
                    return;
                }

                // Lấy câu trả lời: ưu tiên data.answer; nếu thiếu, rơi về toàn bộ data
                const answer = (data && data.answer != null) ? data.answer : data;
                addBubble(safeText(answer), 'bot');

            }catch(err){
                loading.remove();
                addBubble('Có lỗi khi gọi AI: ' + (err?.message || err), 'bot');
            }
        });
    })();
</script>


