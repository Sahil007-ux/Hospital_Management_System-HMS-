USE Hospital_Management_System;
GO

INSERT INTO dbo.Service
(
    Service_Code,
    Service_Name,
    Service_Default_Price,
    Service_Is_Active
)
VALUES
('CARD-ECG', N'Electrocardiogram (ECG)', 500.00, 1),
('IMG-CXR', N'Chest X-Ray', 700.00, 1),
('TREAT-OXY', N'Oxygen Therapy', 600.00, 1);
GO

SELECT *
FROM dbo.Service
ORDER BY Service_ID;