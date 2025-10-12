<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch hẹn của tôi</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">

<div class="container py-4">
    <h2 class="mb-3 text-center">📅 Lịch hẹn của tôi</h2>

    <!-- Nút tạo mới -->
    <div class="d-flex justify-content-end mb-3">
        <a href="${pageContext.request.contextPath}/customer/appointments?action=new"
           class="btn btn-success">+ Tạo lịch hẹn mới</a>
    </div>

    <!-- Thông báo -->
    <c:if test="${not empty param.created}">
        <div class="alert alert-success">✅ Đã tạo lịch hẹn thành công!</div>
    </c:if>
    <c:if test="${not empty param.cancelled}">
        <div class="alert alert-warning">🟡 Đã hủy lịch hẹn.</div>
    </c:if>

    <!-- Danh sách lịch hẹn -->
    <table class="table table-bordered table-striped align-middle text-center">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Thú cưng</th>
            <th>Ngày hẹn</th>
            <th>Trạng thái</th>
            <th>Tổng tiền</th>
            <th>Ghi chú</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="a" items="${appointments}">
            <tr>
                <td>${a.appointmentId}</td>
                <td>${a.pet.name}</td>
                <td>
                    <fmt:formatDate value="${a.appointmentDate}"
                                    pattern="dd/MM/yyyy HH:mm"/>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${a.status == 'SCHEDULED'}">
                            <span class="badge bg-info">Đã đặt</span>
                        </c:when>
                        <c:when test="${a.status == 'CONFIRMED'}">
                            <span class="badge bg-primary">Đã xác nhận</span>
                        </c:when>
                        <c:when test="${a.status == 'IN_PROGRESS'}">
                            <span class="badge bg-warning text-dark">Đang thực hiện</span>
                        </c:when>
                        <c:when test="${a.status == 'COMPLETED'}">
                            <span class="badge bg-success">Hoàn tất</span>
                        </c:when>
                        <c:when test="${a.status == 'CANCELLED'}">
                            <span class="badge bg-secondary">Đã hủy</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-light text-dark">${a.status}</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:out value="${a.totalAmount != null ? a.totalAmount : 0}"/> ₫
                </td>
                <td>
                    <c:out value="${a.notes}"/>
                </td>
                <td>
                    <c:if test="${a.status == 'SCHEDULED' || a.status == 'CONFIRMED'}">
                        <a href="${pageContext.request.contextPath}/customer/appointments?action=cancel&id=${a.appointmentId}"
                           class="btn btn-sm btn-outline-danger"
                           onclick="return confirm('Bạn có chắc muốn hủy lịch này không?')">
                            Hủy
                        </a>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <c:if test="${empty appointments}">
        <div class="alert alert-info text-center">
            Bạn chưa có lịch hẹn nào. Hãy <a href="?action=new">đặt lịch mới</a> nhé!
        </div>
    </c:if>
</div>

</body>
</html>
