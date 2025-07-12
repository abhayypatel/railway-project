package com.railway.util;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DBUtil {
    private static DataSource dataSource;
    private static final int MAX_RETRY_ATTEMPTS = 3;
    private static final int RETRY_DELAY_MS = 1000;
    
    static {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            dataSource = (DataSource) envContext.lookup("jdbc/railway");
        } catch (NamingException e) {
            throw new RuntimeException("Failed to initialize DataSource", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        SQLException lastException = null;
        
        for (int attempt = 1; attempt <= MAX_RETRY_ATTEMPTS; attempt++) {
            try {
                Connection conn = dataSource.getConnection();
                
                if (conn != null && conn.isValid(5)) {
                    return conn;
                } else if (conn != null) {
                    conn.close();
                }
                
            } catch (SQLException e) {
                lastException = e;
                System.err.println("Database connection attempt " + attempt + " failed: " + e.getMessage());
                
                if (attempt < MAX_RETRY_ATTEMPTS) {
                    try {
                        Thread.sleep(RETRY_DELAY_MS * attempt);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        throw new SQLException("Connection retry interrupted", ie);
                    }
                }
            }
        }
        
        throw new SQLException("Failed to obtain database connection after " + MAX_RETRY_ATTEMPTS + " attempts", lastException);
    }

    public static Connection getConnectionSimple() throws SQLException {
        return dataSource.getConnection();
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
    }

    public static void closeResource(AutoCloseable autoCloseable) {
        if (autoCloseable != null) {
            try {
                autoCloseable.close();
            } catch (Exception e) {
                System.err.println("Error closing resource: " + e.getMessage());
            }
        }
    }

    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && conn.isValid(5);
        } catch (SQLException e) {
            System.err.println("Database connectivity test failed: " + e.getMessage());
            return false;
        }
    }
} 