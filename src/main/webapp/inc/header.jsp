<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.petcaresystem.enities.Account" %>
<%@ page import="com.petcaresystem.enities.enu.AccountRoleEnum" %>
<%
    Account loggedInAccount = (Account) session.getAttribute("account");
%>
<style>
    .navbar {
        transition: background-color 0.3s ease;
    }
    .nav-link {
        font-weight: 500;
        transition: color 0.2s ease-in-out;
    }
    .navbar-brand {
        font-weight: bold;
        letter-spacing: 1px;
    }
    .dropdown-menu {
        border-radius: 0.5rem;
        box-shadow: 0 0.5rem 1rem rgba(0,0,0,.15);
        border: none;
    }
    .user-avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        background-color: #0d6efd;
        color: white;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        margin-right: 8px;
        font-size: 14px;
    }
</style>
<header>
    <nav class="navbar navbar-expand-lg navbar-light bg-light px-3 border-bottom shadow-sm">
        <a class="navbar-brand text-primary" href="<%= request.getContextPath() %>/home">
            PetCare
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/home">Home</a>
                </li>

                <%
                    if (loggedInAccount != null) {
                        AccountRoleEnum role = loggedInAccount.getRole();
                        if (role == AccountRoleEnum.ADMIN) { //Phần này dành cho admin
                %>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/admin/dashboard">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/admin/users">Manage Users</a>
                </li>
                <%
                }
                else if (role == AccountRoleEnum.STAFF) { // Phần này dành cho Staff
                %>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/staff/customers">Manage</a>
                </li>
                <%
                }
                else { // Phần này dành cho Customer
                %>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/services">Services</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/user/petList">My Pets</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/customer/appointments.jsp">Appointments</a>
                </li>
                <%
                        }
                    }
                %>
            </ul>

            <ul class="navbar-nav ms-auto align-items-center">
                <%
                    if (loggedInAccount != null) {
                %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                        <div class="user-avatar"><%= loggedInAccount.getFullName().substring(0, 1) %></div>
                        <%= loggedInAccount.getFullName() %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/customer/profile-edit.jsp">Profile</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="<%= request.getContextPath() %>/logout">Logout</a></li>
                    </ul>
                </li>
                <%
                } else {
                %>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/login">Login</a>
                </li>
                <li class="nav-item ms-2">
                    <a class="btn btn-primary btn-sm" href="<%= request.getContextPath() %>/register">
                        Register
                    </a>
                </li>
                <%
                    }
                %>
            </ul>
        </div>
    </nav>
</header>