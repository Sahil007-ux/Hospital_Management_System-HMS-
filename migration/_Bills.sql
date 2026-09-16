CREATE TABLE Bills
(
	Bill_ID INT PRIMARY KEY,
	Patient_ID INT NOT NULL,
	Addmission_ID INT,
	Ammount DECIMAL(10,2) NOT NULL,
	Bill_Date DATE NOT NULL,
	Payment_Satus VARCHAR(20) NOT NULL,
	FOREIGN KEY (Patient_ID) REFERENCES Patients(PatientsID),
	FOREIGN KEY (Addmission_ID) REFERENCES Addmission(Addmission_ID)

);