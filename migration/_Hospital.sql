CREATE TABLE Hospital
(
	Hospital_ID INT IDENTITY (1,1) NOT NULL,
	Name NVARCHAR(150) NOT NULL,
	Type NVARCHAR(50) NULL,
	Bed_Capacity INT NULL,
	Contact_Number VARCHAR(20) NULL,
	Email VARCHAR(100) NULL,
	Address NVARCHAR(260) NULL,
	License_Number VARCHAR(50) NOT NULL,


	-- Constraints

	CONSTRAINT Pk_Hospital PRIMARY KEY (Hospital_ID),
	CONSTRAINT UQ_Hospital_License UNIQUE (License_Number),
	CONSTRAINT UQ_Hopital_Email UNIQUE(Email),
	CONSTRAINT CHK_Bed_Capacity CHECK (Bed_Capacity >= 0)

);
GO