<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Pet Profile</title>
    <style>
        body { font-family: Arial; margin: 30px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        h2 { color: #333; }
    </style>
</head>
<body>

<h2>Pet Profile: ${pet.name}</h2>
<p><b>Breed:</b> ${pet.breed}</p>
<p><b>Age:</b> ${pet.age}</p>
<p><b>Health:</b> ${pet.healthStatus}</p>
<p><b>Owner:</b> ${pet.owner.fullName}</p>

<h3>Service History</h3>
<table>
    <tr>
        <th>Service Type</th>
        <th>Description</th>
        <th>Date</th>
        <th>Cost</th>
        <th>Staff</th>
    </tr>
    <c:forEach var="h" items="${historyList}">
        <tr>
            <td>${h.serviceType}</td>
            <td>${h.description}</td>
            <td>${h.serviceDate}</td>
            <td>${h.cost}</td>
            <td>${h.staffName}</td>
        </tr>
    </c:forEach>
</table>

<br>
<a href="pet?action=list">← Back to list</a>

</body>
</html>
