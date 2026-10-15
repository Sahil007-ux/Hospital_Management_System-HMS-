USE [Hospital_Management_System];
GO

BEGIN TRY
    BEGIN TRANSACTION;

    EXEC sys.sp_rename
        N'dbo.Hospital.Name', N'Hospital_Name', N'COLUMN';

    EXEC sys.sp_rename
        N'dbo.Hospital.Type', N'Hospital_Type', N'COLUMN';

    EXEC sys.sp_rename
        N'dbo.Appointment.Status', N'Appointment_Status', N'COLUMN';

    EXEC sys.sp_rename
        N'dbo.Appointment.Patients_ID', N'Patient_ID', N'COLUMN';

    EXEC sys.sp_rename
        N'dbo.Bills.Ammount', N'Amount', N'COLUMN';

    EXEC sys.sp_rename
        N'dbo.Bills.Payment_Satus', N'Payment_Status', N'COLUMN';

    EXEC sys.sp_rename
        N'dbo.Department.Loaction', N'Location', N'COLUMN';

    EXEC sys.sp_rename
        N'dbo.Patient.FisrtName', N'First_Name', N'COLUMN';

    EXEC sys.sp_rename
        N'dbo.Patient.LastName', N'Last_Name', N'COLUMN';

    EXEC sys.sp_rename
        N'dbo.Patient.DateOfBirth', N'Date_Of_Birth', N'COLUMN';

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO