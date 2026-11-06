USE Hospital_Management_System;
GO

INSERT INTO dbo.Appointment
(
    Appointment_ID,
    Patient_ID,
    Doctor_ID,
    Appointment_Date,
    Appointment_Time,
    Appointment_Reason,
    Appointment_Status
)
VALUES
(4, 21, 1, '2026-11-06', '09:00', 'Emergency follow-up consultation', 'Scheduled'),
(5, 22, 2, '2026-11-06', '10:00', 'Internal medicine consultation', 'Scheduled'),
(6, 23, 3, '2026-11-06', '11:00', 'Surgical evaluation', 'Scheduled'),
(7, 32, 4, '2026-11-07', '09:30', 'Pediatric health examination', 'Scheduled'),
(8, 33, 5, '2026-11-07', '10:30', 'Internal medicine follow-up', 'Scheduled'),
(9, 34, 6, '2026-11-08', '11:00', 'General surgery consultation', 'Scheduled'),
(10, 35, 7, '2026-11-08', '12:00', 'Pediatric treatment follow-up', 'Scheduled');
GO