package com.railway.dao;

import com.railway.model.Reservation;
import com.railway.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class ReservationDAO {

    public boolean createReservation(Reservation reservation) throws SQLException {
        String sql = "INSERT INTO RESERVATION (username, date_made, departure_date, departure_time, passenger, total_fare, line, train_id, origin_station, dest_station, trip_type) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, reservation.getUsername());
            stmt.setDate(2, reservation.getDateMade());
            stmt.setDate(3, reservation.getDepartureDate());
            stmt.setTime(4, reservation.getDepartureTime());
            stmt.setString(5, reservation.getPassenger());
            stmt.setBigDecimal(6, reservation.getTotalFare());
            stmt.setString(7, reservation.getLine());
            stmt.setInt(8, reservation.getTrainId());
            stmt.setString(9, reservation.getOriginStation());
            stmt.setString(10, reservation.getDestStation());
            stmt.setString(11, reservation.getTripType());
            
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Reservation> getReservationsByUsername(String username) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM RESERVATION WHERE username = ? ORDER BY departure_date DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(mapResultSetToReservation(rs));
                }
            }
        }
        return reservations;
    }

    public Reservation getReservationByNumber(int resNum) throws SQLException {
        String sql = "SELECT * FROM RESERVATION WHERE res_num = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, resNum);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReservation(rs);
                }
            }
        }
        return null;
    }

    public boolean cancelReservation(int resNum, String username) throws SQLException {
        String sql = "DELETE FROM RESERVATION WHERE res_num = ? AND username = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, resNum);
            stmt.setString(2, username);
            
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Reservation> getAllReservations() throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM RESERVATION ORDER BY date_made DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        }
        return reservations;
    }

    public List<Reservation> getReservationsByLine(String line) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM RESERVATION WHERE line = ? ORDER BY departure_date";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, line);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(mapResultSetToReservation(rs));
                }
            }
        }
        return reservations;
    }

    public List<Reservation> getReservationsByLineAndDate(String line, Date date) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM RESERVATION WHERE line = ? AND departure_date = ? ORDER BY passenger";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, line);
            stmt.setDate(2, date);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(mapResultSetToReservation(rs));
                }
            }
        }
        return reservations;
    }

    public List<Reservation> getReservationsByCustomerName(String customerName) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM RESERVATION WHERE passenger LIKE ? ORDER BY departure_date DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + customerName + "%");
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(mapResultSetToReservation(rs));
                }
            }
        }
        return reservations;
    }

    public BigDecimal getMonthlyRevenue(int year, int month) throws SQLException {
        String sql = "SELECT SUM(total_fare) FROM RESERVATION WHERE YEAR(date_made) = ? AND MONTH(date_made) = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, year);
            stmt.setInt(2, month);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    BigDecimal revenue = rs.getBigDecimal(1);
                    return revenue != null ? revenue : BigDecimal.ZERO;
                }
            }
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal getRevenueByLine(String line) throws SQLException {
        String sql = "SELECT SUM(total_fare) FROM RESERVATION WHERE line = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, line);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    BigDecimal revenue = rs.getBigDecimal(1);
                    return revenue != null ? revenue : BigDecimal.ZERO;
                }
            }
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal getRevenueByCustomer(String username) throws SQLException {
        String sql = "SELECT SUM(total_fare) FROM RESERVATION WHERE username = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    BigDecimal revenue = rs.getBigDecimal(1);
                    return revenue != null ? revenue : BigDecimal.ZERO;
                }
            }
        }
        return BigDecimal.ZERO;
    }

    public String getTopRevenueCustomer() throws SQLException {
        String sql = "SELECT username FROM RESERVATION GROUP BY username ORDER BY SUM(total_fare) DESC LIMIT 1";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getString("username");
            }
        }
        return null;
    }

    public List<String> getTop5ActiveLines() throws SQLException {
        List<String> lines = new ArrayList<>();
        String sql = "SELECT line FROM RESERVATION GROUP BY line ORDER BY COUNT(*) DESC LIMIT 5";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                lines.add(rs.getString("line"));
            }
        }
        return lines;
    }

    public int getTotalReservationCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM RESERVATION";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        return new Reservation(
            rs.getInt("res_num"),
            rs.getString("username"),
            rs.getDate("date_made"),
            rs.getDate("departure_date"),
            rs.getTime("departure_time"),
            rs.getString("passenger"),
            rs.getBigDecimal("total_fare"),
            rs.getString("line"),
            rs.getInt("train_id"),
            rs.getString("origin_station"),
            rs.getString("dest_station"),
            rs.getString("trip_type")
        );
    }
} 