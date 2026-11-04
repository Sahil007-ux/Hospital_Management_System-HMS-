USE Hospital_Management_System;
GO

INSERT INTO dbo.Department
(
    Department_ID,
    Department_Name,
    Department_Location,
    Hospital_ID
)
VALUES
(4, 'Pediatrics', 'Third Floor', 15),
(5, 'Intensive Care Unit', 'Second Floor', 15),
(6, 'Radiology', 'Ground Floor', 15),
(7, 'Laboratory', 'Ground Floor', 15);
GO