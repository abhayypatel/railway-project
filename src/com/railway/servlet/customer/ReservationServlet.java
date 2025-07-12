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

public class ReservationServlet extends HttpServlet {
    
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
        
        if (username == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            List<Reservation> reservations = reservationDAO.getReservationsByUsername(username);
            request.setAttribute("reservations", reservations);
            
            java.sql.Date currentDate = new java.sql.Date(System.currentTimeMillis());
            request.setAttribute("currentDate", currentDate);
            
            String success = (String) session.getAttribute("success");
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("success");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading reservations: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/customer/reservations.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("cancel".equals(action)) {
            handleCancelReservation(request, response);
        } else {
            doGet(request, response);
        }
    }
    
    private void handleCancelReservation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String reservationIdStr = request.getParameter("reservationId");
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        
        if (reservationIdStr == null || username == null) {
            request.setAttribute("error", "Invalid reservation cancellation request");
            doGet(request, response);
            return;
        }
        
        try {
            int reservationId = Integer.parseInt(reservationIdStr);
            
            Reservation reservation = reservationDAO.getReservationByNumber(reservationId);
            if (reservation != null && reservation.getUsername().equals(username)) {
                
                if (reservationDAO.cancelReservation(reservationId, username)) {
                    request.setAttribute("success", "Reservation cancelled successfully");
                } else {
                    request.setAttribute("error", "Failed to cancel reservation");
                }
            } else {
                request.setAttribute("error", "Reservation not found or access denied");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid reservation ID");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error cancelling reservation: " + e.getMessage());
        }
        
        doGet(request, response);
    }
} 