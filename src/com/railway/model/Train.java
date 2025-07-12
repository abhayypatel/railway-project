package com.railway.model;

public class Train {
    private int trainId;
    private String type;
    private int seats;
    
    public Train() {}
    
    public Train(int trainId, String type, int seats) {
        this.trainId = trainId;
        this.type = type;
        this.seats = seats;
    }
    
    public int getTrainId() {
        return trainId;
    }
    
    public void setTrainId(int trainId) {
        this.trainId = trainId;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public int getSeats() {
        return seats;
    }
    
    public void setSeats(int seats) {
        this.seats = seats;
    }
    
    @Override
    public String toString() {
        return "Train{" +
                "trainId=" + trainId +
                ", type='" + type + '\'' +
                ", seats=" + seats +
                '}';
    }
} 