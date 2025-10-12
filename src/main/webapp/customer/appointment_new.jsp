<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo lịch hẹn mới</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">

<div class="container py-4">
    <h2 class="text-center mb-4">🩺 Tạo lịch hẹn dịch vụ</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <form method="post"
          action="${pageContext.request.contextPath}/customer/appointments"
          class="card shadow p-4">

        <input type="hidden" name="action" value="create"/>

        <!-- Chọn thú cưng -->
        <div class="mb-3">
            <label class="form-label fw-bold">Thú cưng:</label>
            <select name="petId" class="form-select" required>
                <option value="">-- Chọn thú cưng --</option>
                <c:forEach var="p" items="${pets}">
                    <option value="${p.petId}">${p.name} (${p.breed})</option>
                </c:forEach>
            </select>
        </div>

        <!-- Chọn dịch vụ -->
        <div class="mb-3">
            <label class="form-label fw-bold">Dịch vụ:</label><br>
            <c:forEach var="s" items="${services}">
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="checkbox"
                           name="serviceIds" value="${s.serviceId}">
                    <label class="form-check-label">
                            ${s.name} (${s.price}₫)
                    </label>
                </div>
            </c:forEach>
        </div>

        <!-- Ngày giờ -->
        <div class="row mb-3">
            <div class="col-md-6">
                <label class="form-label fw-bold">Thời gian bắt đầu:</label>
                <input type="datetime-local" name="startAt" class="form-control" required>
            </div>
            <div class="col-md-6">
                <label class="form-label fw-bold">Thời gian kết thúc (nếu có):</label>
                <input type="datetime-local" name="endAt" class="form-control">
            </div>
        </div>

        <!-- Ghi chú -->
        <div class="mb-3">
            <label class="form-label fw-bold">Ghi chú:</label>
            <textarea name="notes" class="form-control" rows="3"
                      placeholder="Ví dụ: Cần kiểm tra sức khỏe định kỳ hoặc tỉa lông..."></textarea>
        </div>

        <!-- Nút -->
        <div class="d-flex justify-content-between">
            <a href="${pageContext.request.contextPath}/customer/appointments"
               class="btn btn-secondary">← Quay lại</a>
            <button type="submit" class="btn btn-primary">Đặt lịch</button>
        </div>
    </form>
</div>

</body>
</html>
