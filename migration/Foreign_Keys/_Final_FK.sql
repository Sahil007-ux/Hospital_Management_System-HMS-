


-- Foreign Keys for Addmission
ALTER TABLE Addmission
ADD CONSTRAINT FK_Addmission_Patient FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID);

ALTER TABLE Addmission
ADD CONSTRAINT FK_Addmission_Room FOREIGN KEY (Room_ID) REFERENCES Rooms(Room_ID);

-- Foreign Keys for Appointment
ALTER TABLE Appointment
ADD CONSTRAINT FK_Appointment_Patient FOREIGN KEY (Patients_ID) REFERENCES Patient(Patient_ID);

ALTER TABLE Appointment
ADD CONSTRAINT FK_Appointment_Doctor FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID);

-- Foreign Keys for Bills
ALTER TABLE Bills
ADD CONSTRAINT FK_Bills_Patient FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID);

ALTER TABLE Bills
ADD CONSTRAINT FK_Bills_Addmission FOREIGN KEY (Addmission_ID) REFERENCES Addmission(Admission_ID);

-- Foreign Keys for Doctor
ALTER TABLE Doctor
ADD CONSTRAINT FK_Doctor_Employee FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID);

ALTER TABLE Doctor
ADD CONSTRAINT FK_Doctor_Department FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID);

-- Foreign Keys for Medical_Record
ALTER TABLE Medical_Record
ADD CONSTRAINT FK_MedicalRecord_Patient FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID);

ALTER TABLE Medical_Record
ADD CONSTRAINT FK_MedicalRecord_Doctor FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID);

-- Foreign Keys for Nurse
ALTER TABLE Nurse
ADD CONSTRAINT FK_Nurse_Employee FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID);

-- Foreign Keys for Receptionist
ALTER TABLE Receptionist
ADD CONSTRAINT FK_Receptionist_Employee FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID);

-- Foreign Keys for Test_Report
ALTER TABLE Test_Report
ADD CONSTRAINT FK_TestReport_Patient FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID);

ALTER TABLE Test_Report
ADD CONSTRAINT FK_TestReport_Doctor FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID);
