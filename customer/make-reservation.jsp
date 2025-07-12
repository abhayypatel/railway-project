<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Make Reservation - Railway Project System</title>
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
        <h1 class="mb-4">Make Reservation</h1>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                ${error}
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert alert-success" role="alert">
                ${success}
            </div>
        </c:if>

        <c:if test="${not empty schedule}">
            <div class="row">
                <div class="col-md-8 mx-auto">
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="card-title mb-0">Trip Details</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <h6><strong>Transit Line:</strong></h6>
                                    <p>${schedule.line}</p>
                                    
                                    <h6><strong>Train Number:</strong></h6>
                                    <p>#${schedule.trainId}</p>
                                    
                                    <h6><strong>Route:</strong></h6>
                                    <p>${selectedOrigin} → ${selectedDestination}</p>
                                </div>
                                <div class="col-md-6">
                                    <h6><strong>Departure:</strong></h6>
                                    <p><fmt:formatDate value="${schedule.departureDateTime}" pattern="MMM dd, yyyy"/> at <fmt:formatDate value="${schedule.deptTime}" pattern="HH:mm"/></p>
                                    
                                    <h6><strong>Arrival:</strong></h6>
                                    <p><fmt:formatDate value="${schedule.arrivalDateTime}" pattern="MMM dd, yyyy"/> at <fmt:formatDate value="${schedule.arrivalTime}" pattern="HH:mm"/></p>
                                    
                                    <h6><strong>Travel Time:</strong></h6>
                                    <p>${schedule.travelTime} minutes</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Passenger & Booking Details</h5>
                        </div>
                        <div class="card-body">
                            <form method="post" action="make-reservation">
                                <input type="hidden" name="line" value="${schedule.line}">
                                <input type="hidden" name="origin" value="${selectedOrigin}">
                                <input type="hidden" name="destination" value="${selectedDestination}">
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="passengerName" class="form-label">Passenger Name:</label>
                                        <input type="text" class="form-control" id="passengerName" name="passengerName" 
                                               value="${sessionScope.user.firstName} ${sessionScope.user.lastName}" required>
                                        <small class="form-text text-muted">Full name as it appears on ID</small>
                                    </div>
                                    
                                    <div class="col-md-6 mb-3">
                                        <label for="departureDate" class="form-label">Departure Date:</label>
                                        <input type="date" class="form-control" id="departureDate" name="departureDate" 
                                               value="2025-07-05" required>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="tripType" class="form-label">Trip Type:</label>
                                        <select class="form-select" id="tripType" name="tripType" required onchange="updateFare()">
                                            <option value="">Select trip type</option>
                                            <option value="one-way">One Way</option>
                                            <option value="round-trip">Round Trip (2x fare)</option>
                                        </select>
                                    </div>
                                    
                                    <div class="col-md-6 mb-3">
                                        <label for="passengerType" class="form-label">Passenger Type:</label>
                                        <select class="form-select" id="passengerType" name="passengerType" required onchange="updateFare()">
                                            <option value="">Select passenger type</option>
                                            <option value="adult">Adult (Full Price)</option>
                                            <option value="child">Child (25% discount)</option>
                                            <option value="senior">Senior (35% discount)</option>
                                            <option value="disabled">Disabled (50% discount)</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="card bg-light mb-3">
                                    <div class="card-body">
                                        <h6>Fare Calculation:</h6>
                                        <div class="row text-center">
                                            <div class="col-md-3">
                                                <small class="text-muted">Base Fare:</small><br>
                                                <span id="baseFare">$<fmt:formatNumber value="${schedule.fare}" pattern="0.00"/></span>
                                            </div>
                                            <div class="col-md-3">
                                                <small class="text-muted">Passenger Discount:</small><br>
                                                <span id="discount">None</span>
                                            </div>
                                            <div class="col-md-3">
                                                <small class="text-muted">Trip Type:</small><br>
                                                <span id="tripMultiplier">One Way</span>
                                            </div>
                                            <div class="col-md-3">
                                                <small class="text-muted"><strong>Total Fare:</strong></small><br>
                                                <strong><span id="totalFare">$<fmt:formatNumber value="${schedule.fare}" pattern="0.00"/></span></strong>
                                            </div>
                                        </div>
                                        <div id="calculation-details" class="mt-2 text-center" style="display: none;">
                                            <small class="text-muted">
                                                <span id="calc-step1"></span>
                                                <span id="calc-step2"></span>
                                                <span id="calc-step3"></span>
                                            </small>
                                        </div>
                                    </div>
                                </div>

                                <input type="hidden" id="fareHidden" name="fare" value="${schedule.fare}">

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-success btn-lg">
                                        <i class="fas fa-ticket-alt"></i> Complete Reservation
                                    </button>
                                    <a href="search" class="btn btn-outline-secondary">
                                        <i class="fas fa-arrow-left"></i> Back to Search
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${empty schedule}">
            <div class="row">
                <div class="col-md-8 mx-auto">
                    <div class="card">
                        <div class="card-body text-center">
                            <h5 class="card-title">No Schedule Selected</h5>
                            <p class="card-text">Please select a train schedule from the search results to make a reservation.</p>
                            <a href="search" class="btn btn-primary">Go to Search</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        const baseFareValue = <c:out value="${schedule.fare}" default="0"/>;
        
        function updateFare() {
            const tripType = document.getElementById('tripType').value;
            const passengerType = document.getElementById('passengerType').value;
            
            let fare = baseFareValue;
            let discountedFare = baseFareValue;
            let discountText = 'None';
            let tripMultiplierText = 'One Way';
            
            if (passengerType === 'child') {
                discountedFare = fare * 0.75; 
                discountText = '25% off (Child)';
            } else if (passengerType === 'senior') {
                discountedFare = fare * 0.65; 
                discountText = '35% off (Senior)';
            } else if (passengerType === 'disabled') {
                discountedFare = fare * 0.50;
                discountText = '50% off (Disabled)';
            } else if (passengerType === 'adult') {
                discountedFare = fare;
                discountText = 'None';
            }
            
            let finalFare = discountedFare;
            
            if (tripType === 'round-trip') {
                finalFare = discountedFare * 2;
                tripMultiplierText = 'Round Trip (×2)';
            } else if (tripType === 'one-way') {
                tripMultiplierText = 'One Way (×1)';
            } else {
                tripMultiplierText = 'One Way';
            }
            
            document.getElementById('discount').textContent = discountText;
            document.getElementById('tripMultiplier').textContent = tripMultiplierText;
            document.getElementById('totalFare').textContent = '$' + finalFare.toFixed(2);
            document.getElementById('fareHidden').value = finalFare.toFixed(2);
            
            const calcDetails = document.getElementById('calculation-details');
            const calcStep1 = document.getElementById('calc-step1');
            const calcStep2 = document.getElementById('calc-step2'); 
            const calcStep3 = document.getElementById('calc-step3');
            
            if (tripType && passengerType) {
                calcStep1.textContent = `Base: $${baseFareValue.toFixed(2)}`;
                
                if (discountedFare !== baseFareValue) {
                    calcStep2.textContent = ` → After discount: $${discountedFare.toFixed(2)}`;
                } else {
                    calcStep2.textContent = '';
                }
                
                if (tripType === 'round-trip') {
                    calcStep3.textContent = ` → Round trip: $${finalFare.toFixed(2)}`;
                } else {
                    calcStep3.textContent = '';
                }
                
                calcDetails.style.display = 'block';
            } else {
                calcDetails.style.display = 'none';
            }
        }
    </script>
</body>
</html> 