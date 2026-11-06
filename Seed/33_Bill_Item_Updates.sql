USE Hospital_Management_System;
GO

INSERT INTO dbo.Bill_Item
(
    Bill_ID,
    Service_ID,
    Bill_Item_Description,
    Bill_Item_Service_Date,
    Bill_Item_Quantity,
    Bill_Item_Unit_Price
)
VALUES
(8, 7, N'Complete Blood Count', '2026-11-05 10:30:00', 1, 400.00),
(9, 10, N'Internal Medicine Daily Stay', '2026-11-05 11:30:00', 1, 1500.00),
(10, 9, N'Emergency Room Daily Stay', '2026-11-05 12:30:00', 1, 1000.00);
GO

SELECT
    Bill_ID,
    Service_ID,
    Bill_Item_Description,
    Bill_Item_Quantity,
    Bill_Item_Unit_Price,
    Bill_Item_Line_Total
FROM dbo.Bill_Item
WHERE Bill_ID IN (8, 9, 10)
ORDER BY Bill_ID;