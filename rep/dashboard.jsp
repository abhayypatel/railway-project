<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Representative Dashboard</title>
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
                        <a class="nav-link active" href="dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="customer-service">Customer Service</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="schedules">Train Schedules</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="reports">Reports</a>
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

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>
                <i class="fas fa-tachometer-alt text-success me-2"></i>Customer Representative Dashboard
            </h1>
            <div class="text-muted">
                <i class="fas fa-calendar me-1"></i>
                <fmt:formatDate value="<%= new java.util.Date() %>" pattern="MMMM yyyy"/>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-warning text-dark">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">Pending Questions</h6>
                                <h3 class="mb-0">${unansweredQuestions}</h3>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-question-circle fa-2x"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer bg-warning border-0">
                        <a href="customer-service?view=unanswered" class="text-dark text-decoration-none">
                            <small>Answer Questions <i class="fas fa-arrow-right"></i></small>
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-info text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">Total Questions</h6>
                                <h3 class="mb-0">${totalQuestions}</h3>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-comments fa-2x"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer bg-info border-0">
                        <a href="customer-service" class="text-white text-decoration-none">
                            <small>View All <i class="fas fa-arrow-right"></i></small>
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-primary text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">Train Schedules</h6>
                                <h3 class="mb-0">${totalSchedules}</h3>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-train fa-2x"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer bg-primary border-0">
                        <a href="schedules" class="text-white text-decoration-none">
                            <small>Manage Schedules <i class="fas fa-arrow-right"></i></small>
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">Total Reservations</h6>
                                <h3 class="mb-0">${totalReservations}</h3>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-ticket-alt fa-2x"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer bg-success border-0">
                        <a href="reports" class="text-white text-decoration-none">
                            <small>View Reports <i class="fas fa-arrow-right"></i></small>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-tools me-2"></i>Representative Functions
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="card h-100 border-warning">
                                    <div class="card-body text-center">
                                        <i class="fas fa-headset fa-3x text-warning mb-3"></i>
                                        <h6 class="card-title">Customer Service</h6>
                                        <p class="card-text">Answer customer questions and provide support</p>
                                        <a href="customer-service" class="btn btn-warning">
                                            <i class="fas fa-comments me-1"></i>Manage Questions
                                        </a>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <div class="card h-100 border-primary">
                                    <div class="card-body text-center">
                                        <i class="fas fa-calendar-alt fa-3x text-primary mb-3"></i>
                                        <h6 class="card-title">Train Schedules</h6>
                                        <p class="card-text">Edit and manage train schedule information</p>
                                        <a href="schedules" class="btn btn-primary">
                                            <i class="fas fa-train me-1"></i>Manage Schedules
                                        </a>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <div class="card h-100 border-success">
                                    <div class="card-body text-center">
                                        <i class="fas fa-chart-bar fa-3x text-success mb-3"></i>
                                        <h6 class="card-title">Reports & Analytics</h6>
                                        <p class="card-text">Generate customer and reservation reports</p>
                                        <a href="reports" class="btn btn-success">
                                            <i class="fas fa-file-alt me-1"></i>View Reports
                                        </a>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <div class="card h-100 border-info">
                                    <div class="card-body text-center">
                                        <i class="fas fa-map-marker-alt fa-3x text-info mb-3"></i>
                                        <h6 class="card-title">Station Schedules</h6>
                                        <p class="card-text">View schedules by station origin/destination</p>
                                        <a href="reports?type=station-schedules" class="btn btn-info">
                                            <i class="fas fa-list me-1"></i>Station Reports
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 