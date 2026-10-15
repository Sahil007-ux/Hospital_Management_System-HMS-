USE [Hospital_Management_System];
GO

BEGIN TRY
    BEGIN TRANSACTION;

    ALTER TABLE dbo.Receptionist WITH CHECK
    ADD CONSTRAINT FK_Receptionist_Employee
        FOREIGN KEY (Employee_ID)
        REFERENCES dbo.Employee(Employee_ID);

    ALTER TABLE dbo.Test_Report WITH CHECK
    ADD CONSTRAINT FK_TestReport_Patient
        FOREIGN KEY (Patient_ID)
        REFERENCES dbo.Patient(Patient_ID);

    ALTER TABLE dbo.Test_Report WITH CHECK
    ADD CONSTRAINT FK_TestReport_Doctor
        FOREIGN KEY (Doctor_ID)
        REFERENCES dbo.Doctor(Doctor_ID);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO