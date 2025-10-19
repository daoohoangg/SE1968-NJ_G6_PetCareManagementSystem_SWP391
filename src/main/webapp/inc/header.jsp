<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.petcaresystem.enities.Account" %>
<%@ page import="com.petcaresystem.enities.enu.AccountRoleEnum" %>
<%
    Account loggedInAccount = (Account) session.getAttribute("user");
%>
<%
    if (request.getAttribute("globalHeaderAssetsLoaded") == null) {
        request.setAttribute("globalHeaderAssetsLoaded", Boolean.TRUE);
%>
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
      crossorigin="anonymous"/>
<script defer
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
<style>
    html, body{
        min-height:100%;
        min-height:100vh;
    }
    body{
        display:flex;
        flex-direction:column;
        min-height:100vh;
    }
    body > header,
    body > footer{
        flex-shrink:0;
    }
    body > footer{
        margin-top:auto;
    }
    body > main,
    body > section.page,
    body > .page,
    body > .layout,
    body > .container,
    body > .config-page,
    body > .content-wrapper{
        flex:1 0 auto;
    }
    body > .content-wrapper{
        width:100%;
        display:flex;
        flex-direction:column;
    }
</style>
<%
    }
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
