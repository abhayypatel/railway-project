package com.railway.servlet;

import com.railway.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TestDBServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Database Connection Test</title></head><body>");
        out.println("<h1>Railway Database Connection Test</h1>");
        
        out.println("<h2>Test 1: Basic Connection Test</h2>");
        if (DBUtil.testConnection()) {
            out.println("<p style='color: green;'>Database connection successful</p>");
        } else {
            out.println("<p style='color: red;'>Database connection failed!</p>");
        }
        
        out.println("<h2>Test 2: Query Execution Test</h2>");
        testQueryExecution(out);
        
        out.println("<h2>Test 3: Connection Pool Test</h2>");
        testConnectionPool(out);
        
        out.println("<br><a href='" + request.getContextPath() + "/'>Back to Home</a>");
        out.println("</body></html>");
    }
    
    private void testQueryExecution(PrintWriter out) {
        try (Connection conn = DBUtil.getConnection()) {
            if (conn != null && conn.isValid(5)) {
                out.println("<p style='color: green;'>✓ Connection obtained successfully</p>");
                
                String sql = "SELECT COUNT(*) as count FROM CUSTOMER";
                try (PreparedStatement stmt = conn.prepareStatement(sql);
                     ResultSet rs = stmt.executeQuery()) {
                    
                    if (rs.next()) {
                        int count = rs.getInt("count");
                        out.println("<p style='color: green;'>Query executed successfully. Customer count: " + count + "</p>");
                    }
                }
            } else {
                out.println("<p style='color: red;'>Invalid connection obtained</p>");
            }
        } catch (SQLException e) {
            out.println("<p style='color: red;'>Query execution failed: " + e.getMessage() + "</p>");
        }
    }
    
    private void testConnectionPool(PrintWriter out) {
        int successCount = 0;
        int totalTests = 5;
        
        out.println("<p>Testing " + totalTests + " simultaneous connections...</p>");
        
        for (int i = 1; i <= totalTests; i++) {
            try (Connection conn = DBUtil.getConnection()) {
                if (conn != null && conn.isValid(5)) {
                    successCount++;
                    out.println("<p style='color: green;'>Connection " + i + " successful</p>");
                } else {
                    out.println("<p style='color: red;'>Connection " + i + " invalid</p>");
                }
            } catch (SQLException e) {
                out.println("<p style='color: red;'>Connection " + i + " failed: " + e.getMessage() + "</p>");
            }
        }
        
        out.println("<p><strong>Connection Test Results: " + successCount + "/" + totalTests + " successful</strong></p>");
    }
} 