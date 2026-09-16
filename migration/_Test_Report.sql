CREATE TABLE Test_Report
(

	Report_ID INT PRIMARY KEY,
	Patient_ID INT NOT NULL,
	Doctor_ID INT NOT NULL,
	Test-Date DATE NOT NULL,
	Test-Type NVARCHAR(100) NOT NULL,
	Result NVARCHAR(1000) NULL,

	CONSTRAINT FK_Test_Report_Patient
	FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),

	CONSTRAINT FK_Test_Report_Doctor
	FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)

);