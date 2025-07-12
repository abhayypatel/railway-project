package com.railway.servlet.customer;

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

public class CustomerQuestionServlet extends HttpServlet {
    
    private CustomerQuestionDAO questionDAO;
    
    @Override
    public void init() throws ServletException {
        questionDAO = new CustomerQuestionDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        
        if (username == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            List<CustomerQuestion> questions = questionDAO.getQuestionsByUsername(username);
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
        
        request.getRequestDispatcher("/customer/questions.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("submit".equals(action)) {
            handleSubmitQuestion(request, response);
        } else {
            doGet(request, response);
        }
    }
    
    private void handleSubmitQuestion(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String questionText = request.getParameter("question");
        
        if (username == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        if (questionText == null || questionText.trim().isEmpty()) {
            request.setAttribute("error", "Please enter your question");
            doGet(request, response);
            return;
        }
        
        try {
            CustomerQuestion question = new CustomerQuestion(username, questionText.trim());
            
            if (questionDAO.submitQuestion(question)) {
                session.setAttribute("success", "Your question has been submitted.");
                response.sendRedirect(request.getContextPath() + "/customer/questions");
            } else {
                request.setAttribute("error", "Failed to submit question. Please try again.");
                doGet(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error submitting question: " + e.getMessage());
            doGet(request, response);
        }
    }
} 