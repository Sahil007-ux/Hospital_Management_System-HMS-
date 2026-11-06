USE Hospital_Management_System;
GO

INSERT INTO dbo.Nurse_Assignment
(
    Nurse_ID,
    Admission_ID,
    Nurse_Assignment_Start,
    Nurse_Assignment_End
)
VALUES
(4, 4, '2026-11-04 11:00:00', NULL),
(5, 5, '2026-11-04 12:00:00', NULL),
(6, 6, '2026-11-04 13:00:00', NULL),
(7, 7, '2026-11-05 09:00:00', NULL),
(8, 8, '2026-11-05 10:00:00', NULL),
(9, 9, '2026-11-05 11:00:00', NULL),
(10, 10, '2026-11-05 12:00:00', NULL);
GO

SELECT *
FROM dbo.Nurse_Assignment
ORDER BY Nurse_Assignment_ID;