package com.railway.servlet.admin;

import com.railway.dao.ReservationDAO;
import com.railway.dao.TrainScheduleDAO;
import com.railway.dao.CustomerDAO;
import com.railway.model.Reservation;
import com.railway.model.TrainSchedule;
import com.railway.model.Customer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.ArrayList;
import java.math.BigDecimal;
import java.util.Calendar;

public class ReportsServlet extends HttpServlet {
    
    private ReservationDAO reservationDAO;
    private TrainScheduleDAO scheduleDAO;
    private CustomerDAO customerDAO;
    
    @Override
    public void init() throws ServletException {
        reservationDAO = new ReservationDAO();
        scheduleDAO = new TrainScheduleDAO();
        customerDAO = new CustomerDAO();
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
        
        String reportType = request.getParameter("type");
        
        try {
            if ("reservations-by-line".equals(reportType)) {
                handleReservationsByLineReport(request, response);
            } else if ("schedules-by-station".equals(reportType)) {
                handleSchedulesByStationReport(request, response);
            } else if ("revenue".equals(reportType)) {
                handleRevenueReport(request, response);
            } else if ("customers".equals(reportType)) {
                handleCustomerReport(request, response);
            } else if ("active-lines".equals(reportType)) {
                handleActiveLinesReport(request, response);
            } else {
                handleOverviewReport(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
        }
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
        
        String reportType = request.getParameter("type");
        
        try {
            if ("reservations-by-line".equals(reportType)) {
                String line = request.getParameter("line");
                String dateStr = request.getParameter("date");
                
                if (line != null && !line.trim().isEmpty() && dateStr != null && !dateStr.trim().isEmpty()) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date date = new Date(sdf.parse(dateStr).getTime());
                    
                    List<Reservation> reservations = reservationDAO.getReservationsByLineAndDate(line, date);
                    
                    request.setAttribute("reservations", reservations);
                    request.setAttribute("searchLine", line);
                    request.setAttribute("searchDate", dateStr);
                    request.setAttribute("reportType", "reservations-by-line");
                    request.setAttribute("reportTitle", "Reservations for " + line + " on " + dateStr);
                } else {
                    request.setAttribute("error", "Please provide both line name and date");
                }
                
            } else if ("schedules-by-station".equals(reportType)) {
                String station = request.getParameter("station");
                
                if (station != null && !station.trim().isEmpty()) {
                    List<TrainSchedule> schedules = scheduleDAO.getSchedulesByStation(station);
                    
                    request.setAttribute("schedules", schedules);
                    request.setAttribute("searchStation", station);
                    request.setAttribute("reportType", "schedules-by-station");
                    request.setAttribute("reportTitle", "Train Schedules for " + station + " Station");
                } else {
                    request.setAttribute("error", "Please provide a station name");
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        } catch (ParseException e) {
            request.setAttribute("error", "Invalid date format. Please use YYYY-MM-DD format");
        }
        
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
    
    private void handleReservationsByLineReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("reportType", "reservations-by-line");
        request.setAttribute("reportTitle", "Customer Reservations by Transit Line and Date");
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
    
    private void handleSchedulesByStationReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("reportType", "schedules-by-station");
        request.setAttribute("reportTitle", "Train Schedules by Station");
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
    
    private void handleRevenueReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        Calendar cal = Calendar.getInstance();
        int currentYear = cal.get(Calendar.YEAR);
        
        List<BigDecimal> monthlyRevenues = new ArrayList<>();
        for (int month = 1; month <= 12; month++) {
            BigDecimal revenue = reservationDAO.getMonthlyRevenue(currentYear, month);
            monthlyRevenues.add(revenue);
        }
        
        List<String> topLines = reservationDAO.getTop5ActiveLines();
        List<BigDecimal> lineRevenues = new ArrayList<>();
        for (String line : topLines) {
            BigDecimal revenue = reservationDAO.getRevenueByLine(line);
            lineRevenues.add(revenue);
        }
        
        request.setAttribute("monthlyRevenues", monthlyRevenues);
        request.setAttribute("topLines", topLines);
        request.setAttribute("lineRevenues", lineRevenues);
        request.setAttribute("currentYear", currentYear);
        request.setAttribute("reportType", "revenue");
        request.setAttribute("reportTitle", "Revenue Analytics");
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
    
    private void handleCustomerReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        List<Customer> customers = customerDAO.getAllCustomers();
        String topCustomer = reservationDAO.getTopRevenueCustomer();
        
        List<BigDecimal> customerSpending = new ArrayList<>();
        for (Customer customer : customers) {
            BigDecimal spending = reservationDAO.getRevenueByCustomer(customer.getUsername());
            customerSpending.add(spending);
        }
        
        request.setAttribute("customers", customers);
        request.setAttribute("customerSpending", customerSpending);
        request.setAttribute("topCustomer", topCustomer);
        request.setAttribute("reportType", "customers");
        request.setAttribute("reportTitle", "Customer Analytics");
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
    
    private void handleActiveLinesReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        List<String> topLines = reservationDAO.getTop5ActiveLines();
        List<BigDecimal> lineRevenues = new ArrayList<>();
        for (String line : topLines) {
            BigDecimal revenue = reservationDAO.getRevenueByLine(line);
            lineRevenues.add(revenue);
        }
        
        request.setAttribute("topLines", topLines);
        request.setAttribute("lineRevenues", lineRevenues);
        request.setAttribute("reportType", "active-lines");
        request.setAttribute("reportTitle", "Most Active Transit Lines");
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
    
    private void handleOverviewReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        List<Reservation> allReservations = reservationDAO.getAllReservations();
        List<Customer> allCustomers = customerDAO.getAllCustomers();
        List<TrainSchedule> allSchedules = scheduleDAO.getAllSchedules();
        
        Calendar cal = Calendar.getInstance();
        int currentYear = cal.get(Calendar.YEAR);
        int currentMonth = cal.get(Calendar.MONTH) + 1;
        BigDecimal monthlyRevenue = reservationDAO.getMonthlyRevenue(currentYear, currentMonth);
        
        request.setAttribute("totalReservations", allReservations.size());
        request.setAttribute("totalCustomers", allCustomers.size());
        request.setAttribute("totalSchedules", allSchedules.size());
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("currentMonth", currentMonth);
        request.setAttribute("currentYear", currentYear);
        request.setAttribute("reportType", "overview");
        request.setAttribute("reportTitle", "System Overview");
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
} 