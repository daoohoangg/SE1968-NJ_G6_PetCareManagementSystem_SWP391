<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <title>Thêm thú cưng</title>
</head>
<body style="font-family: system-ui, Arial, sans-serif; margin:24px;">
<h2>Thêm thú cưng</h2>
<form action="<%=ctx%>/customer/pets" method="post" autocomplete="on">
    <input type="hidden" name="action" value="create"/>
    <jsp:include page="_pet-form.jspf"/>
    <div class="actions">
        <button class="btn" type="submit">Lưu</button>
        <a class="btn" href="<%=ctx%>/customer/pets?action=list">Huỷ</a>
    </div>
</form>
</body>
</html>
