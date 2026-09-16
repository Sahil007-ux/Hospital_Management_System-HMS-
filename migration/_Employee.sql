CREATE TABLE Employee
(
	Employee_ID INT PRIMARY KEY,
	Name NVARCHAR(100) NOT NULL,
	Gender CHAR(7),
	CONSTRAINT chk1_Gender CHECK (Gender IN('Male','Female')),
	Phone VARCHAR(20) NULL,
	Email VARCHAR(254) null,
	Salary DECIMAL(12,2) NOT NULL,
	State NVARCHAR(50) NULL,
	City NVARCHAR(50) NULL,
    CONSTRAINT CK_Employee_Salary
	CHECK (Salary >=0 )

);