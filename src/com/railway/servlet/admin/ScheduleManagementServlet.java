package com.railway.servlet.admin;

import com.railway.dao.TrainScheduleDAO;
import com.railway.dao.StationDAO;
import com.railway.dao.TrainDAO;
import com.railway.model.TrainSchedule;
import com.railway.model.Train;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

public class ScheduleManagementServlet extends HttpServlet {
    
    private TrainScheduleDAO scheduleDAO;
    private StationDAO stationDAO;
    private TrainDAO trainDAO;
    
    @Override
    public void init() throws ServletException {
        scheduleDAO = new TrainScheduleDAO();
        stationDAO = new StationDAO();
        trainDAO = new TrainDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("userType");
        
        if (!"ADMIN".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login?msg=access_denied");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("edit".equals(action)) {
                String line = request.getParameter("line");
                TrainSchedule schedule = scheduleDAO.findByLine(line);
                if (schedule != null) {
                    request.setAttribute("schedule", schedule);
                    request.setAttribute("editMode", true);
                }
            } else if ("delete".equals(action)) {
                String line = request.getParameter("line");
                            if (scheduleDAO.deleteSchedule(line)) {
                session.setAttribute("schedule_success", "Schedule deleted successfully");
            } else {
                session.setAttribute("schedule_error", "Failed to delete schedule");
            }
                response.sendRedirect(request.getContextPath() + "/admin/schedules");
                return;
            }
            
            List<TrainSchedule> schedules = scheduleDAO.getAllSchedules();
            System.out.println("DEBUG: Retrieved " + schedules.size() + " schedules from database");
            request.setAttribute("schedules", schedules);
            
            List<String> stationNames = stationDAO.getStationNames();
            request.setAttribute("stationNames", stationNames);
            
            List<Train> trains = trainDAO.getAllTrains();
            request.setAttribute("trains", trains);
            
            String success = (String) session.getAttribute("schedule_success");
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("schedule_success");
            }
            
            String error = (String) session.getAttribute("schedule_error");
            if (error != null) {
                request.setAttribute("error", error);
                session.removeAttribute("schedule_error");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/admin/schedules.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("userType");
        
        if (!"ADMIN".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login?msg=access_denied");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                String line = request.getParameter("line");
                String trainIdStr = request.getParameter("trainId");
                String origin = request.getParameter("origin");
                String dest = request.getParameter("dest");
                String stopsStr = request.getParameter("stops");
                String deptTimeStr = request.getParameter("deptTime");
                String arrivalTimeStr = request.getParameter("arrivalTime");
                String travelTimeStr = request.getParameter("travelTime");
                String fareStr = request.getParameter("fare");
                
                if (line == null || line.trim().isEmpty() ||
                    trainIdStr == null || trainIdStr.trim().isEmpty() ||
                    origin == null || origin.trim().isEmpty() ||
                    dest == null || dest.trim().isEmpty() ||
                    stopsStr == null || stopsStr.trim().isEmpty() ||
                    deptTimeStr == null || deptTimeStr.trim().isEmpty() ||
                    arrivalTimeStr == null || arrivalTimeStr.trim().isEmpty() ||
                    travelTimeStr == null || travelTimeStr.trim().isEmpty() ||
                    fareStr == null || fareStr.trim().isEmpty()) {
                    
                    session.setAttribute("schedule_error", "All fields are required");
                    response.sendRedirect(request.getContextPath() + "/admin/schedules");
                    return;
                }
                
                if (scheduleDAO.lineExists(line.trim())) {
                    session.setAttribute("schedule_error", "Line name already exists: " + line);
                    response.sendRedirect(request.getContextPath() + "/admin/schedules");
                    return;
                }
                
                int trainId = Integer.parseInt(trainIdStr);
                
                if (!trainDAO.trainExists(trainId)) {
                    session.setAttribute("schedule_error", "Train ID " + trainId + " does not exist. Available train IDs: 1001, 1002, 1003, 1004, 1005");
                    response.sendRedirect(request.getContextPath() + "/admin/schedules");
                    return;
                }
                int stops = Integer.parseInt(stopsStr);
                Time deptTime = Time.valueOf(deptTimeStr + ":00");
                Time arrivalTime = Time.valueOf(arrivalTimeStr + ":00");
                int travelTime = Integer.parseInt(travelTimeStr);
                BigDecimal fare = new BigDecimal(fareStr);
                
                TrainSchedule schedule = new TrainSchedule(line.trim(), trainId, origin, dest, stops, 
                                                         deptTime, arrivalTime, travelTime, fare);
                
                System.out.println("DEBUG: Attempting to create schedule: " + line.trim());
                boolean created = scheduleDAO.createSchedule(schedule);
                System.out.println("DEBUG: Schedule creation result: " + created);
                
                if (created) {
                    session.setAttribute("schedule_success", "Schedule '" + line.trim() + "' added successfully!");
                    System.out.println("DEBUG: Success message set for: " + line.trim());
                } else {
                    session.setAttribute("schedule_error", "Failed to add schedule. Please try again.");
                    System.out.println("DEBUG: Failed to create schedule: " + line.trim());
                }
                
            } else if ("update".equals(action)) {
                String line = request.getParameter("line");
                int trainId = Integer.parseInt(request.getParameter("trainId"));
                String origin = request.getParameter("origin");
                String dest = request.getParameter("dest");
                int stops = Integer.parseInt(request.getParameter("stops"));
                Time deptTime = Time.valueOf(request.getParameter("deptTime") + ":00");
                Time arrivalTime = Time.valueOf(request.getParameter("arrivalTime") + ":00");
                int travelTime = Integer.parseInt(request.getParameter("travelTime"));
                BigDecimal fare = new BigDecimal(request.getParameter("fare"));
                
                TrainSchedule schedule = new TrainSchedule(line, trainId, origin, dest, stops, 
                                                         deptTime, arrivalTime, travelTime, fare);
                
                if (scheduleDAO.updateSchedule(schedule)) {
                    session.setAttribute("schedule_success", "Schedule updated successfully");
                } else {
                    session.setAttribute("schedule_error", "Failed to update schedule");
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("schedule_error", "Database error: " + e.getMessage());
            System.out.println("DEBUG: SQLException occurred: " + e.getMessage());
        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("schedule_error", "Invalid number format in form data");
            System.out.println("DEBUG: NumberFormatException occurred: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            session.setAttribute("schedule_error", "Invalid time format. Please use HH:MM format");
            System.out.println("DEBUG: IllegalArgumentException occurred: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/schedules");
    }
} 