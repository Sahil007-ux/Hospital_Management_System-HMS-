INSERT INTO dbo.Admission
(
    Admission_ID,
    Patient_ID,
    Admission_Date,
    Admission_Discharge_Date,
    Admission_Reason
)
VALUES
(4, 24, '2026-11-04 11:00:00', NULL, N'Admission for pediatric observation'),
(5, 25, '2026-11-04 12:00:00', NULL, N'Admission for medical evaluation'),
(6, 26, '2026-11-04 13:00:00', NULL, N'Admission for pediatric treatment');
GO