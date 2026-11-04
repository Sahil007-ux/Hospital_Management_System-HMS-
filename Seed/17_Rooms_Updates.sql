USE Hospital_Management_System;
GO

INSERT INTO dbo.Rooms
(
    Room_ID,
    Room_Number,
    Room_Floor_Number,
    Room_Daily_Charge,
    Room_Type,
    Room_Availability_Status,
    Room_Capacity,
    Department_ID
)
VALUES
(4, 'ER-02', 0, 1200.00, N'General', N'Available', 3, 1),
(5, 'IM-02', 1, 2500.00, N'Private', N'Available', 1, 2),
(6, 'SU-02', 2, 3000.00, N'General', N'Available', 3, 3),
(7, 'PED-01', 3, 1800.00, N'General', N'Available', 3, 4),
(8, 'ICU-01', 2, 5000.00, N'ICU', N'Available', 1, 5);
GO


INSERT INTO dbo.Rooms
(
    Room_ID,
    Room_Number,
    Room_Floor_Number,
    Room_Daily_Charge,
    Room_Type,
    Room_Availability_Status,
    Room_Capacity,
    Department_ID
)
VALUES
(9, 'RAD-01', 0, 2200.00, N'General', N'Available', 2, 6),
(10, 'LAB-01', 0, 1000.00, N'General', N'Available', 2, 7),
(11, 'ER-03', 0, 1500.00, N'General', N'Available', 4, 1);
GO