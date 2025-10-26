<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Service Record Detail</title>
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

        .card {
            background: white;
            border: 1px solid var(--line);
            border-radius: 14px;
            padding: 32px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
        }

        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 24px;
        }

        .detail-item {
            padding: 16px;
            background: #f9fafb;
            border-radius: 10px;
        }

        .detail-label {
            font-size: 12px;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 6px;
        }

        .detail-value {
            font-size: 16px;
            font-weight: 600;
            color: var(--text);
        }

        .pet-card {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            color: white;
            margin-bottom: 24px;
        }

        .pet-avatar {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            font-weight: 700;
        }

        .pet-info h2 {
            margin: 0 0 4px 0;
            font-size: 24px;
        }

        .pet-info p {
            margin: 0;
            opacity: 0.9;
            font-size: 14px;
        }

        .rating {
            display: flex;
            gap: 4px;
        }

        .rating i {
            color: #fbbf24;
            font-size: 20px;
        }

        .rating i.empty {
            color: #d1d5db;
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

        .service-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            background: #dbeafe;
            color: #1e40af;
        }

        @media (max-width: 768px) {
            .content {
                padding: 20px;
            }

            .detail-grid {
                grid-template-columns: 1fr;
            }

            .card {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
<jsp:include page="../inc/header.jsp"/>
<div class="layout">
    <% request.setAttribute("currentPage", "pet-data"); %>
    <jsp:include page="../inc/side-bar.jsp"/>

    <main class="content">
        <div class="header">
            <h1>Service Record Detail #${history.id}</h1>
            <a href="${pageContext.request.contextPath}/petServiceHistory" class="btn">
                <i class="ri-arrow-left-line"></i> Back to List
            </a>
        </div>

        <div class="card">
            <div class="pet-card">
                <div class="pet-avatar">${history.pet.name.substring(0,1).toUpperCase()}</div>
                <div class="pet-info">
                    <h2>${history.pet.name}</h2>
                    <c:if test="${history.pet.customer != null}">
                        <p><i class="ri-user-line"></i> Owner: ${history.pet.customer.fullName}</p>
                        <p><i class="ri-phone-line"></i> ${history.pet.customer.phone}</p>
                    </c:if>
                </div>
            </div>

            <div class="detail-grid">
                <div class="detail-item">
                    <div class="detail-label">Service Type</div>
                    <div class="detail-value">
                        <span class="service-badge">
                            <i class="ri-scissors-cut-line"></i>
                            ${history.serviceType}
                        </span>
                    </div>
                </div>

                <div class="detail-item">
                    <div class="detail-label">Service Date</div>
                    <div class="detail-value">
                        ${history.formattedDate}
                    </div>
                </div>

                <div class="detail-item">
                    <div class="detail-label">Staff Member</div>
                    <div class="detail-value">${history.staff != null ? history.staff.fullName : 'N/A'}</div>
                </div>

                <div class="detail-item">
                    <div class="detail-label">Cost</div>
                    <div class="detail-value">${history.formattedCost}</div>
                </div>

                <div class="detail-item">
                    <div class="detail-label">Description</div>
                    <div class="detail-value">${history.description != null ? history.description : '-'}</div>
                </div>

                <div class="detail-item">
                    <div class="detail-label">Rating</div>
                    <div class="detail-value">
                        <div class="rating">
                            <c:forEach begin="1" end="5" var="star">
                                <i class="ri-star-fill ${star <= (history.rating != null ? history.rating : 0) ? '' : 'empty'}"></i>
                            </c:forEach>
                            <c:if test="${history.rating != null}">
                                <span style="margin-left:8px;color:var(--muted);font-size:14px">(${history.rating}/5)</span>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <c:if test="${not empty history.notes}">
                <div class="notes-section">
                    <h3><i class="ri-file-text-line"></i> Notes</h3>
                    <p>${history.notes}</p>
                </div>
            </c:if>
        </div>
    </main>
</div>

<jsp:include page="../inc/footer.jsp"/>
</body>
</html>
