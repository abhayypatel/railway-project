USE railway;
INSERT INTO CUSTOMER (username, first_name, last_name, email, password) VALUES
('jsmith', 'John', 'Smith', 'john.smith@email.com', 'password123'),
('mwilson', 'Mary', 'Wilson', 'mary.wilson@email.com', 'pass456'),
('bjohnson', 'Bob', 'Johnson', 'bob.johnson@email.com', 'secure789'),
('sjones', 'Sarah', 'Jones', 'sarah.jones@email.com', 'mypass321'),
('dsmith', 'David', 'Smith', 'david.smith@email.com', 'pass654');

INSERT INTO EMPLOYEE (SSN, emp_user, emp_pass, emp_first, emp_last) VALUES
('123456789', 'admin', 'admin123', 'Admin', 'User'),
('987654321', 'rep1', 'rep123', 'Alice', 'Manager'),
('456789123', 'rep2', 'rep456', 'Tom', 'Wilson'),
('789123456', 'rep3', 'rep789', 'Lisa', 'Brown');

INSERT INTO TRAIN (train_id, type, seats) VALUES
(1001, 'Express', 200),
(1002, 'Local', 150),
(1003, 'High-Speed', 300),
(1004, 'Regional', 180),
(1005, 'Express', 220);

INSERT INTO STATION (stat_name, city, state) VALUES
('Penn Station', 'New York', 'NY'),
('Trenton Station', 'Trenton', 'NJ'),
('Princeton Station', 'Princeton', 'NJ'),
('New Brunswick Station', 'New Brunswick', 'NJ'),
('Edison Station', 'Edison', 'NJ'),
('Metuchen Station', 'Metuchen', 'NJ'),
('Philadelphia 30th Street', 'Philadelphia', 'PA'),
('Newark Penn Station', 'Newark', 'NJ'),
('Union Station', 'Washington', 'DC'),
('Baltimore Penn Station', 'Baltimore', 'MD');

INSERT INTO TRAIN_SCHEDULE (line, train_id, origin, dest, stops, dept_time, arrival_time, travel_time, fare) VALUES
('Northeast Corridor', 1001, 'Trenton Station', 'Penn Station', 6, '06:00:00', '07:30:00', 90, 50.00),
('North Jersey Coast', 1002, 'Penn Station', 'Trenton Station', 6, '08:00:00', '09:30:00', 90, 50.00),
('Acela Express', 1003, 'Penn Station', 'Union Station', 3, '10:00:00', '13:00:00', 180, 150.00),
('Pennsylvanian', 1004, 'Penn Station', 'Philadelphia 30th Street', 2, '14:00:00', '15:30:00', 90, 75.00),
('Regional Express', 1005, 'Newark Penn Station', 'Baltimore Penn Station', 4, '16:00:00', '19:00:00', 180, 95.00);

INSERT INTO SCHEDULE_STATION (line, stat_id, stop_seq, arr_time, dept_time) VALUES
('Northeast Corridor', 2, 1, NULL, '06:00:00'),
('Northeast Corridor', 3, 2, '06:15:00', '06:17:00'),
('Northeast Corridor', 4, 3, '06:30:00', '06:32:00'),
('Northeast Corridor', 5, 4, '06:45:00', '06:47:00'),
('Northeast Corridor', 6, 5, '07:00:00', '07:02:00'),
('Northeast Corridor', 8, 6, '07:15:00', '07:17:00'),
('Northeast Corridor', 1, 7, '07:30:00', NULL); 

INSERT INTO SCHEDULE_STATION (line, stat_id, stop_seq, arr_time, dept_time) VALUES
('North Jersey Coast', 1, 1, NULL, '08:00:00'),
('North Jersey Coast', 8, 2, '08:15:00', '08:17:00'),
('North Jersey Coast', 6, 3, '08:30:00', '08:32:00'),
('North Jersey Coast', 5, 4, '08:45:00', '08:47:00'),
('North Jersey Coast', 4, 5, '09:00:00', '09:02:00'),
('North Jersey Coast', 3, 6, '09:15:00', '09:17:00'),
('North Jersey Coast', 2, 7, '09:30:00', NULL);

INSERT INTO SCHEDULE_STATION (line, stat_id, stop_seq, arr_time, dept_time) VALUES
('Acela Express', 1, 1, NULL, '10:00:00'),
('Acela Express', 7, 2, '11:00:00', '11:05:00'),
('Acela Express', 10, 3, '12:00:00', '12:05:00'),
('Acela Express', 9, 4, '13:00:00', NULL);

INSERT INTO RESERVATION (username, date_made, departure_date, departure_time, passenger, total_fare, line, train_id, origin_station, dest_station, trip_type) VALUES
('jsmith', '2024-01-15', '2024-02-01', '06:00:00', 'John Smith', 50.00, 'Northeast Corridor', 1001, 'Trenton Station', 'Penn Station', 'one-way'),
('mwilson', '2024-01-16', '2024-02-02', '06:00:00', 'Mary Wilson', 100.00, 'Northeast Corridor', 1001, 'Princeton Station', 'Penn Station', 'round-trip'),
('bjohnson', '2024-01-17', '2024-02-03', '10:00:00', 'Bob Johnson', 150.00, 'Acela Express', 1003, 'Penn Station', 'Union Station', 'one-way'),
('sjones', '2024-01-18', '2024-02-04', '06:00:00', 'Sarah Jones', 37.50, 'Northeast Corridor', 1001, 'New Brunswick Station', 'Penn Station', 'one-way'),
('dsmith', '2024-01-19', '2024-02-05', '14:00:00', 'David Smith', 75.00, 'Pennsylvanian', 1004, 'Penn Station', 'Philadelphia 30th Street', 'one-way');

INSERT INTO CUSTOMER_QUESTIONS (username, question, answer, question_date, answer_date, answered_by) VALUES
('jsmith', 'What is the baggage policy for trains?', 'You can bring up to 2 personal items and 2 carry-on bags per passenger.', '2024-01-10 10:00:00', '2024-01-10 14:30:00', '987654321'),
('mwilson', 'Can I change my reservation?', 'Yes, you can change your reservation up to 24 hours before departure for a small fee.', '2024-01-12 09:00:00', '2024-01-12 11:15:00', '456789123'),
('bjohnson', 'Are there discounts for senior citizens?', NULL, '2024-01-20 16:30:00', NULL, NULL); 