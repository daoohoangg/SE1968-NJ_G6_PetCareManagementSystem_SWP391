<%@ page import="com.petcaresystem.enities.Account" %>
<%@ page import="com.petcaresystem.enities.enu.AccountRoleEnum" %>
<%
    Account loggedInAccount = (Account) session.getAttribute("account");
%>
<%
    if (request.getAttribute("globalHeaderAssetsLoaded") == null) {
        request.setAttribute("globalHeaderAssetsLoaded", Boolean.TRUE);
%>
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
      crossorigin="anonymous"/>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
<%
    }
%>
<header>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="<%= request.getContextPath() %>/home">
                <img src="<%= request.getContextPath() %>/images/logo.png" alt="PetCare Logo"
                     style="height: 35px; width: auto; margin-right: 8px; border-radius: 4px;">
                <span style="font-weight: 600;">PetCare</span>
            </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="mainNavbar">
            <ul class="navbar-nav mx-auto mb-2 mb-lg-0">

                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/home">Home</a>
                </li>
                <%
                    String petsLink = request.getContextPath() + "/login";
                    String appointmentsLink = request.getContextPath() + "/login";
                    String servicesLink = request.getContextPath() + "/login";
                    if (loggedInAccount != null && loggedInAccount.getRole() == AccountRoleEnum.CUSTOMER) {
                        petsLink = request.getContextPath() + "/customer/pets";
                        appointmentsLink = request.getContextPath() + "/customer/appointments.jsp";
                        servicesLink = request.getContextPath() + "/services";
                    } else if (loggedInAccount != null) {
                        servicesLink = request.getContextPath() + "/services";
                    }
                %>

                <li class="nav-item">
                    <a class="nav-link" href="<%= servicesLink %>">Services</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= petsLink %>">My Pets</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= appointmentsLink %>">Appointments</a>
                </li>
                <%
                    if (loggedInAccount != null) {
                        AccountRoleEnum role = loggedInAccount.getRole();

                        if (role == AccountRoleEnum.STAFF) {
                %>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/staff/home">home</a>
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
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/reception/checkin">Check-In</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/reception/checkout">Check-Out</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/petServiceHistory">Pet Data</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/invoices">Invoices</a>
                </li>
                <%
                        }
                    }

                %>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/inc/contact.jsp">Contact Us</a>
                </li>
            </ul>
            <ul class="navbar-nav ms-auto">
                <%
                    if (loggedInAccount != null) {
                %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                        <div class="user-avatar"><%= loggedInAccount.getFullName().substring(0, 1).toUpperCase() %></div>
                        <%= loggedInAccount.getFullName() %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end dropdown-menu-dark">
                        <%
                            if (loggedInAccount.getRole() != AccountRoleEnum.ADMIN) {
                        %>
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/customer/profile?action=edit">Profile</a></li>
                        <%
                            }
                        %>
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
        </div>
    </nav>
</header>
