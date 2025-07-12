package com.railway.servlet.rep;

import com.railway.dao.ReservationDAO;
import com.railway.dao.TrainScheduleDAO;
import com.railway.model.Reservation;
import com.railway.model.TrainSchedule;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

public class RepReportsServlet extends HttpServlet {
    
    private ReservationDAO reservationDAO;
    private TrainScheduleDAO scheduleDAO;
    
    @Override
    public void init() throws ServletException {
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
        
        String reportType = request.getParameter("type");
        
        try {
            if ("line-reservations".equals(reportType)) {
                handleLineReservationsReport(request);
            } else if ("station-schedules".equals(reportType)) {
                handleStationSchedulesReport(request);
            } else {
                request.setAttribute("showReportOptions", true);
            }
            
            String successMessage = (String) session.getAttribute("reports_success");
            String errorMessage = (String) session.getAttribute("reports_error");
            
            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                session.removeAttribute("reports_success");
            }
            
            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                session.removeAttribute("reports_error");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error generating report: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/rep/reports.jsp").forward(request, response);
    }
    
    private void handleLineReservationsReport(HttpServletRequest request) throws SQLException {
        String line = request.getParameter("line");
        String dateStr = request.getParameter("date");
        
        if (line != null && !line.trim().isEmpty() && dateStr != null && !dateStr.trim().isEmpty()) {
            Date date = Date.valueOf(dateStr);
            List<Reservation> reservations = reservationDAO.getReservationsByLineAndDate(line.trim(), date);
            request.setAttribute("reservations", reservations);
            request.setAttribute("selectedLine", line.trim());
            request.setAttribute("selectedDate", dateStr);
            request.setAttribute("selectedDateFormatted", date);
        }
        
        List<TrainSchedule> schedules = scheduleDAO.getAllSchedules();
        request.setAttribute("schedules", schedules);
        request.setAttribute("reportType", "line-reservations");
    }
    
    private void handleStationSchedulesReport(HttpServletRequest request) throws SQLException {
        String station = request.getParameter("station");
        
        if (station != null && !station.trim().isEmpty()) {
            List<TrainSchedule> schedules = scheduleDAO.getSchedulesByStation(station.trim());
            request.setAttribute("stationSchedules", schedules);
            request.setAttribute("selectedStation", station.trim());
        }
        
        List<TrainSchedule> allSchedules = scheduleDAO.getAllSchedules();
        request.setAttribute("allSchedules", allSchedules);
        request.setAttribute("reportType", "station-schedules");
    }
} 