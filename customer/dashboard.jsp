<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard - Railway Project System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../css/style.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="#">Railway Project</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="search">Search Trains</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="reservations">My Reservations</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="questions">Customer Service</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            Welcome, ${fullName}
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
        <h1 class="mb-4">Customer Dashboard</h1>

        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${sessionScope.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="success" scope="session"/>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                ${error}
            </div>
        </c:if>

        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-primary text-white">
                    <div class="card-body text-center">
                        <h5 class="card-title">Search Trains</h5>
                        <p class="card-text">Find trains for your journey</p>
                        <a href="search" class="btn btn-light">Search Now</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body text-center">
                        <h5 class="card-title">My Reservations</h5>
                        <p class="card-text">View your bookings</p>
                        <a href="reservations" class="btn btn-light">View All</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-info text-white">
                    <div class="card-body text-center">
                        <h5 class="card-title">Customer Service</h5>
                        <p class="card-text">Ask questions or get help</p>
                        <a href="questions" class="btn btn-light">Contact Us</a>
                    </div>
                </div>
            </div>

        </div>

        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Recent Reservations</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty recentReservations}">
                                <div class="table-responsive">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>Reservation #</th>
                                                <th>Train Line</th>
                                                <th>Route</th>
                                                <th>Departure Date</th>
                                                <th>Passenger</th>
                                                <th>Fare</th>
                                                <th>Type</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${recentReservations}" var="reservation" varStatus="status">
                                                <c:if test="${status.index < 5}">
                                                    <tr>
                                                        <td><strong>${reservation.resNum}</strong></td>
                                                        <td>${reservation.line}</td>
                                                        <td>${reservation.originStation} → ${reservation.destStation}</td>
                                                        <td><fmt:formatDate value="${reservation.departureDate}" pattern="MMM dd, yyyy"/></td>
                                                        <td>${reservation.passenger}</td>
                                                        <td>$<fmt:formatNumber value="${reservation.totalFare}" pattern="#,##0.00"/></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${reservation.tripType == 'round-trip'}">
                                                                    <span class="badge bg-info">Round Trip</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-primary">One Way</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <c:if test="${fn:length(recentReservations) > 5}">
                                    <div class="text-center mt-3">
                                        <a href="reservations" class="btn btn-primary">View All Reservations</a>
                                    </div>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4">
                                    <p class="text-muted">No reservations found.</p>
                                    <a href="search" class="btn btn-primary">Book Your First Trip</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 