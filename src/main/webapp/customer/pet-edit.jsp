<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/inc/common-head.jspf" %>

    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Pet</title>

    <!-- Inter + fallbacks -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body { font-family:'Inter', system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; margin:24px; background:#fafbfc; }
        h2 { margin: 0 0 16px; }
        .actions { display:flex; gap:10px; margin-top:16px; }
        .btn { padding:8px 14px; border:1px solid #cfd6df; background:#f4f6f8; color:#1f2a37;
            border-radius:8px; text-decoration:none; cursor:pointer; font-weight:600; }
        .btn:hover { background:#e9edf1; }
        .btn-primary { background:#0d6efd; border-color:#0d6efd; color:#fff; }
        .btn-primary:hover { background:#0b5ed7; }
        .card { background:#fff; border:1px solid #e5e7eb; border-radius:12px; padding:18px; box-shadow:0 6px 14px rgba(0,0,0,.06); }
        .notice { padding:12px 14px; border-radius:8px; background:#fff8e1; border:1px solid #ffe082; color:#7a5d00; }
    </style>
</head>
<body>
<h2>Edit Pet</h2>

<c:if test="${pet == null}">
    <div class="notice">Record not found.</div>
</c:if>

<c:if test="${pet != null}">
    <div class="card">
        <form action="<c:url value='/customer/pets'/>" method="post" autocomplete="on">
            <input type="hidden" name="action" value="update"/>
            <input type="hidden" name="id" value="${pet.petId}"/>

            <!-- Reuse shared form fields -->
            <%@ include file="/inc/common-head.jspf" %>

            <div class="actions">
                <button class="btn btn-primary" type="submit">Update</button>
                <a class="btn" href="<c:url value='/customer/pets'><c:param name='action' value='list'/></c:url>">Back</a>
            </div>
        </form>
    </div>
</c:if>
</body>
</html>
