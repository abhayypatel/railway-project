-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: railway
-- ------------------------------------------------------
-- Server version	9.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `username` varchar(50) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES ('bjohnson','Bob','Johnson','bob.johnson@email.com','secure789'),('dsmith','David','Smith','david.smith@email.com','pass654'),('jsmith','John','Smith','john.smith@email.com','password123'),('mwilson','Mary','Wilson','mary.wilson@email.com','pass456'),('sjones','Sarah','Jones','sarah.jones@email.com','mypass321'),('user1','user','1','user1@email.com','password'),('user2','user','2','user2@email.com','password'),('user3','user','3','user3@email.com','password'),('user4','user','4','user4@email.com','password'),('user5','user','5','user5@email.com','password');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_questions`
--

DROP TABLE IF EXISTS `customer_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_questions` (
  `question_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `question` text NOT NULL,
  `answer` text,
  `question_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `answer_date` datetime DEFAULT NULL,
  `answered_by` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`question_id`),
  KEY `username` (`username`),
  KEY `answered_by` (`answered_by`),
  CONSTRAINT `customer_questions_ibfk_1` FOREIGN KEY (`username`) REFERENCES `customer` (`username`),
  CONSTRAINT `customer_questions_ibfk_2` FOREIGN KEY (`answered_by`) REFERENCES `employee` (`SSN`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_questions`
--

