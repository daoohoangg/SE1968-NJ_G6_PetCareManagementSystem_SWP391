<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<title>Configure System</title>
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
    .voucher-header{display:flex;align-items:center;justify-content:space-between;gap:12px}
    .voucher-empty{padding:16px;border:1px dashed var(--line);border-radius:12px;text-align:center;color:var(--muted);background:#fff}
    .voucher-size-control{display:flex;align-items:center;gap:6px;color:var(--muted);font-size:13px}
    .voucher-size-control select{border:1px solid var(--line);border-radius:10px;padding:6px 10px;background:#fff;color:var(--text)}
    .voucher-pagination{display:flex;align-items:center;justify-content:space-between;margin-top:16px;border:1px solid var(--line);border-radius:12px;padding:10px 16px;background:#fff}
    .voucher-pagination .info{font-size:13px;color:var(--muted)}
    .voucher-pagination .controls{display:flex;align-items:center;gap:8px}
    .voucher-pagination .pager-btn{border:1px solid var(--line);background:#fff;border-radius:10px;padding:6px 12px;font-size:13px;font-weight:600;color:var(--text);text-decoration:none;display:inline-flex;align-items:center;gap:6px;transition:.18s}
    .voucher-pagination .pager-btn:hover{border-color:#cbd5f5;color:var(--primary)}
    .voucher-pagination .pager-btn.disabled{opacity:.5;pointer-events:none}
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
    .voucher-form{
        width: 100%;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        align-items: start;
        overflow: hidden;
    }

    .voucher-form > label,
    .voucher-form > .config-input,
    .voucher-form > .config-select,
    .voucher-form > .config-textarea,
    .voucher-form > button{
        min-width: 0;
        max-width: 100%;
    }

    .voucher-form label{
        display: flex;
        flex-direction: column;
        gap: 6px;
        min-width: 0;
    }

    .voucher-form input.config-input,
    .voucher-form select.config-select,
    .voucher-form textarea.config-textarea{
        width: 100%;
        box-sizing: border-box;
    }

    .voucher-form .voucher-add-btn{
        grid-column: 1 / -1;
        width: 100%;
    }

    .config-card{
        overflow: hidden;
    }
    @media (max-width: 560px){
        .voucher-form{
            grid-template-columns: 1fr;
        }
    }
</style>

<jsp:include page="../inc/header.jsp" />
<main class="content-wrapper">
    <section class="page config-page">
        <% request.setAttribute("activePage", "configure-system"); %>
        <jsp:include page="../inc/side-bar.jsp" />
        <div class="config-main">
            <div class="config-card">
            <div class="config-header">
                <h1>Configure System</h1>
                <p>Configure rules, schedules, vouchers, and email notifications</p>
            </div>

            <!-- Flash Messages -->
            <c:if test="${not empty sessionScope.success}">
                <div style="margin:8px 0;color:#065f46;background:#d1fae5;border:1px solid #a7f3d0;padding:10px;border-radius:8px">${sessionScope.success}</div>
                <c:remove var="success" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div style="margin:8px 0;color:#991b1b;background:#fee2e2;border:1px solid #fecaca;padding:10px;border-radius:8px">${sessionScope.error}</div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <div class="config-tabs" role="tablist">
                <button class="config-tab${activeTab eq 'schedule' ? ' active' : ''}" data-target="schedule" type="button">
                    <i class="ri-calendar-line"></i> Schedule
                </button>
                <button class="config-tab${activeTab eq 'vouchers' ? ' active' : ''}" data-target="vouchers" type="button">
                    <i class="ri-gift-line"></i> Vouchers
                </button>
                <button class="config-tab${activeTab eq 'email' ? ' active' : ''}" data-target="email" type="button">
                    <i class="ri-mail-send-line"></i> Email
                </button>
                <button class="config-tab${activeTab eq 'rules' ? ' active' : ''}" data-target="rules" type="button">
                    <i class="ri-shield-check-line"></i> Rules
                </button>
            </div>

            <div class="tab-panel${activeTab eq 'schedule' ? ' active' : ''}" data-panel="schedule">
                <form method="post" action="${pageContext.request.contextPath}/admin/config">
                    <input type="hidden" name="action" value="update-schedule"/>
                    <input type="hidden" name="tab" value="schedule"/>
                    
                    <div class="setting-section">
                        <h2>Business Hours</h2>
                        <div class="schedule-list">
                            <c:forEach var="day" items="${['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY']}">
                                <c:set var="dayName" value="${day}"/>
                                <c:set var="dayLower" value="${fn:toLowerCase(day)}"/>
                                <c:set var="dayData" value="${scheduleData != null ? scheduleData.get(day) : null}"/>
                                <c:set var="isOpen" value="${dayData != null ? dayData.open : false}"/>
                                <c:set var="openTime" value="${dayData != null && dayData.openTime != null ? dayData.openTime : '08:00'}"/>
                                <c:set var="closeTime" value="${dayData != null && dayData.closeTime != null ? dayData.closeTime : '18:00'}"/>
                                
                                <div class="schedule-row${!isOpen ? ' closed' : ''}">
                                    <div class="schedule-left">
                                        <label class="toggle">
                                            <input type="checkbox" name="${dayLower}Open" value="on" 
                                                   <c:if test="${isOpen}">checked</c:if> 
                                                   onchange="toggleDaySchedule(this, '${dayLower}')"/>
                                            <span class="toggle-track"></span>
                                        </label>
                                        <div>
                                            <div class="day-name">${dayName}</div>
                                            <div class="day-status">
                                                <c:choose>
                                                    <c:when test="${isOpen}">Open</c:when>
                                                    <c:otherwise>Closed</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="schedule-times" id="times-${dayLower}">
                                        <c:choose>
                                            <c:when test="${isOpen}">
                                                <label class="time-field">From
                                                    <input class="config-input" type="time" name="${dayLower}OpenTime" value="${openTime}"/>
                                                </label>
                                                <label class="time-field">To
                                                    <input class="config-input" type="time" name="${dayLower}CloseTime" value="${closeTime}"/>
                                                </label>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="day-status">Closed</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="save-btn">
                            <i class="ri-checkbox-circle-line"></i> Save Business Hours
                        </button>
                    </div>
                </form>
            </div>

            <div class="tab-panel${activeTab eq 'vouchers' ? ' active' : ''}" data-panel="vouchers">
                <div class="setting-section">
                    <h2>Add New Voucher</h2>
                    <form class="voucher-form" method="post" action="${pageContext.request.contextPath}/admin/vouchers">
                        <input type="hidden" name="action" value="create"/>
                        <label>
                            Voucher Code
                            <input class="config-input" name="code" type="text" placeholder="WELCOME20" required/>
                        </label>
                        <label>
                            Discount Value
                            <input class="config-input" name="discountValue" type="number" min="0" step="0.01" placeholder="20" required/>
                        </label>
                        <label>
                            Type
                            <select class="config-select" name="discountType">
                                <option value="PERCENTAGE">Percentage</option>
                                <option value="FIXED">Fixed Amount</option>
                            </select>
                        </label>
                        <label>
                            Expiry Date
                            <input class="config-input" name="expiryDate" type="date"/>
                        </label>
                        <label>
                            Max Uses
                            <input class="config-input" name="maxUses" type="number" min="1" placeholder="Unlimited when empty"/>
                        </label>
                        <button type="submit" class="voucher-add-btn">
                            <i class="ri-add-line"></i> Add Voucher
                        </button>
                    </form>
                </div>

                <div class="setting-section">
                    <div class="voucher-header">
                        <h2>Existing Vouchers</h2>
                        <form class="voucher-size-control" method="get" action="${pageContext.request.contextPath}/admin/config">
                            <input type="hidden" name="tab" value="vouchers"/>
                            <label>
                                Show
                                <select name="voucherSize" onchange="this.form.submit()">
                                    <option value="5" <c:if test="${voucherPageSize == 5}">selected</c:if>>5</option>
                                    <option value="10" <c:if test="${voucherPageSize == 10}">selected</c:if>>10</option>
                                    <option value="20" <c:if test="${voucherPageSize == 20}">selected</c:if>>20</option>
                                </select>
                                per page
                            </label>
                        </form>
                    </div>
                    <c:if test="${empty vouchers}">
                        <div class="voucher-empty">No vouchers available.</div>
                    </c:if>
                    <c:forEach var="voucher" items="${vouchers}">
                        <div class="voucher-item">
                            <div class="voucher-meta">
                                <span class="voucher-code"><c:out value="${voucher.code}"/></span>
                                <div class="voucher-info">
                                    <span>
                                        <c:choose>
                                            <c:when test="${voucher.discountType == 'PERCENTAGE'}">
                                                <c:out value="${voucher.discountValue}"/>% off
                                            </c:when>
                                            <c:when test="${voucher.discountType == 'FIXED'}">
                                                $<fmt:formatNumber value="${voucher.discountValue}" type="number" minFractionDigits="2"/> off
                                            </c:when>
                                            <c:otherwise>Free service</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span>
                                        Expires:
                                        <c:choose>
                                            <c:when test="${voucher.expiryDate != null}">
                                                <c:out value="${fn:substring(voucher.expiryDate, 0, 10)}"/>
                                            </c:when>
                                            <c:otherwise>None</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span>
                                        Uses:
                                        <c:out value="${voucher.timesUsed != null ? voucher.timesUsed : 0}"/> /
                                        <c:choose>
                                            <c:when test="${voucher.maxUses != null}">
                                                <c:out value="${voucher.maxUses}"/>
                                            </c:when>
                                            <c:otherwise>&#8734;</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                            <div class="voucher-actions">
                                <form method="post" action="${pageContext.request.contextPath}/admin/vouchers">
                                    <input type="hidden" name="action" value="update-status"/>
                                    <input type="hidden" name="voucherId" value="${voucher.voucherId}"/>
                                    <input type="hidden" name="targetStatus" value="${not voucher.active}"/>
                                    <input type="hidden" name="voucherPage" value="${voucherCurrentPage}"/>
                                    <input type="hidden" name="voucherSize" value="${voucherPageSize}"/>
                                    <label class="toggle" title="${voucher.active ? 'Deactivate voucher' : 'Activate voucher'}">
                                        <input type="checkbox" onchange="this.form.submit()" <c:if test="${voucher.active}">checked</c:if> />
                                        <span class="toggle-track"></span>
                                    </label>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/admin/vouchers" onsubmit="return confirm('Delete this voucher?');">
                                    <input type="hidden" name="action" value="delete"/>
                                    <input type="hidden" name="voucherId" value="${voucher.voucherId}"/>
                                <input type="hidden" name="voucherPage" value="${voucherCurrentPage}"/>
                                <input type="hidden" name="voucherSize" value="${voucherPageSize}"/>
                                    <button type="submit" class="icon-btn" title="Delete">
                                        <i class="ri-delete-bin-line"></i>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${voucherTotalItems > 0}">
                        <c:url var="voucherPrevUrl" value="/admin/config">
                            <c:param name="tab" value="vouchers"/>
                            <c:param name="voucherSize" value="${voucherPageSize}"/>
                            <c:param name="voucherPage" value="${voucherCurrentPage - 1}"/>
                        </c:url>
                        <c:url var="voucherNextUrl" value="/admin/config">
                            <c:param name="tab" value="vouchers"/>
                            <c:param name="voucherSize" value="${voucherPageSize}"/>
                            <c:param name="voucherPage" value="${voucherCurrentPage + 1}"/>
                        </c:url>
                        <div class="voucher-pagination">
                            <div class="info">
                                Showing <c:out value="${voucherPageStart}" /> - <c:out value="${voucherPageEnd}" /> of <c:out value="${voucherTotalItems}" />
                            </div>
                            <div class="controls">
                                <c:choose>
                                    <c:when test="${voucherHasPrev}">
                                        <a class="pager-btn" href="${voucherPrevUrl}"><i class="ri-arrow-left-line"></i> Prev</a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="pager-btn disabled"><i class="ri-arrow-left-line"></i> Prev</span>
                                    </c:otherwise>
                                </c:choose>
                                <span class="info">Page <c:out value="${voucherCurrentPage}" /> of <c:out value="${voucherTotalPages}" /></span>
                                <c:choose>
                                    <c:when test="${voucherHasNext}">
                                        <a class="pager-btn" href="${voucherNextUrl}">Next <i class="ri-arrow-right-line"></i></a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="pager-btn disabled">Next <i class="ri-arrow-right-line"></i></span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="tab-panel${activeTab eq 'email' ? ' active' : ''}" data-panel="email">
                <!-- Email Notifications Configuration -->
                <form method="post" action="${pageContext.request.contextPath}/admin/config">
                    <input type="hidden" name="action" value="update-email"/>
                    <input type="hidden" name="tab" value="email"/>
                    
                    <div class="setting-section">
                        <h2>Email Notifications</h2>
                        <div class="setting-row">
                            <div class="setting-info">
                                <div class="setting-title">Appointment Confirmation</div>
                                <div class="setting-desc">Send confirmation emails for new appointments</div>
                            </div>
                            <label class="toggle">
                                <input type="checkbox" name="appointmentConfirmation" 
                                       <c:if test="${emailRule != null && emailRule.appointmentConfirmation}">checked</c:if>/>
                                <span class="toggle-track"></span>
                            </label>
                        </div>
                        <div class="setting-row">
                            <div class="setting-info">
                                <div class="setting-title">Reminder Notifications</div>
                                <div class="setting-desc">Send appointment reminders to customers</div>
                            </div>
                            <label class="toggle">
                                <input type="checkbox" name="reminderNotify" 
                                       <c:if test="${emailRule != null && emailRule.reminderNotify}">checked</c:if>/>
                                <span class="toggle-track"></span>
                            </label>
                        </div>
                        <div class="setting-row">
                            <div class="setting-info">
                                <div class="setting-title">Promotional Emails</div>
                                <div class="setting-desc">Send marketing and promotional emails</div>
                            </div>
                            <label class="toggle">
                                <input type="checkbox" name="promotionalEmail" 
                                       <c:if test="${emailRule != null && emailRule.promotionalEmail}">checked</c:if>/>
                                <span class="toggle-track"></span>
                            </label>
                        </div>
                    </div>

                    <div class="setting-section">
                        <h2>Reminder Settings</h2>
                        <div class="number-inputs">
                            <label>
                                Reminder Hours Before Appointment
                                <input class="config-input" type="number" name="reminderHours" min="1" max="23" 
                                       value="${emailRule != null && emailRule.reminderHours != null ? emailRule.reminderHours : 24}"/>
                            </label>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="save-btn">
                            <i class="ri-checkbox-circle-line"></i> Save Email Settings
                        </button>
                    </div>
                </form>
            </div>

            <div class="tab-panel${activeTab eq 'rules' ? ' active' : ''}" data-panel="rules">
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

    // Toggle day schedule functionality
    function toggleDaySchedule(checkbox, dayName) {
        const scheduleRow = checkbox.closest('.schedule-row');
        const timesContainer = document.getElementById('times-' + dayName);
        const dayStatus = scheduleRow.querySelector('.day-status');
        
        if (checkbox.checked) {
            // Show time inputs
            scheduleRow.classList.remove('closed');
            dayStatus.textContent = 'Open';
            
            // Create time inputs if they don't exist
            if (!timesContainer.querySelector('input[type="time"]')) {
                timesContainer.innerHTML = `
                    <label class="time-field">From
                        <input class="config-input" type="time" name="${dayName}OpenTime" value="08:00"/>
                    </label>
                    <label class="time-field">To
                        <input class="config-input" type="time" name="${dayName}CloseTime" value="18:00"/>
                    </label>
                `;
            }
        } else {
            // Hide time inputs
            scheduleRow.classList.add('closed');
            dayStatus.textContent = 'Closed';
            timesContainer.innerHTML = '<span class="day-status">Closed</span>';
        }
    }
</script>
<jsp:include page="../inc/chatbox.jsp" />
<jsp:include page="../inc/footer.jsp" />
