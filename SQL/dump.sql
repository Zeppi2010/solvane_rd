-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: solvane_rd
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `facilities`
--

DROP TABLE IF EXISTS `facilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facilities` (
  `FacilityID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `Region` varchar(100) DEFAULT NULL,
  `Type` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`FacilityID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facilities`
--

LOCK TABLES `facilities` WRITE;
/*!40000 ALTER TABLE `facilities` DISABLE KEYS */;
INSERT INTO `facilities` VALUES (1,'Stormgaard 1','Stormgaard','Aerodynamics and Avionics'),(2,'Drayseria 1','Drayseria','Naval Engineering'),(3,'Soleria 1','Solvane Central Plateau','Civilian'),(4,'Karathi 1','Karathi','Land Warfare');
/*!40000 ALTER TABLE `facilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectchangelog`
--

DROP TABLE IF EXISTS `projectchangelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projectchangelog` (
  `LogID` int NOT NULL AUTO_INCREMENT,
  `ProjectID` int DEFAULT NULL,
  `OldVersion` int DEFAULT NULL,
  `NewVersion` int DEFAULT NULL,
  `ChangedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `Changes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`LogID`),
  KEY `ProjectID` (`ProjectID`),
  CONSTRAINT `projectchangelog_ibfk_1` FOREIGN KEY (`ProjectID`) REFERENCES `projects` (`ProjectID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectchangelog`
--

LOCK TABLES `projectchangelog` WRITE;
/*!40000 ALTER TABLE `projectchangelog` DISABLE KEYS */;
/*!40000 ALTER TABLE `projectchangelog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projects` (
  `ProjectID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `FacilityID` int DEFAULT NULL,
  `Version` int DEFAULT NULL,
  `Changes` varchar(255) DEFAULT NULL,
  `Type` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ProjectID`),
  KEY `FacilityID` (`FacilityID`),
  CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`FacilityID`) REFERENCES `facilities` (`FacilityID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
INSERT INTO `projects` VALUES (1,'Project Grimm',1,1,'Initial design of variable sweep wing mechanism begun','Aerodynamics and Avionics'),(2,'Project Wraith',1,1,'Preliminary stealth rotor blade research initiated','Aerodynamics and Avionics'),(3,'Project Hearthstone',3,1,'Feasibility study for modular reactor core started','Civilian'),(4,'Project Leviathan',2,1,'Submarine carrier hull design and submerged launch system conceptualised','Naval Engineering'),(5,'Project Thunderline',4,1,'Electromagnetic rail propulsion research begun','Land Warfare'),(6,'Project Ironstrider',4,1,'Theoretical framework for bipedal armoured platform established','Land Warfare');
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `log_version_change` BEFORE UPDATE ON `projects` FOR EACH ROW IF OLD.Version != NEW.Version THEN
    INSERT INTO ProjectChangelog (ProjectID, OldVersion, NewVersion, Changes)
    VALUES (OLD.ProjectID, OLD.Version, NEW.Version, NEW.Changes);
END IF */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `scientistprojects`
--

DROP TABLE IF EXISTS `scientistprojects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scientistprojects` (
  `ScientistID` int NOT NULL,
  `ProjectID` int NOT NULL,
  PRIMARY KEY (`ScientistID`,`ProjectID`),
  KEY `ProjectID` (`ProjectID`),
  CONSTRAINT `scientistprojects_ibfk_1` FOREIGN KEY (`ScientistID`) REFERENCES `scientists` (`ScientistID`),
  CONSTRAINT `scientistprojects_ibfk_2` FOREIGN KEY (`ProjectID`) REFERENCES `projects` (`ProjectID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scientistprojects`
--

LOCK TABLES `scientistprojects` WRITE;
/*!40000 ALTER TABLE `scientistprojects` DISABLE KEYS */;
INSERT INTO `scientistprojects` VALUES (1,1),(3,1),(1,2),(2,2),(7,3),(8,3),(9,3),(4,4),(5,4),(6,4),(10,5),(12,5),(11,6);
/*!40000 ALTER TABLE `scientistprojects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scientists`
--

DROP TABLE IF EXISTS `scientists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scientists` (
  `ScientistID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `FacilityID` int DEFAULT NULL,
  `Type` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ScientistID`),
  KEY `FacilityID` (`FacilityID`),
  CONSTRAINT `scientists_ibfk_1` FOREIGN KEY (`FacilityID`) REFERENCES `facilities` (`FacilityID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scientists`
--

LOCK TABLES `scientists` WRITE;
/*!40000 ALTER TABLE `scientists` DISABLE KEYS */;
INSERT INTO `scientists` VALUES (1,'Erik Stormveld',1,'Aerodynamics and Avionics'),(2,'Hilde Bauer',1,'Aerodynamics and Avionics'),(3,'Kenji Nakamura',1,'Aerodynamics and Avionics'),(4,'Lars Dawnmere',2,'Naval Engineering'),(5,'Sigrid Halvorsen',2,'Naval Engineering'),(6,'Wei Zhang',2,'Naval Engineering'),(7,'Bjorn Aldrath',3,'Civilian'),(8,'Astrid Müller',3,'Civilian'),(9,'Yuna Park',3,'Civilian'),(10,'Ragnar Kolvik',4,'Land Warfare'),(11,'Gertrude Eisenberg',4,'Land Warfare'),(12,'Tariq Al-Rashid',4,'Land Warfare');
/*!40000 ALTER TABLE `scientists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testerprojects`
--

DROP TABLE IF EXISTS `testerprojects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `testerprojects` (
  `TesterID` int NOT NULL,
  `ProjectID` int NOT NULL,
  PRIMARY KEY (`TesterID`,`ProjectID`),
  KEY `ProjectID` (`ProjectID`),
  CONSTRAINT `testerprojects_ibfk_1` FOREIGN KEY (`TesterID`) REFERENCES `testers` (`TesterID`),
  CONSTRAINT `testerprojects_ibfk_2` FOREIGN KEY (`ProjectID`) REFERENCES `projects` (`ProjectID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testerprojects`
--

LOCK TABLES `testerprojects` WRITE;
/*!40000 ALTER TABLE `testerprojects` DISABLE KEYS */;
INSERT INTO `testerprojects` VALUES (1,1),(2,2),(5,3),(6,3),(3,4),(4,4),(7,5);
/*!40000 ALTER TABLE `testerprojects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testers`
--

DROP TABLE IF EXISTS `testers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `testers` (
  `TesterID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `FacilityID` int DEFAULT NULL,
  `Type` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`TesterID`),
  KEY `FacilityID` (`FacilityID`),
  CONSTRAINT `testers_ibfk_1` FOREIGN KEY (`FacilityID`) REFERENCES `facilities` (`FacilityID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testers`
--

LOCK TABLES `testers` WRITE;
/*!40000 ALTER TABLE `testers` DISABLE KEYS */;
INSERT INTO `testers` VALUES (1,'Gunnar Vestergaard',1,'Aerodynamics and Avionics'),(2,'Ingrid Solmund',1,'Aerodynamics and Avionics'),(3,'Ulf Brynjarsson',2,'Naval Engineering'),(4,'Mei-Lin Chen',2,'Naval Engineering'),(5,'Thyra Fenwick',3,'Civilian'),(6,'Otto Steinberg',3,'Civilian'),(7,'Leif Haldvard',4,'Land Warfare'),(8,'Sven Moritz',4,'Land Warfare');
/*!40000 ALTER TABLE `testers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'solvane_rd'
--

--
-- Dumping routines for database 'solvane_rd'
--
/*!50003 DROP FUNCTION IF EXISTS `ScientistWorkload` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `ScientistWorkload`(sid INT) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE workload INT;
    SELECT COUNT(*) INTO workload FROM ScientistProjects WHERE ScientistID = sid;
    RETURN workload;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AssignScientist` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AssignScientist`(IN sid INT, IN pid INT)
BEGIN
    DECLARE sci_facility INT;
    DECLARE proj_facility INT;
    SELECT FacilityID INTO sci_facility FROM Scientists WHERE ScientistID = sid;
    SELECT FacilityID INTO proj_facility FROM Projects WHERE ProjectID = pid;
    IF sci_facility = proj_facility THEN
        INSERT INTO ScientistProjects (ScientistID, ProjectID) VALUES (sid, pid);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Scientist and project must belong to the same facility';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-09 14:12:20
