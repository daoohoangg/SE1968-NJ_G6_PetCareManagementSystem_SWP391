<%@ page contentType="text/html; charset=UTF-8" %>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<style>
    :root{
        --primary:#2563eb;
        --primary-soft:#eef2ff;
        --accent:#8b5cf6;
        --success:#16a34a;
        --warning:#f97316;
        --muted:#6b7280;
        --text:#111827;
        --line:#e5e7eb;
        --bg:#f7f9fc;
        --surface:#ffffff;
        --shadow:0 18px 40px rgba(15,23,42,.08);
    }
    .ai-page{
        display:flex;
        background:var(--bg);
        font-family:Inter,system-ui,Segoe UI,Roboto,Arial,sans-serif;
        color:var(--text);
        width:100%;
    }
    .ai-main{
        flex:1;
        padding:32px 40px;
        display:flex;
        flex-direction:column;
        gap:28px;
    }
    .ai-header{
        display:flex;
        align-items:flex-start;
        justify-content:space-between;
        gap:18px;
        flex-wrap:wrap;
    }
    .ai-header h1{
        margin:0;
        font-size:28px;
        font-weight:600;
    }
    .ai-header p{
        margin:8px 0 0;
        color:var(--muted);
        font-size:14px;
        max-width:480px;
    }
    .ai-badge{
        display:inline-flex;
        align-items:center;
        gap:6px;
        padding:8px 14px;
        border-radius:999px;
        background:var(--primary-soft);
        color:var(--primary);
        font-weight:600;
        font-size:13px;
    }
    .ai-grid{
        display:grid;
        grid-template-columns:minmax(0,2fr) minmax(0,1.35fr);
        gap:24px;
    }
    .card{
        background:var(--surface);
        border:1px solid rgba(148,163,184,.25);
        border-radius:20px;
        padding:24px 26px;
        box-shadow:var(--shadow);
        display:flex;
        flex-direction:column;
        gap:20px;
        min-height:0;
    }
    .card-header{
        display:flex;
        align-items:flex-start;
        justify-content:space-between;
        gap:12px;
    }
    .card-header h2{
        margin:0;
        font-size:20px;
        font-weight:600;
    }
    .card-header p{
        margin:6px 0 0;
        color:var(--muted);
        font-size:13px;
    }
    .pill{
        display:inline-flex;
        align-items:center;
        gap:6px;
        padding:6px 12px;
        border-radius:999px;
        background:var(--primary-soft);
        font-size:12px;
        font-weight:600;
        color:var(--primary);
    }

    /* Chat card */
    .chat-card{gap:24px;}
    .chat-window{
        padding:18px;
        border:1px solid var(--line);
        border-radius:18px;
        background:#fff;
        display:flex;
        flex-direction:column;
        gap:16px;
        max-height:360px;
        overflow:auto;
    }
    .chat-message{
        display:flex;
        flex-direction:column;
        gap:6px;
        max-width:86%;
    }
    .chat-message.bot{align-self:flex-start;}
    .chat-message.user{align-self:flex-end;}
    .chat-meta{
        font-size:12px;
        color:#9ca3af;
        display:flex;
        align-items:center;
        gap:6px;
    }
    .chat-bubble{
        padding:14px 16px;
        border-radius:16px;
        font-size:14px;
        line-height:1.5;
        background:var(--primary-soft);
        color:var(--text);
    }
    .chat-message.user .chat-bubble{
        background:var(--primary);
        color:#fff;
    }
    .chat-input-row{
        display:flex;
        align-items:center;
        gap:12px;
        background:#f9fafb;
        border-radius:16px;
        padding:8px 10px 8px 16px;
        border:1px solid var(--line);
    }
    .chat-input-row input{
        flex:1;
        border:none;
        background:transparent;
        outline:none;
        font-size:14px;
        color:var(--text);
    }
    .send-btn{
        width:42px;
        height:42px;
        border-radius:12px;
        border:none;
        background:var(--primary);
        color:#fff;
        display:inline-flex;
        align-items:center;
        justify-content:center;
        font-size:18px;
        cursor:pointer;
        transition:.18s;
        box-shadow:0 12px 28px rgba(37,99,235,.25);
    }
    .send-btn:hover{filter:brightness(.95);}
    .chat-hints{
        background:#f8fafc;
        border-radius:16px;
        padding:16px 18px;
        border:1px dashed rgba(37,99,235,.2);
    }
    .chat-hints p{
        margin:0 0 8px;
        font-weight:600;
        font-size:13px;
        color:var(--muted);
    }
    .chat-hints ul{
        margin:0;
        padding-left:18px;
        color:var(--muted);
        font-size:13px;
        display:flex;
        flex-direction:column;
        gap:6px;
    }

    /* Customer insights */
    .insight-card .detail-box{
        background:#f8fafc;
        border-radius:16px;
        padding:18px 20px;
        border:1px solid rgba(148,163,184,.25);
        display:flex;
        flex-direction:column;
        gap:8px;
    }
    .detail-box strong{
        font-size:14px;
        color:var(--muted);
        text-transform:uppercase;
        letter-spacing:.05em;
    }
    .detail-box span{
        font-size:15px;
        font-weight:600;
        color:var(--text);
    }
    .section-title{
        margin:0;
        font-size:15px;
        font-weight:600;
        color:var(--text);
    }
    .suggestion-list,
    .recommend-list{
        list-style:none;
        margin:0;
        padding:0;
        display:flex;
        flex-direction:column;
        gap:12px;
    }
    .suggestion-item,
    .recommend-item{
        border:1px solid var(--line);
        border-radius:14px;
        padding:14px 16px;
        background:#fff;
        display:flex;
        justify-content:space-between;
        gap:16px;
        align-items:flex-start;
        box-shadow:0 10px 22px rgba(15,23,42,.05);
    }
    .suggestion-content strong{
        font-size:14px;
        display:block;
        margin-bottom:4px;
    }
    .suggestion-content span{
        font-size:12px;
        color:var(--muted);
    }
    .match-badge{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        padding:6px 12px;
        border-radius:999px;
        font-size:12px;
        font-weight:600;
        color:#047857;
        background:rgba(16,185,129,.18);
    }
    .confidence-badge{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        padding:6px 12px;
        border-radius:999px;
        font-size:12px;
        font-weight:600;
        background:rgba(139,92,246,.16);
        color:#6d28d9;
    }
    .generate-btn{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        gap:8px;
        background:var(--primary);
        color:#fff;
        padding:12px 16px;
        border-radius:12px;
        border:none;
        font-weight:600;
        font-size:14px;
        width:100%;
        cursor:pointer;
        transition:.18s;
        box-shadow:0 14px 30px rgba(37,99,235,.25);
    }
    .generate-btn:hover{filter:brightness(.95);}

    /* Configuration */
    .config-card{
        gap:24px;
    }
    .config-grid{
        display:grid;
        gap:18px;
        grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
    }
    .config-field label{
        display:block;
        font-weight:600;
        font-size:13px;
        margin-bottom:6px;
        color:var(--text);
    }
    .config-field input,
    .config-field select{
        width:100%;
        border:1px solid var(--line);
        border-radius:12px;
        padding:12px 14px;
        font-size:14px;
        color:var(--text);
        background:#fff;
        transition:border-color .18s, box-shadow .18s;
    }
    .config-field input:focus,
    .config-field select:focus{
        border-color:var(--primary);
        box-shadow:0 0 0 3px rgba(37,99,235,.18);
        outline:none;
    }
    .slider-row{
        display:flex;
        align-items:center;
        gap:12px;
    }
    .slider-row input[type="range"]{
        flex:1;
        accent-color:var(--primary);
    }
    .slider-value{
        width:48px;
        text-align:right;
        font-size:13px;
        color:var(--muted);
    }
    .config-field textarea{
        width:100%;
        border:1px solid var(--line);
        border-radius:16px;
        padding:14px;
        font-size:14px;
        color:var(--text);
        min-height:120px;
        resize:vertical;
        line-height:1.5;
        transition:border-color .18s, box-shadow .18s;
    }
    .config-field textarea:focus{
        border-color:var(--primary);
        box-shadow:0 0 0 3px rgba(37,99,235,.18);
        outline:none;
    }
    .config-footer{
        display:flex;
        justify-content:flex-end;
    }
    .save-btn{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        gap:8px;
        background:var(--accent);
        color:#fff;
        padding:12px 22px;
        border-radius:12px;
        border:none;
        font-weight:600;
        cursor:pointer;
        transition:.18s;
        box-shadow:0 16px 32px rgba(139,92,246,.25);
    }
    .save-btn:hover{filter:brightness(.96);}

    @media (max-width:992px){
        .ai-main{padding:28px;}
        .ai-grid{grid-template-columns:1fr;}
    }
    @media (max-width:768px){
        .ai-main{padding:24px 18px;}
    }
