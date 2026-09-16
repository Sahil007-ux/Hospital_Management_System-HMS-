CREATE TABLE Rooms
(

	Room_ID INT PRIMARY KEY,
	Room_Number VARCHAR(10) NOT NULL UNIQUE,
	Floor_Number INT NOT NULL,
	Daily_Charge DECIMAL(12,2) NOT NULL,
	Room_Type NVARCHAR(50) NOT NULL,
	Availability_Status NVARCHAR(20) NOT NULL,
	Capacity INT NOT NULL,

	CONSTRAINT CK_Rooms_DailyCharge
	CHECK (Daily_Charge >= 0),

	CONSTRAINT CK_Rooms_Capacity
	CHECK (Capacity > 0)

);