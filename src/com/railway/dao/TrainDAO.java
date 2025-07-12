package com.railway.dao;

import com.railway.model.Train;
import com.railway.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TrainDAO {

    public List<Train> getAllTrains() throws SQLException {
        List<Train> trains = new ArrayList<>();
        String sql = "SELECT train_id, type, seats FROM TRAIN ORDER BY train_id";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Train train = new Train();
                train.setTrainId(rs.getInt("train_id"));
                train.setType(rs.getString("type"));
                train.setSeats(rs.getInt("seats"));
                trains.add(train);
            }
        }
        return trains;
    }

    public List<Integer> getAvailableTrainIds() throws SQLException {
        List<Integer> trainIds = new ArrayList<>();
        String sql = "SELECT train_id FROM TRAIN ORDER BY train_id";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                trainIds.add(rs.getInt("train_id"));
            }
        }
        return trainIds;
    }

    public boolean trainExists(int trainId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM TRAIN WHERE train_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, trainId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public Train getTrainById(int trainId) throws SQLException {
        String sql = "SELECT train_id, type, seats FROM TRAIN WHERE train_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, trainId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Train train = new Train();
                    train.setTrainId(rs.getInt("train_id"));
                    train.setType(rs.getString("type"));
                    train.setSeats(rs.getInt("seats"));
                    return train;
                }
            }
        }
        return null;
    }
} 