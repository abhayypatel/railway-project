<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - Railway Project System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="../css/style.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="dashboard">Railway Project - Admin Panel</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            Management
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="employees">Employee Management</a></li>
                            <li><a class="dropdown-item" href="schedules">Train Schedules</a></li>
                            <li><a class="dropdown-item" href="customer-service">Customer Service</a></li>
                        </ul>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle active" href="#" role="button" data-bs-toggle="dropdown">
                            Reports
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="reports?type=revenue">Revenue Reports</a></li>
                            <li><a class="dropdown-item" href="reports?type=reservations-by-line">Reservation Reports</a></li>
                            <li><a class="dropdown-item" href="reports?type=customers">Customer Reports</a></li>
                            <li><a class="dropdown-item" href="reports?type=active-lines">Active Lines</a></li>
                        </ul>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            Admin: ${sessionScope.fullName}
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="../logout">Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>
                <i class="fas fa-chart-bar text-primary me-2"></i>${reportTitle}
            </h1>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>${error}
            </div>
        </c:if>

        <c:if test="${reportType == 'reservations-by-line'}">
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-search me-2"></i>Search Reservations by Transit Line and Date
                    </h5>
                </div>
                <div class="card-body">
                    <form method="post" action="reports">
                        <input type="hidden" name="type" value="reservations-by-line">
                        <div class="row">
                            <div class="col-md-4">
                                <label for="line" class="form-label">Transit Line Name</label>
                                <input type="text" class="form-control" id="line" name="line" 
                                       value="${searchLine}" placeholder="e.g., Northeast Corridor" required>
                            </div>
                            <div class="col-md-4">
                                <label for="date" class="form-label">Departure Date</label>
                                <input type="date" class="form-control" id="date" name="date" 
                                       value="${searchDate}" required>
                            </div>
                            <div class="col-md-4 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-search me-1"></i>Search Reservations
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <c:if test="${not empty reservations}">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-users me-2"></i>Customer Reservations Results
                            <span class="badge bg-primary ms-2">${reservations.size()} found</span>
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Reservation #</th>
                                        <th>Customer</th>
                                        <th>Passenger Name</th>
                                        <th>Origin</th>
                                        <th>Destination</th>
                                        <th>Departure Time</th>
                                        <th>Trip Type</th>
                                        <th>Fare</th>
                                        <th>Date Made</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="reservation" items="${reservations}">
                                        <tr>
                                            <td>${reservation.resNum}</td>
                                            <td>${reservation.username}</td>
                                            <td>${reservation.passenger}</td>
                                            <td>${reservation.originStation}</td>
                                            <td>${reservation.destStation}</td>
                                            <td><fmt:formatDate value="${reservation.departureTime}" pattern="HH:mm"/></td>
                                            <td>
                                                <span class="badge ${reservation.tripType == 'One-way' ? 'bg-info' : 'bg-success'}">
                                                    ${reservation.tripType}
                                                </span>
                                            </td>
                                            <td>$<fmt:formatNumber value="${reservation.totalFare}" pattern="#,##0.00"/></td>
                                            <td><fmt:formatDate value="${reservation.dateMade}" pattern="MMM dd, yyyy"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>
        </c:if>

        <c:if test="${reportType == 'schedules-by-station'}">
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-search me-2"></i>Search Train Schedules by Station
                    </h5>
                </div>
                <div class="card-body">
                    <form method="post" action="reports">
                        <input type="hidden" name="type" value="schedules-by-station">
                        <div class="row">
                            <div class="col-md-8">
                                <label for="station" class="form-label">Station Name</label>
                                <input type="text" class="form-control" id="station" name="station" 
                                       value="${searchStation}" placeholder="e.g., New York" required>
                                <div class="form-text">Shows schedules where this station is either origin or destination</div>
                            </div>
                            <div class="col-md-4 d-flex align-items-end">
                                <button type="submit" class="btn btn-warning w-100">
                                    <i class="fas fa-search me-1"></i>Search Schedules
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <c:if test="${not empty schedules}">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-train me-2"></i>Train Schedule Results
                            <span class="badge bg-warning text-dark ms-2">${schedules.size()} found</span>
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Line</th>
                                        <th>Train ID</th>
                                        <th>Origin</th>
                                        <th>Destination</th>
                                        <th>Departure</th>
                                        <th>Arrival</th>
                                        <th>Travel Time</th>
                                        <th>Stops</th>
                                        <th>Fare</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="schedule" items="${schedules}">
                                        <tr>
                                            <td><strong>${schedule.line}</strong></td>
                                            <td>${schedule.trainId}</td>
                                            <td>
                                                ${schedule.origin}
                                                <c:if test="${schedule.origin == searchStation}">
                                                    <span class="badge bg-primary ms-1">Origin</span>
                                                </c:if>
                                            </td>
                                            <td>
                                                ${schedule.dest}
                                                <c:if test="${schedule.dest == searchStation}">
                                                    <span class="badge bg-success ms-1">Destination</span>
                                                </c:if>
                                            </td>
                                            <td><fmt:formatDate value="${schedule.deptTime}" pattern="HH:mm"/></td>
                                            <td><fmt:formatDate value="${schedule.arrivalTime}" pattern="HH:mm"/></td>
                                            <td>${schedule.travelTime} min</td>
                                            <td>${schedule.stops}</td>
                                            <td>$<fmt:formatNumber value="${schedule.fare}" pattern="#,##0.00"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>
        </c:if>

        <c:if test="${reportType == 'customers'}">
            <div class="row mb-4">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-users me-2"></i>All Registered Customers
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty customers}">
                                <div class="table-responsive">
                                    <table class="table table-striped">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>Username</th>
                                                <th>Full Name</th>
                                                <th>Email</th>
                                                <th>Total Spending</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="customer" items="${customers}" varStatus="status">
                                                <tr>
                                                    <td><strong>${customer.username}</strong></td>
                                                    <td>${customer.firstName} ${customer.lastName}</td>
                                                    <td>${customer.email}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty customerSpending and status.index < customerSpending.size()}">
                                                                <span class="fw-bold text-success">$<fmt:formatNumber value="${customerSpending[status.index]}" pattern="#,##0.00"/></span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">$0.00</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-crown me-2"></i>Top Customer
                            </h5>
                        </div>
                        <div class="card-body text-center">
                            <c:choose>
                                <c:when test="${not empty topCustomer}">
                                    <div class="text-success mb-3">
                                        <i class="fas fa-trophy fa-3x"></i>
                                    </div>
                                    <h5 class="text-primary">${topCustomer}</h5>
                                    <p class="text-muted">Highest total spending customer</p>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-muted">
                                        <i class="fas fa-users fa-3x mb-3"></i>
                                        <p>No customer data available</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${reportType == 'active-lines'}">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-route me-2"></i>Most Active Transit Lines
                    </h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty topLines}">
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>Rank</th>
                                            <th>Transit Line</th>
                                            <th>Total Revenue</th>
                                            <th>Popularity</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="line" items="${topLines}" varStatus="status">
                                            <tr>
                                                <td>
                                                    <span class="badge bg-primary">#${status.index + 1}</span>
                                                </td>
                                                <td><strong>${line}</strong></td>
                                                <td>
                                                    <c:if test="${not empty lineRevenues and status.index < lineRevenues.size()}">
                                                        $<fmt:formatNumber value="${lineRevenues[status.index]}" pattern="#,##0.00"/>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <div class="progress" style="height: 20px;">
                                                        <div class="progress-bar bg-success" role="progressbar" 
                                                             style="width: ${100 - (status.index * 15)}%" 
                                                             aria-valuenow="${100 - (status.index * 15)}" 
                                                             aria-valuemin="0" aria-valuemax="100">
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center text-muted py-5">
                                <i class="fas fa-route fa-3x mb-3"></i>
                                <h5>No active lines found</h5>
                                <p>No reservation data available to analyze transit line activity.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>

        <c:if test="${reportType == 'revenue'}">
            <div class="row mb-4">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-chart-line me-2"></i>Monthly Revenue - ${currentYear}
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty monthlyRevenues}">
                                <div class="table-responsive">
                                    <table class="table table-striped">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>Month</th>
                                                <th>Revenue</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="revenue" items="${monthlyRevenues}" varStatus="status">
                                                <tr>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${status.index == 0}">January</c:when>
                                                            <c:when test="${status.index == 1}">February</c:when>
                                                            <c:when test="${status.index == 2}">March</c:when>
                                                            <c:when test="${status.index == 3}">April</c:when>
                                                            <c:when test="${status.index == 4}">May</c:when>
                                                            <c:when test="${status.index == 5}">June</c:when>
                                                            <c:when test="${status.index == 6}">July</c:when>
                                                            <c:when test="${status.index == 7}">August</c:when>
                                                            <c:when test="${status.index == 8}">September</c:when>
                                                            <c:when test="${status.index == 9}">October</c:when>
                                                            <c:when test="${status.index == 10}">November</c:when>
                                                            <c:when test="${status.index == 11}">December</c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td>$<fmt:formatNumber value="${revenue}" pattern="#,##0.00"/></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-trophy me-2"></i>Top Revenue Lines
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty topLines}">
                                <c:forEach var="line" items="${topLines}" varStatus="status">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <div>
                                            <span class="badge bg-secondary me-2">${status.index + 1}</span>
                                            ${line}
                                        </div>
                                        <div>
                                            $<fmt:formatNumber value="${lineRevenues[status.index]}" pattern="#,##0"/>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${empty reportType or reportType == 'overview'}">
            <div class="row">
                <div class="col-md-3">
                    <div class="card bg-primary text-white">
                        <div class="card-body text-center">
                            <i class="fas fa-ticket-alt fa-2x mb-2"></i>
                            <h4>${totalReservations}</h4>
                            <p class="mb-0">Total Reservations</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card bg-success text-white">
                        <div class="card-body text-center">
                            <i class="fas fa-dollar-sign fa-2x mb-2"></i>
                            <h4>$<fmt:formatNumber value="${monthlyRevenue}" pattern="#,##0"/></h4>
                            <p class="mb-0">Monthly Revenue</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card bg-info text-white">
                        <div class="card-body text-center">
                            <i class="fas fa-users fa-2x mb-2"></i>
                            <h4>${totalCustomers}</h4>
                            <p class="mb-0">Registered Customers</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card bg-warning text-dark">
                        <div class="card-body text-center">
                            <i class="fas fa-train fa-2x mb-2"></i>
                            <h4>${totalSchedules}</h4>
                            <p class="mb-0">Active Schedules</p>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 