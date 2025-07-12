<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Railway Project System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="../css/style.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="#">Railway Project - Admin Panel</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="dashboard">Dashboard</a>
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
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            Reports
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="reports?type=revenue">Revenue Reports</a></li>
                            <li><a class="dropdown-item" href="reports?type=reservations">Reservation Reports</a></li>
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

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>
                <i class="fas fa-chart-line text-primary me-2"></i>Admin Dashboard
            </h1>
            <div class="text-muted">
                <i class="fas fa-calendar me-1"></i>
                <fmt:formatDate value="<%= new java.util.Date() %>" pattern="MMMM yyyy"/>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>${error}
            </div>
        </c:if>

        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-primary text-white">
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
                    <div class="card-footer bg-primary border-0">
                        <a href="reports?type=reservations" class="text-white text-decoration-none">
                            <small>View Details <i class="fas fa-arrow-right"></i></small>
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">Monthly Revenue</h6>
                                <h3 class="mb-0">$<fmt:formatNumber value="${monthlyRevenue}" pattern="#,##0.00"/></h3>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-dollar-sign fa-2x"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer bg-success border-0">
                        <a href="reports?type=revenue" class="text-white text-decoration-none">
                            <small>View Reports <i class="fas fa-arrow-right"></i></small>
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-info text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">Total Customers</h6>
                                <h3 class="mb-0">${totalCustomers}</h3>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-users fa-2x"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer bg-info border-0">
                        <a href="reports?type=customers" class="text-white text-decoration-none">
                            <small>Customer Reports <i class="fas fa-arrow-right"></i></small>
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-warning text-dark">
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
                    <div class="card-footer bg-warning border-0">
                        <a href="schedules" class="text-dark text-decoration-none">
                            <small>Manage Schedules <i class="fas fa-arrow-right"></i></small>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-bolt me-2"></i>Quick Actions
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <a href="employees" class="btn btn-outline-primary w-100 h-100 d-flex align-items-center">
                                    <div class="text-start">
                                        <i class="fas fa-user-tie fa-2x mb-2"></i><br>
                                        <strong>Employee Management</strong><br>
                                        <small>Add, edit, delete representatives</small>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 mb-3">
                                <a href="schedules" class="btn btn-outline-success w-100 h-100 d-flex align-items-center">
                                    <div class="text-start">
                                        <i class="fas fa-calendar-alt fa-2x mb-2"></i><br>
                                        <strong>Train Schedules</strong><br>
                                        <small>Manage train schedules</small>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 mb-3">
                                <a href="customer-service" class="btn btn-outline-info w-100 h-100 d-flex align-items-center">
                                    <div class="text-start">
                                        <i class="fas fa-headset fa-2x mb-2"></i><br>
                                        <strong>Customer Service</strong><br>
                                        <small>Answer customer questions</small>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 mb-3">
                                <a href="reports" class="btn btn-outline-warning w-100 h-100 d-flex align-items-center">
                                    <div class="text-start">
                                        <i class="fas fa-chart-bar fa-2x mb-2"></i><br>
                                        <strong>Analytics & Reports</strong><br>
                                        <small>View detailed reports</small>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-trophy me-2"></i>Top Performers
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <h6 class="text-primary">
                                <i class="fas fa-crown me-1"></i>Top Revenue Customer
                            </h6>
                            <c:choose>
                                <c:when test="${not empty topCustomer}">
                                    <p class="mb-0"><strong>${topCustomer}</strong></p>
                                    <small class="text-muted">Highest total spending</small>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted mb-0">No data available</p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="mb-3">
                            <h6 class="text-success">
                                <i class="fas fa-route me-1"></i>Most Active Lines
                            </h6>
                            <c:choose>
                                <c:when test="${not empty top5Lines}">
                                    <ul class="list-unstyled mb-0">
                                        <c:forEach var="line" items="${top5Lines}" varStatus="status">
                                            <c:if test="${status.index < 3}">
                                                <li class="small">
                                                    <span class="badge bg-secondary me-1">${status.index + 1}</span>
                                                    ${line}
                                                </li>
                                            </c:if>
                                        </c:forEach>
                                    </ul>
                                    <c:if test="${fn:length(top5Lines) > 3}">
                                        <small class="text-muted">
                                            <a href="reports?type=active-lines">View all top lines...</a>
                                        </small>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted mb-0">No data available</p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div>
                            <h6 class="text-info">
                                <i class="fas fa-database me-1"></i>System Overview
                            </h6>
                            <small class="text-muted">
                                ${totalEmployees} Employees<br>
                                ${totalSchedules} Active Lines<br>
                                ${totalCustomers} Registered Users
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 