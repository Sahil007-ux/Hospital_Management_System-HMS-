CREATE TABLE Medical_Record
(

	Record_ID INT PRIMARY KEY NOT NULL,
	Patient_ID INT NOT NULL,
	Doctor_ID INT NOT NULL,
	Record_Date DATE NOT NULL,
	Diagnoses NVARCHAR(500) NOT NULL,
	Treatment NVARCHAR(1000)  NULL,
	Notes NVARCHAR(1000) NULL,

	CONSTRAINT FK_Medical_Record_Patient
		FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),

	CONSTRAINT FK_Medical_Record_Doctor
		FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)

);