LOCK TABLES `customer_questions` WRITE;
/*!40000 ALTER TABLE `customer_questions` DISABLE KEYS */;
INSERT INTO `customer_questions` VALUES (1,'user1','test123','it works','2025-07-04 22:12:16','2025-07-04 22:44:03','123456789'),(2,'user1','testing 2','awesome','2025-07-04 22:44:51','2025-07-04 22:45:10','123456789'),(3,'user1','test 3','answered 2','2025-07-04 22:46:35','2025-07-04 22:48:32','123456789'),(4,'user2','new question','answered 1','2025-07-04 22:46:54','2025-07-04 22:48:27','123456789');
/*!40000 ALTER TABLE `customer_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `SSN` varchar(11) NOT NULL,
  `emp_user` varchar(50) NOT NULL,
  `emp_pass` varchar(255) NOT NULL,
  `emp_first` varchar(100) NOT NULL,
  `emp_last` varchar(100) NOT NULL,
  PRIMARY KEY (`SSN`),
  UNIQUE KEY `emp_user` (`emp_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES ('123456789','admin','admin123','Admin','User'),('222-22-2222','test1','password','test','user'),('456789123','rep2','rep456','Tom','Wilson'),('789123456','rep3','rep789','Lisa','Brown'),('987654321','rep1','rep123','Alice','Manager');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation`
--

DROP TABLE IF EXISTS `reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation` (
  `res_num` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `date_made` date NOT NULL,
  `departure_date` date NOT NULL,
  `departure_time` time NOT NULL,
  `passenger` varchar(200) NOT NULL,
  `total_fare` decimal(10,2) NOT NULL,
  `line` varchar(100) NOT NULL,
  `train_id` int NOT NULL,
  `origin_station` varchar(100) NOT NULL,
  `dest_station` varchar(100) NOT NULL,
  `trip_type` enum('one-way','round-trip') DEFAULT 'one-way',
  PRIMARY KEY (`res_num`),
  KEY `line` (`line`),
  KEY `train_id` (`train_id`),
  KEY `idx_reservation_username` (`username`),
  KEY `idx_reservation_date` (`departure_date`),
  CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`username`) REFERENCES `customer` (`username`),
  CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`line`) REFERENCES `train_schedule` (`line`),
  CONSTRAINT `reservation_ibfk_3` FOREIGN KEY (`train_id`) REFERENCES `train` (`train_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation`
--

LOCK TABLES `reservation` WRITE;
/*!40000 ALTER TABLE `reservation` DISABLE KEYS */;
INSERT INTO `reservation` VALUES (1,'user1','2025-07-04','2025-07-05','19:00:00','user 1',270.00,'bmore express',1005,'Baltimore Penn Station','New Brunswick Station','round-trip'),(2,'user2','2025-07-04','2025-07-05','10:00:00','user 2',37.50,'Acela Express',1003,'Penn Station','Philadelphia 30th Street','one-way'),(3,'user3','2025-07-04','2025-07-05','08:00:00','user 3',50.00,'North Jersey Coast',1002,'Newark Penn Station','Edison Station','one-way'),(4,'user4','2025-07-04','2025-07-05','08:00:00','user 4',84.50,'North Jersey Coast',1002,'Princeton Station','Trenton Station','round-trip'),(5,'user5','2025-07-04','2025-07-05','06:00:00','user 5',12.50,'Northeast Corridor',1001,'Edison Station','Metuchen Station','one-way'),(6,'user1','2025-07-04','2025-07-05','06:00:00','user 1',21.13,'Northeast Corridor',1001,'Edison Station','Metuchen Station','one-way'),(10,'user1','2025-07-04','2025-07-05','06:00:00','user 1',32.50,'Northeast Corridor',1001,'New Brunswick Station','Newark Penn Station','one-way'),(11,'user1','2025-07-04','2025-07-05','06:00:00','user 1',50.00,'Northeast Corridor',1001,'New Brunswick Station','Penn Station','one-way');
/*!40000 ALTER TABLE `reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule_station`
--

DROP TABLE IF EXISTS `schedule_station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule_station` (
  `line` varchar(100) NOT NULL,
  `stat_id` int NOT NULL,
  `stop_seq` int NOT NULL,
  `arr_time` time DEFAULT NULL,
  `dept_time` time DEFAULT NULL,
  PRIMARY KEY (`line`,`stat_id`),
  KEY `stat_id` (`stat_id`),
  CONSTRAINT `schedule_station_ibfk_1` FOREIGN KEY (`line`) REFERENCES `train_schedule` (`line`),
  CONSTRAINT `schedule_station_ibfk_2` FOREIGN KEY (`stat_id`) REFERENCES `station` (`stat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule_station`
--

LOCK TABLES `schedule_station` WRITE;
/*!40000 ALTER TABLE `schedule_station` DISABLE KEYS */;
INSERT INTO `schedule_station` VALUES ('Acela Express',1,1,NULL,'10:00:00'),('Acela Express',7,2,'11:00:00','11:05:00'),('Acela Express',9,4,'13:00:00',NULL),('Acela Express',10,3,'12:00:00','12:05:00'),('North Jersey Coast',1,1,NULL,'08:00:00'),('North Jersey Coast',2,7,'09:30:00',NULL),('North Jersey Coast',3,6,'09:15:00','09:17:00'),('North Jersey Coast',4,5,'09:00:00','09:02:00'),('North Jersey Coast',5,4,'08:45:00','08:47:00'),('North Jersey Coast',6,3,'08:30:00','08:32:00'),('North Jersey Coast',8,2,'08:15:00','08:17:00'),('Northeast Corridor',1,7,'07:30:00',NULL),('Northeast Corridor',2,1,NULL,'06:00:00'),('Northeast Corridor',3,2,'06:15:00','06:17:00'),('Northeast Corridor',4,3,'06:30:00','06:32:00'),('Northeast Corridor',5,4,'06:45:00','06:47:00'),('Northeast Corridor',6,5,'07:00:00','07:02:00'),('Northeast Corridor',8,6,'07:15:00','07:17:00');
/*!40000 ALTER TABLE `schedule_station` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `station`
--

DROP TABLE IF EXISTS `station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `station` (
  `stat_id` int NOT NULL AUTO_INCREMENT,
  `stat_name` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `state` varchar(50) NOT NULL,
  PRIMARY KEY (`stat_id`),
  KEY `idx_station_city` (`city`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `station`
--

LOCK TABLES `station` WRITE;
/*!40000 ALTER TABLE `station` DISABLE KEYS */;
INSERT INTO `station` VALUES (1,'Penn Station','New York','NY'),(2,'Trenton Station','Trenton','NJ'),(3,'Princeton Station','Princeton','NJ'),(4,'New Brunswick Station','New Brunswick','NJ'),(5,'Edison Station','Edison','NJ'),(6,'Metuchen Station','Metuchen','NJ'),(7,'Philadelphia 30th Street','Philadelphia','PA'),(8,'Newark Penn Station','Newark','NJ'),(9,'Union Station','Washington','DC'),(10,'Baltimore Penn Station','Baltimore','MD');
/*!40000 ALTER TABLE `station` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train`
--

DROP TABLE IF EXISTS `train`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `train` (
  `train_id` int NOT NULL,
  `type` varchar(50) NOT NULL,
  `seats` int NOT NULL,
  PRIMARY KEY (`train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train`
--

LOCK TABLES `train` WRITE;
/*!40000 ALTER TABLE `train` DISABLE KEYS */;
INSERT INTO `train` VALUES (1001,'Express',200),(1002,'Local',150),(1003,'High-Speed',300),(1004,'Regional',180),(1005,'Express',220);
/*!40000 ALTER TABLE `train` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train_schedule`
--

DROP TABLE IF EXISTS `train_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `train_schedule` (
  `line` varchar(100) NOT NULL,
  `train_id` int NOT NULL,
  `origin` varchar(100) NOT NULL,
  `dest` varchar(100) NOT NULL,
  `stops` int NOT NULL,
  `dept_time` time NOT NULL,
  `arrival_time` time NOT NULL,
  `travel_time` int NOT NULL,
  `fare` decimal(10,2) NOT NULL,
  PRIMARY KEY (`line`),
  KEY `train_id` (`train_id`),
  KEY `idx_schedule_origin_dest` (`origin`,`dest`),
  CONSTRAINT `train_schedule_ibfk_1` FOREIGN KEY (`train_id`) REFERENCES `train` (`train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train_schedule`
--

LOCK TABLES `train_schedule` WRITE;
/*!40000 ALTER TABLE `train_schedule` DISABLE KEYS */;
INSERT INTO `train_schedule` VALUES ('Acela Express',1003,'Penn Station','Union Station',4,'10:00:00','13:00:00',180,150.00),('bmore express',1005,'Baltimore Penn Station','New Brunswick Station',4,'19:00:00','23:30:00',270,120.00),('North Jersey Coast',1002,'Penn Station','Trenton Station',6,'08:00:00','09:30:00',90,50.00),('Northeast Corridor',1001,'Trenton Station','Penn Station',6,'06:00:00','07:30:00',90,50.00),('Pennsylvanian',1004,'Penn Station','Philadelphia 30th Street',2,'14:00:00','15:30:00',90,75.00),('Regional Express',1005,'Newark Penn Station','Baltimore Penn Station',4,'16:00:00','19:00:00',180,95.00);
/*!40000 ALTER TABLE `train_schedule` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-06  0:49:18
