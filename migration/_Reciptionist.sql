create table Receptionist 
(
	Receptionist_ID INT  PRIMARY KEY NOT NULL,
	Employee_ID INT NOT NULL,
	Desk_Number VARCHAR(20) NOT NULL,
	Shift NVARCHAR(20) NOT NULL,
    CONSTRAINT FK_Receptionist_Employee
	FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);	

 
