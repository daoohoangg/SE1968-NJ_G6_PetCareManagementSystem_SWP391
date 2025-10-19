<%@ page contentType="text/html; charset=UTF-8" %>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<style>
    :root{
        --primary:#2563eb;
        --primary-soft:#eef2ff;
        --success:#16a34a;
        --danger:#dc2626;
        --warning:#f97316;
        --muted:#6b7280;
        --text:#111827;
        --line:#e5e7eb;
        --bg:#f7f9fc;
        --surface:#ffffff;
        --shadow:0 18px 40px rgba(15,23,42,.08);
    }
    .accounts-page{
        display:flex;
        background:var(--bg);
        font-family:Inter,system-ui,Segoe UI,Roboto,Arial,sans-serif;
        color:var(--text);
        width:100%;
    }
    .accounts-main{
        flex:1;
        padding:32px 40px;
        display:flex;
        flex-direction:column;
        gap:28px;
    }
    .accounts-header{
        display:flex;
        align-items:flex-start;
        justify-content:space-between;
        gap:18px;
        flex-wrap:wrap;
    }
    .accounts-header h1{
        margin:0;
        font-size:28px;
        font-weight:600;
    }
    .accounts-header p{
        margin:8px 0 0;
        color:var(--muted);
        font-size:14px;
    }
    .add-account-btn{
        display:inline-flex;
        align-items:center;
        gap:8px;
        background:var(--primary);
        color:#fff;
        padding:10px 18px;
        border-radius:12px;
        text-decoration:none;
        font-weight:600;
        font-size:14px;
        border:none;
        cursor:pointer;
        box-shadow:0 12px 28px rgba(37,99,235,.25);
        transition:filter .18s, transform .18s;
    }
    .add-account-btn:hover{filter:brightness(.95);transform:translateY(-1px)}
    .stats-row{
        display:grid;
        gap:18px;
        grid-template-columns:repeat(auto-fit,minmax(160px,1fr));
    }
    .stat-card{
        background:var(--surface);
        border:1px solid rgba(148,163,184,.25);
        border-radius:18px;
        padding:20px 22px;
        box-shadow:var(--shadow);
        display:flex;
        flex-direction:column;
        gap:6px;
        min-height:0;
    }
    .stat-title{
        font-size:13px;
        color:var(--muted);
        text-transform:uppercase;
        letter-spacing:.05em;
        font-weight:600;
    }
    .stat-value{
        font-size:26px;
        font-weight:700;
    }
    .filters{
        display:flex;
        align-items:center;
        gap:14px;
        flex-wrap:wrap;
        background:var(--surface);
        border:1px solid var(--line);
        border-radius:14px;
        padding:12px 16px;
        box-shadow:0 8px 20px rgba(15,23,42,.05);
    }
    .search-field{
        flex:1;
        display:flex;
        align-items:center;
        gap:10px;
        background:var(--primary-soft);
        border-radius:12px;
        padding:10px 14px;
    }
    .search-field i{color:var(--primary)}
    .search-field input{
        border:none;
        background:transparent;
        outline:none;
        font-size:14px;
        color:var(--text);
        width:100%;
    }
    .role-filter{
        border:1px solid var(--line);
        border-radius:12px;
        padding:10px 12px;
        min-width:160px;
        font-size:14px;
        color:var(--text);
        background:#fff;
    }
    .accounts-table{
        width:100%;
        border-collapse:separate;
        border-spacing:0;
        background:var(--surface);
        border:1px solid rgba(148,163,184,.26);
        border-radius:18px;
        overflow:hidden;
        box-shadow:var(--shadow);
    }
    .accounts-table thead th{
        background:#f3f4f6;
        text-align:left;
        padding:16px 20px;
        font-size:12px;
        font-weight:700;
        text-transform:uppercase;
        color:#6b7280;
        letter-spacing:.05em;
    }
    .accounts-table tbody td{
        padding:18px 20px;
        border-top:1px solid var(--line);
        vertical-align:middle;
    }
    .user-cell{
        display:flex;
        align-items:flex-start;
        gap:14px;
    }
    .avatar{
        width:42px;
        height:42px;
        border-radius:14px;
        background:var(--primary-soft);
        color:var(--primary);
        font-weight:700;
        display:flex;
        align-items:center;
        justify-content:center;
    }
    .user-meta strong{
        display:block;
        font-size:15px;
        margin-bottom:4px;
    }
    .user-meta span{
        display:flex;
        align-items:center;
        gap:8px;
        color:var(--muted);
        font-size:13px;
    }
    .user-meta span i{color:var(--muted)}
    .role-pill{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        padding:6px 12px;
        border-radius:999px;
        font-size:12px;
        font-weight:600;
        min-width:70px;
    }
    .role-admin{background:rgba(220,38,38,.1);color:var(--danger);}
    .role-staff{background:rgba(59,130,246,.15);color:#2563eb;}
    .role-customer{background:rgba(16,185,129,.15);color:#047857;}
    .status-pill{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        padding:6px 12px;
        border-radius:999px;
        font-size:12px;
        font-weight:600;
        text-transform:uppercase;
        letter-spacing:.04em;
    }
    .status-active{background:rgba(16,185,129,.15);color:#047857;}
    .status-locked{background:rgba(220,38,38,.15);color:var(--danger);}
    .status-pending{background:rgba(249,115,22,.18);color:var(--warning);}
    .actions-cell{
        display:flex;
        gap:10px;
    }
    .icon-btn{
        width:36px;
        height:36px;
        border-radius:10px;
        border:1px solid var(--line);
        background:#fff;
        display:inline-flex;
        align-items:center;
        justify-content:center;
        color:#4b5563;
        cursor:pointer;
        transition:.18s;
    }
    .icon-btn:hover{
        background:var(--primary-soft);
        color:var(--primary);
        border-color:rgba(37,99,235,.35);
    }
    .modal-backdrop{
        position:fixed;
        inset:0;
        background:rgba(15,23,42,.7);
        display:none;
        align-items:center;
        justify-content:center;
        padding:20px;
        z-index:1300;
    }
    .modal-backdrop.show{display:flex;}
    .modal-card{
        width:100%;
        max-width:420px;
        background:#fff;
        border-radius:18px;
        border:1px solid rgba(148,163,184,.18);
        box-shadow:0 30px 65px rgba(15,23,42,.25);
        padding:26px 30px 30px;
        display:flex;
        flex-direction:column;
        gap:18px;
        animation:modalFade .22s ease-out;
        font-family:inherit;
    }
    .modal-header{
        display:flex;
        justify-content:space-between;
        align-items:flex-start;
        gap:14px;
    }
    .modal-header h2{
        margin:0;
        font-size:22px;
        font-weight:600;
    }
    .modal-header p{
        margin:6px 0 0;
        color:var(--muted);
        font-size:13px;
    }
    .close-btn{
        background:none;
        border:none;
        color:#9ca3af;
        font-size:22px;
        cursor:pointer;
    }
    .modal-body{
        display:flex;
        flex-direction:column;
        gap:14px;
    }
    .modal-field label{
        display:block;
        font-size:13px;
        font-weight:600;
        color:var(--text);
        margin-bottom:6px;
    }
    .modal-field input,
    .modal-field select{
        width:100%;
        border:1px solid var(--line);
        border-radius:12px;
        padding:11px 12px;
        font-size:14px;
        color:var(--text);
        background:#fff;
        transition:border-color .18s, box-shadow .18s;
    }
    .modal-field input:focus,
    .modal-field select:focus{
        border-color:var(--primary);
        box-shadow:0 0 0 3px rgba(37,99,235,.18);
        outline:none;
    }
    .modal-actions{
        display:flex;
        justify-content:flex-end;
        gap:12px;
        margin-top:6px;
    }
    .btn-outline,
    .btn-primary{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        padding:10px 18px;
        border-radius:12px;
        font-weight:600;
        font-size:14px;
        border:1px solid transparent;
        cursor:pointer;
        transition:.18s;
    }
    .btn-outline{
        border-color:var(--line);
        background:#fff;
        color:var(--text);
    }
    .btn-outline:hover{border-color:#cbd5f5;background:#f8fafc;}
    .btn-primary{
        background:var(--primary);
        color:#fff;
        box-shadow:0 12px 26px rgba(37,99,235,.25);
    }
    .btn-primary:hover{filter:brightness(.95);transform:translateY(-1px);}
    body.modal-open{overflow:hidden;}
    @media (max-width:992px){
        .accounts-main{padding:28px;}
    }
    @media (max-width:768px){
        .accounts-main{padding:24px 18px;}
        .filters{flex-direction:column;align-items:stretch;}
        .role-filter{width:100%;}
    }
    @keyframes modalFade{
        from{opacity:0;transform:translateY(10px);}
        to{opacity:1;transform:translateY(0);}
    }
</style>

<jsp:include page="../inc/header.jsp" />
<main class="content-wrapper">
    <section class="page accounts-page">
        <jsp:include page="../inc/side-bar.jsp" />
        <div class="accounts-main">
            <div class="accounts-header">
                <div>
                    <h1>Account Management</h1>
                    <p>Create accounts with different roles and manage authorization</p>
                </div>
                <button class="add-account-btn" type="button" data-open-modal="addAccountModal">
                    <i class="ri-add-line"></i>Add Account
                </button>
            </div>

            <div class="stats-row">
                <div class="stat-card">
                    <span class="stat-title">Total</span>
                    <span class="stat-value">4</span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Active</span>
                    <span class="stat-value">3</span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Locked</span>
                    <span class="stat-value">1</span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Admins</span>
                    <span class="stat-value">1</span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Staff</span>
                    <span class="stat-value">1</span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Customers</span>
                    <span class="stat-value">2</span>
                </div>
            </div>

            <div class="filters">
                <div class="search-field">
                    <i class="ri-search-line"></i>
                    <input type="text" placeholder="Search accounts..." />
                </div>
                <select class="role-filter">
                    <option>All Roles</option>
                    <option>Admin</option>
                    <option>Staff</option>
                    <option>Customer</option>
                </select>
            </div>

            <table class="accounts-table">
                <thead>
                <tr>
                    <th>User</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Last Login</th>
                    <th>Created</th>
                    <th style="text-align:center;">Actions</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>
                        <div class="user-cell">
                            <div class="avatar">JA</div>
                            <div class="user-meta">
                                <strong>John Admin</strong>
                                <span><i class="ri-mail-line"></i>admin@petcare.com</span>
                                <span><i class="ri-phone-line"></i>+1 (555) 123-4567</span>
                            </div>
                        </div>
                    </td>
                    <td><span class="role-pill role-admin">Admin</span></td>
                    <td><span class="status-pill status-active">active</span></td>
                    <td>2024-01-15 09:30</td>
                    <td>2024-01-01</td>
                    <td>
                        <div class="actions-cell">
                            <button class="icon-btn" type="button" data-open-modal="editAccountModal" title="Edit">
                                <i class="ri-pencil-line"></i>
                            </button>
                            <button class="icon-btn" type="button" title="Lock">
                                <i class="ri-lock-line"></i>
                            </button>
                            <button class="icon-btn" type="button" title="Delete">
                                <i class="ri-delete-bin-line"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="user-cell">
                            <div class="avatar">SS</div>
                            <div class="user-meta">
                                <strong>Sarah Staff</strong>
                                <span><i class="ri-mail-line"></i>sarah@petcare.com</span>
                                <span><i class="ri-phone-line"></i>+1 (555) 234-5678</span>
                            </div>
                        </div>
                    </td>
                    <td><span class="role-pill role-staff">Staff</span></td>
                    <td><span class="status-pill status-active">active</span></td>
                    <td>2024-01-15 08:45</td>
                    <td>2024-01-05</td>
                    <td>
                        <div class="actions-cell">
                            <button class="icon-btn" type="button" data-open-modal="editAccountModal" title="Edit">
                                <i class="ri-pencil-line"></i>
                            </button>
                            <button class="icon-btn" type="button" title="Lock">
                                <i class="ri-lock-line"></i>
                            </button>
                            <button class="icon-btn" type="button" title="Delete">
                                <i class="ri-delete-bin-line"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="user-cell">
                            <div class="avatar">MC</div>
                            <div class="user-meta">
                                <strong>Mike Customer</strong>
                                <span><i class="ri-mail-line"></i>mike@email.com</span>
                                <span><i class="ri-phone-line"></i>+1 (555) 345-6789</span>
                            </div>
                        </div>
                    </td>
                    <td><span class="role-pill role-customer">Customer</span></td>
                    <td><span class="status-pill status-active">active</span></td>
                    <td>2024-01-14 16:20</td>
                    <td>2024-01-10</td>
                    <td>
                        <div class="actions-cell">
                            <button class="icon-btn" type="button" data-open-modal="editAccountModal" title="Edit">
                                <i class="ri-pencil-line"></i>
                            </button>
                            <button class="icon-btn" type="button" title="Lock">
                                <i class="ri-lock-line"></i>
                            </button>
                            <button class="icon-btn" type="button" title="Delete">
                                <i class="ri-delete-bin-line"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="user-cell">
                            <div class="avatar">EW</div>
                            <div class="user-meta">
                                <strong>Emma Wilson</strong>
                                <span><i class="ri-mail-line"></i>emma@email.com</span>
                                <span><i class="ri-phone-line"></i>+1 (555) 456-7890</span>
                            </div>
                        </div>
                    </td>
                    <td><span class="role-pill role-customer">Customer</span></td>
                    <td><span class="status-pill status-locked">locked</span></td>
                    <td>2024-01-12 14:15</td>
                    <td>2024-01-08</td>
                    <td>
                        <div class="actions-cell">
                            <button class="icon-btn" type="button" data-open-modal="editAccountModal" title="Edit">
                                <i class="ri-pencil-line"></i>
                            </button>
                            <button class="icon-btn" type="button" title="Unlock">
                                <i class="ri-lock-unlock-line"></i>
                            </button>
                            <button class="icon-btn" type="button" title="Delete">
                                <i class="ri-delete-bin-line"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </section>
</main>

<div class="modal-backdrop" id="addAccountModal" aria-hidden="true">
    <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="addAccountTitle">
        <div class="modal-header">
            <div>
                <h2 id="addAccountTitle">Add New Account</h2>
                <p>Create a new user account with role-based access.</p>
            </div>
            <button class="close-btn" type="button" data-close-modal>&times;</button>
        </div>
        <form class="modal-body">
            <div class="modal-field">
                <label for="addFullName">Full Name</label>
                <input id="addFullName" type="text" placeholder="Full name" />
            </div>
            <div class="modal-field">
                <label for="addEmail">Email</label>
                <input id="addEmail" type="email" placeholder="name@example.com" />
            </div>
            <div class="modal-field">
                <label for="addPhone">Phone</label>
                <input id="addPhone" type="tel" placeholder="+1 (555) 000-0000" />
            </div>
            <div class="modal-field">
                <label for="addRole">Role</label>
                <select id="addRole">
                    <option>Customer</option>
                    <option>Staff</option>
                    <option>Admin</option>
                </select>
            </div>
            <div class="modal-field">
                <label for="addPassword">Password</label>
                <input id="addPassword" type="password" placeholder="••••••••" />
            </div>
        </form>
        <div class="modal-actions">
            <button class="btn-outline" type="button" data-close-modal>Cancel</button>
            <button class="btn-primary" type="button">Create Account</button>
        </div>
    </div>
</div>

<div class="modal-backdrop" id="editAccountModal" aria-hidden="true">
    <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="editAccountTitle">
        <div class="modal-header">
            <div>
                <h2 id="editAccountTitle">Edit Account</h2>
                <p>Update account details and permissions.</p>
            </div>
            <button class="close-btn" type="button" data-close-modal>&times;</button>
        </div>
        <form class="modal-body">
            <div class="modal-field">
                <label for="editFullName">Full Name</label>
                <input id="editFullName" type="text" value="Mike Customer" />
            </div>
            <div class="modal-field">
                <label for="editEmail">Email</label>
                <input id="editEmail" type="email" value="mike@email.com" />
            </div>
            <div class="modal-field">
                <label for="editPhone">Phone</label>
                <input id="editPhone" type="tel" value="+1 (555) 345-6789" />
            </div>
            <div class="modal-field">
                <label for="editRole">Role</label>
                <select id="editRole">
                    <option>Customer</option>
                    <option>Staff</option>
                    <option>Admin</option>
                </select>
            </div>
        </form>
        <div class="modal-actions">
            <button class="btn-outline" type="button" data-close-modal>Cancel</button>
            <button class="btn-primary" type="button">Update Account</button>
        </div>
    </div>
</div>

<script>
    (function () {
        const body = document.body;
        const openButtons = document.querySelectorAll('[data-open-modal]');
        const closeButtons = document.querySelectorAll('[data-close-modal]');

        const showModal = (modalId) => {
            const modal = document.getElementById(modalId);
            if (!modal) return;
            modal.classList.add('show');
            modal.setAttribute('aria-hidden', 'false');
            body.classList.add('modal-open');
            const focusable = modal.querySelector('input, select, button');
            window.setTimeout(() => focusable && focusable.focus(), 70);
        };

        const hideModal = (modal) => {
            modal.classList.remove('show');
            modal.setAttribute('aria-hidden', 'true');
            body.classList.remove('modal-open');
        };

        openButtons.forEach(btn => {
            btn.addEventListener('click', () => showModal(btn.getAttribute('data-open-modal')));
        });

        closeButtons.forEach(btn => {
            btn.addEventListener('click', () => hideModal(btn.closest('.modal-backdrop')));
        });

        document.querySelectorAll('.modal-backdrop').forEach(backdrop => {
            backdrop.addEventListener('click', (event) => {
                if (event.target === backdrop) {
                    hideModal(backdrop);
                }
            });
        });

        document.addEventListener('keydown', (event) => {
            if (event.key === 'Escape') {
                document.querySelectorAll('.modal-backdrop.show').forEach(hideModal);
            }
        });
    })();
</script>
<jsp:include page="../inc/chatbox.jsp" />
<jsp:include page="../inc/footer.jsp" />
