<%@ page contentType="text/html; charset=UTF-8"%>
<section class="page">
  <h1>System Configuration</h1><p>Configure rules, schedules, vouchers, and email notifications</p>
  <div class="tabs sub">
    <a class="tab" href="${cxt}/config/schedule">Schedule</a>
    <a class="tab" href="${cxt}/config/vouchers">Vouchers</a>
    <a class="tab" href="${cxt}/config/email">Email</a>
    <a class="tab active" href="${cxt}/config/rules">Rules</a>
  </div>

  <div class="card">
    <strong>Booking Rules</strong>
    <label>Maximum Advance Booking (days) <input type="number" value="90"/></label>
    <label>Cancellation Notice (hours) <input type="number" value="24"/></label>
    <label>Auto-confirmation <input type="checkbox" checked/></label>
    <label>Require Deposit <input type="checkbox"/></label>
    <button class="btn success">Save All Settings</button>
  </div>
</section>
<% pageContext.setAttribute("cxt", request.getContextPath()); %>
