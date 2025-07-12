<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Trains - Railway Project System</title>
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
                        <a class="nav-link" href="dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="search">Search Trains</a>
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
                            Welcome, ${sessionScope.user.firstName} ${sessionScope.user.lastName}
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
        <h1 class="mb-4">Search Train Schedules</h1>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                ${error}
            </div>
        </c:if>

        <c:if test="${not empty message}">
            <div class="alert alert-info" role="alert">
                ${message}
            </div>
        </c:if>

        <div class="row">
            <div class="col-md-8 mx-auto">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Find Your Train</h5>
                    </div>
                    <div class="card-body">
                        <form method="post" action="search">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="origin" class="form-label">From (Origin):</label>
                                    <select class="form-select" id="origin" name="origin" required>
                                        <option value="">Select departure station</option>
                                        <c:forEach var="station" items="${stationNames}">
                                            <option value="${station}" ${station == searchOrigin ? 'selected' : ''}>${station}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="destination" class="form-label">To (Destination):</label>
                                    <select class="form-select" id="destination" name="destination" required>
                                        <option value="">Select arrival station</option>
                                        <c:forEach var="station" items="${stationNames}">
                                            <option value="${station}" ${station == searchDestination ? 'selected' : ''}>${station}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">Search Trains</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <c:if test="${not empty schedules}">
            <div class="row mt-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Available Trains from ${searchOrigin} to ${searchDestination}</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Transit Line</th>
                                            <th>Train #</th>
                                            <th>Departure Time</th>
                                            <th>Arrival Time</th>
                                            <th>Travel Time</th>
                                            <th>Fare</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="schedule" items="${schedules}">
                                            <tr>
                                                <td><strong>${schedule.line}</strong></td>
                                                <td>#${schedule.trainId}</td>
                                                <td>${schedule.deptTime}</td>
                                                <td>${schedule.arrivalTime}</td>
                                                <td>${schedule.travelTime} minutes</td>
                                                <td>$${schedule.fare}</td>
                                                <td>
                                                    <a href="make-reservation?line=${schedule.line}&origin=${searchOrigin}&destination=${searchDestination}" 
                                                       class="btn btn-success btn-sm">Book Now</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>


    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 