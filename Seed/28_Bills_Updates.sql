USE Hospital_Management_System;
GO

INSERT INTO dbo.Bills
(
    Bill_ID,
    Patient_ID,
    Admission_ID,
    Bill_Date
)
VALUES
(4, 24, 4, '2026-11-04'),
(5, 25, 5, '2026-11-04'),
(6, 26, 6, '2026-11-04'),
(7, 32, 7, '2026-11-05'),
(8, 33, 8, '2026-11-05'),
(9, 34, 9, '2026-11-05'),
(10, 35, 10, '2026-11-05');
GO