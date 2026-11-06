USE Hospital_Management_System;
GO

INSERT INTO dbo.Payment
(
    Bill_ID,
    Payment_Date,
    Payment_Amount,
    Payment_Method,
    Payment_Reference_Number,
    Payment_Notes
)
VALUES
(2, '2026-11-05 13:00:00', 500.00, 'Cash', N'RCPT-20261105-003', N'Remaining balance payment'),
(3, '2026-11-05 13:30:00', 1800.00, 'Cash', N'RCPT-20261105-004', N'Full payment'),
(4, '2026-11-05 14:00:00', 500.00, 'Cash', N'RCPT-20261105-005', N'Full payment'),
(5, '2026-11-05 14:30:00', 1500.00, 'Cash', N'RCPT-20261105-006', N'Full payment'),
(6, '2026-11-05 15:00:00', 500.00, 'Cash', N'RCPT-20261105-007', N'Full payment'),
(7, '2026-11-05 15:30:00', 500.00, 'Cash', N'RCPT-20261105-008', N'Full payment'),
(8, '2026-11-05 16:00:00', 400.00, 'Cash', N'RCPT-20261105-009', N'Full payment'),
(9, '2026-11-05 16:30:00', 1500.00, 'Cash', N'RCPT-20261105-010', N'Full payment'),
(10, '2026-11-05 17:00:00', 1000.00, 'Cash', N'RCPT-20261105-011', N'Full payment');
GO

SELECT *
FROM dbo.Payment
ORDER BY Payment_ID;