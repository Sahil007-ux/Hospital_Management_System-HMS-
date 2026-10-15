USE [Hospital_Management_System];
GO

CREATE OR ALTER VIEW dbo.vw_Bill_Summary
AS
WITH ItemTotals AS
(
    SELECT
        Bill_ID,
        SUM(Bill_Item_Line_Total) AS Bill_Total
    FROM dbo.Bill_Item
    GROUP BY Bill_ID
),
PaymentTotals AS
(
    SELECT
        Bill_ID,
        SUM(Payment_Amount) AS Bill_Paid_Amount
    FROM dbo.Payment
    GROUP BY Bill_ID
)
SELECT
    b.Bill_ID,
    b.Patient_ID,
    b.Admission_ID,
    b.Bill_Date,

    ISNULL(i.Bill_Total, 0) AS Bill_Total,
    ISNULL(p.Bill_Paid_Amount, 0) AS Bill_Paid_Amount,

    ISNULL(i.Bill_Total, 0)
        - ISNULL(p.Bill_Paid_Amount, 0)
        AS Bill_Balance,

    CASE
        WHEN ISNULL(p.Bill_Paid_Amount, 0)
             > ISNULL(i.Bill_Total, 0)
            THEN 'Overpaid'

        WHEN ISNULL(i.Bill_Total, 0) = 0
            THEN 'NoCharge'

        WHEN ISNULL(p.Bill_Paid_Amount, 0) = 0
            THEN 'Unpaid'

        WHEN p.Bill_Paid_Amount < i.Bill_Total
            THEN 'PartiallyPaid'

        ELSE 'Paid'
    END AS Bill_Payment_Status

FROM dbo.Bills AS b
LEFT JOIN ItemTotals AS i
    ON i.Bill_ID = b.Bill_ID
LEFT JOIN PaymentTotals AS p
    ON p.Bill_ID = b.Bill_ID;
GO

SELECT *
FROM dbo.vw_Bill_Summary;