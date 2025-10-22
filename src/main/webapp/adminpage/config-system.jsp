<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<style>
    :root{
        --primary:#2563eb;
        --primary-surface:#eef2ff;
        --accent:#16a34a;
        --text:#1f2937;
        --muted:#6b7280;
        --line:#e5e7eb;
        --bg:#f7f9fc;
        --surface:#f3f4f6;
    }
    .config-page{
        display:flex;
        background:var(--bg);
        font-family:Inter,system-ui,Segoe UI,Roboto,Arial,sans-serif;
        flex:1 0 auto;
        width:100%;
        min-height:0;
    }
    .config-main{flex:1;padding:32px 40px}
    .config-card{
        background:#fff;border:1px solid rgba(148,163,184,.25);border-radius:18px;
        box-shadow:0 20px 45px rgba(15,23,42,.08);padding:32px 36px;max-width:960px;margin:0 auto;
    }
    .config-header h1{margin:0;font-size:26px;font-weight:600;color:var(--text)}
    .config-header p{margin:6px 0 28px;font-size:14px;color:var(--muted)}

    .config-tabs{
        display:flex;align-items:center;gap:12px;
        background:var(--surface);padding:6px;border-radius:999px;margin-bottom:28px;
        border:1px solid rgba(148,163,184,.3);
    }
    .config-tab{
        position:relative;display:flex;align-items:center;gap:8px;
        padding:10px 20px;border:none;border-radius:999px;background:transparent;
        font-size:14px;font-weight:600;color:#4b5563;cursor:pointer;transition:.18s;
    }
    .config-tab i{font-size:18px}
    .config-tab.active{
        background:#fff;color:var(--primary);box-shadow:0 10px 20px rgba(37,99,235,.15);
    }
    .config-tab:not(.active):hover{color:var(--primary)}

    .tab-panel{display:none;animation:fadeIn .24s ease-out}
    .tab-panel.active{display:block}

    .setting-section + .setting-section{margin-top:28px}
    .setting-section h2{
        margin:0 0 18px;font-size:18px;font-weight:600;color:var(--text);
    }
    .setting-row{
        display:flex;align-items:flex-start;justify-content:space-between;
        gap:18px;padding:16px 0;border-bottom:1px solid var(--line);
    }
    .setting-row:last-child{border-bottom:none}
    .setting-info{flex:1}
    .setting-title{font-size:15px;font-weight:600;color:var(--text);margin-bottom:4px}
    .setting-desc{font-size:13px;color:var(--muted)}

    .toggle{
        position:relative;width:46px;height:24px;display:inline-flex;align-items:center;
    }
    .toggle input{display:none}
    .toggle-track{
        width:100%;height:100%;background:#d1d5db;border-radius:999px;position:relative;transition:.18s;
    }
    .toggle-track::after{
        content:"";position:absolute;top:3px;left:3px;width:18px;height:18px;border-radius:50%;
        background:#fff;box-shadow:0 2px 4px rgba(15,23,42,.3);transition:.18s;
    }
    .toggle input:checked + .toggle-track{background:var(--primary)}
    .toggle input:checked + .toggle-track::after{transform:translateX(22px)}
    .toggle input:disabled + .toggle-track{background:#e5e7eb;opacity:.6;cursor:not-allowed}

    .number-inputs{display:flex;flex-wrap:wrap;gap:14px}
    .number-inputs label{display:flex;flex-direction:column;font-size:13px;color:var(--muted);gap:6px}
    .config-input,
    .config-select,
    .config-textarea{
        border:1px solid var(--line);border-radius:12px;
        padding:12px 14px;font-size:14px;color:var(--text);background:#fff;
        transition:border-color .18s, box-shadow .18s;
    }
    .config-select{min-width:160px}
    .config-input:focus,
    .config-select:focus,
    .config-textarea:focus{
        border-color:var(--primary);box-shadow:0 0 0 3px rgba(37,99,235,.18);outline:none;
    }
    .config-textarea{min-height:110px;resize:vertical}

    .voucher-form{display:grid;grid-template-columns:repeat(auto-fit,minmax(160px,1fr));gap:16px;margin-bottom:18px}
    .voucher-form .full{grid-column:1 / -1}
    .voucher-add-btn{
        grid-column:1 / -1;
        display:inline-flex;align-items:center;justify-content:center;gap:8px;
        padding:12px;border-radius:12px;border:none;background:var(--primary);color:#fff;
        font-weight:600;font-size:15px;cursor:pointer;transition:.18s;
    }
    .voucher-add-btn:hover{filter:brightness(.95)}

    .voucher-list{display:flex;flex-direction:column;gap:12px;margin-top:16px}
    .voucher-item{
        display:flex;align-items:center;justify-content:space-between;
        border:1px solid var(--line);border-radius:12px;padding:12px 16px;background:#fff;
        box-shadow:0 2px 5px rgba(15,23,42,.06);
    }
    .voucher-meta{display:flex;align-items:center;gap:12px}
    .voucher-code{
        display:inline-flex;align-items:center;justify-content:center;
        padding:6px 12px;border-radius:999px;background:#111827;color:#fff;font-size:12px;font-weight:600;
        letter-spacing:.6px;text-transform:uppercase;
    }
    .voucher-info{font-size:13px;color:var(--text)}
    .voucher-info span{color:var(--muted);margin-left:8px}
    .voucher-actions{display:flex;align-items:center;gap:12px}
    .icon-btn{
        width:36px;height:36px;display:inline-flex;align-items:center;justify-content:center;
        border:1px solid var(--line);border-radius:10px;background:#fff;color:#4b5563;
        cursor:pointer;transition:.18s;
    }
    .icon-btn:hover{border-color:#cbd5f5;color:var(--primary)}

    .schedule-list{display:flex;flex-direction:column;border:1px solid var(--line);border-radius:16px;overflow:hidden}
    .schedule-row{
        display:flex;align-items:center;justify-content:space-between;padding:14px 18px;
        border-bottom:1px solid var(--line);background:#fff;
    }
    .schedule-row:last-child{border-bottom:none;border-radius:0 0 16px 16px}
    .schedule-left{display:flex;align-items:center;gap:14px}
    .day-name{font-size:15px;font-weight:600;color:var(--text)}
    .day-status{font-size:12px;color:var(--muted)}
    .schedule-times{display:flex;align-items:center;gap:12px}
    .time-field{display:flex;align-items:center;gap:8px;font-size:13px;color:var(--muted)}
    .time-field input{width:110px}
    .schedule-row.closed{background:#f9fafb}
    .schedule-row.closed .day-name{color:#9ca3af}

    .form-actions{display:flex;justify-content:flex-end;margin-top:32px}
    .save-btn{
        display:inline-flex;align-items:center;gap:10px;
        background:var(--accent);color:#fff;font-weight:600;font-size:15px;
        border:none;padding:12px 22px;border-radius:14px;cursor:pointer;
        box-shadow:0 12px 25px rgba(22,163,74,.25);transition:.18s;
    }
    .save-btn:hover{filter:brightness(.95)}

    @media (max-width:1024px){
        .config-main{padding:28px 24px}
        .config-card{padding:28px 24px}
        .schedule-times{flex-direction:column;align-items:flex-start}
    }
    @media (max-width:720px){
        .config-tabs{flex-wrap:wrap}
        .config-tab{flex:1 0 46%;justify-content:center}
        .schedule-row{flex-direction:column;align-items:flex-start;gap:12px}
        .voucher-item{flex-direction:column;align-items:flex-start;gap:12px}
        .form-actions{justify-content:stretch}
        .save-btn{width:100%;justify-content:center}
    }
    @keyframes fadeIn{
        from{opacity:0;transform:translateY(8px)}
        to{opacity:1;transform:translateY(0)}
    }
</style>

<jsp:include page="../inc/header.jsp" />
<main class="content-wrapper">
    <section class="page config-page">
        <% request.setAttribute("currentPage", "configure-system"); %>
        <jsp:include page="../inc/side-bar.jsp" />
        <div class="config-main">
            <div class="config-card">
            <div class="config-header">
                <h1>System Configuration</h1>
                <p>Configure rules, schedules, vouchers, and email notifications</p>
            </div>

            <div class="config-tabs" role="tablist">
                <button class="config-tab active" data-target="schedule" type="button">
                    <i class="ri-calendar-line"></i> Schedule
                </button>
                <button class="config-tab" data-target="vouchers" type="button">
                    <i class="ri-gift-line"></i> Vouchers
                </button>
                <button class="config-tab" data-target="email" type="button">
                    <i class="ri-mail-send-line"></i> Email
                </button>
                <button class="config-tab" data-target="rules" type="button">
                    <i class="ri-shield-check-line"></i> Rules
                </button>
            </div>

            <div class="tab-panel active" data-panel="schedule">
                <div class="setting-section">
                    <h2>Business Hours</h2>
                    <div class="schedule-list">
                        <div class="schedule-row">
                            <div class="schedule-left">
                                <label class="toggle">
                                    <input type="checkbox" checked/>
                                    <span class="toggle-track"></span>
                                </label>
                                <div>
                                    <div class="day-name">Monday</div>
                                    <div class="day-status">Open</div>
                                </div>
                            </div>
                            <div class="schedule-times">
                                <label class="time-field">From
                                    <input class="config-input" type="time" value="08:00"/>
                                </label>
                                <label class="time-field">To
                                    <input class="config-input" type="time" value="18:00"/>
                                </label>
                            </div>
                        </div>
                        <div class="schedule-row">
                            <div class="schedule-left">
                                <label class="toggle">
                                    <input type="checkbox" checked/>
                                    <span class="toggle-track"></span>
                                </label>
                                <div>
                                    <div class="day-name">Tuesday</div>
                                    <div class="day-status">Open</div>
                                </div>
                            </div>
                            <div class="schedule-times">
                                <label class="time-field">From
                                    <input class="config-input" type="time" value="08:00"/>
                                </label>
                                <label class="time-field">To
                                    <input class="config-input" type="time" value="18:00"/>
                                </label>
                            </div>
                        </div>
                        <div class="schedule-row">
                            <div class="schedule-left">
                                <label class="toggle">
                                    <input type="checkbox" checked/>
                                    <span class="toggle-track"></span>
                                </label>
                                <div>
                                    <div class="day-name">Wednesday</div>
                                    <div class="day-status">Open</div>
                                </div>
                            </div>
                            <div class="schedule-times">
                                <label class="time-field">From
                                    <input class="config-input" type="time" value="08:00"/>
                                </label>
                                <label class="time-field">To
                                    <input class="config-input" type="time" value="18:00"/>
                                </label>
                            </div>
                        </div>
                        <div class="schedule-row">
                            <div class="schedule-left">
                                <label class="toggle">
                                    <input type="checkbox" checked/>
                                    <span class="toggle-track"></span>
                                </label>
                                <div>
                                    <div class="day-name">Thursday</div>
                                    <div class="day-status">Open</div>
                                </div>
                            </div>
                            <div class="schedule-times">
                                <label class="time-field">From
                                    <input class="config-input" type="time" value="08:00"/>
                                </label>
                                <label class="time-field">To
                                    <input class="config-input" type="time" value="18:00"/>
                                </label>
                            </div>
                        </div>
                        <div class="schedule-row">
                            <div class="schedule-left">
                                <label class="toggle">
                                    <input type="checkbox" checked/>
                                    <span class="toggle-track"></span>
                                </label>
                                <div>
                                    <div class="day-name">Friday</div>
                                    <div class="day-status">Open</div>
                                </div>
                            </div>
                            <div class="schedule-times">
                                <label class="time-field">From
                                    <input class="config-input" type="time" value="08:00"/>
                                </label>
                                <label class="time-field">To
                                    <input class="config-input" type="time" value="18:00"/>
                                </label>
                            </div>
                        </div>
                        <div class="schedule-row">
                            <div class="schedule-left">
                                <label class="toggle">
                                    <input type="checkbox" checked/>
                                    <span class="toggle-track"></span>
                                </label>
                                <div>
                                    <div class="day-name">Saturday</div>
                                    <div class="day-status">Open</div>
                                </div>
                            </div>
                            <div class="schedule-times">
                                <label class="time-field">From
                                    <input class="config-input" type="time" value="09:00"/>
                                </label>
                                <label class="time-field">To
                                    <input class="config-input" type="time" value="17:00"/>
                                </label>
                            </div>
                        </div>
                        <div class="schedule-row closed">
                            <div class="schedule-left">
                                <label class="toggle">
                                    <input type="checkbox" disabled/>
                                    <span class="toggle-track"></span>
                                </label>
                                <div>
                                    <div class="day-name">Sunday</div>
                                    <div class="day-status">Closed</div>
                                </div>
                            </div>
                            <div class="schedule-times">
                                <span class="day-status">Closed</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="tab-panel" data-panel="vouchers">
                <div class="setting-section">
                    <h2>Add New Voucher</h2>
                    <div class="voucher-form">
                        <label>
                            Voucher Code
                            <input class="config-input" type="text" placeholder="WELCOME20"/>
                        </label>
                        <label>
                            Discount Amount
                            <input class="config-input" type="number" min="0" placeholder="20"/>
                        </label>
                        <label>
                            Type
                            <select class="config-select">
                                <option>Percentage</option>
                                <option>Fixed Amount</option>
                                <option>Free Service</option>
                            </select>
                        </label>
                        <label>
                            Expiry Date
                            <input class="config-input" type="date"/>
                        </label>
                        <button type="button" class="voucher-add-btn">
                            <i class="ri-add-line"></i> Add Voucher
                        </button>
                    </div>
                </div>

                <div class="setting-section">
                    <h2>Existing Vouchers</h2>
                    <div class="voucher-list">
                        <div class="voucher-item">
                            <div class="voucher-meta">
                                <span class="voucher-code">WELCOME20</span>
                                <div class="voucher-info">20% off<span>Expires: 2024-12-31</span></div>
                            </div>
                            <div class="voucher-actions">
                                <label class="toggle">
                                    <input type="checkbox" checked/>
                                    <span class="toggle-track"></span>
                                </label>
                                <button type="button" class="icon-btn" title="Delete">
                                    <i class="ri-delete-bin-line"></i>
                                </button>
                            </div>
                        </div>
                        <div class="voucher-item">
                            <div class="voucher-meta">
                                <span class="voucher-code">NEWCLIENT10</span>
                                <div class="voucher-info">$10 off<span>Expires: 2024-11-30</span></div>
                            </div>
                            <div class="voucher-actions">
                                <label class="toggle">
                                    <input type="checkbox" checked/>
                                    <span class="toggle-track"></span>
                                </label>
                                <button type="button" class="icon-btn" title="Delete">
                                    <i class="ri-delete-bin-line"></i>
                                </button>
                            </div>
                        </div>
                        <div class="voucher-item">
                            <div class="voucher-meta">
                                <span class="voucher-code">LOYAL15</span>
                                <div class="voucher-info">15% off<span>Expires: 2024-10-31</span></div>
                            </div>
                            <div class="voucher-actions">
                                <label class="toggle">
                                    <input type="checkbox"/>
                                    <span class="toggle-track"></span>
                                </label>
                                <button type="button" class="icon-btn" title="Delete">
                                    <i class="ri-delete-bin-line"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="tab-panel" data-panel="email">
                <div class="setting-section">
                    <h2>Email Notifications</h2>
                    <div class="setting-row">
                        <div class="setting-info">
                            <div class="setting-title">Appointment Confirmation</div>
                            <div class="setting-desc">Send confirmation emails for new appointments</div>
                        </div>
                        <label class="toggle">
                            <input type="checkbox" checked/>
                            <span class="toggle-track"></span>
                        </label>
                    </div>
                    <div class="setting-row">
                        <div class="setting-info">
                            <div class="setting-title">Reminder Notifications</div>
                            <div class="setting-desc">Send appointment reminders to customers</div>
                        </div>
                        <label class="toggle">
                            <input type="checkbox" checked/>
                            <span class="toggle-track"></span>
                        </label>
                    </div>
                    <div class="setting-row">
                        <div class="setting-info">
                            <div class="setting-title">Promotional Emails</div>
                            <div class="setting-desc">Send marketing and promotional emails</div>
                        </div>
                        <label class="toggle">
                            <input type="checkbox"/>
                            <span class="toggle-track"></span>
                        </label>
                    </div>
                </div>

                <div class="setting-section">
                    <h2>Reminder Settings</h2>
                    <div class="number-inputs">
                        <label>
                            Reminder Hours Before Appointment
                            <input class="config-input" type="number" value="24"/>
                        </label>
                    </div>
                </div>

                <div class="setting-section">
                    <h2>Email Template</h2>
                    <textarea class="config-textarea">Dear {customerName}, your appointment for {serviceName} is scheduled for {date} at {time}.</textarea>
                    <p class="setting-desc" style="margin-top:8px">Use {customerName}, {serviceName}, {date}, {time} as placeholders</p>
                </div>
            </div>

            <div class="tab-panel" data-panel="rules">
                <div class="setting-section">
                    <h2>Booking Rules</h2>
                    <div class="number-inputs">
                        <label>
                            Maximum Advance Booking (days)
                            <input class="config-input" type="number" value="90"/>
                        </label>
                        <label>
                            Cancellation Notice (hours)
                            <input class="config-input" type="number" value="24"/>
                        </label>
                    </div>
                </div>

                <div class="setting-section">
                    <div class="setting-row">
                        <div class="setting-info">
                            <div class="setting-title">Auto-confirmation</div>
                            <div class="setting-desc">Automatically confirm bookings</div>
                        </div>
                        <label class="toggle">
                            <input type="checkbox" checked/>
                            <span class="toggle-track"></span>
                        </label>
                    </div>
                    <div class="setting-row">
                        <div class="setting-info">
                            <div class="setting-title">Require Deposit</div>
                            <div class="setting-desc">Require deposit for bookings</div>
                        </div>
                        <label class="toggle">
                            <input type="checkbox"/>
                            <span class="toggle-track"></span>
                        </label>
                    </div>
                </div>
            </div>

            <div class="form-actions">
                <button type="button" class="save-btn">
                    <i class="ri-checkbox-circle-line"></i> Save All Settings
                </button>
            </div>
            </div>
        </div>
    </section>
</main>

<script>
    (function(){
        const tabs = document.querySelectorAll('.config-tab');
        const panels = document.querySelectorAll('.tab-panel');
        if(!tabs.length || !panels.length) return;
        tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                const target = tab.dataset.target;
                tabs.forEach(btn => btn.classList.toggle('active', btn === tab));
                panels.forEach(panel => panel.classList.toggle('active', panel.dataset.panel === target));
            });
        });
    })();
</script>
<jsp:include page="../inc/chatbox.jsp" />
<jsp:include page="../inc/footer.jsp" />
