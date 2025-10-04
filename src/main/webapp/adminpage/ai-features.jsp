<%@ page contentType="text/html; charset=UTF-8" %>
<section class="page grid-2-1">
    <div class="card">
        <div class="card-head"><strong>AI Assistant Chat</strong></div>
        <div class="chat-box">
            <div class="msg bot">10:30 AM — Hello! I'm your AI assistant powered by Gemini.</div>
        </div>
        <div class="chat-input">
            <input type="text" placeholder="Ask the AI assistant..."/>
            <button class="btn primary">➤</button>
        </div>
        <div class="hint">
            <p>Try asking:</p>
            <ul>
                <li>What services should I recommend for a Golden Retriever?</li>
                <li>When should I schedule the next appointment?</li>
                <li>How can I improve customer satisfaction?</li>
            </ul>
        </div>
    </div>

    <div class="card">
        <div class="card-head">
            <strong>Customer AI Analysis</strong>
            <span class="tag">Powered by Gemini AI</span>
        </div>
        <div class="panel">
            <div class="panel-title">Current Customer: Sarah Johnson</div>
            <div>Pet: Max — Golden Retriever</div>
            <div>Last Visit: 2024-01-10</div>
            <div>Preferred: Grooming, Health Checkup</div>
        </div>

        <h4>AI Calendar Suggestions</h4>
        <ul class="list">
            <li>Cat Grooming — 2024-01-21 9:30 AM <span class="badge up">91% match</span></li>
            <li>Pet Training — 2024-01-23 3:30 PM <span class="badge up">86% match</span></li>
            <li>Vaccination — 2024-01-26 1:00 PM <span class="badge up">82% match</span></li>
        </ul>

        <h4>Service Recommendations</h4>
        <ul class="list">
            <li>Senior Pet Care Package <span class="badge up">89% confidence</span></li>
            <li>Puppy Socialization <span class="badge up">77% confidence</span></li>
            <li>Pet Photography <span class="badge up">73% confidence</span></li>
        </ul>

        <button class="btn primary" style="width:100%">Generate New Suggestions</button>
    </div>
</section>
