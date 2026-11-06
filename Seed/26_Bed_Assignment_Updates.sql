USE Hospital_Management_System;
GO

INSERT INTO dbo.Bed_Assignment
(
    Admission_ID,
    Bed_ID,
    Bed_Assignment_Start,
    Bed_Assignment_End
)
VALUES
(7, 12, '2026-11-05 09:00:00', NULL),
(8, 24, '2026-11-05 10:00:00', NULL),
(9, 14, '2026-11-05 11:00:00', NULL),
(10, 16, '2026-11-05 12:00:00', NULL);
GO