package com.railway.servlet.admin;

import com.railway.dao.EmployeeDAO;
import com.railway.model.Employee;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class EmployeeManagementServlet extends HttpServlet {
    
    private EmployeeDAO employeeDAO;
    
    @Override
    public void init() throws ServletException {
        employeeDAO = new EmployeeDAO();
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
                String ssn = request.getParameter("ssn");
                Employee employee = employeeDAO.findBySSN(ssn);
                if (employee != null) {
                    request.setAttribute("employee", employee);
                    request.setAttribute("editMode", true);
                }
            } else if ("delete".equals(action)) {
                String ssn = request.getParameter("ssn");
                if (employeeDAO.deleteEmployee(ssn)) {
                    session.setAttribute("success", "Employee deleted successfully");
                } else {
                    request.setAttribute("error", "Failed to delete employee");
                }
                response.sendRedirect(request.getContextPath() + "/admin/employees");
                return;
            }
            
            List<Employee> employees = employeeDAO.getAllEmployees();
            request.setAttribute("employees", employees);
            
            String success = (String) session.getAttribute("success");
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("success");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/admin/employees.jsp").forward(request, response);
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
                String ssn = request.getParameter("ssn");
                String empUser = request.getParameter("empUser");
                String empPass = request.getParameter("empPass");
                String empFirst = request.getParameter("empFirst");
                String empLast = request.getParameter("empLast");
                
                if (employeeDAO.ssnExists(ssn)) {
                    request.setAttribute("error", "SSN already exists");
                } else if (employeeDAO.empUserExists(empUser)) {
                    request.setAttribute("error", "Username already exists");
                } else {
                    Employee employee = new Employee(ssn, empUser, empPass, empFirst, empLast);
                    
                    if (employeeDAO.createEmployee(employee)) {
                        session.setAttribute("success", "Employee added successfully");
                    } else {
                        request.setAttribute("error", "Failed to add employee");
                    }
                }
                
            } else if ("update".equals(action)) {
                String ssn = request.getParameter("ssn");
                String empUser = request.getParameter("empUser");
                String empPass = request.getParameter("empPass");
                String empFirst = request.getParameter("empFirst");
                String empLast = request.getParameter("empLast");
                
                Employee existingByUser = employeeDAO.findByUsername(empUser);
                if (existingByUser != null && !existingByUser.getSsn().equals(ssn)) {
                    request.setAttribute("error", "Username already exists for another employee");
                } else {
                    Employee employee = new Employee(ssn, empUser, empPass, empFirst, empLast);
                    
                    if (employeeDAO.updateEmployee(employee)) {
                        session.setAttribute("success", "Employee updated successfully");
                    } else {
                        request.setAttribute("error", "Failed to update employee");
                    }
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }
} 