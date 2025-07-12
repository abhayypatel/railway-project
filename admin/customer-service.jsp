<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Customer Service</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="../css/style.css" rel="stylesheet">
    <style>
        .question-card {
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-bottom: 20px;
            padding: 15px;
        }
        .question-unanswered {
            border-left: 4px solid #ffc107;
        }
        .question-answered {
            border-left: 4px solid #28a745;
        }
        .stats-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
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
                            <li><a class="dropdown-item" href="employees">Employee Management</a></li>
                            <li><a class="dropdown-item" href="schedules">Train Schedules</a></li>
                            <li><a class="dropdown-item active" href="customer-service">Customer Service</a></li>
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
        <div class="row">
            <div class="col-md-12">
                <h1 class="mb-4">
                    <i class="fas fa-headset text-primary me-2"></i>Customer Service Management
                </h1>
                
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <div class="stats-card">
                    <h5>Question Statistics</h5>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="text-center">
                                <h4 class="text-primary">${totalQuestions}</h4>
                                <p>Total Questions</p>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="text-center">
                                <h4 class="text-warning">${unansweredQuestions}</h4>
                                <p>Unanswered</p>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="text-center">
                                <h4 class="text-success">${answeredQuestions}</h4>
                                <p>Answered</p>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="text-center">
                                <h4 class="text-info">
                                    <c:choose>
                                        <c:when test="${totalQuestions > 0}">
                                            <fmt:formatNumber value="${(answeredQuestions / totalQuestions) * 100}" 
                                                            maxFractionDigits="1"/>%
                                        </c:when>
                                        <c:otherwise>0%</c:otherwise>
                                    </c:choose>
                                </h4>
                                <p>Response Rate</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="mb-3">
                    <div class="btn-group" role="group">
                        <a href="customer-service" class="btn ${filter != 'unanswered' ? 'btn-primary' : 'btn-outline-primary'}">
                            All Questions
                        </a>
                        <a href="customer-service?filter=unanswered" class="btn ${filter == 'unanswered' ? 'btn-warning' : 'btn-outline-warning'}">
                            Unanswered Only
                        </a>
                    </div>
                </div>
                
                <c:choose>
                    <c:when test="${not empty questions}">
                        <c:forEach var="question" items="${questions}">
                            <div class="question-card ${question.answered ? 'question-answered' : 'question-unanswered'}">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <h6><strong>Customer:</strong> ${question.username}</h6>
                                        <small class="text-muted">
                                            Asked on: <fmt:formatDate value="${question.questionDate}" pattern="MMM dd, yyyy 'at' hh:mm a"/>
                                        </small>
                                    </div>
                                    <div>
                                        <span class="badge ${question.answered ? 'bg-success' : 'bg-warning text-dark'}">
                                            ${question.answered ? 'Answered' : 'Pending'}
                                        </span>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <strong>Question:</strong>
                                    <p class="mt-2">${question.question}</p>
                                </div>
                                
                                <c:choose>
                                    <c:when test="${question.answered}">
                                        <div class="bg-light p-3 rounded">
                                            <div class="d-flex justify-content-between mb-2">
                                                <strong class="text-success">Admin Response:</strong>
                                                <small class="text-muted">
                                                    by ${question.answeredBy} on 
                                                    <fmt:formatDate value="${question.answerDate}" pattern="MMM dd, yyyy"/>
                                                </small>
                                            </div>
                                            <p class="mb-0">${question.answer}</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <form method="post" action="customer-service">
                                            <input type="hidden" name="action" value="answer">
                                            <input type="hidden" name="questionId" value="${question.questionId}">
                                            <div class="mb-3">
                                                <label class="form-label"><strong>Your Answer:</strong></label>
                                                <textarea class="form-control" name="answer" rows="3" 
                                                        placeholder="Type your response here..." required></textarea>
                                            </div>
                                            <button type="submit" class="btn btn-success">Submit Answer</button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center mt-5">
                            <h5>No questions found</h5>
                            <p class="text-muted">
                                <c:choose>
                                    <c:when test="${filter == 'unanswered'}">
                                        All questions have been answered!
                                    </c:when>
                                    <c:otherwise>
                                        No customer questions have been submitted yet.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 