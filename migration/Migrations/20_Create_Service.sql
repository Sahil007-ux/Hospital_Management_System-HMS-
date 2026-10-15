USE [Hospital_Management_System];
GO

CREATE TABLE dbo.Service
(
    Service_ID INT IDENTITY(1,1) NOT NULL,
    Service_Code VARCHAR(30) NOT NULL,
    Service_Name NVARCHAR(150) NOT NULL,
    Default_Price DECIMAL(12,2) NOT NULL,
    Is_Active BIT NOT NULL
        CONSTRAINT DF_Service_IsActive DEFAULT (1),

    CONSTRAINT PK_Service
        PRIMARY KEY (Service_ID),

    CONSTRAINT UQ_Service_Code
        UNIQUE (Service_Code),

    CONSTRAINT CK_Service_DefaultPrice
        CHECK (Default_Price >= 0)
);