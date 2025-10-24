<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Pet Profile</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        :root{
            --primary:#2563eb; --text:#1f2937; --muted:#6b7280;
            --line:#e5e7eb; --bg:#f7f9fc; --table-head:#f3f4f6;
        }
        *{box-sizing:border-box}
        body{margin:0;font-family:Inter,system-ui,Arial,sans-serif;color:var(--text);background:var(--bg);padding:28px 36px}
        
        .profile-header{background:#fff;border:1px solid var(--line);border-radius:14px;padding:24px;margin-bottom:20px;box-shadow:0 1px 3px rgba(15,23,42,.04)}
        h2{margin:0 0 16px 0;font-size:24px;color:var(--text)}
        .info-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:12px}
        .info-item{padding:8px 0}
        .info-label{font-size:12px;color:var(--muted);font-weight:600;text-transform:uppercase;margin-bottom:4px}
        .info-value{font-size:15px;color:var(--text)}
        
        .card{background:#fff;border:1px solid var(--line);border-radius:14px;overflow:hidden;box-shadow:0 1px 3px rgba(15,23,42,.04)}
        h3{margin:0;padding:16px 18px;background:var(--table-head);font-size:16px;border-bottom:1px solid var(--line)}
        table{width:100%;border-collapse:separate;border-spacing:0}
        thead th{background:var(--table-head);text-align:left;padding:14px 18px;font-size:13px;color:#4b5563;font-weight:600;border-bottom:1px solid var(--line)}
        tbody td{padding:16px 18px;vertical-align:middle;border-top:1px solid var(--line)}
        tbody tr:hover{background:#fafafa}
        
        .btn-back{display:inline-flex;align-items:center;gap:6px;padding:8px 14px;background:#f3f4f6;color:#374151;border:1px solid var(--line);border-radius:8px;text-decoration:none;font-weight:600;margin-top:16px}
        .btn-back:hover{background:#e5e7eb}
        .empty{padding:24px;text-align:center;color:var(--muted)}
    </style>
</head>
<body>

<div class="profile-header">
    <h2><i class="ri-bear-smile-line"></i> ${pet.name}</h2>
    <div class="info-grid">
        <div class="info-item">
            <div class="info-label">Species</div>
            <div class="info-value">${pet.species}</div>
        </div>
        <div class="info-item">
            <div class="info-label">Breed</div>
            <div class="info-value">${pet.breed}</div>
        </div>
        <div class="info-item">
            <div class="info-label">Gender</div>
            <div class="info-value">${pet.gender}</div>
        </div>
        <div class="info-item">
            <div class="info-label">Age</div>
            <div class="info-value">${pet.age} years</div>
        </div>
        <div class="info-item">
            <div class="info-label">Date of Birth</div>
            <div class="info-value"><fmt:formatDate value="${pet.dateOfBirth}" pattern="dd/MM/yyyy"/></div>
        </div>
        <div class="info-item">
            <div class="info-label">Weight</div>
            <div class="info-value">${pet.weight} kg</div>
        </div>
        <div class="info-item">
            <div class="info-label">Health Status</div>
            <div class="info-value">${pet.healthStatus}</div>
        </div>
        <div class="info-item">
            <div class="info-label">Owner</div>
            <div class="info-value">${pet.customer.fullName}</div>
        </div>
    </div>
    <c:if test="${not empty pet.medicalNotes}">
        <div style="margin-top:16px;padding-top:16px;border-top:1px solid var(--line)">
            <div class="info-label">Medical Notes</div>
            <div class="info-value">${pet.medicalNotes}</div>
        </div>
    </c:if>
</div>

<div class="card">
    <h3>Service History</h3>
    <c:choose>
        <c:when test="${empty historyList}">
            <div class="empty">No service history available.</div>
        </c:when>
        <c:otherwise>
            <table>
                <thead>
                <tr>
                    <th>Service Type</th>
                    <th>Description</th>
                    <th>Date</th>
                    <th>Cost</th>
                    <th>Staff</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="h" items="${historyList}">
                    <tr>
                        <td>${h.serviceType}</td>
                        <td><c:out value="${h.description}" default="-"/></td>
                        <td><fmt:formatDate value="${h.serviceDate}" pattern="dd/MM/yyyy"/></td>
                        <td><fmt:formatNumber value="${h.cost}" type="currency" currencySymbol="$" minFractionDigits="2"/></td>
                        <td>${h.staff != null ? h.staff.fullName : '-'}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>

<a href="${pageContext.request.contextPath}/customer/pets?action=list" class="btn-back">
    <i class="ri-arrow-left-line"></i> Back to list
</a>

</body>
</html>
