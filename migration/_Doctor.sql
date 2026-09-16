CREATE TABLE Doctor

(	
	Doctor_ID INT PRIMARY KEY,
	Employee_ID INT UNIQUE NOT NULL,
	Department_ID INT NOT NULL,
	Specialization VARCHAR(100) NOT NULL,
	Qualification VARCHAR(100) NOT NULL,
	Department VARCHAR(100) NOT NULL,

);


