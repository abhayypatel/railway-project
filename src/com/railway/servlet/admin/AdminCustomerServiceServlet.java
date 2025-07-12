package com.railway.servlet.admin;

import com.railway.dao.CustomerQuestionDAO;
import com.railway.model.CustomerQuestion;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class AdminCustomerServiceServlet extends HttpServlet {
    
    private CustomerQuestionDAO questionDAO;
    
    @Override
    public void init() throws ServletException {
        questionDAO = new CustomerQuestionDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("userType");
        
        if (!"ADMIN".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=access_denied");
            return;
        }
        
        try {
            String filter = request.getParameter("filter");
            List<CustomerQuestion> questions;
            
            if ("unanswered".equals(filter)) {
                questions = questionDAO.getUnansweredQuestions();
            } else {
                questions = questionDAO.getAllQuestions();
            }
            
            int totalQuestions = questionDAO.getTotalQuestionCount();
            int answeredQuestions = questionDAO.getAnsweredQuestionCount();
            int unansweredQuestions = totalQuestions - answeredQuestions;
            
            request.setAttribute("questions", questions);
            request.setAttribute("totalQuestions", totalQuestions);
            request.setAttribute("answeredQuestions", answeredQuestions);
            request.setAttribute("unansweredQuestions", unansweredQuestions);
            request.setAttribute("filter", filter);
            
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                session.removeAttribute("successMessage");
            }
            
            request.getRequestDispatcher("/admin/customer-service.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/admin/customer-service.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("userType");
        
        if (!"ADMIN".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=access_denied");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("answer".equals(action)) {
            handleAnswerQuestion(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/customer-service");
        }
    }
    
    private void handleAnswerQuestion(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String adminSSN = (String) session.getAttribute("ssn");
        
        try {
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            String answer = request.getParameter("answer");
            
            if (answer != null && !answer.trim().isEmpty()) {
                boolean success = questionDAO.answerQuestion(questionId, answer.trim(), adminSSN);
                
                if (success) {
                    session.setAttribute("successMessage", "Answer submitted successfully!");
                } else {
                    session.setAttribute("errorMessage", "Failed to submit answer. Please try again.");
                }
            } else {
                session.setAttribute("errorMessage", "Answer cannot be empty.");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid question ID.");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/customer-service");
    }
} 