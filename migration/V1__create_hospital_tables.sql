create table Patients
(
	PatientsID int identity(1,1) primary key,
	FistName varchar(50) not null,
	LastName varchar(50) not null,
	Gender char(7),
	constraint chk_Gender check (Gender IN('Male','Female'))
);
