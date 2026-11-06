USE Hospital_Management_System;
GO

UPDATE dbo.Appointment
SET Appointment_Status = 'Completed'
WHERE Appointment_ID = 1
  AND Appointment_Status = 'Scheduled';
GO

-- بررسی نتیجه
SELECT *
FROM dbo.Appointment
WHERE Appointment_ID = 1;