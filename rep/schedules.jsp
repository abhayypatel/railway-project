<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Train Schedule Management - Customer Rep</title>
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
                        <a class="nav-link active" href="schedules">Train Schedules</a>
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
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>
                <i class="fas fa-train text-success me-2"></i>Train Schedule Management
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

        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">
                    <i class="fas fa-list me-2"></i>Train Schedules - Edit & Delete
                </h5>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty schedules}">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="table-success">
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
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="schedule" items="${schedules}">
                                        <tr>
                                            <td><strong>${schedule.line}</strong></td>
                                            <td>${schedule.trainId}</td>
                                            <td>${schedule.origin}</td>
                                            <td>${schedule.dest}</td>
                                            <td><fmt:formatDate value="${schedule.deptTime}" pattern="HH:mm"/></td>
                                            <td><fmt:formatDate value="${schedule.arrivalTime}" pattern="HH:mm"/></td>
                                            <td>${schedule.travelTime} min</td>
                                            <td>${schedule.stops}</td>
                                            <td>$<fmt:formatNumber value="${schedule.fare}" pattern="#,##0.00"/></td>
                                            <td>
                                                <button type="button" class="btn btn-sm btn-outline-primary me-1" 
                                                        data-bs-toggle="modal" data-bs-target="#editScheduleModal"
                                                        onclick="populateEditForm('${schedule.line}', '${schedule.trainId}', '${schedule.origin}', '${schedule.dest}', '${schedule.deptTime}', '${schedule.arrivalTime}', '${schedule.travelTime}', '${schedule.stops}', '${schedule.fare}')">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                                <button type="button" class="btn btn-sm btn-outline-danger" 
                                                        onclick="confirmDelete('${schedule.line}')">
                                                    <i class="fas fa-trash"></i> Delete
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center text-muted py-4">
                            <i class="fas fa-train fa-3x mb-3"></i>
                            <h5>No schedules found</h5>
                            <p>No train schedules are currently available in the system.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editScheduleModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-edit me-2"></i>Edit Schedule
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="schedules">
                    <input type="hidden" name="action" value="update">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="editLine" class="form-label">Line Name</label>
                                <input type="text" class="form-control" id="editLine" name="line" readonly>
                                <div class="form-text">Line name cannot be changed</div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="editTrainId" class="form-label">Train ID *</label>
                                <select class="form-select" id="editTrainId" name="trainId" required>
                                    <option value="">Select Train</option>
                                    <c:forEach var="train" items="${trains}">
                                        <option value="${train.trainId}">${train.trainId} - ${train.type} (${train.seats} seats)</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="editOrigin" class="form-label">Origin Station *</label>
                                <select class="form-select" id="editOrigin" name="origin" required>
                                    <option value="">Select Origin Station</option>
                                    <c:forEach var="station" items="${stationNames}">
                                        <option value="${station}">${station}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="editDest" class="form-label">Destination Station *</label>
                                <select class="form-select" id="editDest" name="dest" required>
                                    <option value="">Select Destination Station</option>
                                    <c:forEach var="station" items="${stationNames}">
                                        <option value="${station}">${station}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="editDeptTime" class="form-label">Departure Time *</label>
                                <input type="time" class="form-control" id="editDeptTime" name="deptTime" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="editArrivalTime" class="form-label">Arrival Time *</label>
                                <input type="time" class="form-control" id="editArrivalTime" name="arrivalTime" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label for="editTravelTime" class="form-label">Travel Time (minutes) *</label>
                                <input type="number" class="form-control" id="editTravelTime" name="travelTime" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="editStops" class="form-label">Number of Stops *</label>
                                <input type="number" class="form-control" id="editStops" name="stops" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="editFare" class="form-label">Base Fare ($) *</label>
                                <input type="number" step="0.01" class="form-control" id="editFare" name="fare" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-save me-1"></i>Update Schedule
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="deleteConfirmModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-exclamation-triangle text-danger me-2"></i>Confirm Delete
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete the schedule for line <strong id="deleteLineName"></strong>?</p>
                    <p class="text-danger"><strong>Warning:</strong> This action cannot be undone!</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form method="post" action="schedules" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="line" id="deleteLineInput">
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-trash me-1"></i>Delete Schedule
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function populateEditForm(line, trainId, origin, dest, deptTime, arrivalTime, travelTime, stops, fare) {
            document.getElementById('editLine').value = line;
            document.getElementById('editTrainId').value = trainId;
            document.getElementById('editOrigin').value = origin;
            document.getElementById('editDest').value = dest;
            
            if (deptTime) {
                document.getElementById('editDeptTime').value = deptTime.substring(0, 5);
            }
            if (arrivalTime) {
                document.getElementById('editArrivalTime').value = arrivalTime.substring(0, 5);
            }
            
            document.getElementById('editTravelTime').value = travelTime;
            document.getElementById('editStops').value = stops;
            document.getElementById('editFare').value = fare;
        }
        
        function confirmDelete(line) {
            document.getElementById('deleteLineName').textContent = line;
            document.getElementById('deleteLineInput').value = line;
            new bootstrap.Modal(document.getElementById('deleteConfirmModal')).show();
        }
    </script>
</body>
</html> 