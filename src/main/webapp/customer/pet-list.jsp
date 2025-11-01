<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/inc/common-head.jspf" %>

    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Pets</title>

    <!-- Inter + fallbacks -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body { font-family: 'Inter', system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; margin:24px; background:#fafbfc; }
        .topbar { display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; }
        .btn { padding:8px 12px; border:1px solid #ccc; background:#f7f7f7; cursor:pointer; border-radius:6px; text-decoration:none; color:#222; display:inline-block; }
        .btn:hover{ background:#eee; }
        table { width:100%; border-collapse: collapse; background:#fff; }
        th, td { border:1px solid #e5e5e5; padding:8px; text-align:left; vertical-align:middle; }
        th { background:#f5f5f5; }
        .actions { display:flex; gap:8px; align-items:center; }
        .flash { margin-bottom:12px; padding:10px 12px; border-radius:6px; background:#eef9f0; border:1px solid #cde8d2; color:#135c22;}
        .empty { padding:24px; text-align:center; color:#666; border:1px dashed #ddd; border-radius:8px; background:#fff; }
        form.inline { display:inline; margin:0; }
    </style>
</head>
<body>

<div class="topbar">
    <h2>My Pets</h2>
    <a class="btn" href="<c:url value='/customer/pets'><c:param name='action' value='add'/></c:url>">+ Add Pet</a>
</div>

<c:if test="${not empty sessionScope.flash}">
    <div class="flash"><c:out value='${sessionScope.flash}'/></div>
    <c:remove var="flash" scope="session"/>
</c:if>

<c:choose>
    <c:when test="${empty pets}">
        <div class="empty">You haven’t added any pets yet.</div>
    </c:when>
    <c:otherwise>
        <table aria-label="My pets table">
            <thead>
            <tr>
                <th>Name</th>
                <th>Species</th>
                <th>Breed</th>
                <th>Gender</th>
                <th>Age</th>
                <th>Date of Birth</th>
                <th>Weight (kg)</th>
                <th>Health Status</th>
                <th>Medical Notes</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${pets}">
                <tr>
                    <td><c:out value="${p.name}"/></td>
                    <td><c:out value="${p.species}"/></td>
                    <td><c:out value="${p.breed}"/></td>
                    <td><c:out value="${p.gender}"/></td>
                    <td><c:out value="${p.age}"/></td>
                    <td><c:out value="${p.dateOfBirth}"/></td>
                    <td><c:out value="${p.weight}"/></td>
                    <td><c:out value="${p.healthStatus}"/></td>
                    <td><c:out value="${p.medicalNotes}"/></td>
                    <td class="actions">
                        <a class="btn" href="<c:url value='/customer/pets'>
                                                <c:param name='action' value='edit'/>
                                                <c:param name='id' value='${p.petId}'/>
                                             </c:url>">Edit</a>

                        <form class="inline" action="<c:url value='/customer/pets'/>" method="post"
                              onsubmit="return confirm('Delete this pet?');">
                            <input type="hidden" name="action" value="delete"/>
                            <input type="hidden" name="id" value="${p.petId}"/>
                            <button class="btn" type="submit">Delete</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:otherwise>
</c:choose>

</body>
</html>
