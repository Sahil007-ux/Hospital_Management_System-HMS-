USE Hospital_Management_System;
GO

INSERT INTO dbo.Test_Report
(
    Test_Report_ID,
    Patient_ID,
    Doctor_ID,
    Test_Report_Date,
    Test_Report_Type,
    Test_Report_Result
)
VALUES
(4, 24, 10, '2026-11-05',
 N'Complete Blood Count',
 N'WBC: 7.8 x10^9/L; Hemoglobin: 13.5 g/dL; Platelets: 265 x10^9/L'),

(5, 25, 10, '2026-11-05',
 N'Blood Glucose Test',
 N'Fasting Blood Glucose: 95 mg/dL'),

(6, 26, 9, '2026-11-05',
 N'Chest X-Ray',
 N'No obvious acute abnormality identified in the chest X-ray.'),

(7, 32, 10, '2026-11-05',
 N'Urinalysis',
 N'Color: Yellow; Appearance: Clear; Protein: Negative; Glucose: Negative'),

(8, 33, 10, '2026-11-05',
 N'Lipid Profile',
 N'Total Cholesterol: 180 mg/dL; HDL: 50 mg/dL; LDL: 110 mg/dL; Triglycerides: 100 mg/dL'),

(9, 34, 9, '2026-11-05',
 N'Electrocardiogram (ECG)',
 N'Normal sinus rhythm recorded; clinical correlation advised.'),

(10, 35, 10, '2026-11-05',
 N'Thyroid Function Test',
 N'TSH: 2.1 mIU/L; Free T4: 1.2 ng/dL');
GO

SELECT *
FROM dbo.Test_Report
ORDER BY Test_Report_ID;