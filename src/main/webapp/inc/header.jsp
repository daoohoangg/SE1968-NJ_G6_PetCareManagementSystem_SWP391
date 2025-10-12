<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-3">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">🐾 PetCare</a>

        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">

                <!-- Hiện thị cho tất cả mọi người -->
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a>
                </li>

                <!-- Menu cho customer sẽ chỉnh sửa sau khi code user sửa xong -->
                <c:if test="${sessionScope.role == 'USER'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/petList">My Pets</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/appointments">Appointments</a>
                    </li>
                </c:if>

                <!-- Menu cho STAFF sẽ chỉnh sửa sau khi code về staff xong -->
                <c:if test="${sessionScope.role == 'STAFF'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/staff/customers">Manage Customers</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/staff/services">Manage Services</a>
                    </li>
                </c:if>

                <!-- Menu cho ADMIN sẽ chỉnh sửa thêm -->
                <c:if test="${sessionScope.role == 'ADMIN'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Manage Users</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/settings">System Settings</a>
                    </li>
                </c:if>
            </ul>

            <ul class="navbar-nav ms-auto">
                <c:choose>
                    <c:when test="${not empty sessionScope.username}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                Account
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Profile</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </nav>
</header>
