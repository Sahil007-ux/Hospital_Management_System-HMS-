USE Hospital_Management_System
GO

EXEC sys.sp_rename
     @objname = N'dbo.Addmission',
     @newname = N'Admission',
     @objtype = N'OBJECT';

GO