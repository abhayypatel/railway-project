package com.railway.servlet.customer;

import com.railway.dao.TrainScheduleDAO;
import com.railway.dao.StationDAO;
import com.railway.model.TrainSchedule;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class SearchScheduleServlet extends HttpServlet {
    
    private TrainScheduleDAO scheduleDAO;
    private StationDAO stationDAO;
    
    @Override
    public void init() throws ServletException {
        scheduleDAO = new TrainScheduleDAO();
        stationDAO = new StationDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            List<String> stationNames = stationDAO.getStationNames();
            request.setAttribute("stationNames", stationNames);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading stations");
        }
        
        request.getRequestDispatcher("/customer/search.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            System.out.println("SearchScheduleServlet doPost called");
            
            String origin = request.getParameter("origin");
            String destination = request.getParameter("destination");
            
            System.out.println("Origin: " + origin + ", Destination: " + destination);
            
            if (origin == null || destination == null || origin.trim().isEmpty() || destination.trim().isEmpty()) {
                request.setAttribute("error", "Please select both origin and destination");
                doGet(request, response);
                return;
            }
            
            if (origin.equals(destination)) {
                request.setAttribute("error", "Origin and destination cannot be the same");
                doGet(request, response);
                return;
            }
            
            try {
                System.out.println("Searching for schedules...");
                List<TrainSchedule> schedules = scheduleDAO.searchSchedulesWithStops(origin, destination);
                System.out.println("Found " + schedules.size() + " schedules");
                
                request.setAttribute("schedules", schedules);
                request.setAttribute("searchOrigin", origin);
                request.setAttribute("searchDestination", destination);
                
                if (schedules.isEmpty()) {
                    request.setAttribute("message", "No trains found for the selected route");
                }
                
                List<String> stationNames = stationDAO.getStationNames();
                request.setAttribute("stationNames", stationNames);
                
            } catch (SQLException e) {
                System.err.println("SQL Exception in SearchScheduleServlet: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "Error searching schedules: " + e.getMessage());
            }
            
            System.out.println("Forwarding to search.jsp");
            request.getRequestDispatcher("/customer/search.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("General Exception in SearchScheduleServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error: " + e.getMessage());
        }
    }
} 