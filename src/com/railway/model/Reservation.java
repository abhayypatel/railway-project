package com.railway.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;

public class Reservation {
    private int resNum;
    private String username;
    private Date dateMade;
    private Date departureDate;
    private Time departureTime;
    private String passenger;
    private BigDecimal totalFare;
    private String line;
    private int trainId;
    private String originStation;
    private String destStation;
    private String tripType;
    
    public Reservation() {}
    
    public Reservation(int resNum, String username, Date dateMade, Date departureDate,
                      Time departureTime, String passenger, BigDecimal totalFare, 
                      String line, int trainId, String originStation, String destStation, 
                      String tripType) {
        this.resNum = resNum;
        this.username = username;
        this.dateMade = dateMade;
        this.departureDate = departureDate;
        this.departureTime = departureTime;
        this.passenger = passenger;
        this.totalFare = totalFare;
        this.line = line;
        this.trainId = trainId;
        this.originStation = originStation;
        this.destStation = destStation;
        this.tripType = tripType;
    }
    
    public int getResNum() {
        return resNum;
    }
    
    public void setResNum(int resNum) {
        this.resNum = resNum;
    }

    public int getReservationId() {
        return resNum;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public Date getDateMade() {
        return dateMade;
    }
    
    public void setDateMade(Date dateMade) {
        this.dateMade = dateMade;
    }
    
    public Date getDepartureDate() {
        return departureDate;
    }
    
    public void setDepartureDate(Date departureDate) {
        this.departureDate = departureDate;
    }
    
    public Time getDepartureTime() {
        return departureTime;
    }
    
    public void setDepartureTime(Time departureTime) {
        this.departureTime = departureTime;
    }
    
    public String getPassenger() {
        return passenger;
    }
    
    public void setPassenger(String passenger) {
        this.passenger = passenger;
    }
    
    public BigDecimal getTotalFare() {
        return totalFare;
    }
    
    public void setTotalFare(BigDecimal totalFare) {
        this.totalFare = totalFare;
    }
    
    public String getLine() {
        return line;
    }
    
    public void setLine(String line) {
        this.line = line;
    }
    
    public int getTrainId() {
        return trainId;
    }
    
    public void setTrainId(int trainId) {
        this.trainId = trainId;
    }
    
    public String getOriginStation() {
        return originStation;
    }
    
    public void setOriginStation(String originStation) {
        this.originStation = originStation;
    }
    
    public String getDestStation() {
        return destStation;
    }
    
    public void setDestStation(String destStation) {
        this.destStation = destStation;
    }
    
    public String getTripType() {
        return tripType;
    }
    
    public void setTripType(String tripType) {
        this.tripType = tripType;
    }
    
    public boolean isRoundTrip() {
        return "round-trip".equals(tripType);
    }
    
    @Override
    public String toString() {
        return "Reservation{" +
                "resNum=" + resNum +
                ", username='" + username + '\'' +
                ", passenger='" + passenger + '\'' +
                ", line='" + line + '\'' +
                ", trainId=" + trainId +
                ", originStation='" + originStation + '\'' +
                ", destStation='" + destStation + '\'' +
                ", departureDate=" + departureDate +
                ", departureTime=" + departureTime +
                ", totalFare=" + totalFare +
                '}';
    }
} 