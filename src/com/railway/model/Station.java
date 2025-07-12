package com.railway.model;

public class Station {
    private int statId;
    private String statName;
    private String city;
    private String state;
    
    public Station() {}
    
    public Station(int statId, String statName, String city, String state) {
        this.statId = statId;
        this.statName = statName;
        this.city = city;
        this.state = state;
    }
    
    public int getStatId() {
        return statId;
    }
    
    public void setStatId(int statId) {
        this.statId = statId;
    }
    
    public String getStatName() {
        return statName;
    }
    
    public void setStatName(String statName) {
        this.statName = statName;
    }
    
    public String getCity() {
        return city;
    }
    
    public void setCity(String city) {
        this.city = city;
    }
    
    public String getState() {
        return state;
    }
    
    public void setState(String state) {
        this.state = state;
    }
    
    public String getFullLocation() {
        return statName + ", " + city + ", " + state;
    }
    
    @Override
    public String toString() {
        return "Station{" +
                "statId=" + statId +
                ", statName='" + statName + '\'' +
                ", city='" + city + '\'' +
                ", state='" + state + '\'' +
                '}';
    }
} 