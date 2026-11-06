USE Hospital_Management_System;
GO

-- Add 4 new admissions

INSERT INTO dbo.Admission
(
    Admission_ID,
    Patient_ID,
    Admission_Date,
    Admission_Discharge_Date,
    Admission_Reason
)
VALUES
(7, 32, '2026-11-05 09:00:00', NULL,
 N'Admission for general medical examination'),

(8, 33, '2026-11-05 10:00:00', NULL,
 N'Admission for pediatric treatment'),

(9, 34, '2026-11-05 11:00:00', NULL,
 N'Admission for internal medicine evaluation'),

(10, 35, '2026-11-05 12:00:00', NULL,
 N'Admission for general medical observation');
GO