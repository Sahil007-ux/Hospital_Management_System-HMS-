USE Hospital_Management_System;
GO

EXEC sys.sp_rename
    @objname = N'dbo.Employee.Name',
    @newname = N'Employee_Name',
    @objtype = N'COLUMN';
GO