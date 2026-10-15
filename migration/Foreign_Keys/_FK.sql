-- REFERENCE ONLY: already included in _Master_Query.sql. Do not execute twice.
ALTER TABLE [dbo].[Admission]  WITH CHECK ADD  CONSTRAINT [FK_Addmission_Patient] FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([Patient_ID])
GO

ALTER TABLE [dbo].[Admission] CHECK CONSTRAINT [FK_Addmission_Patient]
GO

ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [FK_Appointment_Doctor] FOREIGN KEY([Doctor_ID])
REFERENCES [dbo].[Doctor] ([Doctor_ID])
GO

ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [FK_Appointment_Doctor]
GO

ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [FK_Appointment_Patient] FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([Patient_ID])
GO

ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [FK_Appointment_Patient]
GO

ALTER TABLE [dbo].[Bed]  WITH CHECK ADD  CONSTRAINT [FK_Bed_Room] FOREIGN KEY([Room_ID])
REFERENCES [dbo].[Rooms] ([Room_ID])
GO

ALTER TABLE [dbo].[Bed] CHECK CONSTRAINT [FK_Bed_Room]
GO

ALTER TABLE [dbo].[Bed_Assignment]  WITH CHECK ADD  CONSTRAINT [FK_BedAssignment_Admission] FOREIGN KEY([Admission_ID])
REFERENCES [dbo].[Admission] ([Admission_ID])
GO

ALTER TABLE [dbo].[Bed_Assignment] CHECK CONSTRAINT [FK_BedAssignment_Admission]
GO

ALTER TABLE [dbo].[Bed_Assignment]  WITH CHECK ADD  CONSTRAINT [FK_BedAssignment_Bed] FOREIGN KEY([Bed_ID])
REFERENCES [dbo].[Bed] ([Bed_ID])
GO

ALTER TABLE [dbo].[Bed_Assignment] CHECK CONSTRAINT [FK_BedAssignment_Bed]
GO

ALTER TABLE [dbo].[Bill_Item]  WITH CHECK ADD  CONSTRAINT [FK_BillItem_Bill] FOREIGN KEY([Bill_ID])
REFERENCES [dbo].[Bills] ([Bill_ID])
GO

ALTER TABLE [dbo].[Bill_Item] CHECK CONSTRAINT [FK_BillItem_Bill]
GO

ALTER TABLE [dbo].[Bill_Item]  WITH CHECK ADD  CONSTRAINT [FK_BillItem_Service] FOREIGN KEY([Service_ID])
REFERENCES [dbo].[Service] ([Service_ID])
GO

ALTER TABLE [dbo].[Bill_Item] CHECK CONSTRAINT [FK_BillItem_Service]
GO

ALTER TABLE [dbo].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_Admission_Patient] FOREIGN KEY([Admission_ID], [Patient_ID])
REFERENCES [dbo].[Admission] ([Admission_ID], [Patient_ID])
GO

ALTER TABLE [dbo].[Bills] CHECK CONSTRAINT [FK_Bills_Admission_Patient]
GO

ALTER TABLE [dbo].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_Patient] FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([Patient_ID])
GO

ALTER TABLE [dbo].[Bills] CHECK CONSTRAINT [FK_Bills_Patient]
GO

ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [FK_Department_Hospital] FOREIGN KEY([Hospital_ID])
REFERENCES [dbo].[Hospital] ([Hospital_ID])
GO

ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [FK_Department_Hospital]
GO

ALTER TABLE [dbo].[Doctor]  WITH CHECK ADD  CONSTRAINT [FK_Doctor_Department] FOREIGN KEY([Department_ID])
REFERENCES [dbo].[Department] ([Department_ID])
GO

ALTER TABLE [dbo].[Doctor] CHECK CONSTRAINT [FK_Doctor_Department]
GO

ALTER TABLE [dbo].[Doctor]  WITH CHECK ADD  CONSTRAINT [FK_Doctor_Employee] FOREIGN KEY([Employee_ID])
REFERENCES [dbo].[Employee] ([Employee_ID])
GO

ALTER TABLE [dbo].[Doctor] CHECK CONSTRAINT [FK_Doctor_Employee]
GO

