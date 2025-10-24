<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <title>Thú cưng của tôi</title>
    <style>
        body { font-family: system-ui, Arial, sans-serif; margin: 24px; }
        .topbar { display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; }
        .btn { padding:8px 12px; border:1px solid #ccc; background:#f7f7f7; cursor:pointer; border-radius:6px; text-decoration:none; color:#222;}
        .btn:hover{ background:#eee; }
        table { width:100%; border-collapse: collapse;}
        th, td { border:1px solid #e5e5e5; padding:8px; text-align:left; }
        th { background:#fafafa; }
        .actions { display:flex; gap:8px; }
        .flash { margin-bottom:12px; padding:10px 12px; border-radius:6px; background:#eef9f0; border:1px solid #cde8d2; color:#135c22;}
        .empty { padding:24px; text-align:center; color:#666; border:1px dashed #ddd; border-radius:8px;}
    </style>
</head>
<body>

<div class="topbar">
    <h2>Thú cưng của tôi</h2>
    <a class="btn" href="<%=ctx%>/customer/pets?action=add">+ Thêm thú cưng</a>
</div>

<c:if test="${not empty sessionScope.flash}">
    <div class="flash">${sessionScope.flash}</div>
    <c:remove var="flash" scope="session"/>
</c:if>

<c:choose>
    <c:when test="${empty pets}">
        <div class="empty">Bạn chưa thêm thú cưng nào.</div>
    </c:when>
    <c:otherwise>
        <table>
            <thead>
            <tr>
                <th>Tên</th>
                <th>Loài</th>
                <th>Giống</th>
                <th>Giới tính</th>
                <th>Tuổi</th>
                <th>Ngày sinh</th>
                <th>Cân nặng (kg)</th>
                <th>Tình trạng sức khoẻ</th>
                <th>Ghi chú y tế</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${pets}">
                <tr>
                    <td>${p.name}</td>
                    <td>${p.species}</td>
                    <td>${p.breed}</td>
                    <td>${p.gender}</td>
                    <td><c:out value="${p.age}"/></td>
                    <td><c:out value="${p.dateOfBirth}"/></td>
                    <td><c:out value="${p.weight}"/></td>
                    <td>${p.healthStatus}</td>
                    <td><c:out value="${p.medicalNotes}"/></td>
                    <td class="actions">
                        <a class="btn" href="<%=ctx%>/customer/pets?action=edit&id=${p.petId}">Sửa</a>
                        <form action="<%=ctx%>/customer/pets" method="post" onsubmit="return confirm('Xoá thú cưng này?');">
                            <input type="hidden" name="action" value="delete"/>
                            <input type="hidden" name="id" value="${p.petId}"/>
                            <button class="btn" type="submit">Xoá</button>
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
