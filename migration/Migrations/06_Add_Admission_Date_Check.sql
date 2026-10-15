USE [Hospital_Management_System];
GO

ALTER TABLE dbo.Admission WITH CHECK
ADD CONSTRAINT CK_Admission_Dates
CHECK (
    Discharge_Date IS NULL
    OR Discharge_Date >= Admission_Date
);
GO