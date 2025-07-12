<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Railway Project System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-lg mt-5">
                    <div class="card-header bg-success text-white text-center">
                        <h3 class="mb-0">Create Account</h3>
                        <p class="mb-0">Join our railway project system</p>
                    </div>
                    <div class="card-body p-4">
                        
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                ${error}
                            </div>
                        </c:if>
                        
                        <form method="post" action="register">
                            <div class="mb-3">
                                <label for="username" class="form-label">Username:</label>
                                <input type="text" class="form-control" id="username" name="username" 
                                       value="${param.username}" required>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="firstName" class="form-label">First Name:</label>
                                    <input type="text" class="form-control" id="firstName" name="firstName" 
                                           value="${param.firstName}" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="lastName" class="form-label">Last Name:</label>
                                    <input type="text" class="form-control" id="lastName" name="lastName" 
                                           value="${param.lastName}" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="email" class="form-label">Email:</label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       value="${param.email}" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="password" class="form-label">Password:</label>
                                <input type="password" class="form-control" id="password" name="password" 
                                       minlength="6" required>
                                <div class="form-text">Password must be at least 6 characters long.</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">Confirm Password:</label>
                                <input type="password" class="form-control" id="confirmPassword" 
                                       name="confirmPassword" minlength="6" required>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-success">Create Account</button>
                            </div>
                        </form>
                        
                        <hr>
                        <div class="text-center">
                            <p class="mb-0">Already have an account? <a href="login">Sign in here</a></p>
                            <p class="mb-0"><a href="./">Back to Home</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.getElementById('confirmPassword').addEventListener('input', function() {
            var password = document.getElementById('password').value;
            var confirmPassword = this.value;
            
            if (password !== confirmPassword) {
                this.setCustomValidity('Passwords do not match');
            } else {
                this.setCustomValidity('');
            }
        });
    </script>
</body>
</html> 