ALTER TABLE [dbo].[Medical_Record]  WITH CHECK ADD  CONSTRAINT [FK_MedicalRecord_Doctor] FOREIGN KEY([Doctor_ID])
REFERENCES [dbo].[Doctor] ([Doctor_ID])
GO

ALTER TABLE [dbo].[Medical_Record] CHECK CONSTRAINT [FK_MedicalRecord_Doctor]
GO

ALTER TABLE [dbo].[Medical_Record]  WITH CHECK ADD  CONSTRAINT [FK_MedicalRecord_Patient] FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([Patient_ID])
GO

ALTER TABLE [dbo].[Medical_Record] CHECK CONSTRAINT [FK_MedicalRecord_Patient]
GO

ALTER TABLE [dbo].[Nurse]  WITH CHECK ADD  CONSTRAINT [FK_Nurse_Department] FOREIGN KEY([Department_ID])
REFERENCES [dbo].[Department] ([Department_ID])
GO

ALTER TABLE [dbo].[Nurse] CHECK CONSTRAINT [FK_Nurse_Department]
GO

ALTER TABLE [dbo].[Nurse]  WITH CHECK ADD  CONSTRAINT [FK_Nurse_Employee] FOREIGN KEY([Employee_ID])
REFERENCES [dbo].[Employee] ([Employee_ID])
GO

ALTER TABLE [dbo].[Nurse] CHECK CONSTRAINT [FK_Nurse_Employee]
GO

ALTER TABLE [dbo].[Nurse_Assignment]  WITH CHECK ADD  CONSTRAINT [FK_NurseAssignment_Admission] FOREIGN KEY([Admission_ID])
REFERENCES [dbo].[Admission] ([Admission_ID])
GO

ALTER TABLE [dbo].[Nurse_Assignment] CHECK CONSTRAINT [FK_NurseAssignment_Admission]
GO

ALTER TABLE [dbo].[Nurse_Assignment]  WITH CHECK ADD  CONSTRAINT [FK_NurseAssignment_Nurse] FOREIGN KEY([Nurse_ID])
REFERENCES [dbo].[Nurse] ([Nurse_ID])
GO

ALTER TABLE [dbo].[Nurse_Assignment] CHECK CONSTRAINT [FK_NurseAssignment_Nurse]
GO

ALTER TABLE [dbo].[Payment]  WITH CHECK ADD  CONSTRAINT [FK_Payment_Bill] FOREIGN KEY([Bill_ID])
REFERENCES [dbo].[Bills] ([Bill_ID])
GO

ALTER TABLE [dbo].[Payment] CHECK CONSTRAINT [FK_Payment_Bill]
GO

ALTER TABLE [dbo].[Receptionist]  WITH CHECK ADD  CONSTRAINT [FK_Receptionist_Employee] FOREIGN KEY([Employee_ID])
REFERENCES [dbo].[Employee] ([Employee_ID])
GO

ALTER TABLE [dbo].[Receptionist] CHECK CONSTRAINT [FK_Receptionist_Employee]
GO

ALTER TABLE [dbo].[Rooms]  WITH CHECK ADD  CONSTRAINT [FK_Rooms_Department] FOREIGN KEY([Department_ID])
REFERENCES [dbo].[Department] ([Department_ID])
GO

ALTER TABLE [dbo].[Rooms] CHECK CONSTRAINT [FK_Rooms_Department]
GO

ALTER TABLE [dbo].[Test_Report]  WITH CHECK ADD  CONSTRAINT [FK_TestReport_Doctor] FOREIGN KEY([Doctor_ID])
REFERENCES [dbo].[Doctor] ([Doctor_ID])
GO

ALTER TABLE [dbo].[Test_Report] CHECK CONSTRAINT [FK_TestReport_Doctor]
GO

ALTER TABLE [dbo].[Test_Report]  WITH CHECK ADD  CONSTRAINT [FK_TestReport_Patient] FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([Patient_ID])
GO

ALTER TABLE [dbo].[Test_Report] CHECK CONSTRAINT [FK_TestReport_Patient]
GO
