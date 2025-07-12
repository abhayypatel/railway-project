package com.railway.servlet.customer;

import com.railway.dao.ReservationDAO;
import com.railway.dao.TrainScheduleDAO;
import com.railway.model.Reservation;
import com.railway.model.TrainSchedule;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.sql.SQLException;

public class MakeReservationServlet extends HttpServlet {
    
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
        
        String line = request.getParameter("line");
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        
        if (line == null || origin == null || destination == null) {
            response.sendRedirect(request.getContextPath() + "/customer/search");
            return;
        }
        
        try {
            TrainSchedule schedule = scheduleDAO.findByLine(line);
            if (schedule != null) {
                request.setAttribute("schedule", schedule);
                request.setAttribute("selectedOrigin", origin);
                request.setAttribute("selectedDestination", destination);
            } else {
                request.setAttribute("error", "Schedule not found");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading schedule details");
        }
        
        request.getRequestDispatcher("/customer/make-reservation.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        
        String line = request.getParameter("line");
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String passengerName = request.getParameter("passengerName");
        String departureDate = request.getParameter("departureDate");
        String tripType = request.getParameter("tripType");
        String passengerType = request.getParameter("passengerType");
        String fareStr = request.getParameter("fare");
        
        System.out.println("MakeReservationServlet POST - Line: " + line + ", Origin: " + origin + ", Destination: " + destination);
        System.out.println("Passenger: " + passengerName + ", Date: " + departureDate + ", Trip: " + tripType + ", Type: " + passengerType + ", Fare: " + fareStr);
        
        if (line == null || origin == null || destination == null || 
            passengerName == null || departureDate == null || tripType == null || 
            passengerType == null || fareStr == null) {
            request.setAttribute("error", "Please fill in all fields");
            doGet(request, response);
            return;
        }
        
        try {
            Date depDate = Date.valueOf(departureDate);
            BigDecimal finalFare = new BigDecimal(fareStr);
            
            TrainSchedule schedule = scheduleDAO.findByLine(line);
            if (schedule == null) {
                request.setAttribute("error", "Schedule not found for line: " + line);
                doGet(request, response);
                return;
            }
            
            System.out.println("Using pre-calculated fare from frontend: " + finalFare);
            
            Reservation reservation = new Reservation();
            reservation.setUsername(username);
            reservation.setDateMade(new Date(System.currentTimeMillis()));
            reservation.setDepartureDate(depDate);
            reservation.setDepartureTime(schedule.getDeptTime());
            reservation.setPassenger(passengerName.trim());
            reservation.setTotalFare(finalFare);
            reservation.setLine(line);
            reservation.setTrainId(schedule.getTrainId());
            reservation.setOriginStation(origin);
            reservation.setDestStation(destination);
            reservation.setTripType(tripType);
            
            if (reservationDAO.createReservation(reservation)) {
                System.out.println("Reservation created successfully, redirecting to reservations page");
                session.setAttribute("success", "Reservation added successfully!");
                response.sendRedirect(request.getContextPath() + "/customer/reservations");
            } else {
                System.out.println("Failed to create reservation");
                request.setAttribute("error", "Failed to create reservation");
                doGet(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Error creating reservation: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error creating reservation: " + e.getMessage());
            doGet(request, response);
        }
    }
} 