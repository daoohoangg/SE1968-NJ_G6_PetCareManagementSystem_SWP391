<%@ page contentType="text/html; charset=UTF-8" %>
<section class="page">
    <div class="page-title header-row">
        <div>
            <h1>Account Management</h1>
            <p>Create accounts with different roles and manage authorization</p>
        </div>
        <a class="btn primary">+ Add Account</a>
    </div>

    <div class="cards grid-5">
        <div class="card stat"><div class="stat-title">Total</div><div class="stat-value">4</div></div>
        <div class="card stat"><div class="stat-title">Active</div><div class="stat-value">3</div></div>
        <div class="card stat"><div class="stat-title">Locked</div><div class="stat-value">1</div></div>
        <div class="card stat"><div class="stat-title">Admins</div><div class="stat-value">1</div></div>
        <div class="card stat"><div class="stat-title">Staff</div><div class="stat-value">1</div></div>
    </div>

    <div class="toolbar">
        <input class="search" placeholder="Search accounts..."/>
        <select>
            <option>All Roles</option>
            <option>Admin</option>
            <option>Staff</option>
            <option>Customer</option>
        </select>
    </div>

    <div class="table">
        <div class="row head">
            <div>User</div><div>Role</div><div>Status</div><div>Last Login</div><div>Created</div><div>Actions</div>
        </div>

        <div class="row">
            <div>
                <strong>John Admin</strong><br/>
                <a href="mailto:admin@petcare.com">admin@petcare.com</a> · <span>+1 (555) 123-4567</span>
            </div>
            <div><span class="role admin">Admin</span></div>
            <div><span class="pill active">active</span></div>
            <div>2024-01-15 09:30</div>
            <div>2024-01-01</div>
            <div class="actions"><a>👁</a><a>✏️</a><a>🔒</a></div>
        </div>

        <div class="row">
            <div><strong>Sarah Staff</strong><br/><a href="mailto:sarah@petcare.com">sarah@petcare.com</a> · <span>+1 (555) 234-5678</span></div>
            <div><span class="role staff">Staff</span></div>
            <div><span class="pill active">active</span></div>
            <div>2024-01-15 08:45</div>
            <div>2024-01-05</div>
            <div class="actions"><a>👁</a><a>✏️</a><a>🔒</a></div>
        </div>

        <div class="row">
            <div><strong>Mike Customer</strong><br/><a href="mailto:mike@email.com">mike@email.com</a> · <span>+1 (555) 345-6789</span></div>
            <div><span class="role customer">Customer</span></div>
            <div><span class="pill locked">locked</span></div>
            <div>2024-01-14 16:20</div>
            <div>2024-01-10</div>
            <div class="actions"><a>👁</a><a>✏️</a><a>🔓</a></div>
        </div>
    </div>
</section>
