CREATE TABLE Addmission 
(
	
	Admission_ID INT PRIMARY KEY,
	Patient_ID INT NOT NULL,
	Room_ID INT NOT NULL,
	Admission_Date DATE NOT NULL,
	Discharge_Date DATE NULL,
	Reason NVARCHAR(500) NOT NULL,
	
	CONSTRAINT FK_Admission_Ptient
	FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),

	CONSTRAINT FK_Admission_Room
	FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID),

	CONSTRAINT CK_Admission_Dates
		CHECK (
			Discharge_Date IS NULL
			OR Discharge_Date >= Admission_Date
		)
);