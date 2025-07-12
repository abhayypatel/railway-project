<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Service - Railway Project System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
                        <a class="nav-link active" href="questions">Customer Service</a>
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

        <h1 class="mb-4">
            <i class="fas fa-question-circle text-primary me-2"></i>Customer Service
        </h1>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>${error}
            </div>
        </c:if>

        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-plus-circle me-2"></i>Ask a Question
                        </h5>
                    </div>
                    <div class="card-body">
                        <form method="post" action="questions">
                            <input type="hidden" name="action" value="submit">
                            
                            <div class="mb-3">
                                <label for="question" class="form-label">Your Question:</label>
                                <textarea class="form-control" id="question" name="question" rows="4" 
                                          placeholder="Please describe your question or issue in detail..." required></textarea>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-paper-plane me-2"></i>Submit Question
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-history me-2"></i>Your Questions & Answers
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty questions}">
                                <div class="row">
                                    <div class="col-12">
                                        <c:forEach var="question" items="${questions}">
                                            <div class="card mb-3 ${question.answered ? 'border-success' : 'border-warning'}">
                                                <div class="card-header d-flex justify-content-between align-items-center">
                                                    <div>
                                                        <strong>Question #${question.questionId}</strong>
                                                        <span class="badge ${question.answered ? 'bg-success' : 'bg-warning text-dark'} ms-2">
                                                            <i class="fas ${question.answered ? 'fa-check-circle' : 'fa-clock'} me-1"></i>
                                                            ${question.answered ? 'Answered' : 'Pending'}
                                                        </span>
                                                    </div>
                                                    <small class="text-muted">
                                                        <i class="fas fa-calendar me-1"></i>
                                                        <fmt:formatDate value="${question.questionDate}" pattern="MMM dd, yyyy 'at' hh:mm a"/>
                                                    </small>
                                                </div>
                                                <div class="card-body">
                                                    <div class="mb-3">
                                                        <h6 class="text-primary">
                                                            <i class="fas fa-user me-2"></i>Your Question:
                                                        </h6>
                                                        <p class="ps-4">${question.question}</p>
                                                    </div>
                                                    
                                                    <c:if test="${question.answered}">
                                                        <div class="bg-light p-3 rounded">
                                                            <h6 class="text-success">
                                                                <i class="fas fa-user-tie me-2"></i>Customer Service Response:
                                                            </h6>
                                                            <p class="ps-4 mb-2">${question.answer}</p>
                                                            <small class="text-muted">
                                                                <i class="fas fa-clock me-1"></i>
                                                                Answered on <fmt:formatDate value="${question.answerDate}" pattern="MMM dd, yyyy 'at' hh:mm a"/>
                                                                by Customer Service Team
                                                            </small>
                                                        </div>
                                                    </c:if>
                                                    
                                                    <c:if test="${not question.answered}">
                                                        <div class="bg-warning bg-opacity-10 p-3 rounded">
                                                            <p class="text-warning mb-0">
                                                                <i class="fas fa-hourglass-half me-2"></i>
                                                                <strong>Awaiting Response</strong> - Our customer service team will respond to your question soon.
                                                            </p>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                                
                                <div class="mt-3 pt-3 border-top">
                                    <div class="row text-center">
                                        <div class="col-md-4">
                                            <div class="text-primary">
                                                <i class="fas fa-question-circle fa-2x mb-2"></i>
                                                <h5>${fn:length(questions)}</h5>
                                                <small class="text-muted">Total Questions</small>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="text-success">
                                                <i class="fas fa-check-circle fa-2x mb-2"></i>
                                                <h5>
                                                    <c:set var="answeredCount" value="0" />
                                                    <c:forEach var="q" items="${questions}">
                                                        <c:if test="${q.answered}">
                                                            <c:set var="answeredCount" value="${answeredCount + 1}" />
                                                        </c:if>
                                                    </c:forEach>
                                                    ${answeredCount}
                                                </h5>
                                                <small class="text-muted">Answered</small>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="text-warning">
                                                <i class="fas fa-clock fa-2x mb-2"></i>
                                                <h5>${fn:length(questions) - answeredCount}</h5>
                                                <small class="text-muted">Pending</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-comments fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">No Questions Yet</h5>
                                    <button type="button" class="btn btn-primary" onclick="document.getElementById('question').focus();">
                                        <i class="fas fa-plus-circle me-2"></i>Ask Your First Question
                                    </button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>


    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 