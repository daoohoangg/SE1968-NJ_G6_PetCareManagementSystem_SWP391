<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Manage Services</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        :root{
            --primary:#2563eb; /* blue-600 */
            --primary-100:#e9f0ff;
            --text:#1f2937;    /* gray-800 */
            --muted:#6b7280;   /* gray-500 */
            --line:#e5e7eb;    /* gray-200 */
            --bg:#f7f9fc;
            --table-head:#f3f4f6;
            --pill:#111827;    /* gray-900 */
        }
        *{box-sizing:border-box}
        html,body{height:100%}
        body{
            margin:0;
            font-family:Inter,system-ui,Segoe UI,Roboto,Arial,Helvetica,sans-serif;
            color:var(--text);
            background:var(--bg);
        }
        .layout{display:flex;min-height:100vh}

        /* Sidebar (style giữ nguyên để áp cho sidebar include) */
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

        /* Content */
        .content{flex:1;padding:28px 36px}
        .topbar{display:flex;align-items:center;gap:16px;margin-bottom:18px}
        .title-wrap{flex:1}
        h2{margin:0 0 2px 0;font-size:24px}
        .subtitle{margin:0;color:var(--muted);font-size:14px}

        .btn-add{
            display:inline-flex;align-items:center;gap:8px;
            background:var(--primary);color:#fff;border:none;
            padding:10px 14px;border-radius:10px;font-weight:600;cursor:pointer;
            box-shadow:0 1px 0 rgba(0,0,0,.05);
        }
        .btn-add:hover{filter:brightness(.96)}

        /* Search */
        .search{
            background:#fff;border:1px solid var(--line);
            border-radius:12px;padding:10px 12px;margin:16px 0 20px;
            display:flex;align-items:center;gap:10px;
            box-shadow:0 1px 2px rgba(0,0,0,.03);
        }
        .search i{color:#9ca3af}
        .search input{
            border:none;outline:none;flex:1;font-size:14px;color:var(--text);
            background:transparent;
        }

        /* Table */
        .card{
            background:#fff;border:1px solid var(--line);border-radius:14px;
            overflow:hidden;box-shadow:0 1px 3px rgba(15,23,42,.04);
        }
        table{width:100%;border-collapse:separate;border-spacing:0}
        thead th{
            background:var(--table-head);text-align:left;padding:14px 18px;
            font-size:13px;color:#4b5563;font-weight:600;border-bottom:1px solid var(--line);
        }
        tbody td{padding:16px 18px;vertical-align:middle;border-top:1px solid var(--line)}
        tbody tr:hover{background:#fafafa}
        .name strong{display:block;margin-bottom:4px}
        .desc{font-size:12px;color:#6b7280}

        /* Category tag (outline) */
        .tag{
            display:inline-block;padding:4px 10px;border-radius:999px;
            font-size:12px;font-weight:600;border:1px solid #d1d5db;color:#374151;background:#fff;
        }
        .tag.grooming{border-color:#bfdbfe;color:#1d4ed8}
        .tag.medical{border-color:#bbf7d0;color:#15803d}
        .tag.training{border-color:#fde68a;color:#92400e}

        /* Status pill */
        .status{
            display:inline-flex;align-items:center;justify-content:center;
            padding:4px 10px;border-radius:999px;font-size:12px;font-weight:700;text-transform:lowercase;
        }
        .status.active{background:var(--pill);color:#fff}
        .status.inactive{background:#e5e7eb;color:#374151}

        /* Action buttons (square icon buttons) */
        .actions{display:flex;gap:8px}
        .icon-btn{
            width:34px;height:34px;display:inline-flex;align-items:center;justify-content:center;
            background:#fff;border:1px solid var(--line);border-radius:10px;cursor:pointer;
            color:#4b5563;transition:.15s;
        }
        .icon-btn:hover{border-color:#c7cbd1;color:var(--text);background:#f9fafb}
        .icon-btn.edit i{content:""}
        .icon-btn.view i{content:""}
        .icon-btn.delete:hover{color:#dc2626;border-color:#fecaca;background:#fff}

        /* Responsive */
        @media (max-width: 900px){
            .sidebar{display:none}
            .content{padding:22px}
            .desc{display:none}
        }
    </style>
</head>
<body>
<%@ include file="inc/header.jsp" %>

<div class="layout">
    <%-- set currentPage để sidebar.jsp đánh dấu active --%>
    <% request.setAttribute("currentPage", "manage-services"); %>

    <%-- Sidebar include (thay cho khối <aside> cũ) --%>
    <%@ include file="inc/sidebar.jsp" %>

    <!-- Main -->
    <main class="content">
        <div class="topbar">
            <div class="title-wrap">
                <h2>Manage Services</h2>
                <p class="subtitle">Add, update, or delete service information</p>
            </div>
            <button class="btn-add"><i class="ri-add-line"></i> Add Service</button>
        </div>

        <div class="search">
            <i class="ri-search-line"></i>
            <input type="text" placeholder="Search services..." />
        </div>

        <div class="card">
            <table class="service-table">
                <thead>
                <tr>
                    <th>Service Name</th>
                    <th>Category</th>
                    <th>Duration</th>
                    <th>Price</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td class="name">
                        <strong>Dog Grooming</strong>
                        <div class="desc">Complete grooming service including bath, nail trimming, and styling</div>
                    </td>
                    <td><span class="tag grooming">Grooming</span></td>
                    <td>120 min</td>
                    <td>$45</td>
                    <td><span class="status active">active</span></td>
                    <td class="actions">
                        <button class="icon-btn edit" title="Edit"><i class="ri-pencil-line"></i></button>
                        <button class="icon-btn view" title="View"><i class="ri-eye-line"></i></button>
                        <button class="icon-btn delete" title="Delete"><i class="ri-delete-bin-line"></i></button>
                    </td>
                </tr>

                <tr>
                    <td class="name">
                        <strong>Cat Vaccination</strong>
                        <div class="desc">Annual vaccination package for cats</div>
                    </td>
                    <td><span class="tag medical">Medical</span></td>
                    <td>30 min</td>
                    <td>$75</td>
                    <td><span class="status active">active</span></td>
                    <td class="actions">
                        <button class="icon-btn edit"><i class="ri-pencil-line"></i></button>
                        <button class="icon-btn view"><i class="ri-eye-line"></i></button>
                        <button class="icon-btn delete"><i class="ri-delete-bin-line"></i></button>
                    </td>
                </tr>

                <tr>
                    <td class="name">
                        <strong>Pet Training</strong>
                        <div class="desc">Basic obedience training session</div>
                    </td>
                    <td><span class="tag training">Training</span></td>
                    <td>60 min</td>
                    <td>$80</td>
                    <td><span class="status active">active</span></td>
                    <td class="actions">
                        <button class="icon-btn edit"><i class="ri-pencil-line"></i></button>
                        <button class="icon-btn view"><i class="ri-eye-line"></i></button>
                        <button class="icon-btn delete"><i class="ri-delete-bin-line"></i></button>
                    </td>
                </tr>

                <tr>
                    <td class="name">
                        <strong>Health Checkup</strong>
                        <div class="desc">Comprehensive health examination</div>
                    </td>
                    <td><span class="tag medical">Medical</span></td>
                    <td>45 min</td>
                    <td>$65</td>
                    <td><span class="status inactive">inactive</span></td>
                    <td class="actions">
                        <button class="icon-btn edit"><i class="ri-pencil-line"></i></button>
                        <button class="icon-btn view"><i class="ri-eye-line"></i></button>
                        <button class="icon-btn delete"><i class="ri-delete-bin-line"></i></button>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </main>
</div>
</body>
</html>
