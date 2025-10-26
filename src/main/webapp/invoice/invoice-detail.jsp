<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Invoice Detail - ${invoice.invoiceNumber}</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --text: #1f2937;
            --muted: #6b7280;
            --line: #e5e7eb;
            --bg: #f7f9fc;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Inter, system-ui, sans-serif;
            color: var(--text);
            background: var(--bg);
        }

        .layout {
            display: flex;
            min-height: 100vh;
        }

        .content {
            flex: 1;
            padding: 28px 36px;
            max-width: 900px;
            margin: 0 auto;
        }

        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }

        h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 700;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            background: #f3f4f6;
            color: var(--text);
            border: none;
            cursor: pointer;
        }

        .btn:hover {
            background: #e5e7eb;
        }

        .btn-primary {
            background: var(--primary);
            color: #fff;
        }

        .btn-primary:hover {
            filter: brightness(.96);
        }

        .card {
            background: white;
            border: 1px solid var(--line);
            border-radius: 14px;
            padding: 32px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
            margin-bottom: 20px;
        }

        .invoice-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 32px;
            padding-bottom: 24px;
            border-bottom: 2px solid var(--line);
        }

        .invoice-number {
            font-size: 32px;
            font-weight: 700;
            color: var(--primary);
            margin: 0;
        }

        .badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 600;
            border: 1px solid;
        }

        .badge.success {
            border-color: #bbf7d0;
            color: #15803d;
            background: #f0fdf4;
        }

        .badge.warning {
            border-color: #fde68a;
            color: #92400e;
            background: #fefce8;
        }

        .badge.danger {
            border-color: #fecaca;
            color: #991b1b;
            background: #fef2f2;
        }

        .badge.primary {
            border-color: #bfdbfe;
            color: #1d4ed8;
            background: #eff6ff;
        }

        .badge.secondary {
            border-color: #d1d5db;
            color: #374151;
            background: #f9fafb;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 32px;
            margin-bottom: 32px;
        }

        .info-section h3 {
            margin: 0 0 12px 0;
            font-size: 14px;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .info-section p {
            margin: 4px 0;
            font-size: 15px;
        }

        .info-section strong {
            font-weight: 600;
        }

        .amount-table {
            margin-top: 32px;
            border-top: 2px solid var(--line);
            padding-top: 24px;
        }

        .amount-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            font-size: 15px;
        }

        .amount-row.total {
            border-top: 2px solid var(--line);
            margin-top: 12px;
            padding-top: 16px;
            font-size: 20px;
            font-weight: 700;
            color: var(--primary);
        }

        .notes-section {
            padding: 20px;
            background: #fffbeb;
            border-left: 4px solid #f59e0b;
            border-radius: 10px;
            margin-top: 24px;
        }

        .notes-section h3 {
            margin: 0 0 12px 0;
            font-size: 16px;
            color: #92400e;
        }

        .notes-section p {
            margin: 0;
            line-height: 1.6;
            color: #78350f;
        }

        .action-buttons {
            display: flex;
            gap: 12px;
            margin-top: 24px;
        }

        @media (max-width: 768px) {
            .content {
                padding: 20px;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .invoice-header {
                flex-direction: column;
                gap: 16px;
            }
        }
    </style>
</head>
<body>
<jsp:include page="../inc/header.jsp"/>
<div class="layout">
    <% request.setAttribute("currentPage", "invoices"); %>
    <jsp:include page="../inc/side-bar.jsp"/>

    <main class="content">
        <div class="header">
            <h1>Invoice Detail</h1>
            <a href="${pageContext.request.contextPath}/invoices" class="btn">
                <i class="ri-arrow-left-line"></i> Back to List
            </a>
        </div>

        <div class="card">
            <div class="invoice-header">
                <div>
                    <p class="invoice-number">${invoice.invoiceNumber}</p>
                    <p style="margin:8px 0 0 0;color:var(--muted)">
                        <i class="ri-calendar-line"></i> Issued: ${invoice.formattedIssueDate}
                    </p>
                </div>
                <span class="badge ${invoice.statusBadgeClass}">${invoice.status}</span>
            </div>

            <div class="info-grid">
                <div class="info-section">
                    <h3>Bill To</h3>
                    <c:choose>
                        <c:when test="${invoice.customer != null}">
                            <p><strong>${invoice.customer.fullName}</strong></p>
                            <p><i class="ri-mail-line"></i> ${invoice.customer.email}</p>
                            <p><i class="ri-phone-line"></i> ${invoice.customer.phone}</p>
                        </c:when>
                        <c:otherwise>
                            <p style="color:#6b7280">Customer information not available</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="info-section">
                    <h3>Invoice Details</h3>
                    <p><strong>Due Date:</strong> ${invoice.formattedDueDate}</p>
                    <c:if test="${invoice.appointment != null}">
                        <p><strong>Appointment ID:</strong> #${invoice.appointment.appointmentId}</p>
                    </c:if>
                    <c:if test="${invoice.voucher != null}">
                        <p><strong>Voucher:</strong> ${invoice.voucher.code}</p>
                    </c:if>
                </div>
            </div>

            <div class="amount-table">
                <div class="amount-row">
                    <span>Subtotal:</span>
                    <span><fmt:formatNumber value="${invoice.subtotal}" type="currency" currencySymbol="$"/></span>
                </div>
                <div class="amount-row">
                    <span>Tax:</span>
                    <span><fmt:formatNumber value="${invoice.taxAmount}" type="currency" currencySymbol="$"/></span>
                </div>
                <div class="amount-row">
                    <span>Discount:</span>
                    <span>-<fmt:formatNumber value="${invoice.discountAmount}" type="currency"
                                             currencySymbol="$"/></span>
                </div>
                <div class="amount-row total">
                    <span>Total Amount:</span>
                    <span>${invoice.formattedTotal}</span>
                </div>
                <div class="amount-row">
                    <span>Amount Paid:</span>
                    <span><fmt:formatNumber value="${invoice.amountPaid}" type="currency" currencySymbol="$"/></span>
                </div>
                <div class="amount-row" style="font-weight:600;color:#dc2626">
                    <span>Amount Due:</span>
                    <span>${invoice.formattedAmountDue}</span>
                </div>
            </div>

            <c:if test="${not empty invoice.notes}">
                <div class="notes-section">
                    <h3><i class="ri-file-text-line"></i> Notes</h3>
                    <p>${invoice.notes}</p>
                </div>
            </c:if>

            <div class="action-buttons">
                <c:if test="${invoice.status != 'PAID' && invoice.status != 'CANCELLED'}">
                    <form method="post" action="${pageContext.request.contextPath}/invoices" style="display:inline">
                        <input type="hidden" name="action" value="updateStatus"/>
                        <input type="hidden" name="id" value="${invoice.invoiceId}"/>
                        <input type="hidden" name="status" value="PAID"/>
                        <button type="submit" class="btn btn-primary"
                                onclick="return confirm('Mark this invoice as paid?');">
                            <i class="ri-check-line"></i> Mark as Paid
                        </button>
                    </form>

                    <form method="post" action="${pageContext.request.contextPath}/invoices" style="display:inline">
                        <input type="hidden" name="action" value="updateStatus"/>
                        <input type="hidden" name="id" value="${invoice.invoiceId}"/>
                        <input type="hidden" name="status" value="CANCELLED"/>
                        <button type="submit" class="btn"
                                onclick="return confirm('Cancel this invoice?');">
                            <i class="ri-close-line"></i> Cancel Invoice
                        </button>
                    </form>
                </c:if>
            </div>
        </div>
    </main>
</div>

<jsp:include page="../inc/footer.jsp"/>
</body>
</html>
