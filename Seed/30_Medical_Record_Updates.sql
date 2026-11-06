USE Hospital_Management_System;
GO

INSERT INTO dbo.Medical_Record
(
    Medical_Record_ID,
    Patient_ID,
    Doctor_ID,
    Medical_Record_Date,
    Medical_Record_Diagnoses,
    Medical_Record_Treatment,
    Medical_Record_Notes
)
VALUES
(4, 24, 7, '2026-11-04',
 N'Pediatric fever under evaluation',
 N'Clinical examination and temperature monitoring',
 N'Patient admitted for pediatric observation'),

(5, 25, 2, '2026-11-04',
 N'Internal medicine condition under evaluation',
 N'Inpatient monitoring and diagnostic tests',
 N'Further evaluation required'),

(6, 26, 7, '2026-11-04',
 N'Pediatric infection under evaluation',
 N'Supportive treatment and clinical monitoring',
 N'Response to treatment to be monitored'),

(7, 32, 5, '2026-11-05',
 N'General medical symptoms under evaluation',
 N'Clinical examination and laboratory investigation',
 N'Initial assessment completed'),

(8, 33, 7, '2026-11-05',
 N'Pediatric condition under evaluation',
 N'Pediatric examination and supportive care',
 N'Follow-up assessment required'),

(9, 34, 2, '2026-11-05',
 N'Internal medicine symptoms under evaluation',
 N'Clinical monitoring and diagnostic evaluation',
 N'Further assessment pending'),

(10, 35, 7, '2026-11-05',
 N'General pediatric observation',
 N'Clinical examination and inpatient observation',
 N'Patient condition to be monitored');
GO