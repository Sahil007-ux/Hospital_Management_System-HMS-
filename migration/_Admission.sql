CREATE TABLE Addmission 
(
	
	Admission_ID INT PRIMARY KEY,
	Patient_ID INT NOT NULL,
	Room_ID INT NOT NULL,
	Admission_Date DATE NOT NULL,
	Discharge_Date DATE NULL,
	Reason NVARCHAR(500) NOT NULL,
	

);