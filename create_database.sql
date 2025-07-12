DROP DATABASE IF EXISTS railway;
CREATE DATABASE railway;
USE railway;

DROP USER IF EXISTS 'railway_app'@'localhost';
CREATE USER 'railway_app'@'localhost' IDENTIFIED BY 'railway123';
GRANT ALL PRIVILEGES ON railway.* TO 'railway_app'@'localhost';
FLUSH PRIVILEGES;

CREATE TABLE CUSTOMER (
    username VARCHAR(50) PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE EMPLOYEE (
    SSN VARCHAR(11) PRIMARY KEY,
    emp_user VARCHAR(50) NOT NULL UNIQUE,
    emp_pass VARCHAR(255) NOT NULL,
    emp_first VARCHAR(100) NOT NULL,
    emp_last VARCHAR(100) NOT NULL
);

CREATE TABLE TRAIN (
    train_id INT(4) PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    seats INT NOT NULL
);

CREATE TABLE STATION (
    stat_id INT PRIMARY KEY AUTO_INCREMENT,
    stat_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(50) NOT NULL
);

CREATE TABLE TRAIN_SCHEDULE (
    line VARCHAR(100) PRIMARY KEY,
    train_id INT(4) NOT NULL,
    origin VARCHAR(100) NOT NULL,
    dest VARCHAR(100) NOT NULL,
    stops INT NOT NULL,
    dept_time TIME NOT NULL,
    arrival_time TIME NOT NULL,
    travel_time INT NOT NULL, -- in minutes
    fare DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (train_id) REFERENCES TRAIN(train_id)
);

CREATE TABLE RESERVATION (
    res_num INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    date_made DATE NOT NULL,
    departure_date DATE NOT NULL,
    departure_time TIME NOT NULL,
    passenger VARCHAR(200) NOT NULL,
    total_fare DECIMAL(10,2) NOT NULL,
    line VARCHAR(100) NOT NULL,
    train_id INT(4) NOT NULL,
    origin_station VARCHAR(100) NOT NULL,
    dest_station VARCHAR(100) NOT NULL,
    trip_type ENUM('one-way', 'round-trip') DEFAULT 'one-way',
    FOREIGN KEY (username) REFERENCES CUSTOMER(username),
    FOREIGN KEY (line) REFERENCES TRAIN_SCHEDULE(line),
    FOREIGN KEY (train_id) REFERENCES TRAIN(train_id)
);

CREATE TABLE SCHEDULE_STATION (
    line VARCHAR(100),
    stat_id INT,
    stop_seq INT NOT NULL,
    arr_time TIME,
    dept_time TIME,
    PRIMARY KEY (line, stat_id),
    FOREIGN KEY (line) REFERENCES TRAIN_SCHEDULE(line),
    FOREIGN KEY (stat_id) REFERENCES STATION(stat_id)
);

CREATE TABLE CUSTOMER_QUESTIONS (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    question TEXT NOT NULL,
    answer TEXT,
    question_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    answer_date DATETIME,
    answered_by VARCHAR(11),
    FOREIGN KEY (username) REFERENCES CUSTOMER(username),
    FOREIGN KEY (answered_by) REFERENCES EMPLOYEE(SSN)
);

CREATE INDEX idx_reservation_username ON RESERVATION(username);
CREATE INDEX idx_reservation_date ON RESERVATION(departure_date);
CREATE INDEX idx_station_city ON STATION(city);
CREATE INDEX idx_schedule_origin_dest ON TRAIN_SCHEDULE(origin, dest); 