
CREATE DATABASE HopitalDB

CREATE TABLE Patients
(

	PatientsID INT IDENTITY(1,1) primary key,
	FistName VARCHAR(50) not null,
	LastName VARCHAR(50) not null,
	Gender CHAR(7),
	CONSTRAINT chk_Gender CHECK (Gender IN('Male','Female')),
	Age INT,
	DateOfBirth DATE,
	Phone INT,
	Address VARCHAR(50),
	Blood_Group VARCHAR(3) CHECK (Blood_Group IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
	))

 
);
