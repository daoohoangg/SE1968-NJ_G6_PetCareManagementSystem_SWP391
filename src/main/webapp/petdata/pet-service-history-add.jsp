<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Add Pet Service History</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        :root{
            --primary:#2563eb; --text:#1f2937; --muted:#6b7280;
            --line:#e5e7eb; --bg:#f7f9fc;
        }
        *{box-sizing:border-box}
        body{margin:0;font-family:Inter,system-ui,Arial,sans-serif;color:var(--text);background:var(--bg);padding:28px 36px}
        
        .form-card{max-width:600px;margin:0 auto;background:#fff;border:1px solid var(--line);border-radius:14px;padding:28px;box-shadow:0 1px 3px rgba(15,23,42,.04)}
        h2{margin:0 0 6px 0;font-size:24px}
        .subtitle{margin:0 0 24px 0;color:var(--muted);font-size:14px}
        
        .form-field{margin-bottom:18px}
        .form-field label{display:block;font-size:13px;font-weight:600;color:#374151;margin-bottom:6px}
        .form-field input,
        .form-field textarea,
        .form-field select{
            width:100%;border:1px solid var(--line);border-radius:10px;padding:11px 12px;
            font-size:14px;color:var(--text);background:#fff;
            transition:border-color .15s, box-shadow .15s;
        }
        .form-field textarea{min-height:90px;resize:vertical;font-family:inherit}
        .form-field input:focus,
        .form-field textarea:focus,
        .form-field select:focus{
            border-color:var(--primary);box-shadow:0 0 0 3px rgba(37,99,235,.18);outline:none;
        }
        
        .form-actions{display:flex;gap:12px;margin-top:24px}
        .btn{padding:10px 16px;border-radius:10px;font-size:14px;font-weight:600;cursor:pointer;border:none;text-decoration:none;display:inline-flex;align-items:center;gap:6px}
        .btn-cancel{background:#f3f4f6;color:#374151}
        .btn-cancel:hover{background:#e5e7eb}
        .btn-primary{background:var(--primary);color:#fff;box-shadow:0 1px 0 rgba(0,0,0,.05)}
        .btn-primary:hover{filter:brightness(.96)}
    </style>
</head>
<body>

<div class="form-card">
    <h2>Add Service History</h2>
    <p class="subtitle">Record a new spa/grooming service for a pet</p>
    
    <form method="post" action="${pageContext.request.contextPath}/petServiceHistory">
        <input type="hidden" name="action" value="add"/>
        
        <div class="form-field">
            <label for="idpet">Pet ID</label>
            <input type="number" id="idpet" name="idpet" required placeholder="Enter pet ID"/>
        </div>
        
        <div class="form-field">
            <label for="serviceType">Service Type</label>
            <select id="serviceType" name="serviceType" required>
                <option value="">Select service type</option>
                <option value="Grooming">Grooming</option>
                <option value="Spa">Spa</option>
                <option value="Medical">Medical</option>
                <option value="Training">Training</option>
                <option value="Other">Other</option>
            </select>
        </div>
        
        <div class="form-field">
            <label for="description">Description</label>
            <textarea id="description" name="description" placeholder="Enter service description"></textarea>
        </div>
        
        <div class="form-field">
            <label for="serviceDate">Service Date</label>
            <input type="date" id="serviceDate" name="serviceDate" required/>
        </div>
        
        <div class="form-field">
            <label for="cost">Cost ($)</label>
            <input type="number" id="cost" name="cost" min="0" step="0.01" required placeholder="0.00"/>
        </div>
        
        <div class="form-field">
            <label for="staffId">Staff ID</label>
            <input type="number" id="staffId" name="staffId" placeholder="Enter staff ID (optional)"/>
        </div>
        
        <div class="form-actions">
            <a href="${pageContext.request.contextPath}/petServiceHistory" class="btn btn-cancel">
                <i class="ri-close-line"></i> Cancel
            </a>
            <button type="submit" class="btn btn-primary">
                <i class="ri-save-line"></i> Save Record
            </button>
        </div>
    </form>
</div>

</body>
</html>
