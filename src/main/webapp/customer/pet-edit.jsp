<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/inc/common-head.jspf" %>

    <meta charset="UTF-8"/>
    <title>Cáº­p nháº­t thÃº cÆ°ng</title>
</head>
<body style="font-family: system-ui, Arial, sans-serif; margin:24px;">
<h2>Cáº­p nháº­t thÃº cÆ°ng</h2>

<c:if test="${pet == null}">
    <p>KhÃ´ng tÃ¬m tháº¥y báº£n ghi.</p>
</c:if>

<c:if test="${pet != null}">
    <form action="<%=ctx%>/customer/pets" method="post" autocomplete="on">
        <input type="hidden" name="action" value="update"/>
        <input type="hidden" name="id" value="${pet.petId}"/>
        <jsp:include page="_pet-form.jspf"/>
        <div class="actions">
            <button class="btn" type="submit">Cáº­p nháº­t</button>
            <a class="btn" href="<%=ctx%>/customer/pets?action=list">Quay láº¡i</a>
        </div>
    </form>
</c:if>
</body>
</html>

