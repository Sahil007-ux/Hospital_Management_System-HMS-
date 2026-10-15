USE [Hospital_Management_System];
GO

SELECT
    Bill_ID,
    Patient_ID,
    Admission_ID,
    Bill_Date,
    Bill_Total AS Total_AFN,
    Bill_Paid_Amount AS Paid_AFN,
    Bill_Balance AS Balance_AFN,
    Bill_Payment_Status
FROM dbo.vw_Bill_Summary
ORDER BY Bill_ID;