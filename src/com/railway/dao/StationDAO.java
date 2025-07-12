package com.railway.dao;

import com.railway.model.Station;
import com.railway.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StationDAO {

    public List<Station> getAllStations() throws SQLException {
        List<Station> stations = new ArrayList<>();
        String sql = "SELECT * FROM STATION ORDER BY state, city, stat_name";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                stations.add(mapResultSetToStation(rs));
            }
        }
        return stations;
    }

    public Station findById(int statId) throws SQLException {
        String sql = "SELECT * FROM STATION WHERE stat_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, statId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToStation(rs);
                }
            }
        }
        return null;
    }

    public Station findByName(String statName) throws SQLException {
        String sql = "SELECT * FROM STATION WHERE stat_name = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, statName);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToStation(rs);
                }
            }
        }
        return null;
    }

    public List<Station> findByCity(String city) throws SQLException {
        List<Station> stations = new ArrayList<>();
        String sql = "SELECT * FROM STATION WHERE city = ? ORDER BY stat_name";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, city);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    stations.add(mapResultSetToStation(rs));
                }
            }
        }
        return stations;
    }

    public List<Station> findByState(String state) throws SQLException {
        List<Station> stations = new ArrayList<>();
        String sql = "SELECT * FROM STATION WHERE state = ? ORDER BY city, stat_name";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, state);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    stations.add(mapResultSetToStation(rs));
                }
            }
        }
        return stations;
    }

    public List<Station> searchByName(String searchTerm) throws SQLException {
        List<Station> stations = new ArrayList<>();
        String sql = "SELECT * FROM STATION WHERE stat_name LIKE ? OR city LIKE ? ORDER BY stat_name";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    stations.add(mapResultSetToStation(rs));
                }
            }
        }
        return stations;
    }

    public List<String> getStationNames() throws SQLException {
        List<String> stationNames = new ArrayList<>();
        String sql = "SELECT DISTINCT stat_name FROM STATION ORDER BY stat_name";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                stationNames.add(rs.getString("stat_name"));
            }
        }
        return stationNames;
    }

    public List<String> getCities() throws SQLException {
        List<String> cities = new ArrayList<>();
        String sql = "SELECT DISTINCT city FROM STATION ORDER BY city";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                cities.add(rs.getString("city"));
            }
        }
        return cities;
    }

    public List<String> getStates() throws SQLException {
        List<String> states = new ArrayList<>();
        String sql = "SELECT DISTINCT state FROM STATION ORDER BY state";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                states.add(rs.getString("state"));
            }
        }
        return states;
    }
    
    private Station mapResultSetToStation(ResultSet rs) throws SQLException {
        return new Station(
            rs.getInt("stat_id"),
            rs.getString("stat_name"),
            rs.getString("city"),
            rs.getString("state")
        );
    }
} 