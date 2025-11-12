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
<link rel="icon" href="<%= request.getContextPath() %>/images/logo.png" type="image/png">
<style>
    .navbar {
        padding: 0.75rem 2rem;
    }

    .navbar .container {
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    .navbar-collapse {
        display: flex !important;
        justify-content: space-between;
        align-items: center;
        width: 100%;
    }
    .navbar-nav.mx-auto {
        flex: 1;
        justify-content: center;
    }
    .navbar-nav.ms-auto {
        display: flex;
        align-items: center;
        justify-content: flex-end;
    }
    .navbar-nav .nav-item {
        margin: 0 0.5rem;
    }
    .navbar-nav .nav-link {
        color: #ccc !important;
        font-weight: 500;
        transition: color 0.2s ease, transform 0.2s ease;
    }

    .navbar-nav .nav-link:hover,
    .navbar-nav .nav-link:focus {
        color: #fff !important;
        transform: translateY(-1px);
    }
    .navbar-brand {
        display: flex;
        align-items: center;
        font-size: 1.25rem;
        font-weight: 600;
        color: #fff !important;
    }
    .navbar-brand img {
        height: 35px;
        width: auto;
        margin-right: 8px;
        border-radius: 4px;
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
    @media (max-width: 991px) {
        .navbar .container {
            flex-wrap: wrap;
        }
        .navbar-nav.mx-auto {
            justify-content: flex-start;
            text-align: left;
        }
        .navbar-nav.ms-auto {
            justify-content: flex-start;
        }
    }
</style>
<%
    }
%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
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
                        if (loggedInAccount == null) {
                    %>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/services">Services</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/customer/appointments.jsp">Appointments</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/inc/contact.jsp">Contact Us</a>
                    </li>
                    <%
                    } else if (loggedInAccount.getRole() == AccountRoleEnum.CUSTOMER) {
                    %>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/services">Services</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/customer/appointments.jsp">Appointments</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/customer/pets">My Pets</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/inc/contact.jsp">Contact Us</a>
                    </li>
                    <%
                    } else if (loggedInAccount.getRole() == AccountRoleEnum.ADMIN) {
                    %>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/accounts">Manage Accounts</a>
                    </li>
                    <%
                    } else if (loggedInAccount.getRole() == AccountRoleEnum.STAFF) {
                    %>
                    <%-- // Thêm chức năng staff (ví dụ: Lịch làm việc) --%>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/petServiceHistory">Pet Data</a>
                    </li>
                    <%
                    } else if (loggedInAccount.getRole() == AccountRoleEnum.RECEPTIONIST) {
                    %>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/reception/checkin">Check-In</a>
                </li>
                  
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/invoices">Invoice</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/customer/appointments.jsp">Appointments</a>
                    </li>
                    <%
                        }
                    %>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <%
                        if (loggedInAccount != null) {
                    %>
                    <li class="nav-item dropdown">
                        <%
                            String roleName = loggedInAccount.getRole().name();
                            String formattedRole = roleName.substring(0, 1).toUpperCase() + roleName.substring(1).toLowerCase();
                        %>
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                            <div class="user-avatar"><%= loggedInAccount.getFullName().substring(0, 1).toUpperCase() %></div>
                            <%= loggedInAccount.getFullName() %> (<%= formattedRole %>)

                        </a>

                        <ul class="dropdown-menu dropdown-menu-end dropdown-menu-dark">
                            <%
                                if (loggedInAccount.getRole() == AccountRoleEnum.CUSTOMER) {
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
