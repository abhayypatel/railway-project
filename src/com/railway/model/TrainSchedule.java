package com.railway.model;

import java.math.BigDecimal;
import java.sql.Time;
import java.util.Date;
import java.util.Calendar;

public class TrainSchedule {
    private String line;
    private int trainId;
    private String origin;
    private String dest;
    private int stops;
    private Time deptTime;
    private Time arrivalTime;
    private int travelTime;
    private BigDecimal fare;
    
    private Train train;
    
    public TrainSchedule() {}
    
    public TrainSchedule(String line, int trainId, String origin, String dest, 
                        int stops, Time deptTime, Time arrivalTime, int travelTime, BigDecimal fare) {
        this.line = line;
        this.trainId = trainId;
        this.origin = origin;
        this.dest = dest;
        this.stops = stops;
        this.deptTime = deptTime;
        this.arrivalTime = arrivalTime;
        this.travelTime = travelTime;
        this.fare = fare;
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
    
    public String getOrigin() {
        return origin;
    }
    
    public void setOrigin(String origin) {
        this.origin = origin;
    }
    
    public String getDest() {
        return dest;
    }
    
    public void setDest(String dest) {
        this.dest = dest;
    }
    
    public int getStops() {
        return stops;
    }
    
    public void setStops(int stops) {
        this.stops = stops;
    }
    
    public Time getDeptTime() {
        return deptTime;
    }
    
    public void setDeptTime(Time deptTime) {
        this.deptTime = deptTime;
    }
    
    public Time getArrivalTime() {
        return arrivalTime;
    }
    
    public void setArrivalTime(Time arrivalTime) {
        this.arrivalTime = arrivalTime;
    }
    
    public int getTravelTime() {
        return travelTime;
    }
    
    public void setTravelTime(int travelTime) {
        this.travelTime = travelTime;
    }
    
    public BigDecimal getFare() {
        return fare;
    }
    
    public void setFare(BigDecimal fare) {
        this.fare = fare;
    }

    public String getTransitLineName() {
        return line;
    }

    public Train getTrain() {
        if (train == null) {
            train = new Train();
            train.setTrainId(this.trainId);
        }
        return train;
    }
    
    public void setTrain(Train train) {
        this.train = train;
        if (train != null) {
            this.trainId = train.getTrainId();
        }
    }

    public Date getDepartureDateTime() {
        if (deptTime == null) return null;
        
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        
        Calendar timeCal = Calendar.getInstance();
        timeCal.setTime(deptTime);
        
        cal.set(Calendar.HOUR_OF_DAY, timeCal.get(Calendar.HOUR_OF_DAY));
        cal.set(Calendar.MINUTE, timeCal.get(Calendar.MINUTE));
        cal.set(Calendar.SECOND, timeCal.get(Calendar.SECOND));
        
        return cal.getTime();
    }

    public Date getArrivalDateTime() {
        if (arrivalTime == null || deptTime == null) return null;
        
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        
        Calendar timeCal = Calendar.getInstance();
        timeCal.setTime(arrivalTime);
        
        cal.set(Calendar.HOUR_OF_DAY, timeCal.get(Calendar.HOUR_OF_DAY));
        cal.set(Calendar.MINUTE, timeCal.get(Calendar.MINUTE));
        cal.set(Calendar.SECOND, timeCal.get(Calendar.SECOND));
        
        Calendar deptCal = Calendar.getInstance();
        deptCal.setTime(deptTime);
        
        int deptMinutes = deptCal.get(Calendar.HOUR_OF_DAY) * 60 + deptCal.get(Calendar.MINUTE);
        int arrivalMinutes = timeCal.get(Calendar.HOUR_OF_DAY) * 60 + timeCal.get(Calendar.MINUTE);
        
        if (arrivalMinutes <= deptMinutes) {
            cal.add(Calendar.DAY_OF_MONTH, 1);
        }
        
        return cal.getTime();
    }
    
    public String getFormattedTravelTime() {
        int hours = travelTime / 60;
        int minutes = travelTime % 60;
        return hours + "h " + minutes + "m";
    }
    
    @Override
    public String toString() {
        return "TrainSchedule{" +
                "line='" + line + '\'' +
                ", trainId=" + trainId +
                ", origin='" + origin + '\'' +
                ", dest='" + dest + '\'' +
                ", deptTime=" + deptTime +
                ", arrivalTime=" + arrivalTime +
                ", fare=" + fare +
                '}';
    }
} 