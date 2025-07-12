package com.railway.servlet.rep;

import com.railway.dao.TrainScheduleDAO;
import com.railway.dao.TrainDAO;
import com.railway.model.TrainSchedule;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Time;
import java.util.List;

public class RepScheduleServlet extends HttpServlet {
    
    private TrainScheduleDAO scheduleDAO;
    private TrainDAO trainDAO;
    
    @Override
    public void init() throws ServletException {
        scheduleDAO = new TrainScheduleDAO();
        trainDAO = new TrainDAO();
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
            List<TrainSchedule> schedules = scheduleDAO.getAllSchedules();
            request.setAttribute("schedules", schedules);
            
            String successMessage = (String) session.getAttribute("schedule_success");
            String errorMessage = (String) session.getAttribute("schedule_error");
            
            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                session.removeAttribute("schedule_success");
            }
            
            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                session.removeAttribute("schedule_error");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading schedules: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/rep/schedules.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("userType");
        
        if (!"EMP_REP".equals(userType) && !"ADMIN".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=access_denied");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("update".equals(action)) {
                handleUpdateSchedule(request, session);
            } else if ("delete".equals(action)) {
                handleDeleteSchedule(request, session);
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("schedule_error", "Error processing request: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/rep/schedules");
    }
    
    private void handleUpdateSchedule(HttpServletRequest request, HttpSession session) throws SQLException {
        String line = request.getParameter("line");
        String trainIdStr = request.getParameter("trainId");
        String origin = request.getParameter("origin");
        String dest = request.getParameter("dest");
        String stopsStr = request.getParameter("stops");
        String deptTimeStr = request.getParameter("deptTime");
        String arrivalTimeStr = request.getParameter("arrivalTime");
        String travelTimeStr = request.getParameter("travelTime");
        String fareStr = request.getParameter("fare");
        
        if (line == null || trainIdStr == null || origin == null || dest == null ||
            stopsStr == null || deptTimeStr == null || arrivalTimeStr == null ||
            travelTimeStr == null || fareStr == null) {
            session.setAttribute("schedule_error", "All fields are required");
            return;
        }
        
        try {
            int trainId = Integer.parseInt(trainIdStr);
            int stops = Integer.parseInt(stopsStr);
            Time deptTime = Time.valueOf(deptTimeStr + ":00");
            Time arrivalTime = Time.valueOf(arrivalTimeStr + ":00");
            int travelTime = Integer.parseInt(travelTimeStr);
            BigDecimal fare = new BigDecimal(fareStr);
            
            TrainSchedule schedule = new TrainSchedule(line, trainId, origin, dest, stops, 
                                                     deptTime, arrivalTime, travelTime, fare);
            
            boolean updated = scheduleDAO.updateSchedule(schedule);
            
            if (updated) {
                session.setAttribute("schedule_success", "Schedule updated successfully!");
            } else {
                session.setAttribute("schedule_error", "Failed to update schedule");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("schedule_error", "Invalid number format in input fields");
        } catch (IllegalArgumentException e) {
            session.setAttribute("schedule_error", "Invalid time format. Use HH:MM format");
        }
    }
    
    private void handleDeleteSchedule(HttpServletRequest request, HttpSession session) throws SQLException {
        String line = request.getParameter("line");
        
        if (line == null || line.trim().isEmpty()) {
            session.setAttribute("schedule_error", "Schedule line is required");
            return;
        }
        
        boolean deleted = scheduleDAO.deleteSchedule(line.trim());
        
        if (deleted) {
            session.setAttribute("schedule_success", "Schedule deleted successfully!");
        } else {
            session.setAttribute("schedule_error", "Failed to delete schedule");
        }
    }
} 