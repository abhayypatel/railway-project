package com.railway.dao;

import com.railway.model.Employee;
import com.railway.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {

    public Employee authenticate(String empUser, String empPass) throws SQLException {
        String sql = "SELECT * FROM EMPLOYEE WHERE emp_user = ? AND emp_pass = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, empUser);
            stmt.setString(2, empPass);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEmployee(rs);
                }
            }
        }
        return null;
    }

    public Employee findBySSN(String ssn) throws SQLException {
        String sql = "SELECT * FROM EMPLOYEE WHERE SSN = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, ssn);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEmployee(rs);
                }
            }
        }
        return null;
    }

    public Employee findByUsername(String empUser) throws SQLException {
        String sql = "SELECT * FROM EMPLOYEE WHERE emp_user = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, empUser);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEmployee(rs);
                }
            }
        }
        return null;
    }

    public boolean createEmployee(Employee employee) throws SQLException {
        String sql = "INSERT INTO EMPLOYEE (SSN, emp_user, emp_pass, emp_first, emp_last) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, employee.getSsn());
            stmt.setString(2, employee.getEmpUser());
            stmt.setString(3, employee.getEmpPass());
            stmt.setString(4, employee.getEmpFirst());
            stmt.setString(5, employee.getEmpLast());
            
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateEmployee(Employee employee) throws SQLException {
        String sql = "UPDATE EMPLOYEE SET emp_user = ?, emp_pass = ?, emp_first = ?, emp_last = ? WHERE SSN = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, employee.getEmpUser());
            stmt.setString(2, employee.getEmpPass());
            stmt.setString(3, employee.getEmpFirst());
            stmt.setString(4, employee.getEmpLast());
            stmt.setString(5, employee.getSsn());
            
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteEmployee(String ssn) throws SQLException {
        String sql = "DELETE FROM EMPLOYEE WHERE SSN = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, ssn);
            
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Employee> getAllEmployees() throws SQLException {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT * FROM EMPLOYEE ORDER BY emp_last, emp_first";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                employees.add(mapResultSetToEmployee(rs));
            }
        }
        return employees;
    }

    public boolean ssnExists(String ssn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM EMPLOYEE WHERE SSN = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, ssn);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean empUserExists(String empUser) throws SQLException {
        String sql = "SELECT COUNT(*) FROM EMPLOYEE WHERE emp_user = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, empUser);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
    
    private Employee mapResultSetToEmployee(ResultSet rs) throws SQLException {
        return new Employee(
            rs.getString("SSN"),
            rs.getString("emp_user"),
            rs.getString("emp_pass"),
            rs.getString("emp_first"),
            rs.getString("emp_last")
        );
    }
} 