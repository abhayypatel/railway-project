package com.railway.dao;

import com.railway.model.CustomerQuestion;
import com.railway.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerQuestionDAO {

    public boolean submitQuestion(CustomerQuestion question) throws SQLException {
        String sql = "INSERT INTO CUSTOMER_QUESTIONS (username, question, question_date) VALUES (?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, question.getUsername());
            stmt.setString(2, question.getQuestion());
            stmt.setTimestamp(3, question.getQuestionDate());
            
            return stmt.executeUpdate() > 0;
        }
    }

    public List<CustomerQuestion> getQuestionsByUsername(String username) throws SQLException {
        List<CustomerQuestion> questions = new ArrayList<>();
        String sql = "SELECT * FROM CUSTOMER_QUESTIONS WHERE username = ? ORDER BY question_date DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    questions.add(mapResultSetToCustomerQuestion(rs));
                }
            }
        }
        return questions;
    }

    public List<CustomerQuestion> getUnansweredQuestions() throws SQLException {
        List<CustomerQuestion> questions = new ArrayList<>();
        String sql = "SELECT * FROM CUSTOMER_QUESTIONS WHERE answer IS NULL ORDER BY question_date ASC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                questions.add(mapResultSetToCustomerQuestion(rs));
            }
        }
        return questions;
    }

    public List<CustomerQuestion> getAllQuestions() throws SQLException {
        List<CustomerQuestion> questions = new ArrayList<>();
        String sql = "SELECT * FROM CUSTOMER_QUESTIONS ORDER BY question_date DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                questions.add(mapResultSetToCustomerQuestion(rs));
            }
        }
        return questions;
    }

    public boolean answerQuestion(int questionId, String answer, String answeredBy) throws SQLException {
        String sql = "UPDATE CUSTOMER_QUESTIONS SET answer = ?, answer_date = ?, answered_by = ? WHERE question_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, answer);
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            stmt.setString(3, answeredBy);
            stmt.setInt(4, questionId);
            
            return stmt.executeUpdate() > 0;
        }
    }

    public CustomerQuestion getQuestionById(int questionId) throws SQLException {
        String sql = "SELECT * FROM CUSTOMER_QUESTIONS WHERE question_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, questionId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomerQuestion(rs);
                }
            }
        }
        return null;
    }

    public boolean deleteQuestion(int questionId) throws SQLException {
        String sql = "DELETE FROM CUSTOMER_QUESTIONS WHERE question_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, questionId);
            
            return stmt.executeUpdate() > 0;
        }
    }

    public int getTotalQuestionCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM CUSTOMER_QUESTIONS";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getAnsweredQuestionCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM CUSTOMER_QUESTIONS WHERE answer IS NOT NULL";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    private CustomerQuestion mapResultSetToCustomerQuestion(ResultSet rs) throws SQLException {
        return new CustomerQuestion(
            rs.getInt("question_id"),
            rs.getString("username"),
            rs.getString("question"),
            rs.getString("answer"),
            rs.getTimestamp("question_date"),
            rs.getTimestamp("answer_date"),
            rs.getString("answered_by")
        );
    }
} 