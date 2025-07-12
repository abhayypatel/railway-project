<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - Customer Rep</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="../css/style.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container">
            <a class="navbar-brand" href="dashboard">Railway Project - Customer Rep</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="customer-service">Customer Service</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="schedules">Train Schedules</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="reports">Reports</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            Representative: ${sessionScope.fullName}
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
                <i class="fas fa-chart-bar text-success me-2"></i>Representative Reports
            </h1>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${showReportOptions}">
            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="card h-100">
                        <div class="card-body text-center">
                            <i class="fas fa-users fa-3x text-primary mb-3"></i>
                            <h5 class="card-title">Customer Reservations by Line & Date</h5>
                            <p class="card-text">View all customers who have reservations on a specific transit line and date.</p>
                            <a href="reports?type=line-reservations" class="btn btn-primary">
                                <i class="fas fa-list me-1"></i>Generate Report
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="card h-100">
                        <div class="card-body text-center">
                            <i class="fas fa-map-marker-alt fa-3x text-success mb-3"></i>
                            <h5 class="card-title">Station Schedules</h5>
                            <p class="card-text">View all train schedules for a given station (both as origin and destination).</p>
                            <a href="reports?type=station-schedules" class="btn btn-success">
                                <i class="fas fa-train me-1"></i>Generate Report
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${reportType == 'line-reservations'}">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-users me-2"></i>Customer Reservations by Line & Date
                    </h5>
                </div>
                <div class="card-body">
                    <form method="get" action="reports" class="mb-4">
                        <input type="hidden" name="type" value="line-reservations">
                        <div class="row">
                            <div class="col-md-5">
                                <label class="form-label">Transit Line:</label>
                                <select class="form-select" name="line" required>
                                    <option value="">Select Transit Line</option>
                                    <c:forEach var="schedule" items="${schedules}">
                                        <option value="${schedule.line}" ${selectedLine == schedule.line ? 'selected' : ''}>${schedule.line}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-5">
                                <label class="form-label">Date:</label>
                                <input type="date" class="form-control" name="date" value="${selectedDate}" required>
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-search me-1"></i>Search
                                </button>
                            </div>
                        </div>
                    </form>

                    <c:if test="${not empty reservations}">
                        <div class="alert alert-info">
                            <strong>Showing reservations for:</strong> ${selectedLine} on <fmt:formatDate value="${selectedDateFormatted}" pattern="MMMM dd, yyyy"/>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead class="table-success">
                                    <tr>
                                        <th>Reservation #</th>
                                        <th>Customer</th>
                                        <th>Passenger</th>
                                        <th>Route</th>
                                        <th>Departure Time</th>
                                        <th>Trip Type</th>
                                        <th>Fare</th>
                                        <th>Booked On</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="reservation" items="${reservations}">
                                        <tr>
                                            <td><strong>#${reservation.resNum}</strong></td>
                                            <td>${reservation.username}</td>
                                            <td>${reservation.passenger}</td>
                                            <td>${reservation.originStation} → ${reservation.destStation}</td>
                                            <td><fmt:formatDate value="${reservation.departureTime}" pattern="HH:mm"/></td>
                                            <td>
                                                <span class="badge ${reservation.tripType == 'round-trip' ? 'bg-warning text-dark' : 'bg-secondary'}">
                                                    ${reservation.tripType == 'round-trip' ? 'Round Trip' : 'One Way'}
                                                </span>
                                            </td>
                                            <td>$<fmt:formatNumber value="${reservation.totalFare}" pattern="#,##0.00"/></td>
                                            <td><fmt:formatDate value="${reservation.dateMade}" pattern="MMM dd, yyyy"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <div class="text-muted mt-2">
                            <strong>Total Reservations:</strong> ${reservations.size()}
                        </div>
                    </c:if>
                    
                    <c:if test="${empty reservations and not empty selectedLine}">
                        <div class="alert alert-warning">
                            <i class="fas fa-info-circle me-2"></i>No reservations found for <strong>${selectedLine}</strong> on <fmt:formatDate value="${selectedDateFormatted}" pattern="MMMM dd, yyyy"/>.
                        </div>
                    </c:if>
                </div>
            </div>
        </c:if>

        <c:if test="${reportType == 'station-schedules'}">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-map-marker-alt me-2"></i>Station Schedules Report
                    </h5>
                </div>
                <div class="card-body">
                    <form method="get" action="reports" class="mb-4">
                        <input type="hidden" name="type" value="station-schedules">
                        <div class="row">
                            <div class="col-md-8">
                                <label class="form-label">Station Name:</label>
                                <input type="text" class="form-control" name="station" 
                                       value="${selectedStation}" placeholder="Enter station name..." required>
                                <div class="form-text">Available stations: 
                                    <c:forEach var="schedule" items="${allSchedules}" varStatus="status">
                                        ${schedule.origin}<c:if test="${!status.last}">, </c:if>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="col-md-4 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-search me-1"></i>Search
                                </button>
                            </div>
                        </div>
                    </form>

                    <c:if test="${not empty stationSchedules}">
                        <div class="alert alert-info">
                            <strong>Showing schedules for station:</strong> ${selectedStation}
                        </div>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead class="table-success">
                                    <tr>
                                        <th>Transit Line</th>
                                        <th>Train #</th>
                                        <th>Origin</th>
                                        <th>Destination</th>
                                        <th>Departure</th>
                                        <th>Arrival</th>
                                        <th>Travel Time</th>
                                        <th>Stops</th>
                                        <th>Fare</th>
                                        <th>Role</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="schedule" items="${stationSchedules}">
                                        <tr>
                                            <td><strong>${schedule.line}</strong></td>
                                            <td>#${schedule.trainId}</td>
                                            <td>
                                                ${schedule.origin}
                                                <c:if test="${schedule.origin == selectedStation}">
                                                    <span class="badge bg-primary ms-1">Origin</span>
                                                </c:if>
                                            </td>
                                            <td>
                                                ${schedule.dest}
                                                <c:if test="${schedule.dest == selectedStation}">
                                                    <span class="badge bg-success ms-1">Destination</span>
                                                </c:if>
                                            </td>
                                            <td><fmt:formatDate value="${schedule.deptTime}" pattern="HH:mm"/></td>
                                            <td><fmt:formatDate value="${schedule.arrivalTime}" pattern="HH:mm"/></td>
                                            <td>${schedule.travelTime} min</td>
                                            <td>${schedule.stops}</td>
                                            <td>$<fmt:formatNumber value="${schedule.fare}" pattern="#,##0.00"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${schedule.origin == selectedStation}">
                                                        <span class="text-primary">Origin Station</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-success">Destination Station</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <div class="text-muted mt-2">
                            <strong>Total Schedules:</strong> ${stationSchedules.size()}
                        </div>
                    </c:if>
                    
                    <c:if test="${empty stationSchedules and not empty selectedStation}">
                        <div class="alert alert-warning">
                            <i class="fas fa-info-circle me-2"></i>No schedules found for station <strong>${selectedStation}</strong>. Please check the station name and try again.
                        </div>
                    </c:if>
                </div>
            </div>
        </c:if>

        <c:if test="${not showReportOptions}">
            <div class="mt-4">
                <a href="reports" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-1"></i>Back to Reports
                </a>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 