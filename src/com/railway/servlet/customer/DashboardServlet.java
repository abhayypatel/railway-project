package com.railway.servlet.customer;

import com.railway.dao.ReservationDAO;
import com.railway.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class DashboardServlet extends HttpServlet {
    
    private ReservationDAO reservationDAO;
    
    @Override
    public void init() throws ServletException {
        reservationDAO = new ReservationDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        
        try {
            List<Reservation> recentReservations = reservationDAO.getReservationsByUsername(username);
            request.setAttribute("recentReservations", recentReservations);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading dashboard data");
        }
        
        request.getRequestDispatcher("/customer/dashboard.jsp").forward(request, response);
    }
} 