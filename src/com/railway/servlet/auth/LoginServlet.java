package com.railway.servlet.auth;

import com.railway.dao.CustomerDAO;
import com.railway.dao.EmployeeDAO;
import com.railway.model.Customer;
import com.railway.model.Employee;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

public class LoginServlet extends HttpServlet {
    
    private CustomerDAO customerDAO;
    private EmployeeDAO employeeDAO;
    
    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
        employeeDAO = new EmployeeDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType");
        
        if (username == null || password == null || userType == null) {
            request.setAttribute("error", "Please fill in all fields");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        try {
            HttpSession session = request.getSession();
            
            if ("customer".equals(userType)) {
                Customer customer = customerDAO.authenticate(username, password);
                if (customer != null) {
                    session.setAttribute("user", customer);
                    session.setAttribute("userType", "CUSTOMER");
                    session.setAttribute("username", customer.getUsername());
                    session.setAttribute("fullName", customer.getFullName());
                    response.sendRedirect(request.getContextPath() + "/customer/dashboard");
                } else {
                    request.setAttribute("error", "Invalid username or password");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            } else if ("employee".equals(userType)) {
                Employee employee = employeeDAO.authenticate(username, password);
                if (employee != null && !employee.isAdmin()) {
                    session.setAttribute("user", employee);
                    session.setAttribute("userType", "EMP_REP");
                    session.setAttribute("username", employee.getEmpUser());
                    session.setAttribute("fullName", employee.getFullName());
                    session.setAttribute("ssn", employee.getSsn());
                    
                    response.sendRedirect(request.getContextPath() + "/rep/dashboard");
                } else {
                    request.setAttribute("error", "Invalid username or password");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            } else if ("admin".equals(userType)) {
                Employee employee = employeeDAO.authenticate(username, password);
                if (employee != null && employee.isAdmin()) {
                    session.setAttribute("user", employee);
                    session.setAttribute("userType", "ADMIN");
                    session.setAttribute("username", employee.getEmpUser());
                    session.setAttribute("fullName", employee.getFullName());
                    session.setAttribute("ssn", employee.getSsn());
                    
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    request.setAttribute("error", "Invalid username or password or insufficient privileges");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Invalid user type");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred. Please try again.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
} 