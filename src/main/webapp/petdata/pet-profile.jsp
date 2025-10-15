<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<section class="page">
    <div class="page-title">
        <h1>🐾 Pet Profile</h1>
        <p>View details and service history for <strong>${pet.name}</strong></p>
    </div>

    <div class="actions-row">
        <a href="pet?action=list" class="btn">← Back to List</a>
        <a class="btn primary">+ Add Service Record</a>
    </div>

    <div class="cards grid-2" style="margin-top:16px">
        <div class="card">
            <div class="card-head"><strong>Basic Information</strong></div>
            <ul class="list">
                <li><b>Name:</b> ${pet.name}</li>
                <li><b>Breed:</b> ${pet.breed}</li>
                <li><b>Age:</b> ${pet.age}</li>
                <li><b>Health:</b> ${pet.healthStatus}</li>
                <li><b>Owner:</b> ${pet.owner.fullName}</li>
            </ul>
        </div>
        <div class="card">
            <div class="card-head"><strong>Service Summary</strong></div>
            <canvas id="svcChart"></canvas>
        </div>
    </div>

    <div class="card" style="margin-top:24px">
        <div class="card-head"><strong>Service History</strong></div>
        <table class="table">
            <thead>
            <tr>
                <th>Service Type</th>
                <th>Description</th>
                <th>Date</th>
                <th>Cost</th>
                <th>Staff</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="h" items="${historyList}">
                <tr>
                    <td>${h.serviceType}</td>
                    <td>${h.description}</td>
                    <td>${h.serviceDate}</td>
                    <td>${h.cost}</td>
                    <td>${h.staffName}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</section>

<style>
    .page {
        padding: 24px;
        font-family: Arial, sans-serif;
    }
    .page-title h1 {
        margin: 0;
        color: #333;
    }
    .page-title p {
        color: #666;
    }
    .actions-row {
        margin: 16px 0;
        display: flex;
        gap: 8px;
    }
    .btn {
        background: #ddd;
        padding: 8px 16px;
        border-radius: 6px;
        text-decoration: none;
        color: #222;
        transition: 0.2s;
    }
    .btn:hover {
        background: #ccc;
    }
    .btn.primary {
        background: #007bff;
        color: #fff;
    }
    .cards {
        display: grid;
        gap: 16px;
    }
    .grid-2 {
        grid-template-columns: repeat(2, 1fr);
    }
    .card {
        background: #fafafa;
        border-radius: 8px;
        padding: 16px;
        box-shadow: 0 1px 4px rgba(0,0,0,0.1);
    }
    .card-head {
        font-weight: bold;
        margin-bottom: 8px;
    }
    .list {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .list li {
        padding: 4px 0;
    }
    .table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 8px;
    }
    .table th, .table td {
        border: 1px solid #ddd;
        padding: 8px;
    }
    .table th {
        background: #f2f2f2;
    }
</style>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const ctx = document.getElementById('svcChart');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Grooming', 'Vet Check', 'Vaccination', 'Training'],
            datasets: [{
                label: 'Service Distribution',
                data: [40, 25, 20, 15],
                backgroundColor: ['#4caf50', '#2196f3', '#ffc107', '#e91e63']
            }]
        },
        options: {
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });
</script>
