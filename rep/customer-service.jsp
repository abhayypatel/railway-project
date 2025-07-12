<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Service Management - Railway Project System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="../css/style.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container">
            <a class="navbar-brand" href="#">Railway Project - Customer Rep</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="customer-service">Customer Service</a>
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
                <i class="fas fa-headset text-success me-2"></i>Customer Service Management
            </h1>
            
            <div class="btn-group" role="group">
                <a href="customer-service?view=all" class="btn ${currentView == 'all' ? 'btn-success' : 'btn-outline-success'}">
                    <i class="fas fa-list me-1"></i>All Questions
                </a>
                <a href="customer-service?view=unanswered" class="btn ${currentView == 'unanswered' ? 'btn-warning' : 'btn-outline-warning'}">
                    <i class="fas fa-exclamation-circle me-1"></i>Unanswered Only
                </a>
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
                    <div class="card-body text-center">
                        <i class="fas fa-question-circle fa-2x mb-2"></i>
                        <h5>${fn:length(questions)}</h5>
                        <small>Total Questions</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-warning text-dark">
                    <div class="card-body text-center">
                        <i class="fas fa-clock fa-2x mb-2"></i>
                        <h5>
                            <c:set var="unansweredCount" value="0" />
                            <c:forEach var="q" items="${questions}">
                                <c:if test="${not q.answered}">
                                    <c:set var="unansweredCount" value="${unansweredCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${unansweredCount}
                        </h5>
                        <small>Pending</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body text-center">
                        <i class="fas fa-check-circle fa-2x mb-2"></i>
                        <h5>${fn:length(questions) - unansweredCount}</h5>
                        <small>Answered</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-info text-white">
                    <div class="card-body text-center">
                        <i class="fas fa-percentage fa-2x mb-2"></i>
                        <h5>
                            <c:choose>
                                <c:when test="${fn:length(questions) > 0}">
                                    <fmt:formatNumber value="${((fn:length(questions) - unansweredCount) / fn:length(questions)) * 100}" maxFractionDigits="0"/>%
                                </c:when>
                                <c:otherwise>0%</c:otherwise>
                            </c:choose>
                        </h5>
                        <small>Response Rate</small>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <c:choose>
                    <c:when test="${not empty questions}">
                        <c:forEach var="question" items="${questions}">
                            <div class="card mb-3 ${question.answered ? 'border-success' : 'border-warning'} ${not question.answered ? 'shadow' : ''}">
                                <div class="card-header d-flex justify-content-between align-items-center ${question.answered ? 'bg-light' : 'bg-warning bg-opacity-10'}">
                                    <div>
                                        <strong>Question #${question.questionId}</strong>
                                        <span class="ms-2">
                                            <i class="fas fa-user me-1"></i>
                                            <strong>${question.username}</strong>
                                        </span>
                                        <span class="badge ${question.answered ? 'bg-success' : 'bg-warning text-dark'} ms-2">
                                            <i class="fas ${question.answered ? 'fa-check-circle' : 'fa-clock'} me-1"></i>
                                            ${question.answered ? 'Answered' : 'Pending Response'}
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
                                            <i class="fas fa-comment me-2"></i>Customer Question:
                                        </h6>
                                        <div class="bg-light p-3 rounded">
                                            <p class="mb-0">${question.question}</p>
                                        </div>
                                    </div>
                                    
                                    <c:choose>
                                        <c:when test="${question.answered}">
                                            <div class="mb-3">
                                                <h6 class="text-success">
                                                    <i class="fas fa-reply me-2"></i>Your Response:
                                                </h6>
                                                <div class="bg-success bg-opacity-10 p-3 rounded border-start border-success border-4">
                                                    <p class="mb-2">${question.answer}</p>
                                                    <small class="text-muted">
                                                        <i class="fas fa-clock me-1"></i>
                                                        Answered on <fmt:formatDate value="${question.answerDate}" pattern="MMM dd, yyyy 'at' hh:mm a"/>
                                                    </small>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="mb-3">
                                                <h6 class="text-warning">
                                                    <i class="fas fa-pen me-2"></i>Provide Response:
                                                </h6>
                                                <form method="post" action="customer-service">
                                                    <input type="hidden" name="action" value="answer">
                                                    <input type="hidden" name="questionId" value="${question.questionId}">
                                                    
                                                    <div class="mb-3">
                                                        <textarea class="form-control" name="answer" rows="3" 
                                                                  placeholder="Type your response to help the customer..." required></textarea>
                                                    </div>
                                                    
                                                    <div class="d-flex gap-2">
                                                        <button type="submit" class="btn btn-success">
                                                            <i class="fas fa-paper-plane me-2"></i>Send Response
                                                        </button>
                                                        <button type="button" class="btn btn-outline-secondary" onclick="this.closest('form').querySelector('textarea').value='';">
                                                            <i class="fas fa-eraser me-2"></i>Clear
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="card">
                            <div class="card-body text-center py-5">
                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">
                                    <c:choose>
                                        <c:when test="${currentView == 'unanswered'}">
                                            No Unanswered Questions
                                        </c:when>
                                        <c:otherwise>
                                            No Questions Found
                                        </c:otherwise>
                                    </c:choose>
                                </h5>
                                <p class="text-muted">
                                    <c:choose>
                                        <c:when test="${currentView == 'unanswered'}">
                                            Great job! All customer questions have been answered.
                                        </c:when>
                                        <c:otherwise>
                                            No customers have submitted questions yet.
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <c:if test="${currentView == 'unanswered'}">
                                    <a href="customer-service?view=all" class="btn btn-primary">
                                        <i class="fas fa-list me-2"></i>View All Questions
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 