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
(4, 5, N'General Medical Consultation',
 '2026-11-04 11:30:00', 1, 500),

(5, 10, N'Internal Medicine Daily Stay',
 '2026-11-04 12:30:00', 1, 1500),

(6, 5, N'General Medical Consultation',
 '2026-11-04 13:30:00', 1, 500),

(7, 5, N'General Medical Consultation',
 '2026-11-05 09:30:00', 1, 500);
GO