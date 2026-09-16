CREATE TABLE Appointment
(
	Appointment_ID INT PRIMARY KEY,
	Patients_ID INT NOT NULL,
	Doctor_ID INT NOT NULL,
	Appointment_Date DATE,
	Appointment_Time TIME,
	Reason VARCHAR(300),
	Status VARCHAR(50),
	FOREIGN KEY (Patinet_ID) REFERENCES Patient(Patient_ID),
	FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)



);
