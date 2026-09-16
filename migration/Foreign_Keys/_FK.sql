

-- Department
ALTER TABLE Department
ADD CONSTRAINT fk_dept_hospital
FOREIGN KEY (Hospital_ID) REFERENCES Hospital(Hospital_ID);

-- Doctor
ALTER TABLE Doctor
ADD CONSTRAINT fk_doc_employee
FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID);

ALTER TABLE Doctor
ADD CONSTRAINT fk_doc_dept
FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID);

-- Appointment
ALTER TABLE Appointment
ADD CONSTRAINT fk_appt_patient
FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID);

ALTER TABLE Appointment
ADD CONSTRAINT fk_appt_doctor
FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID);

-- Admission
ALTER TABLE Admission
ADD CONSTRAINT fk_adm_patient
FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID);
