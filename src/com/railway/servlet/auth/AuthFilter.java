package com.railway.servlet.auth;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/customer/*", "/rep/*", "/admin/*"})
public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        System.out.println("AuthFilter: Processing request to " + requestURI);
        System.out.println("AuthFilter: Context path is " + contextPath);
        System.out.println("AuthFilter: Session exists: " + (session != null));
        
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("AuthFilter: No valid session, redirecting to login");
            httpResponse.sendRedirect(contextPath + "/login?msg=please_login");
            return;
        }
        
        String userType = (String) session.getAttribute("userType");
        System.out.println("AuthFilter: User type is " + userType);
        
        if (requestURI.startsWith(contextPath + "/customer/")) {
            if (!"CUSTOMER".equals(userType)) {
                System.out.println("AuthFilter: User not authorized for customer area");
                httpResponse.sendRedirect(contextPath + "/login?msg=access_denied");
                return;
            }
        } else if (requestURI.startsWith(contextPath + "/rep/")) {
            if (!"EMP_REP".equals(userType) && !"ADMIN".equals(userType)) {
                System.out.println("AuthFilter: User not authorized for rep area");
                httpResponse.sendRedirect(contextPath + "/login?msg=access_denied");
                return;
            }
        } else if (requestURI.startsWith(contextPath + "/admin/")) {
            if (!"ADMIN".equals(userType)) {
                System.out.println("AuthFilter: User not authorized for admin area");
                httpResponse.sendRedirect(contextPath + "/login?msg=access_denied");
                return;
            }
        }
        
        System.out.println("AuthFilter: Authorization passed, continuing to " + requestURI);
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
    }
} 