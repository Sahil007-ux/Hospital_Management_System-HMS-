USE [Hospital_Management_System];
GO

ALTER TABLE dbo.Receptionist
ADD CONSTRAINT UQ_Receptionist_Employee
    UNIQUE (Employee_ID);