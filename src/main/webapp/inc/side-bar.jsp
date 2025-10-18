<style>
    /* Sidebar only */
    .sidebar{width:240px;background:#fff;border-right:1px solid var(--line);padding:20px 12px}
    .logo{display:flex;flex-direction:column;align-items:flex-start;gap:2px;padding:4px 10px 12px}
    .logo i{font-size:22px;color:var(--primary)}
    .logo span{font-weight:600}
    .logo p{margin:0;color:#9ca3af;font-size:12px}
    .menu{margin-top:12px}
    .menu-item{
        display:flex;align-items:center;gap:10px;
        padding:10px 12px;margin:2px 0;border-radius:10px;
        color:#4b5563;text-decoration:none;transition:.15s;
    }
    .menu-item i{font-size:18px}
    .menu-item:hover{background:#f3f4f6;color:var(--text)}
    .menu-item.active{background:var(--primary-100);color:var(--primary);font-weight:600}

    @media (max-width: 900px){
        .sidebar{display:none}
    }
</style>

<aside class="sidebar">
    <div class="logo">
        <i class="ri-heart-line"></i>
        <span>PetCare Pro</span>
        <p>Management System</p>
    </div>

    <nav class="menu">
        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="menu-item ${currentPage == 'dashboard' ? 'active' : ''}">
            <i class="ri-dashboard-line"></i>Dashboard
        </a>

        <a href="${pageContext.request.contextPath}/admin/service?action=list"
           class="menu-item ${currentPage == 'manage-services' ? 'active' : ''}">
            <i class="ri-scissors-line"></i>Manage Services
        </a>

        <a href="${pageContext.request.contextPath}/admin/config"
           class="menu-item ${currentPage == 'configure-system' ? 'active' : ''}">
            <i class="ri-settings-3-line"></i>Configure System
        </a>

        <a href="${pageContext.request.contextPath}/admin/accounts"
           class="menu-item ${currentPage == 'manage-accounts' ? 'active' : ''}">
            <i class="ri-user-settings-line"></i>Manage Accounts
        </a>

        <a href="${pageContext.request.contextPath}/admin/ai"
           class="menu-item ${currentPage == 'ai-features' ? 'active' : ''}">
            <i class="ri-robot-line"></i>AI Features
        </a>

        <a href="${pageContext.request.contextPath}/admin/reports"
           class="menu-item ${currentPage == 'reports' ? 'active' : ''}">
            <i class="ri-bar-chart-2-line"></i>Generate Reports
        </a>
    </nav>
</aside>