</style>

<jsp:include page="../inc/header.jsp" />
<main class="content-wrapper">
    <section class="page ai-page">
        <% request.setAttribute("activePage", "ai-features"); %>
        <jsp:include page="../inc/side-bar.jsp" />
        <div class="ai-main">
            <div class="ai-header">
                <div>
                    <h1>AI Features</h1>
                    <p>Using Gemini AI for intelligent suggestions and support across chat, scheduling, and customer analysis.</p>
                </div>
                <span class="ai-badge"><i class="ri-flashlight-line"></i> Powered by Gemini AI</span>
            </div>

            <div class="ai-grid">
                <div class="card chat-card">
                    <div class="card-header">
                        <div>
                            <h2>AI Assistant Chat</h2>
                            <p>Ask for scheduling, recommendations, and more.</p>
                        </div>
                    </div>

                    <div class="chat-window" id="aiChatWindow">
                        <!-- Messages will be added dynamically -->
                    </div>

                    <div class="chat-input-row">
                        <input type="text" id="aiChatInput" placeholder="Ask the AI assistant…" />
                        <button class="send-btn" type="button" id="aiSendBtn" aria-label="Send message">
                            <i class="ri-send-plane-2-line"></i>
                        </button>
                    </div>

                    <div class="chat-hints">
                        <p>Try asking:</p>
                        <ul>
                            <li>"What services should I recommend for a Golden Retriever?"</li>
                            <li>"When should I schedule the next appointment?"</li>
                            <li>"How can I improve customer satisfaction?"</li>
                        </ul>
                    </div>
                </div>

                <div class="card insight-card">
                    <div class="card-header">
                        <div>
                            <h2>Customer AI Analysis</h2>
                            <p>Personalised insights generated from recent interactions.</p>
                        </div>
                    </div>
                    <div class="detail-box">
                        <strong>Current Customer</strong>
                        <span>Sarah Johnson</span>
                        <span>Pet: Max &middot; Golden Retriever</span>
                        <span>Last Visit: 2024-01-10</span>
                        <span>Preferred: Grooming, Health Checkup</span>
                    </div>

                    <div>
                        <p class="section-title"><i class="ri-calendar-check-line" style="color:#2563eb;margin-right:6px;"></i>AI Calendar Suggestions</p>
                        <ul class="suggestion-list">
                            <li class="suggestion-item">
                                <div class="suggestion-content">
                                    <strong>Cat Grooming</strong>
                                    <span>2024-01-21 at 9:30 AM</span>
                                </div>
                                <span class="match-badge">91% match</span>
                            </li>
                            <li class="suggestion-item">
                                <div class="suggestion-content">
                                    <strong>Pet Training</strong>
                                    <span>2024-01-23 at 3:30 PM</span>
                                </div>
                                <span class="match-badge">86% match</span>
                            </li>
                            <li class="suggestion-item">
                                <div class="suggestion-content">
                                    <strong>Vaccination</strong>
                                    <span>2024-01-26 at 1:00 PM</span>
                                </div>
                                <span class="match-badge">82% match</span>
                            </li>
                        </ul>
                    </div>

                    <div>
                        <p class="section-title"><i class="ri-magic-line" style="color:#8b5cf6;margin-right:6px;"></i>Service Recommendations</p>
                        <ul class="recommend-list">
                            <li class="recommend-item">
                                <div>
                                    <strong>Senior Pet Care Package</strong>
                                    <span style="display:block;font-size:12px;color:var(--muted);margin-top:4px;">Suitable for older pets needing special attention</span>
                                </div>
                                <span class="confidence-badge">89% confidence</span>
                            </li>
                            <li class="recommend-item">
                                <div>
                                    <strong>Puppy Socialization</strong>
                                    <span style="display:block;font-size:12px;color:var(--muted);margin-top:4px;">High demand in your area</span>
                                </div>
                                <span class="confidence-badge">77% confidence</span>
                            </li>
                            <li class="recommend-item">
                                <div>
                                    <strong>Pet Photography</strong>
                                    <span style="display:block;font-size:12px;color:var(--muted);margin-top:4px;">Popular add-on service</span>
                                </div>
                                <span class="confidence-badge">73% confidence</span>
                            </li>
                        </ul>
                    </div>

                    <button class="generate-btn" type="button" id="generateSuggestionsBtn">
                        <i class="ri-brain-line"></i> Generate New Suggestions
                    </button>
                </div>
            </div>

            <div class="card config-card">
                <div class="card-header">
                    <div>
                        <h2>AI Configuration</h2>
                        <p>Configure your Gemini API integration and assistant behaviour.</p>
                    </div>
                    <div style="display: flex; gap: 10px;">
                        <button class="btn-outline" type="button" id="loadConfigBtn">
                            <i class="ri-refresh-line"></i> Load Current
                        </button>
                        <button class="btn-outline" type="button" id="resetConfigBtn">
                            <i class="ri-restart-line"></i> Reset
                        </button>
                    </div>
                </div>

                <div class="config-grid">
                    <div class="config-field">
                        <label for="apiKey">Gemini API Key</label>
                        <input id="apiKey" type="text" value="YOUR_GEMINI_API_KEY_HERE" />
                        <small style="display:block;margin-top:6px;font-size:12px;color:var(--muted);">
                            Replace with your actual Gemini API key for live functionality.
                        </small>
                    </div>
                    <div class="config-field">
                        <label for="modelSelect">AI Model</label>
                        <select id="modelSelect">
                            <option>Gemini Pro Vision</option>
                            <option>Gemini Pro</option>
                            <option>Gemini Flash</option>
                        </select>
                    </div>
                    <div class="config-field">
                        <label>AI Creativity Level</label>
                        <div class="slider-row">
                            <input id="creativitySlider" type="range" min="0" max="100" value="40" />
                            <span class="slider-value" id="creativityValue">40%</span>
                        </div>
                        <small style="display:block;margin-top:6px;font-size:12px;color:var(--muted);">
                            Lower = more focused, Higher = more creative responses.
                        </small>
                    </div>
                    <div class="config-field">
                        <label for="responseLength">Response Length</label>
                        <input id="responseLength" type="number" value="1000" min="100" step="50" />
                    </div>
                </div>

                <div class="config-field">
                    <label for="systemPrompt">System Prompt</label>
                    <div style="display: flex; gap: 10px; margin-bottom: 10px;">
                        <button class="btn-outline" type="button" id="loadPromptBtn" style="padding: 8px 12px; font-size: 12px;">
                            <i class="ri-download-line"></i> Load from DB
                        </button>
                        <button class="btn-outline" type="button" id="savePromptBtn" style="padding: 8px 12px; font-size: 12px;">
                            <i class="ri-upload-line"></i> Save to DB
                        </button>
                        <button class="btn-outline" type="button" id="previewPromptBtn" style="padding: 8px 12px; font-size: 12px;">
                            <i class="ri-eye-line"></i> Preview
                        </button>
                    </div>
                    <textarea id="systemPrompt" placeholder="Enter your system prompt here...">You are a helpful AI assistant for a pet care management system. Provide professional, caring, and accurate advice about pet care services, scheduling, and customer support. Always prioritise pet welfare and customer satisfaction.</textarea>
                    <div id="promptStats" style="margin-top: 8px; font-size: 12px; color: var(--muted);">
                        <span id="promptLength">0</span> characters
                    </div>
                </div>

                <div class="config-footer">
                    <button class="save-btn" type="button" id="saveConfigBtn">
                        <i class="ri-save-3-line"></i> Save AI Configuration
                    </button>
                </div>
            </div>
        </div>
    </section>
