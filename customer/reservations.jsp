<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reservations - Railway Project System</title>
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
                        <a class="nav-link" href="search">Search Trains</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="reservations">My Reservations</a>
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
        <c:if test="${not empty success}">
            <div class="position-fixed top-0 end-0 p-3" style="z-index: 1050;">
                <div class="toast align-items-center text-white bg-success border-0 show" role="alert">
                    <div class="d-flex">
                        <div class="toast-body">
                            <i class="fas fa-check-circle me-2"></i>${success}
                        </div>
                        <button type="button" class="btn-close btn-close-white me-2 m-auto" onclick="this.parentElement.parentElement.parentElement.style.display='none'"></button>
                    </div>
                </div>
            </div>
        </c:if>

        <h1 class="mb-4">My Reservations</h1>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                ${error}
            </div>
        </c:if>

        <div class="mb-3">
            <a href="search" class="btn btn-primary">
                <i class="fas fa-search"></i> Book New Trip
            </a>
        </div>

        <c:choose>
            <c:when test="${not empty reservations}">
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Your Booking History</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Reservation #</th>
                                                <th>Booked On</th>
                                                <th>Transit Line</th>
                                                <th>Train #</th>
                                                <th>Route</th>
                                                <th>Departure</th>
                                                <th>Passenger</th>
                                                <th>Trip Type</th>
                                                <th>Fare</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="reservation" items="${reservations}">
                                                <tr>
                                                    <td><strong>#${reservation.reservationId}</strong></td>
                                                    <td>
                                                        <fmt:formatDate value="${reservation.dateMade}" pattern="MMM dd, yyyy"/>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-info text-dark">${reservation.line}</span>
                                                    </td>
                                                    <td><strong>#${reservation.trainId}</strong></td>
                                                    <td>
                                                        <small class="text-muted">${reservation.originStation}</small><br>
                                                        <i class="fas fa-arrow-down text-primary"></i><br>
                                                        <small class="text-muted">${reservation.destStation}</small>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${reservation.departureDate}" pattern="MMM dd, yyyy"/><br>
                                                        <small class="text-muted">at ${reservation.departureTime}</small>
                                                    </td>
                                                    <td>${reservation.passenger}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${reservation.tripType == 'round-trip'}">
                                                                <span class="badge bg-warning text-dark">Round Trip</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">One Way</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <strong>$<fmt:formatNumber value="${reservation.totalFare}" pattern="0.00"/></strong>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <button type="button" class="btn btn-sm btn-outline-info" 
                                                                    onclick="showReservationDetails(${reservation.reservationId})">
                                                                Details
                                                            </button>
                                                                <button type="button" class="btn btn-sm btn-outline-danger" 
                                                                        onclick="cancelReservation(${reservation.reservationId})">
                                                                    Cancel
                                                                </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                
                                <div class="mt-3">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <p class="text-muted mb-0">
                                                <strong>Total Reservations:</strong> ${fn:length(reservations)}
                                            </p>
                                        </div>
                                        <div class="col-md-6 text-end">
                                            <c:set var="totalSpent" value="0" />
                                            <c:forEach var="reservation" items="${reservations}">
                                                <c:set var="totalSpent" value="${totalSpent + reservation.totalFare}" />
                                            </c:forEach>
                                            <p class="text-muted mb-0">
                                                <strong>Total Spent:</strong> $<fmt:formatNumber value="${totalSpent}" pattern="0.00"/>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <div class="col-md-8 mx-auto">
                        <div class="card text-center">
                            <div class="card-body">
                                <i class="fas fa-ticket-alt fa-3x text-muted mb-3"></i>
                                <h5 class="card-title">No Reservations Found</h5>
                                <p class="card-text text-muted">
                                    You haven't made any train reservations yet. Start by searching for available trains and book your first trip!
                                </p>
                                <a href="search" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Search Trains
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="modal fade" id="reservationModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Reservation Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="reservationDetails">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="cancelModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Cancel Reservation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to cancel this reservation?</p>
                    <p class="text-warning"><small>This action cannot be undone.</small></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Keep Reservation</button>
                    <form method="post" action="reservations" style="display: inline;">
                        <input type="hidden" name="action" value="cancel">
                        <input type="hidden" name="reservationId" id="cancelReservationId">
                        <button type="submit" class="btn btn-danger">Yes, Cancel Reservation</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function showReservationDetails(reservationId) {
            document.getElementById('reservationDetails').innerHTML = 
                '<p><strong>Reservation ID:</strong> #' + reservationId + '</p>' +
                '<p>Complete reservation details are shown in the table above.</p>';
            new bootstrap.Modal(document.getElementById('reservationModal')).show();
        }
        
        function cancelReservation(reservationId) {
            document.getElementById('cancelReservationId').value = reservationId;
            new bootstrap.Modal(document.getElementById('cancelModal')).show();
        }
    </script>
</body>
</html> 