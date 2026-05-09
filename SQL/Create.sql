CREATE DATABASE solvane_rd;
USE solvane_rd;

CREATE TABLE Facilities (
    FacilityID  INT          PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(100),
    Region      VARCHAR(100),
    Type        VARCHAR(100)
);

CREATE TABLE Scientists (
    ScientistID INT          PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(100),
    FacilityID  INT,
    Type        VARCHAR(100),
    FOREIGN KEY (FacilityID) REFERENCES Facilities(FacilityID)
);

CREATE TABLE Testers (
    TesterID    INT          PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(100),
    FacilityID  INT,
    Type        VARCHAR(100),
    FOREIGN KEY (FacilityID) REFERENCES Facilities(FacilityID)
);

CREATE TABLE Projects (
    ProjectID   INT          PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(100),
    FacilityID  INT,
    Version     INT,
    Changes     VARCHAR(255),
    Type        VARCHAR(100),
    FOREIGN KEY (FacilityID) REFERENCES Facilities(FacilityID)
);

CREATE TABLE ScientistProjects (
    ScientistID INT,
    ProjectID   INT,
    PRIMARY KEY (ScientistID, ProjectID),
    FOREIGN KEY (ScientistID) REFERENCES Scientists(ScientistID),
    FOREIGN KEY (ProjectID)   REFERENCES Projects(ProjectID)
);

CREATE TABLE TesterProjects (
    TesterID    INT,
    ProjectID   INT,
    PRIMARY KEY (TesterID, ProjectID),
    FOREIGN KEY (TesterID)  REFERENCES Testers(TesterID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

CREATE TABLE ProjectChangelog (
    LogID       INT      PRIMARY KEY AUTO_INCREMENT,
    ProjectID   INT,
    OldVersion  INT,
    NewVersion  INT,
    ChangedAt   DATETIME DEFAULT CURRENT_TIMESTAMP,
	Changes VARCHAR(255),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

DELIMITER //
CREATE TRIGGER log_version_change
BEFORE UPDATE ON Projects
FOR EACH ROW
IF OLD.Version != NEW.Version THEN
    INSERT INTO ProjectChangelog (ProjectID, OldVersion, NewVersion, Changes)
    VALUES (OLD.ProjectID, OLD.Version, NEW.Version, NEW.Changes);
END IF//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE AssignScientist(IN sid INT, IN pid INT)
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
END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION ScientistWorkload(sid INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE workload INT;
    SELECT COUNT(*) INTO workload FROM ScientistProjects WHERE ScientistID = sid;
    RETURN workload;
END//
DELIMITER ;
