CREATE TABLE Addmission 
(
	
	Admission_ID INT PRIMARY KEY,
	Patient_ID INT NOT NULL,
	Room_ID INT NOT NULL,
	Admission_Date DATE NOT NULL,
	Discharge_Date DATE NULL,
	Reason NVARCHAR(500) NOT NULL,
	

);





CREATE TABLE Appointment
(
	Appointment_ID INT PRIMARY KEY,
	Patients_ID INT NOT NULL,
	Doctor_ID INT NOT NULL,
	Appointment_Date DATE,
	Appointment_Time TIME,
	Reason VARCHAR(300),
	Status VARCHAR(50),



);





CREATE TABLE Bills
(
	Bill_ID INT PRIMARY KEY,
	Patient_ID INT NOT NULL,
	Addmission_ID INT,
	Ammount DECIMAL(10,2) NOT NULL,
	Bill_Date DATE NOT NULL,
	Payment_Satus VARCHAR(20) NOT NULL,


);




CREATE TABLE Department

( 
	Department_ID INT PRIMARY KEY,
	Department_Name VARCHAR(100) NOT NULL,
	Loaction VARCHAR(100)

);





CREATE TABLE Doctor

(	
	Doctor_ID INT PRIMARY KEY,
	Employee_ID INT UNIQUE NOT NULL,
	Department_ID INT NOT NULL,
	Specialization VARCHAR(100) NOT NULL,
	Qualification VARCHAR(100) NOT NULL,
	Department VARCHAR(100) NOT NULL,

);







CREATE TABLE Employee
(
	Employee_ID INT PRIMARY KEY,
	Name NVARCHAR(100) NOT NULL,
	Gender CHAR(7),
	CONSTRAINT chk1_Gender CHECK (Gender IN('Male','Female')),
	Phone VARCHAR(20) NULL,
	Email VARCHAR(254) null,
	Salary DECIMAL(12,2) NOT NULL,
	State NVARCHAR(50) NULL,
	City NVARCHAR(50) NULL,
    CONSTRAINT CK_Employee_Salary
	CHECK (Salary >=0 )

);




CREATE TABLE Hospital
(
	Hospital_ID INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
	Name NVARCHAR(150) NOT NULL,
	Type NVARCHAR(50) NULL,
	Bed_Capacity INT NULL,
	Contact_Number VARCHAR(20) NULL,
	Email VARCHAR(100) NULL,
	Address NVARCHAR(260) NULL,
	License_Number VARCHAR(50) NOT NULL,


	-- Constraints

);
GO




CREATE TABLE Medical_Record
(

	Record_ID INT PRIMARY KEY NOT NULL,
	Patient_ID INT NOT NULL,
	Doctor_ID INT NOT NULL,
	Record_Date DATE NOT NULL,
	Diagnoses NVARCHAR(500) NOT NULL,
	Treatment NVARCHAR(1000)  NULL,
	Notes NVARCHAR(1000) NULL,


);




CREATE TABLE Nurse
(
	Nurse_ID INT PRIMARY KEY NOT NULL,
	Employee_ID INT NOT NULL UNIQUE,
	Qualification NVARCHAR(100) NOT NULL,
	Shift NVARCHAR(20) NOT NULL,
    CONSTRAINT FK_Nurse_Employee
);




CREATE TABLE Receptionist
(
	Receptionist_ID INT  PRIMARY KEY NOT NULL,
	Employee_ID INT NOT NULL,
	Desk_Number VARCHAR(20) NOT NULL,
	Shift NVARCHAR(20) NOT NULL,
);	

 


 


CREATE TABLE Patient
(

	Patient_ID INT IDENTITY(1,1) primary key,
	FisrtName VARCHAR(50) not null,
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




CREATE TABLE Rooms
(

	Room_ID INT PRIMARY KEY,
	Room_Number VARCHAR(10) NOT NULL UNIQUE,
	Floor_Number INT NOT NULL,
	Daily_Charge DECIMAL(12,2) NOT NULL,
	Room_Type NVARCHAR(50) NOT NULL,
	Availability_Status NVARCHAR(20) NOT NULL,
	Capacity INT NOT NULL,

	CONSTRAINT CK_Rooms_DailyCharge
	CHECK (Daily_Charge >= 0),

	CONSTRAINT CK_Rooms_Capacity
	CHECK (Capacity > 0)

);




CREATE TABLE Test_Report
(

	Report_ID INT PRIMARY KEY,
	Patient_ID INT NOT NULL,
	Doctor_ID INT NOT NULL,
	Test_Date DATE NOT NULL,
	Test_Type NVARCHAR(100) NOT NULL,
	Result NVARCHAR(1000) NULL,

);
