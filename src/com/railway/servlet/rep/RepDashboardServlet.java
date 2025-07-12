package com.railway.servlet.rep;

import com.railway.dao.CustomerQuestionDAO;
import com.railway.dao.ReservationDAO;
import com.railway.dao.TrainScheduleDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

public class RepDashboardServlet extends HttpServlet {
    
    private CustomerQuestionDAO questionDAO;
    private ReservationDAO reservationDAO;
    private TrainScheduleDAO scheduleDAO;
    
    @Override
    public void init() throws ServletException {
        questionDAO = new CustomerQuestionDAO();
        reservationDAO = new ReservationDAO();
        scheduleDAO = new TrainScheduleDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("userType");
        
        if (!"EMP_REP".equals(userType) && !"ADMIN".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=access_denied");
            return;
        }
        
        try {
            int totalQuestions = questionDAO.getTotalQuestionCount();
            int unansweredQuestions = totalQuestions - questionDAO.getAnsweredQuestionCount();
            int totalSchedules = scheduleDAO.getTotalScheduleCount();
            int totalReservations = reservationDAO.getTotalReservationCount();
            
            request.setAttribute("totalQuestions", totalQuestions);
            request.setAttribute("unansweredQuestions", unansweredQuestions);
            request.setAttribute("totalSchedules", totalSchedules);
            request.setAttribute("totalReservations", totalReservations);
            
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");
            
            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                session.removeAttribute("successMessage");
            }
            
            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                session.removeAttribute("errorMessage");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading dashboard data: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/rep/dashboard.jsp").forward(request, response);
    }
} 