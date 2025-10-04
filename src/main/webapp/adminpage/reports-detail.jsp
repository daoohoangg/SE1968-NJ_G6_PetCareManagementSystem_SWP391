<%@ page contentType="text/html; charset=UTF-8" %>
<section class="page">
    <div class="page-title">
        <h1>Generate Reports</h1>
        <p>Operational and financial reports from the system</p>
        <div class="date-range">
            <input type="date" value="2024-01-01"/><span>to</span><input type="date" value="2024-01-31"/>
        </div>
    </div>

    <div class="cards grid-4">
        <div class="card stat"><div class="stat-title">Total Revenue</div><div class="stat-value">$91,000</div><div class="stat-sub">+12.5%</div></div>
        <div class="card stat"><div class="stat-title">Total Appointments</div><div class="stat-value">624</div><div class="stat-sub"><a href="#">94.2% completed</a></div></div>
        <div class="card stat"><div class="stat-title">Avg Transaction</div><div class="stat-value">$76.5</div><div class="stat-sub"><a href="#">Top: Dog Grooming</a></div></div>
        <div class="card stat"><div class="stat-title">Customer Rating</div><div class="stat-value">4.7/5.0</div><div class="stat-sub">Avg 67min</div></div>
    </div>

    <div class="tabs">
        <button class="tab active">Financial Reports</button>
        <button class="tab">Operational Reports</button>
    </div>

    <div class="grid-2">
        <div class="card">
            <div class="card-head">
                <strong>Monthly Revenue Trend</strong>
                <div class="right">
                    <button class="btn">PDF</button>
                    <button class="btn">Excel</button>
                </div>
            </div>
            <canvas id="revenueTrend"></canvas>
        </div>

        <div class="card">
            <div class="card-head">
                <strong>Revenue by Service</strong>
                <button class="btn">PDF</button>
            </div>
            <canvas id="revenuePie"></canvas>
        </div>
    </div>

    <div class="card" style="margin-top:16px">
        <div class="card-head">
            <strong>Detailed Financial Report</strong>
            <div class="right">
                <button class="btn success">Generate Report</button>
                <button class="btn">Print</button>
            </div>
        </div>
        <div class="table">
            <div class="row head">
                <div>Service Category</div><div>Bookings</div><div>Revenue</div><div>Avg Price</div><div>Growth</div>
            </div>
            <div class="row">
                <div>Dog Grooming</div><div>35</div><div>$8750</div><div>$250.00</div><div><span class="badge up">+10%</span></div>
            </div>
            <div class="row">
                <div>Cat Grooming</div><div>25</div><div>$5500</div><div>$220.00</div><div><span class="badge down">-24%</span></div>
            </div>
            <div class="row">
                <div>Health Checkup</div><div>20</div><div>$6200</div><div>$310.00</div><div><span class="badge up">+18%</span></div>
            </div>
            <div class="row">
                <div>Vaccination</div><div>15</div><div>$4800</div><div>$320.00</div><div><span class="badge down">-6%</span></div>
            </div>
            <div class="row">
                <div>Training</div><div>5</div><div>$1200</div><div>$240.00</div><div><span class="badge up">+9%</span></div>
            </div>
        </div>
    </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    new Chart(document.getElementById('revenueTrend'), {
        type:'line',
        data:{labels:['Jan','Feb','Mar','Apr','May','Jun'],
            datasets:[{label:'Revenue', data:[12000,15000,16000,14800,18000,19000], fill:false}]}
    });
    new Chart(document.getElementById('revenuePie'), {
        type:'pie',
        data:{labels:['Dog Grooming 35%','Cat Grooming 25%','Health Checkup 20%','Vaccination 15%','Training 5%'],
            datasets:[{data:[35,25,20,15,5]}]}
    });
</script>
