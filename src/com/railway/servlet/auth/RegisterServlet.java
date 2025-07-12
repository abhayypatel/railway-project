package com.railway.servlet.auth;

import com.railway.dao.CustomerDAO;
import com.railway.model.Customer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

public class RegisterServlet extends HttpServlet {
    
    private CustomerDAO customerDAO;
    
    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (username == null || firstName == null || lastName == null || 
            email == null || password == null || confirmPassword == null) {
            request.setAttribute("error", "Please fill in all fields");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        if (username.trim().isEmpty() || firstName.trim().isEmpty() || 
            lastName.trim().isEmpty() || email.trim().isEmpty() || 
            password.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        if (!email.contains("@") || !email.contains(".")) {
            request.setAttribute("error", "Please enter a valid email address");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        try {
            if (customerDAO.usernameExists(username)) {
                request.setAttribute("error", "Username already exists. Please choose a different one.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            if (customerDAO.emailExists(email)) {
                request.setAttribute("error", "Email already registered. Please use a different email.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            Customer customer = new Customer(username.trim(), firstName.trim(), 
                                           lastName.trim(), email.trim(), password);
            
            if (customerDAO.createCustomer(customer)) {
                request.setAttribute("success", "Registration successful! Please login with your credentials.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
} 