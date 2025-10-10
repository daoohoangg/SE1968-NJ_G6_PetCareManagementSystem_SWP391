<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Services</title>
    <link rel="stylesheet" href="manage-services.css" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>
<div class="layout">
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="logo">
            <i class="ri-heart-line"></i>
            <span>PetCare Pro</span>
            <p>Management System</p>
        </div>
        <nav class="menu">
            <a href="#" class="menu-item"><i class="ri-dashboard-line"></i> Dashboard</a>
            <a href="#" class="menu-item active"><i class="ri-scissors-line"></i> Manage Services</a>
            <a href="#" class="menu-item"><i class="ri-settings-3-line"></i> Configure System</a>
            <a href="#" class="menu-item"><i class="ri-user-settings-line"></i> Manage Accounts</a>
            <a href="#" class="menu-item"><i class="ri-robot-line"></i> AI Features</a>
            <a href="#" class="menu-item"><i class="ri-bar-chart-2-line"></i> Generate Reports</a>
        </nav>
    </aside>

    <!-- Main content -->
    <main class="content">
        <div class="header">
            <h2>Manage Services</h2>
            <p>Add, update, or delete service information</p>
            <button class="btn-add"><i class="ri-add-line"></i> Add Service</button>
        </div>

        <div class="search-box">
            <input type="text" placeholder="Search services..." />
        </div>

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
                <td>
                    <strong>Dog Grooming</strong>
                    <p>Complete grooming service including bath, nail trimming, and styling</p>
                </td>
                <td><span class="tag grooming">Grooming</span></td>
                <td>120 min</td>
                <td>$45</td>
                <td><span class="status active">active</span></td>
                <td>
                    <button class="icon-btn edit"><i class="ri-pencil-line"></i></button>
                    <button class="icon-btn delete"><i class="ri-delete-bin-line"></i></button>
                </td>
            </tr>
            <tr>
                <td>
                    <strong>Cat Vaccination</strong>
                    <p>Annual vaccination package for cats</p>
                </td>
                <td><span class="tag medical">Medical</span></td>
                <td>30 min</td>
                <td>$75</td>
                <td><span class="status active">active</span></td>
                <td>
                    <button class="icon-btn edit"><i class="ri-pencil-line"></i></button>
                    <button class="icon-btn delete"><i class="ri-delete-bin-line"></i></button>
                </td>
            </tr>
            <tr>
                <td>
                    <strong>Pet Training</strong>
                    <p>Basic obedience training session</p>
                </td>
                <td><span class="tag training">Training</span></td>
                <td>60 min</td>
                <td>$80</td>
                <td><span class="status active">active</span></td>
                <td>
                    <button class="icon-btn edit"><i class="ri-pencil-line"></i></button>
                    <button class="icon-btn delete"><i class="ri-delete-bin-line"></i></button>
                </td>
            </tr>
            <tr>
                <td>
                    <strong>Health Checkup</strong>
                    <p>Comprehensive health examination</p>
                </td>
                <td><span class="tag medical">Medical</span></td>
                <td>45 min</td>
                <td>$65</td>
                <td><span class="status inactive">inactive</span></td>
                <td>
                    <button class="icon-btn edit"><i class="ri-pencil-line"></i></button>
                    <button class="icon-btn delete"><i class="ri-delete-bin-line"></i></button>
                </td>
            </tr>
            </tbody>
        </table>
    </main>
</div>
</body>
</html>
<style>
* {
margin: 0;
padding: 0;
box-sizing: border-box;
font-family: "Inter", sans-serif;
}

body {
background-color: #f7f9fc;
color: #333;
}

.layout {
display: flex;
height: 100vh;
}

/* Sidebar */
.sidebar {
width: 240px;
background-color: #fff;
border-right: 1px solid #e0e0e0;
padding: 20px 10px;
}

.logo {
text-align: center;
margin-bottom: 30px;
}

.logo i {
font-size: 24px;
color: #007bff;
}

.logo span {
display: block;
font-weight: 600;
font-size: 18px;
color: #333;
}

.logo p {
font-size: 12px;
color: #777;
}

.menu-item {
display: flex;
align-items: center;
gap: 10px;
color: #555;
text-decoration: none;
padding: 10px 15px;
border-radius: 8px;
margin-bottom: 5px;
transition: background 0.2s, color 0.2s;
}

.menu-item.active,
.menu-item:hover {
background-color: #e9f3ff;
color: #007bff;
}

/* Main Content */
.content {
flex: 1;
padding: 30px 40px;
}

.header {
display: flex;
align-items: center;
justify-content: space-between;
margin-bottom: 20px;
}

.header h2 {
font-size: 22px;
color: #222;
}

.header p {
color: #666;
font-size: 14px;
flex: 1;
margin-left: 20px;
}

.btn-add {
background-color: #007bff;
border: none;
color: white;
padding: 10px 16px;
border-radius: 8px;
cursor: pointer;
display: flex;
align-items: center;
gap: 6px;
font-weight: 500;
}

.btn-add:hover {
background-color: #005fcc;
}

/* Search Box */
.search-box {
background: white;
border-radius: 10px;
padding: 10px;
margin-bottom: 20px;
box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}

.search-box input {
width: 100%;
border: none;
outline: none;
font-size: 14px;
color: #333;
}

/* Table */
.service-table {
width: 100%;
border-collapse: collapse;
background: white;
border-radius: 12px;
overflow: hidden;
box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}

.service-table th,
.service-table td {
padding: 14px 18px;
text-align: left;
font-size: 14px;
}

.service-table thead {
background-color: #f4f6fa;
}

.service-table tbody tr {
border-top: 1px solid #eee;
}

.service-table td p {
font-size: 12px;
color: #777;
}

/* Tags */
.tag {
padding: 4px 10px;
border-radius: 12px;
font-size: 12px;
font-weight: 500;
}

.tag.grooming { background-color: #e0f3ff; color: #007bff; }
.tag.medical { background-color: #e9f7ec; color: #28a745; }
.tag.training { background-color: #fff3cd; color: #d39e00; }

/* Status */
.status {
padding: 4px 10px;
border-radius: 12px;
font-size: 12px;
text-transform: lowercase;
font-weight: 600;
}

.status.active { background-color: #000; color: #fff; }
.status.inactive { background-color: #ddd; color: #333; }

/* Action buttons */
.icon-btn {
background: none;
border: none;
cursor: pointer;
margin-right: 5px;
font-size: 18px;
color: #555;
transition: color 0.2s;
}

.icon-btn.edit:hover { color: #007bff; }
.icon-btn.delete:hover { color: #e63946; }
</style>