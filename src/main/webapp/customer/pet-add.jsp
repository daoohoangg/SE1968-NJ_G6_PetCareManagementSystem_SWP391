<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/inc/common-head.jspf" %>

    <meta charset="UTF-8"/>
    <title>ThÃªm thÃº cÆ°ng</title>
</head>
<body style="font-family: system-ui, Arial, sans-serif; margin:24px;">
<h2>ThÃªm thÃº cÆ°ng</h2>
<form action="<%=ctx%>/customer/pets" method="post" autocomplete="on">
    <input type="hidden" name="action" value="create"/>
    <jsp:include page="_pet-form.jspf"/>
    <div class="actions">
        <button class="btn" type="submit">LÆ°u</button>
        <a class="btn" href="<%=ctx%>/customer/pets?action=list">Huá»·</a>
    </div>
</form>
</body>
</html>

