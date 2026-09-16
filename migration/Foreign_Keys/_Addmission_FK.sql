ALTER TABLE Addmission
	CONSTRAINT FK_Admission_Ptient
	FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),

	CONSTRAINT FK_Admission_Room
	FOREIGN KEY (Room_ID) REFERENCES Rooms(Room_ID),

	CONSTRAINT CK_Admission_Dates
		CHECK (
			Discharge_Date IS NULL
			OR Discharge_Date >= Admission_Date
		);
