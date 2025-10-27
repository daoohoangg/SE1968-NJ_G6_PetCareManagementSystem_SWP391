<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Add Service Record</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --text: #1f2937;
            --muted: #6b7280;
            --line: #e5e7eb;
            --bg: #f7f9fc;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Inter, system-ui, sans-serif;
            color: var(--text);
            background: var(--bg);
        }

        .layout {
            display: flex;
            min-height: 100vh;
        }

        .content {
            flex: 1;
            padding: 28px 36px;
            max-width: 900px;
            margin: 0 auto;
        }

        .header {
            margin-bottom: 24px;
        }

        h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 700;
        }

        .subtitle {
            color: var(--muted);
            font-size: 14px;
            margin: 4px 0 0 0;
        }

        .card {
            background: white;
            border: 1px solid var(--line);
            border-radius: 14px;
            padding: 32px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 8px;
        }

        label .required {
            color: #ef4444;
        }

        input, select, textarea {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid var(--line);
            border-radius: 10px;
            font-size: 14px;
            font-family: inherit;
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .rating-input {
            display: flex;
            gap: 8px;
        }

        .rating-input input[type="radio"] {
            display: none;
        }

        .rating-input label {
            cursor: pointer;
            font-size: 24px;
            color: #d1d5db;
            margin: 0;
        }

        .rating-input input[type="radio"]:checked ~ label,
        .rating-input label:hover,
        .rating-input label:hover ~ label {
            color: #fbbf24;
        }

        .actions {
            display: flex;
            gap: 12px;
            margin-top: 32px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 20px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
            flex: 1;
        }

        .btn-secondary {
            background: #f3f4f6;
            color: var(--text);
        }

        .btn:hover {
            filter: brightness(0.95);
        }

        @media (max-width: 768px) {
            .content {
                padding: 20px;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .card {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
<jsp:include page="../inc/header.jsp"/>
<div class="layout">
    <% request.setAttribute("currentPage", "pet-data"); %>
    <jsp:include page="../inc/side-bar.jsp"/>

    <main class="content">
        <div class="header">
            <h1>Add Service Record</h1>
            <p class="subtitle">Create a new spa/grooming service record for a pet</p>
        </div>

        <div class="card">
            <form method="post" action="${pageContext.request.contextPath}/petServiceHistory">
                <input type="hidden" name="action" value="add">

                <div class="form-row">
                    <div class="form-group">
                        <label>Pet <span class="required">*</span></label>
                        <select name="petId" required>
                            <option value="">Select a pet...</option>
                            <c:forEach var="pet" items="${pets}">
                                <option value="${pet.id}">${pet.name} - ${pet.customer.fullName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Staff <span class="required">*</span></label>
                        <select name="staffId" required>
                            <option value="">Select staff...</option>
                            <c:forEach var="staff" items="${staffList}">
                                <option value="${staff.accountId}">${staff.fullName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Service Type <span class="required">*</span></label>
                        <select name="serviceType" required>
                            <option value="">Select service...</option>
                            <option value="Full Grooming">Full Grooming</option>
                            <option value="Spa">Spa</option>
                            <option value="Bath">Bath</option>
                            <option value="Haircut">Haircut</option>
                            <option value="Nail Trim">Nail Trim</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Service Date <span class="required">*</span></label>
                        <input type="date" name="serviceDate" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Description <span class="required">*</span></label>
                    <input type="text" name="description" placeholder="Brief description of the service" required>
                </div>

                <div class="form-group">
                    <label>Cost ($) <span class="required">*</span></label>
                    <input type="number" name="cost" step="0.01" min="0" placeholder="0.00" required>
                </div>

                <div class="form-group">
                    <label>Notes</label>
                    <textarea name="notes" placeholder="Additional notes about the service..."></textarea>
                </div>

                <div class="form-group">
                    <label>Rating</label>
                    <div class="rating-input">
                        <input type="radio" name="rating" value="5" id="star5">
                        <label for="star5"><i class="ri-star-fill"></i></label>
                        <input type="radio" name="rating" value="4" id="star4">
                        <label for="star4"><i class="ri-star-fill"></i></label>
                        <input type="radio" name="rating" value="3" id="star3">
                        <label for="star3"><i class="ri-star-fill"></i></label>
                        <input type="radio" name="rating" value="2" id="star2">
                        <label for="star2"><i class="ri-star-fill"></i></label>
                        <input type="radio" name="rating" value="1" id="star1">
                        <label for="star1"><i class="ri-star-fill"></i></label>
                    </div>
                </div>

                <div class="actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="ri-save-line"></i> Save Record
                    </button>
                    <a href="${pageContext.request.contextPath}/petServiceHistory" class="btn btn-secondary">
                        <i class="ri-close-line"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
    </main>
</div>

<jsp:include page="../inc/footer.jsp"/>

<script>
    // Set default date to today
    document.querySelector('input[name="serviceDate"]').valueAsDate = new Date();
</script>
</body>
</html>
