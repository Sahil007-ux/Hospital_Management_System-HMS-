USE Hospital_Management_System;
GO

EXEC sys.sp_rename 
     @objname = N'dbo.Bills.Addmission_ID',
     @newname = N'Admission_ID',
     @objtype = N'COLUMN';

     GO