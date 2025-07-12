package com.railway.dao;

import com.railway.model.TrainSchedule;
import com.railway.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TrainScheduleDAO {

    public List<TrainSchedule> getAllSchedules() throws SQLException {
        List<TrainSchedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM TRAIN_SCHEDULE ORDER BY line, dept_time";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                schedules.add(mapResultSetToTrainSchedule(rs));
            }
        }
        return schedules;
    }

    public TrainSchedule findByLine(String line) throws SQLException {
        String sql = "SELECT * FROM TRAIN_SCHEDULE WHERE line = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, line);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTrainSchedule(rs);
                }
            }
        }
        return null;
    }

    public List<TrainSchedule> searchSchedules(String origin, String destination) throws SQLException {
        List<TrainSchedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM TRAIN_SCHEDULE WHERE origin = ? AND dest = ? ORDER BY dept_time";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, origin);
            stmt.setString(2, destination);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    schedules.add(mapResultSetToTrainSchedule(rs));
                }
            }
        }
        return schedules;
    }

    public List<TrainSchedule> searchSchedulesWithStops(String origin, String destination) throws SQLException {
        List<TrainSchedule> schedules = new ArrayList<>();
        
        String directSql = "SELECT * FROM TRAIN_SCHEDULE WHERE origin = ? AND dest = ? ORDER BY dept_time";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(directSql)) {
            
            stmt.setString(1, origin);
            stmt.setString(2, destination);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    schedules.add(mapResultSetToTrainSchedule(rs));
                }
            }
        }
        
        String stopsSql = "SELECT DISTINCT ts.* FROM TRAIN_SCHEDULE ts " +
                         "JOIN SCHEDULE_STATION ss1 ON ts.line = ss1.line " +
                         "JOIN SCHEDULE_STATION ss2 ON ts.line = ss2.line " +
                         "JOIN STATION st1 ON ss1.stat_id = st1.stat_id " +
                         "JOIN STATION st2 ON ss2.stat_id = st2.stat_id " +
                         "WHERE st1.stat_name = ? AND st2.stat_name = ? AND ss1.stop_seq < ss2.stop_seq " +
                         "ORDER BY ts.dept_time";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(stopsSql)) {
            
            stmt.setString(1, origin);
            stmt.setString(2, destination);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    TrainSchedule schedule = mapResultSetToTrainSchedule(rs);
                    boolean isDuplicate = false;
                    for (TrainSchedule existing : schedules) {
                        if (existing.getLine().equals(schedule.getLine())) {
                            isDuplicate = true;
                            break;
                        }
                    }
                    if (!isDuplicate) {
                        schedules.add(schedule);
                    }
                }
            }
        }
        
        return schedules;
    }

    public List<TrainSchedule> getSchedulesByStation(String stationName) throws SQLException {
        List<TrainSchedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM TRAIN_SCHEDULE WHERE origin = ? OR dest = ? ORDER BY dept_time";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, stationName);
            stmt.setString(2, stationName);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    schedules.add(mapResultSetToTrainSchedule(rs));
                }
            }
        }
        return schedules;
    }

    public boolean createSchedule(TrainSchedule schedule) throws SQLException {
        String sql = "INSERT INTO TRAIN_SCHEDULE (line, train_id, origin, dest, stops, dept_time, arrival_time, travel_time, fare) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, schedule.getLine());
            stmt.setInt(2, schedule.getTrainId());
            stmt.setString(3, schedule.getOrigin());
            stmt.setString(4, schedule.getDest());
            stmt.setInt(5, schedule.getStops());
            stmt.setTime(6, schedule.getDeptTime());
            stmt.setTime(7, schedule.getArrivalTime());
            stmt.setInt(8, schedule.getTravelTime());
            stmt.setBigDecimal(9, schedule.getFare());
            
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateSchedule(TrainSchedule schedule) throws SQLException {
        String sql = "UPDATE TRAIN_SCHEDULE SET train_id = ?, origin = ?, dest = ?, stops = ?, dept_time = ?, arrival_time = ?, travel_time = ?, fare = ? WHERE line = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, schedule.getTrainId());
            stmt.setString(2, schedule.getOrigin());
            stmt.setString(3, schedule.getDest());
            stmt.setInt(4, schedule.getStops());
            stmt.setTime(5, schedule.getDeptTime());
            stmt.setTime(6, schedule.getArrivalTime());
            stmt.setInt(7, schedule.getTravelTime());
            stmt.setBigDecimal(8, schedule.getFare());
            stmt.setString(9, schedule.getLine());
            
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteSchedule(String line) throws SQLException {
        String sql = "DELETE FROM TRAIN_SCHEDULE WHERE line = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, line);
            
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean lineExists(String line) throws SQLException {
        String sql = "SELECT COUNT(*) FROM TRAIN_SCHEDULE WHERE line = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, line);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public int getTotalScheduleCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM TRAIN_SCHEDULE";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    private TrainSchedule mapResultSetToTrainSchedule(ResultSet rs) throws SQLException {
        return new TrainSchedule(
            rs.getString("line"),
            rs.getInt("train_id"),
            rs.getString("origin"),
            rs.getString("dest"),
            rs.getInt("stops"),
            rs.getTime("dept_time"),
            rs.getTime("arrival_time"),
            rs.getInt("travel_time"),
            rs.getBigDecimal("fare")
        );
    }
} 