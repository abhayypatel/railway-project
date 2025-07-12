<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Management - Railway Project System</title>
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
                        <a class="nav-link dropdown-toggle active" href="#" role="button" data-bs-toggle="dropdown">
                            Management
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item active" href="employees">Employee Management</a></li>
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
                <i class="fas fa-user-tie text-primary me-2"></i>Employee Management
            </h1>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addEmployeeModal">
                <i class="fas fa-plus me-1"></i>Add New Employee
            </button>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>${error}
            </div>
        </c:if>

        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">
                    <i class="fas fa-list me-2"></i>All Employees
                </h5>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty employees}">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="table-dark">
                                    <tr>
                                        <th>SSN</th>
                                        <th>Username</th>
                                        <th>Full Name</th>
                                        <th>Role</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="employee" items="${employees}">
                                        <tr>
                                            <td>${employee.ssn}</td>
                                            <td><strong>${employee.empUser}</strong></td>
                                            <td>${employee.empFirst} ${employee.empLast}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${employee.admin}">
                                                        <span class="badge bg-danger">Administrator</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-info">Customer Representative</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <button type="button" class="btn btn-sm btn-outline-primary me-1" 
                                                        data-bs-toggle="modal" data-bs-target="#editEmployeeModal"
                                                        onclick="populateEditForm('${employee.ssn}', '${employee.empUser}', '${employee.empFirst}', '${employee.empLast}')">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                                <c:if test="${!employee.admin}">
                                                    <button type="button" class="btn btn-sm btn-outline-danger" 
                                                            onclick="confirmDelete('${employee.ssn}', '${employee.empFirst} ${employee.empLast}')">
                                                        <i class="fas fa-trash"></i> Delete
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center text-muted py-4">
                            <i class="fas fa-user-tie fa-3x mb-3"></i>
                            <h5>No employees found</h5>
                            <p>Click "Add New Employee" to create your first employee record.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addEmployeeModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-plus-circle me-2"></i>Add New Employee
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="employees">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="addSsn" class="form-label">SSN *</label>
                            <input type="text" class="form-control" id="addSsn" name="ssn" required 
                                   placeholder="e.g., 123-45-6789" pattern="[0-9]{3}-[0-9]{2}-[0-9]{4}">
                            <div class="form-text">Format: XXX-XX-XXXX</div>
                        </div>
                        <div class="mb-3">
                            <label for="addEmpUser" class="form-label">Username *</label>
                            <input type="text" class="form-control" id="addEmpUser" name="empUser" required 
                                   placeholder="e.g., rep2">
                        </div>
                        <div class="mb-3">
                            <label for="addEmpPass" class="form-label">Password *</label>
                            <input type="password" class="form-control" id="addEmpPass" name="empPass" required 
                                   placeholder="Enter password">
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="addEmpFirst" class="form-label">First Name *</label>
                                <input type="text" class="form-control" id="addEmpFirst" name="empFirst" required 
                                       placeholder="e.g., Jane">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="addEmpLast" class="form-label">Last Name *</label>
                                <input type="text" class="form-control" id="addEmpLast" name="empLast" required 
                                       placeholder="e.g., Smith">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Add Employee
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editEmployeeModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-edit me-2"></i>Edit Employee
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="employees">
                    <input type="hidden" name="action" value="update">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="editSsn" class="form-label">SSN *</label>
                            <input type="text" class="form-control" id="editSsn" name="ssn" required readonly>
                            <div class="form-text">SSN cannot be changed</div>
                        </div>
                        <div class="mb-3">
                            <label for="editEmpUser" class="form-label">Username *</label>
                            <input type="text" class="form-control" id="editEmpUser" name="empUser" required>
                        </div>
                        <div class="mb-3">
                            <label for="editEmpPass" class="form-label">Password *</label>
                            <input type="password" class="form-control" id="editEmpPass" name="empPass" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="editEmpFirst" class="form-label">First Name *</label>
                                <input type="text" class="form-control" id="editEmpFirst" name="empFirst" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="editEmpLast" class="form-label">Last Name *</label>
                                <input type="text" class="form-control" id="editEmpLast" name="empLast" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Update Employee
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
                    <p>Are you sure you want to delete employee <strong id="deleteEmployeeName"></strong>?</p>
                    <p class="text-danger"><strong>Warning:</strong> This action cannot be undone!</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a href="#" id="deleteConfirmBtn" class="btn btn-danger">
                        <i class="fas fa-trash me-1"></i>Delete Employee
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function populateEditForm(ssn, empUser, empFirst, empLast) {
            document.getElementById('editSsn').value = ssn;
            document.getElementById('editEmpUser').value = empUser;
            document.getElementById('editEmpFirst').value = empFirst;
            document.getElementById('editEmpLast').value = empLast;
            document.getElementById('editEmpPass').value = '';
        }
        
        function confirmDelete(ssn, fullName) {
            document.getElementById('deleteEmployeeName').textContent = fullName;
            document.getElementById('deleteConfirmBtn').href = 'employees?action=delete&ssn=' + encodeURIComponent(ssn);
            new bootstrap.Modal(document.getElementById('deleteConfirmModal')).show();
        }
        
        setTimeout(function() {
            const toast = document.querySelector('.toast');
            if (toast) {
                toast.style.display = 'none';
            }
        }, 5000);
    </script>
</body>
</html> 