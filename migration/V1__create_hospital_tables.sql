
CREATE DATABASE HopitalDB

CREATE TABLE Patients
(
	PatientsID INT IDENTITY(1,1) primary key,
	FistName VARCHAR(50) not null,
	LastName VARCHAR(50) not null,
	Gender CHAR(7),
	CONSTRAINT chk_Gender CHECK (Gender IN('Male','Female'))
);
