package com.railway.dao;

import com.railway.model.Customer;
import com.railway.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    public Customer findByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM CUSTOMER WHERE username = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomer(rs);
                }
            }
        }
        return null;
    }

    public Customer authenticate(String username, String password) throws SQLException {
        String sql = "SELECT * FROM CUSTOMER WHERE username = ? AND password = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomer(rs);
                }
            }
        }
        return null;
    }

    public boolean createCustomer(Customer customer) throws SQLException {
        String sql = "INSERT INTO CUSTOMER (username, first_name, last_name, email, password) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, customer.getUsername());
            stmt.setString(2, customer.getFirstName());
            stmt.setString(3, customer.getLastName());
            stmt.setString(4, customer.getEmail());
            stmt.setString(5, customer.getPassword());
            
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateCustomer(Customer customer) throws SQLException {
        String sql = "UPDATE CUSTOMER SET first_name = ?, last_name = ?, email = ? WHERE username = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, customer.getFirstName());
            stmt.setString(2, customer.getLastName());
            stmt.setString(3, customer.getEmail());
            stmt.setString(4, customer.getUsername());
            
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Customer> getAllCustomers() throws SQLException {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM CUSTOMER ORDER BY last_name, first_name";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                customers.add(mapResultSetToCustomer(rs));
            }
        }
        return customers;
    }

    public boolean usernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM CUSTOMER WHERE username = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM CUSTOMER WHERE email = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
    
    private Customer mapResultSetToCustomer(ResultSet rs) throws SQLException {
        return new Customer(
            rs.getString("username"),
            rs.getString("first_name"),
            rs.getString("last_name"),
            rs.getString("email"),
            rs.getString("password")
        );
    }
} 