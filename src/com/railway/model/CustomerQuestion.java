package com.railway.model;

import java.sql.Timestamp;

public class CustomerQuestion {
    private int questionId;
    private String username;
    private String question;
    private String answer;
    private Timestamp questionDate;
    private Timestamp answerDate;
    private String answeredBy;
    
    public CustomerQuestion() {}
    
    public CustomerQuestion(String username, String question) {
        this.username = username;
        this.question = question;
        this.questionDate = new Timestamp(System.currentTimeMillis());
    }
    
    public CustomerQuestion(int questionId, String username, String question, String answer,
                           Timestamp questionDate, Timestamp answerDate, String answeredBy) {
        this.questionId = questionId;
        this.username = username;
        this.question = question;
        this.answer = answer;
        this.questionDate = questionDate;
        this.answerDate = answerDate;
        this.answeredBy = answeredBy;
    }
    
    public int getQuestionId() {
        return questionId;
    }
    
    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getQuestion() {
        return question;
    }
    
    public void setQuestion(String question) {
        this.question = question;
    }
    
    public String getAnswer() {
        return answer;
    }
    
    public void setAnswer(String answer) {
        this.answer = answer;
    }
    
    public Timestamp getQuestionDate() {
        return questionDate;
    }
    
    public void setQuestionDate(Timestamp questionDate) {
        this.questionDate = questionDate;
    }
    
    public Timestamp getAnswerDate() {
        return answerDate;
    }
    
    public void setAnswerDate(Timestamp answerDate) {
        this.answerDate = answerDate;
    }
    
    public String getAnsweredBy() {
        return answeredBy;
    }
    
    public void setAnsweredBy(String answeredBy) {
        this.answeredBy = answeredBy;
    }
    
    public boolean isAnswered() {
        return answer != null && !answer.trim().isEmpty();
    }
    
    @Override
    public String toString() {
        return "CustomerQuestion{" +
                "questionId=" + questionId +
                ", username='" + username + '\'' +
                ", question='" + question + '\'' +
                ", isAnswered=" + isAnswered() +
                '}';
    }
} 