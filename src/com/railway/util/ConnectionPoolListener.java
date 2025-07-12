package com.railway.util;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class ConnectionPoolListener implements ServletContextListener {
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Railway Project System: Application started");
        System.out.println("Database connection pool initialized");
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Railway Project System: Application stopped");
        System.out.println("Database connection pool destroyed");
    }
} 