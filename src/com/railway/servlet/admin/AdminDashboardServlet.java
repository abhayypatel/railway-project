package com.railway.servlet.admin;

import com.railway.dao.ReservationDAO;
import com.railway.dao.CustomerDAO;
import com.railway.dao.EmployeeDAO;
import com.railway.dao.TrainScheduleDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.List;

public class AdminDashboardServlet extends HttpServlet {
    
    private ReservationDAO reservationDAO;
    private CustomerDAO customerDAO;
    private EmployeeDAO employeeDAO;
    private TrainScheduleDAO scheduleDAO;
    
    @Override
    public void init() throws ServletException {
        reservationDAO = new ReservationDAO();
        customerDAO = new CustomerDAO();
        employeeDAO = new EmployeeDAO();
        scheduleDAO = new TrainScheduleDAO();
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
        
        try {
            Calendar cal = Calendar.getInstance();
            int currentYear = cal.get(Calendar.YEAR);
            int currentMonth = cal.get(Calendar.MONTH) + 1;
            
            BigDecimal monthlyRevenue = reservationDAO.getMonthlyRevenue(currentYear, currentMonth);
            String topCustomer = reservationDAO.getTopRevenueCustomer();
            List<String> top5Lines = reservationDAO.getTop5ActiveLines();
            
            int totalReservations = reservationDAO.getAllReservations().size();
            int totalCustomers = customerDAO.getAllCustomers().size();
            int totalEmployees = employeeDAO.getAllEmployees().size();
            int totalSchedules = scheduleDAO.getAllSchedules().size();
            
            request.setAttribute("monthlyRevenue", monthlyRevenue);
            request.setAttribute("topCustomer", topCustomer);
            request.setAttribute("top5Lines", top5Lines);
            request.setAttribute("totalReservations", totalReservations);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("totalEmployees", totalEmployees);
            request.setAttribute("totalSchedules", totalSchedules);
            request.setAttribute("currentMonth", currentMonth);
            request.setAttribute("currentYear", currentYear);
            
            String success = (String) session.getAttribute("success");
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("success");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading dashboard data: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
} 