</main>

<script>
    (function(){
        // ===== Global Variables =====
        let currentConfig = null;
        
        // ===== Slider Logic =====
        const slider = document.getElementById('creativitySlider');
        const valueLabel = document.getElementById('creativityValue');
        if (slider && valueLabel) {
            const updateValue = () => valueLabel.textContent = slider.value + '%';
            slider.addEventListener('input', updateValue);
            updateValue();
        }
        
        // ===== Prompt Management =====
        const systemPrompt = document.getElementById('systemPrompt');
        const promptLength = document.getElementById('promptLength');
        
        // Update prompt length counter
        function updatePromptLength() {
            if (systemPrompt && promptLength) {
                promptLength.textContent = systemPrompt.value.length;
            }
        }
        
        if (systemPrompt) {
            systemPrompt.addEventListener('input', updatePromptLength);
            updatePromptLength();
        }
        
        // Load current configuration from database
        async function loadCurrentConfig() {
            try {
                const response = await fetch('<%= request.getContextPath() %>/admin/ai/current');
                const data = await response.json();
                
                if (data.success && data.configuration) {
                    currentConfig = data.configuration;
                    
                    // Update form fields
                    if (systemPrompt) {
                        systemPrompt.value = currentConfig.prompt || '';
                        updatePromptLength();
                    }
                    
                    if (slider) {
                        slider.value = currentConfig.creativityLevel || 40;
                        updateValue();
                    }
                    
                    showNotification('Configuration loaded successfully!', 'success');
                } else {
                    showNotification('Failed to load configuration: ' + (data.error || 'Unknown error'), 'error');
                }
            } catch (error) {
                console.error('Load config error:', error);
                showNotification('Error loading configuration: ' + error.message, 'error');
            }
        }
        
        // Save configuration to database
        async function saveConfiguration() {
            const prompt = systemPrompt ? systemPrompt.value : '';
            const creativityLevel = slider ? parseInt(slider.value) : 40;
            
            if (!prompt.trim()) {
                showNotification('Please enter a system prompt', 'error');
                return;
            }
            
            try {
                const formData = new FormData();
                formData.append('prompt', prompt);
                formData.append('creativityLevel', creativityLevel.toString());
                
                const response = await fetch('<%= request.getContextPath() %>/admin/ai/update-config', {
                    method: 'POST',
                    body: formData
                });
                
                const data = await response.json();
                
                if (data.success) {
                    showNotification('Configuration saved successfully!', 'success');
                    currentConfig = { prompt, creativityLevel };
                } else {
                    showNotification('Failed to save configuration: ' + (data.error || 'Unknown error'), 'error');
                }
            } catch (error) {
                console.error('Save config error:', error);
                showNotification('Error saving configuration: ' + error.message, 'error');
            }
        }
        
        // Load prompt from database
        async function loadPrompt() {
            await loadCurrentConfig();
        }
        
        // Save prompt to database
        async function savePrompt() {
            const prompt = systemPrompt ? systemPrompt.value : '';
            
            if (!prompt.trim()) {
                showNotification('Please enter a system prompt', 'error');
                return;
            }
            
            try {
                const formData = new FormData();
                formData.append('prompt', prompt);
                
                const response = await fetch('<%= request.getContextPath() %>/admin/ai/update-prompt', {
                    method: 'POST',
                    body: formData
                });
                
                const data = await response.json();
                
                if (data.success) {
                    showNotification('Prompt saved successfully!', 'success');
                } else {
                    showNotification('Failed to save prompt: ' + (data.error || 'Unknown error'), 'error');
                }
            } catch (error) {
                console.error('Save prompt error:', error);
                showNotification('Error saving prompt: ' + error.message, 'error');
            }
        }
        
        // Preview prompt
        function previewPrompt() {
            const prompt = systemPrompt ? systemPrompt.value : '';
            
            if (!prompt.trim()) {
                showNotification('Please enter a system prompt to preview', 'error');
                return;
            }
            
            // Create preview modal
            const modal = document.createElement('div');
            modal.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 1000;
            `;
            
            modal.innerHTML = `
                <div style="
                    background: white;
                    padding: 20px;
                    border-radius: 12px;
                    max-width: 600px;
                    max-height: 80vh;
                    overflow-y: auto;
                    box-shadow: 0 20px 40px rgba(0,0,0,0.3);
                ">
                    <h3 style="margin: 0 0 15px 0; color: var(--text);">Prompt Preview</h3>
                    <div style="
                        background: #f8f9fa;
                        padding: 15px;
                        border-radius: 8px;
                        border-left: 4px solid var(--primary);
                        white-space: pre-wrap;
                        font-family: monospace;
                        font-size: 14px;
                        line-height: 1.5;
                        color: var(--text);
                    ">${escapeHtml(prompt)}</div>
                    <div style="margin-top: 15px; text-align: right;">
                        <button onclick="this.closest('.modal').remove()" style="
                            background: var(--primary);
                            color: white;
                            border: none;
                            padding: 8px 16px;
                            border-radius: 6px;
                            cursor: pointer;
                        ">Close</button>
                    </div>
                </div>
            `;
            
            document.body.appendChild(modal);
            
            // Close on click outside
            modal.addEventListener('click', (e) => {
                if (e.target === modal) {
                    modal.remove();
                }
            });
        }
        
        // Reset configuration
        function resetConfiguration() {
            if (confirm('Are you sure you want to reset the configuration to default values?')) {
                if (systemPrompt) {
                    systemPrompt.value = 'You are a helpful AI assistant for a pet care management system. Provide professional, caring, and accurate advice about pet care services, scheduling, and customer support. Always prioritise pet welfare and customer satisfaction.';
                    updatePromptLength();
                }
                
                if (slider) {
                    slider.value = 40;
                    updateValue();
                }
                
                showNotification('Configuration reset to default values', 'info');
            }
        }
        
        // Show notification
        function showNotification(message, type = 'info') {
            const notification = document.createElement('div');
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 12px 20px;
                border-radius: 8px;
                color: white;
                font-weight: 500;
                z-index: 1001;
                animation: slideIn 0.3s ease-out;
            `;
            
            const colors = {
                success: '#10b981',
                error: '#ef4444',
                info: '#3b82f6',
                warning: '#f59e0b'
            };
            
            notification.style.backgroundColor = colors[type] || colors.info;
            notification.textContent = message;
            
            document.body.appendChild(notification);
            
            // Auto remove after 3 seconds
            setTimeout(() => {
                notification.style.animation = 'slideOut 0.3s ease-in';
                setTimeout(() => notification.remove(), 300);
            }, 3000);
        }
        
        // Add CSS for animations
        const style = document.createElement('style');
        style.textContent = `
            @keyframes slideIn {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
            @keyframes slideOut {
                from { transform: translateX(0); opacity: 1; }
                to { transform: translateX(100%); opacity: 0; }
            }
        `;
        document.head.appendChild(style);
        
        // ===== Event Listeners =====
        const loadConfigBtn = document.getElementById('loadConfigBtn');
        const resetConfigBtn = document.getElementById('resetConfigBtn');
        const loadPromptBtn = document.getElementById('loadPromptBtn');
        const savePromptBtn = document.getElementById('savePromptBtn');
        const previewPromptBtn = document.getElementById('previewPromptBtn');
        const saveConfigBtn = document.getElementById('saveConfigBtn');
        
        if (loadConfigBtn) loadConfigBtn.addEventListener('click', loadCurrentConfig);
        if (resetConfigBtn) resetConfigBtn.addEventListener('click', resetConfiguration);
        if (loadPromptBtn) loadPromptBtn.addEventListener('click', loadPrompt);
        if (savePromptBtn) savePromptBtn.addEventListener('click', savePrompt);
        if (previewPromptBtn) previewPromptBtn.addEventListener('click', previewPrompt);
        if (saveConfigBtn) saveConfigBtn.addEventListener('click', saveConfiguration);
        
        // Load configuration on page load
        loadCurrentConfig();

        // ===== Generate Suggestions =====
        const generateBtn = document.getElementById('generateSuggestionsBtn');
        if (generateBtn) {
            generateBtn.addEventListener('click', async () => {
                const originalText = generateBtn.innerHTML;
                generateBtn.innerHTML = '<i class="ri-loader-4-line"></i> Đang tạo gợi ý...';
                generateBtn.disabled = true;

                try {
                    const response = await fetch('<%= request.getContextPath() %>/admin/ai/generate-suggestions?customerId=1', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' }
                    });

                    const data = await response.json();

                    if (data.success && data.calendarSuggestions && data.serviceRecommendations) {
                        // Update calendar suggestions
                        updateCalendarSuggestions(data.calendarSuggestions);
                        
                        // Update service recommendations
                        updateServiceRecommendations(data.serviceRecommendations);
                        
                        alert('Đã tạo gợi ý mới thành công!');
                    } else {
                        throw new Error(data.error || 'Không thể tạo gợi ý');
                    }
                } catch (error) {
                    console.error('Generate error:', error);
                    alert('Có lỗi xảy ra: ' + error.message);
                } finally {
                    generateBtn.innerHTML = originalText;
                    generateBtn.disabled = false;
                }
            });
        }

        // Update calendar suggestions in UI
        function updateCalendarSuggestions(suggestions) {
            const listContainer = document.querySelector('.suggestion-list');
            if (!listContainer) return;

            listContainer.innerHTML = '';
            suggestions.forEach(item => {
                const li = document.createElement('li');
                li.className = 'suggestion-item';
                li.innerHTML = `
                    <div class="suggestion-content">
                        <strong>${escapeHtml(item.service)}</strong>
                        <span>${item.date} at ${item.time}</span>
                    </div>
                    <span class="match-badge">${item.matchPercent}% match</span>
                `;
                listContainer.appendChild(li);
            });
        }

        // Update service recommendations in UI
        function updateServiceRecommendations(recommendations) {
            const listContainer = document.querySelector('.recommend-list');
            if (!listContainer) return;

            listContainer.innerHTML = '';
            recommendations.forEach(item => {
                const li = document.createElement('li');
                li.className = 'recommend-item';
                li.innerHTML = `
                    <div>
                        <strong>${escapeHtml(item.serviceName)}</strong>
                        <span style="display:block;font-size:12px;color:var(--muted);margin-top:4px;">${escapeHtml(item.description)}</span>
                    </div>
                    <span class="confidence-badge">${item.confidence}% confidence</span>
                `;
                listContainer.appendChild(li);
            });
        }

        // Escape HTML to prevent XSS
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        // ===== Chat Functionality =====
        const chatWindow = document.getElementById('aiChatWindow');
        const chatInput = document.getElementById('aiChatInput');
        const sendBtn = document.getElementById('aiSendBtn');

        // Add message to chat
        function addChatMessage(text, isBot) {
            const messageDiv = document.createElement('div');
            messageDiv.className = 'chat-message ' + (isBot ? 'bot' : 'user');
            
            const now = new Date();
            const timeStr = now.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });
            
            if (isBot) {
                messageDiv.innerHTML = `
                    <div class="chat-meta"><i class="ri-robot-line"></i><span>${timeStr}</span></div>
                    <div class="chat-bubble">${escapeHtml(text)}</div>
                `;
            } else {
                messageDiv.innerHTML = `
                    <div class="chat-meta"><span>${timeStr}</span></div>
                    <div class="chat-bubble">${escapeHtml(text)}</div>
                `;
            }
            
            chatWindow.appendChild(messageDiv);
            chatWindow.scrollTop = chatWindow.scrollHeight;
        }

        // Send message to AI
        async function sendAIMessage() {
            const message = chatInput.value.trim();
            if (!message) return;

            addChatMessage(message, false);
            chatInput.value = '';

            // Show loading
            const loadingDiv = document.createElement('div');
            loadingDiv.className = 'chat-message bot';
            loadingDiv.innerHTML = `
                <div class="chat-meta"><i class="ri-robot-line"></i><span>...</span></div>
                <div class="chat-bubble">Đang suy nghĩ...</div>
            `;
            chatWindow.appendChild(loadingDiv);
            chatWindow.scrollTop = chatWindow.scrollHeight;

            try {
                const response = await fetch('<%= request.getContextPath() %>/ai/gemini', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ prompt: message })
                });

                loadingDiv.remove();

                if (!response.ok) {
                    addChatMessage('Xin lỗi, có lỗi xảy ra khi gửi tin nhắn.', true);
                    return;
                }

                const data = await response.json();
                const answer = data.answer || 'Không có phản hồi từ AI.';
                addChatMessage(answer, true);
            } catch (error) {
                loadingDiv.remove();
                addChatMessage('Xin lỗi, không thể kết nối đến AI service.', true);
                console.error('Chat error:', error);
            }
        }

        // Event listeners for chat
        if (sendBtn && chatInput) {
            sendBtn.addEventListener('click', sendAIMessage);
            chatInput.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') sendAIMessage();
            });
        }

        // Initialize with welcome message
        if (chatWindow) {
            addChatMessage('Xin chào! Tôi là trợ lý AI được hỗ trợ bởi Gemini. Tôi có thể giúp bạn về lịch trình, gợi ý dịch vụ và hỗ trợ khách hàng. Tôi có thể giúp gì cho bạn hôm nay?', true);
        }
    })();
</script>
<jsp:include page="../inc/chatbox.jsp" />
<jsp:include page="../inc/footer.jsp" />
