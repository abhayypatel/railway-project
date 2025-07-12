package com.railway.model;

public class Employee {
    private String ssn;
    private String empUser;
    private String empPass;
    private String empFirst;
    private String empLast;
    
    public Employee() {}
    
    public Employee(String ssn, String empUser, String empPass, String empFirst, String empLast) {
        this.ssn = ssn;
        this.empUser = empUser;
        this.empPass = empPass;
        this.empFirst = empFirst;
        this.empLast = empLast;
    }
    
    public String getSsn() {
        return ssn;
    }
    
    public void setSsn(String ssn) {
        this.ssn = ssn;
    }
    
    public String getEmpUser() {
        return empUser;
    }
    
    public void setEmpUser(String empUser) {
        this.empUser = empUser;
    }
    
    public String getEmpPass() {
        return empPass;
    }
    
    public void setEmpPass(String empPass) {
        this.empPass = empPass;
    }
    
    public String getEmpFirst() {
        return empFirst;
    }
    
    public void setEmpFirst(String empFirst) {
        this.empFirst = empFirst;
    }
    
    public String getEmpLast() {
        return empLast;
    }
    
    public void setEmpLast(String empLast) {
        this.empLast = empLast;
    }
    
    public String getFullName() {
        return empFirst + " " + empLast;
    }
    
    public boolean isAdmin() {
        return "123456789".equals(ssn);
    }
    
    @Override
    public String toString() {
        return "Employee{" +
                "ssn='" + ssn + '\'' +
                ", empUser='" + empUser + '\'' +
                ", empFirst='" + empFirst + '\'' +
                ", empLast='" + empLast + '\'' +
                '}';
    }
} 