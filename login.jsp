<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Railway Project System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-lg mt-5">
                    <div class="card-header bg-primary text-white text-center">
                        <h3 class="mb-0">Railway Project System</h3>
                        <p class="mb-0">Please sign in to your account</p>
                    </div>
                    <div class="card-body p-4">
                        
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
                        
                        <c:if test="${param.msg == 'logout'}">
                            <div class="alert alert-info" role="alert">
                                You have been successfully logged out.
                            </div>
                        </c:if>
                        
                        <c:if test="${param.msg == 'please_login'}">
                            <div class="alert alert-warning" role="alert">
                                Please log in to access that page.
                            </div>
                        </c:if>
                        
                        <c:if test="${param.msg == 'access_denied'}">
                            <div class="alert alert-danger" role="alert">
                                Access denied. Please log in with appropriate credentials.
                            </div>
                        </c:if>
                        
                        <form method="post" action="login">
                            <div class="mb-3">
                                <label for="userType" class="form-label">Login as:</label>
                                <select class="form-select" id="userType" name="userType" required>
                                    <option value="">Select user type</option>
                                    <option value="customer">Customer</option>
                                    <option value="employee">Customer Representative</option>
                                    <option value="admin">Manager/Admin</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="username" class="form-label">Username:</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="password" class="form-label">Password:</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">Sign In</button>
                            </div>
                        </form>
                        
                        <hr>
                        <div class="text-center">
                            <p class="mb-0">Don't have an account? <a href="register">Create one here</a></p>
                            <p class="mb-0"><a href="./">Back to Home</a></p>
                        </div>
                        
                        <div class="mt-4">
                            <small class="text-muted">
                                <strong>Demo Credentials:</strong><br>
                                Customer: user1 / password<br>
                                Employee: rep1 / rep123<br>
                                Admin: admin / admin123
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