<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <title>Cập nhật thú cưng</title>
</head>
<body style="font-family: system-ui, Arial, sans-serif; margin:24px;">
<h2>Cập nhật thú cưng</h2>

<c:if test="${pet == null}">
    <p>Không tìm thấy bản ghi.</p>
</c:if>

<c:if test="${pet != null}">
    <form action="<%=ctx%>/customer/pets" method="post" autocomplete="on">
        <input type="hidden" name="action" value="update"/>
        <input type="hidden" name="id" value="${pet.petId}"/>
        <jsp:include page="_pet-form.jspf"/>
        <div class="actions">
            <button class="btn" type="submit">Cập nhật</button>
            <a class="btn" href="<%=ctx%>/customer/pets?action=list">Quay lại</a>
        </div>
    </form>
</c:if>
</body>
</html>
