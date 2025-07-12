package com.railway.servlet.rep;

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

public class CustomerServiceServlet extends HttpServlet {
    
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
        String empSSN = (String) session.getAttribute("ssn");
        
        if (!"EMP_REP".equals(userType) && !"ADMIN".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String view = request.getParameter("view");
        if (view == null) view = "all";
        
        try {
            List<CustomerQuestion> questions;
            
            if ("unanswered".equals(view)) {
                questions = questionDAO.getUnansweredQuestions();
                request.setAttribute("currentView", "unanswered");
            } else {
                questions = questionDAO.getAllQuestions();
                request.setAttribute("currentView", "all");
            }
            
            request.setAttribute("questions", questions);
            
            String success = (String) session.getAttribute("success");
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("success");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading questions: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/rep/customer-service.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("answer".equals(action)) {
            handleAnswerQuestion(request, response);
        } else {
            doGet(request, response);
        }
    }
    
    private void handleAnswerQuestion(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("userType");
        String empSSN = (String) session.getAttribute("ssn");
        
        if (!"EMP_REP".equals(userType) && !"ADMIN".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String questionIdStr = request.getParameter("questionId");
        String answer = request.getParameter("answer");
        
        if (questionIdStr == null || answer == null || answer.trim().isEmpty()) {
            request.setAttribute("error", "Please provide a valid answer");
            doGet(request, response);
            return;
        }
        
        try {
            int questionId = Integer.parseInt(questionIdStr);
            
            if (questionDAO.answerQuestion(questionId, answer.trim(), empSSN)) {
                session.setAttribute("success", "Question answered successfully!");
                response.sendRedirect(request.getContextPath() + "/rep/customer-service");
            } else {
                request.setAttribute("error", "Failed to answer question. Please try again.");
                doGet(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid question ID");
            doGet(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error answering question: " + e.getMessage());
            doGet(request, response);
        }
    }
} 