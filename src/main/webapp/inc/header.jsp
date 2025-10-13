<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.petcaresystem.enities.Account" %>
<%@ page import="com.petcaresystem.enities.enu.AccountRoleEnum" %>
<%
    Account loggedInAccount = (Account) session.getAttribute("user");
%>
<header>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-3">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/home">PetCare</a>

        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">

                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/home">Home</a>
                </li>

                <%
                    if (loggedInAccount != null) {
                        AccountRoleEnum role = loggedInAccount.getRole();
                        if (role == AccountRoleEnum.CUSTOMER) {
                %>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/user/petList">My Pets</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/user/appointments">Appointments</a>
                </li>
                <%
                }
                else if (role == AccountRoleEnum.STAFF) {
                %>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/staff/customers">Manage Customers</a>
                </li>
                <%
                }
                else if (role == AccountRoleEnum.ADMIN) {
                %>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/admin/dashboard">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/admin/users">Manage Users</a>
                </li>
                <%
                        }
                    }
                %>
            </ul>

            <ul class="navbar-nav ms-auto">
                <%
                    if (loggedInAccount != null) {
                %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        Account
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/profile">Profile</a></li>
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/logout">Logout</a></li>
                    </ul>
                </li>
                <%
                } else {
                %>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/login">Login</a>
                </li>
                <li class="nav-item  ms-2">
                    <a class="nav-link" href="<%= request.getContextPath() %>/register">Register</a>
                </li>
                <%
                    }
                %>
            </ul>
        </div>
    </nav>
</header>
