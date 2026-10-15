-- 23_Standardize_Column_Names_Fixed.sql
-- Corrected dependency handling: CHECKs, filtered indexes, computed column and triggers.
-- SQL Server 2022 / Hospital_Management_System
-- Run the WHOLE file in SSMS. No table or application rows are deleted.
-- Own columns use the entity prefix; FKs retain the referenced entity's name.
-- Payment is optional because it was absent from the inspected schema.
-- This migration also updates the five assignment triggers created in steps 16/18/19.
-- Use this migration on the existing database; do not replay earlier migrations afterward.

USE [Hospital_Management_System];
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

DECLARE @Renames TABLE
(
    Table_Name SYSNAME NOT NULL,
    Old_Name SYSNAME NOT NULL,
    New_Name SYSNAME NOT NULL,
    Is_Required BIT NOT NULL,
    Is_Computed BIT NOT NULL,
    PRIMARY KEY (Table_Name, Old_Name)
);

INSERT INTO @Renames VALUES
    (N'Admission', N'Discharge_Date', N'Admission_Discharge_Date', 1, 0),
    (N'Admission', N'Reason', N'Admission_Reason', 1, 0),
    (N'Appointment', N'Reason', N'Appointment_Reason', 1, 0),
    (N'Bed', N'Is_Active', N'Bed_Is_Active', 1, 0),
    (N'Bed_Assignment', N'Assigned_From', N'Bed_Assignment_Start', 1, 0),
    (N'Bed_Assignment', N'Assigned_To', N'Bed_Assignment_End', 1, 0),
    (N'Bill_Item', N'Service_Description', N'Bill_Item_Description', 1, 0),
    (N'Bill_Item', N'Service_Date', N'Bill_Item_Service_Date', 1, 0),
    (N'Bill_Item', N'Quantity', N'Bill_Item_Quantity', 1, 0),
    (N'Bill_Item', N'Unit_Price', N'Bill_Item_Unit_Price', 1, 0),
    (N'Bill_Item', N'Line_Total', N'Bill_Item_Line_Total', 1, 1),
    (N'Bills', N'Amount', N'Bill_Amount', 1, 0),
    (N'Bills', N'Payment_Status', N'Bill_Payment_Status', 1, 0),
    (N'Department', N'Location', N'Department_Location', 1, 0),
    (N'Doctor', N'Specialization', N'Doctor_Specialization', 1, 0),
    (N'Doctor', N'Qualification', N'Doctor_Qualification', 1, 0),
    (N'Doctor', N'Department', N'Doctor_Department', 1, 0),
    (N'Employee', N'Gender', N'Employee_Gender', 1, 0),
    (N'Employee', N'Phone', N'Employee_Phone', 1, 0),
    (N'Employee', N'Email', N'Employee_Email', 1, 0),
    (N'Employee', N'Salary', N'Employee_Salary', 1, 0),
    (N'Employee', N'State', N'Employee_State', 1, 0),
    (N'Employee', N'City', N'Employee_City', 1, 0),
    (N'Hospital', N'Bed_Capacity', N'Hospital_Bed_Capacity', 1, 0),
    (N'Hospital', N'Contact_Number', N'Hospital_Contact_Number', 1, 0),
    (N'Hospital', N'Email', N'Hospital_Email', 1, 0),
    (N'Hospital', N'Address', N'Hospital_Address', 1, 0),
    (N'Hospital', N'License_Number', N'Hospital_License_Number', 1, 0),
    (N'Medical_Record', N'Record_ID', N'Medical_Record_ID', 1, 0),
    (N'Medical_Record', N'Record_Date', N'Medical_Record_Date', 1, 0),
    (N'Medical_Record', N'Diagnoses', N'Medical_Record_Diagnoses', 1, 0),
    (N'Medical_Record', N'Treatment', N'Medical_Record_Treatment', 1, 0),
    (N'Medical_Record', N'Notes', N'Medical_Record_Notes', 1, 0),
    (N'Nurse', N'Qualification', N'Nurse_Qualification', 1, 0),
    (N'Nurse', N'Shift', N'Nurse_Shift', 1, 0),
    (N'Nurse_Assignment', N'Assigned_From', N'Nurse_Assignment_Start', 1, 0),
    (N'Nurse_Assignment', N'Assigned_To', N'Nurse_Assignment_End', 1, 0),
    (N'Patient', N'First_Name', N'Patient_First_Name', 1, 0),
    (N'Patient', N'Last_Name', N'Patient_Last_Name', 1, 0),
    (N'Patient', N'Gender', N'Patient_Gender', 1, 0),
    (N'Patient', N'Age', N'Patient_Age', 1, 0),
    (N'Patient', N'Date_Of_Birth', N'Patient_Date_Of_Birth', 1, 0),
    (N'Patient', N'Phone', N'Patient_Phone', 1, 0),
    (N'Patient', N'Address', N'Patient_Address', 1, 0),
    (N'Patient', N'Blood_Group', N'Patient_Blood_Group', 1, 0),
    (N'Receptionist', N'Desk_Number', N'Receptionist_Desk_Number', 1, 0),
    (N'Receptionist', N'Shift', N'Receptionist_Shift', 1, 0),
    (N'Rooms', N'Floor_Number', N'Room_Floor_Number', 1, 0),
    (N'Rooms', N'Daily_Charge', N'Room_Daily_Charge', 1, 0),
    (N'Rooms', N'Availability_Status', N'Room_Availability_Status', 1, 0),
    (N'Rooms', N'Capacity', N'Room_Capacity', 1, 0),
    (N'Service', N'Default_Price', N'Service_Default_Price', 1, 0),
    (N'Service', N'Is_Active', N'Service_Is_Active', 1, 0),
    (N'Test_Report', N'Report_ID', N'Test_Report_ID', 1, 0),
    (N'Test_Report', N'Test_Date', N'Test_Report_Date', 1, 0),
    (N'Test_Report', N'Test_Type', N'Test_Report_Type', 1, 0),
    (N'Test_Report', N'Result', N'Test_Report_Result', 1, 0),
    (N'Payment', N'Amount', N'Payment_Amount', 0, 0),
    (N'Payment', N'Reference_Number', N'Payment_Reference_Number', 0, 0),
    (N'Payment', N'Notes', N'Payment_Notes', 0, 0);

DECLARE @Triggers TABLE
(
    Trigger_ID INT PRIMARY KEY,
    Trigger_Name SYSNAME NOT NULL,
    Definition NVARCHAR(MAX) NULL,
    Was_Disabled BIT NOT NULL
);

DECLARE @ExpectedTriggers TABLE (Trigger_Name SYSNAME PRIMARY KEY);
INSERT INTO @ExpectedTriggers VALUES
    (N'TR_BedAssignment_NoOverlap'),
    (N'TR_BedAssignment_AdmissionDates'),
    (N'TR_Admission_BedAssignmentDates'),
    (N'TR_NurseAssignment_AdmissionDates'),
    (N'TR_Admission_NurseAssignmentDates');

DECLARE @Table SYSNAME, @Old SYSNAME, @New SYSNAME,
        @ObjectName NVARCHAR(776), @Trigger SYSNAME,
        @Definition NVARCHAR(MAX), @WasDisabled BIT,
        @Command NVARCHAR(MAX);

BEGIN TRY
    BEGIN TRANSACTION;

    -- Stop before changes if the expected schema does not match.
    IF EXISTS
    (
        SELECT 1 FROM @Renames AS r
        WHERE (r.Is_Required = 1
               OR OBJECT_ID(N'dbo.' + QUOTENAME(r.Table_Name), N'U') IS NOT NULL)
          AND
          (
              (COL_LENGTH(N'dbo.' + QUOTENAME(r.Table_Name), r.Old_Name) IS NULL
               AND COL_LENGTH(N'dbo.' + QUOTENAME(r.Table_Name), r.New_Name) IS NULL)
              OR
              (COL_LENGTH(N'dbo.' + QUOTENAME(r.Table_Name), r.Old_Name) IS NOT NULL
               AND COL_LENGTH(N'dbo.' + QUOTENAME(r.Table_Name), r.New_Name) IS NOT NULL)
          )
    )
        THROW 50100, 'Unexpected schema: missing column or conflicting target name.', 1;

    INSERT INTO @Triggers
    SELECT t.object_id, t.name, m.definition, t.is_disabled
    FROM sys.triggers AS t
    INNER JOIN sys.sql_modules AS m ON m.object_id = t.object_id
    INNER JOIN @ExpectedTriggers AS e ON e.Trigger_Name = t.name
    WHERE OBJECT_SCHEMA_NAME(t.object_id) = N'dbo';

    IF (SELECT COUNT(*) FROM @Triggers) <> 5
       OR EXISTS (SELECT 1 FROM @Triggers WHERE Definition IS NULL)
        THROW 50101, 'Expected five readable assignment triggers. No changes were committed.', 1;

    -- Do not silently leave other known SQL modules with stale column names.
    IF EXISTS
    (
        SELECT 1
        FROM sys.sql_expression_dependencies AS d
        INNER JOIN sys.sql_modules AS m ON m.object_id = d.referencing_id
        INNER JOIN @Renames AS r
            ON d.referenced_id =
                OBJECT_ID(N'dbo.' + QUOTENAME(r.Table_Name), N'U')
        WHERE NOT EXISTS
            (SELECT 1 FROM @Triggers AS t WHERE t.Trigger_ID = d.referencing_id)
    )
        THROW 50102, 'Another SQL module depends on affected tables. Review its definition first.', 1;


    -- Capture CHECK definitions and states before removing enforced dependencies.
    DECLARE @Checks TABLE
    (
        Table_Name SYSNAME, Constraint_Name SYSNAME, Definition NVARCHAR(MAX),
        Was_Disabled BIT, Was_Untrusted BIT
    );
    INSERT INTO @Checks
    SELECT OBJECT_NAME(c.parent_object_id), c.name, c.definition,
           c.is_disabled, c.is_not_trusted
    FROM sys.check_constraints AS c
    WHERE EXISTS (SELECT 1 FROM @Renames AS r
                  WHERE c.parent_object_id = OBJECT_ID(N'dbo.' + QUOTENAME(r.Table_Name)));

    DECLARE @CheckTable SYSNAME, @CheckName SYSNAME,
            @CheckDefinition NVARCHAR(MAX), @CheckDisabled BIT, @CheckUntrusted BIT;
    DECLARE CheckDrop CURSOR LOCAL FAST_FORWARD FOR
        SELECT Table_Name, Constraint_Name FROM @Checks;
    OPEN CheckDrop;
    FETCH NEXT FROM CheckDrop INTO @CheckTable, @CheckName;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Command = N'ALTER TABLE dbo.' + QUOTENAME(@CheckTable)
            + N' DROP CONSTRAINT ' + QUOTENAME(@CheckName) + N';';
        EXEC sys.sp_executesql @Command;
        FETCH NEXT FROM CheckDrop INTO @CheckTable, @CheckName;
    END;
    CLOSE CheckDrop;
    DEALLOCATE CheckDrop;

    -- These are the two filtered indexes present in the inspected schema.
    -- Stop on additional filtered indexes rather than leaving a stale filter.
    IF EXISTS
    (
        SELECT 1 FROM sys.indexes AS ix
        WHERE ix.has_filter = 1
          AND EXISTS (SELECT 1 FROM @Renames AS r
                      WHERE ix.object_id = OBJECT_ID(N'dbo.' + QUOTENAME(r.Table_Name)))
          AND NOT (ix.object_id = OBJECT_ID(N'dbo.Bed_Assignment')
                   AND ix.name IN (N'UX_BedAssignment_OpenBed', N'UX_BedAssignment_OpenAdmission'))
    )
        THROW 50107, 'Unexpected filtered index. Review before renaming.', 1;

    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.Bed_Assignment')
                   AND name = N'UX_BedAssignment_OpenBed' AND is_unique = 1 AND has_filter = 1 AND is_disabled = 0)
       OR NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.Bed_Assignment')
                   AND name = N'UX_BedAssignment_OpenAdmission' AND is_unique = 1 AND has_filter = 1 AND is_disabled = 0)
        THROW 50108, 'Expected active bed-assignment filtered indexes are missing.', 1;

    DROP INDEX UX_BedAssignment_OpenBed ON dbo.Bed_Assignment;
    DROP INDEX UX_BedAssignment_OpenAdmission ON dbo.Bed_Assignment;

    -- Definitions were saved in @Triggers and are restored below.
    DECLARE TriggerDrop CURSOR LOCAL FAST_FORWARD FOR
        SELECT Trigger_Name FROM @Triggers;
    OPEN TriggerDrop;
    FETCH NEXT FROM TriggerDrop INTO @Trigger;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Command = N'DROP TRIGGER dbo.' + QUOTENAME(@Trigger) + N';';
        EXEC sys.sp_executesql @Command;
        FETCH NEXT FROM TriggerDrop INTO @Trigger;
    END;
    CLOSE TriggerDrop;
    DEALLOCATE TriggerDrop;

    -- Rebuild this computed expression using the new input-column names.
    -- Refuse to drop it if someone added an index using the computed column.
    IF EXISTS
    (
        SELECT 1
        FROM sys.index_columns AS ic
        INNER JOIN sys.columns AS c
            ON c.object_id = ic.object_id AND c.column_id = ic.column_id
        WHERE c.object_id = OBJECT_ID(N'dbo.Bill_Item')
          AND c.name = N'Line_Total'
    )
        THROW 50103, 'Line_Total has an index dependency. Review it first.', 1;

    IF COL_LENGTH(N'dbo.Bill_Item', N'Line_Total') IS NOT NULL
        EXEC sys.sp_executesql
            N'ALTER TABLE dbo.Bill_Item DROP COLUMN Line_Total;';

    DECLARE RenameCursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT Table_Name, Old_Name, New_Name
        FROM @Renames
        WHERE Is_Computed = 0
          AND OBJECT_ID(N'dbo.' + QUOTENAME(Table_Name), N'U') IS NOT NULL
        ORDER BY Table_Name, Old_Name;

    OPEN RenameCursor;
    FETCH NEXT FROM RenameCursor INTO @Table, @Old, @New;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF COL_LENGTH(N'dbo.' + QUOTENAME(@Table), @Old) IS NOT NULL
        BEGIN
            SET @ObjectName =
                N'dbo.' + QUOTENAME(@Table) + N'.' + QUOTENAME(@Old);

            EXEC sys.sp_rename
                @objname = @ObjectName,
                @newname = @New,
                @objtype = N'COLUMN';
        END;

        FETCH NEXT FROM RenameCursor INTO @Table, @Old, @New;
    END;

    CLOSE RenameCursor;
    DEALLOCATE RenameCursor;

    IF COL_LENGTH(N'dbo.Bill_Item', N'Bill_Item_Line_Total') IS NULL
        EXEC sys.sp_executesql N'
            ALTER TABLE dbo.Bill_Item
            ADD Bill_Item_Line_Total AS
                CAST(Bill_Item_Quantity * Bill_Item_Unit_Price
                     AS DECIMAL(22,2)) PERSISTED;';


    -- Rebuild CHECK constraints with bracket-delimited column substitutions.
    DECLARE CheckRestore CURSOR LOCAL FAST_FORWARD FOR
        SELECT Table_Name, Constraint_Name, Definition, Was_Disabled, Was_Untrusted
        FROM @Checks;
    OPEN CheckRestore;
    FETCH NEXT FROM CheckRestore
        INTO @CheckTable, @CheckName, @CheckDefinition, @CheckDisabled, @CheckUntrusted;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE CheckRename CURSOR LOCAL FAST_FORWARD FOR
            SELECT Old_Name, New_Name FROM @Renames WHERE Table_Name = @CheckTable;
        OPEN CheckRename;
        FETCH NEXT FROM CheckRename INTO @Old, @New;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @CheckDefinition = REPLACE(@CheckDefinition, QUOTENAME(@Old), QUOTENAME(@New));
            FETCH NEXT FROM CheckRename INTO @Old, @New;
        END;
        CLOSE CheckRename;
        DEALLOCATE CheckRename;
        SET @Command = N'ALTER TABLE dbo.' + QUOTENAME(@CheckTable)
            + CASE WHEN @CheckUntrusted = 0 AND @CheckDisabled = 0 THEN N' WITH CHECK' ELSE N' WITH NOCHECK' END
            + N' ADD CONSTRAINT ' + QUOTENAME(@CheckName) + N' CHECK ' + @CheckDefinition + N';';
        EXEC sys.sp_executesql @Command;
        SET @Command = N'ALTER TABLE dbo.' + QUOTENAME(@CheckTable)
            + CASE WHEN @CheckDisabled = 1 THEN N' NOCHECK' ELSE N' CHECK' END
            + N' CONSTRAINT ' + QUOTENAME(@CheckName) + N';';
        EXEC sys.sp_executesql @Command;
        FETCH NEXT FROM CheckRestore
            INTO @CheckTable, @CheckName, @CheckDefinition, @CheckDisabled, @CheckUntrusted;
    END;
    CLOSE CheckRestore;
    DEALLOCATE CheckRestore;

    EXEC sys.sp_executesql N'
        CREATE UNIQUE INDEX UX_BedAssignment_OpenBed
        ON dbo.Bed_Assignment (Bed_ID) WHERE Bed_Assignment_End IS NULL;
        CREATE UNIQUE INDEX UX_BedAssignment_OpenAdmission
        ON dbo.Bed_Assignment (Admission_ID) WHERE Bed_Assignment_End IS NULL;';

    DECLARE TriggerCursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT Trigger_Name, Definition, Was_Disabled
        FROM @Triggers ORDER BY Trigger_Name;

    OPEN TriggerCursor;
    FETCH NEXT FROM TriggerCursor
        INTO @Trigger, @Definition, @WasDisabled;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Normalize header whitespace without changing trigger body or literals.
        DECLARE @TriggerPosition INT;
        DECLARE @Header NVARCHAR(MAX);

        SET @TriggerPosition = CHARINDEX(N'TRIGGER', UPPER(@Definition));
        IF @TriggerPosition = 0
            THROW 50104, 'Trigger keyword not found.', 1;

        SET @Header = UPPER(LEFT(@Definition, @TriggerPosition - 1));
        SET @Header = REPLACE(@Header, N' ', N'');
        SET @Header = REPLACE(@Header, NCHAR(9), N'');
        SET @Header = REPLACE(@Header, NCHAR(10), N'');
        SET @Header = REPLACE(@Header, NCHAR(13), N'');

        IF @Header NOT IN (N'CREATE', N'ALTER', N'CREATEORALTER')
            THROW 50104, 'Unexpected trigger header.', 1;

        SET @Definition = N'CREATE OR ALTER ' +
            SUBSTRING(@Definition, @TriggerPosition, LEN(@Definition));

        -- Avoid adding the prefix again on a repeat run.
        IF CHARINDEX(N'Admission_Discharge_Date', @Definition) = 0
            SET @Definition = REPLACE(@Definition,
                N'Discharge_Date', N'Admission_Discharge_Date');

        IF @Trigger IN
        (
            N'TR_NurseAssignment_AdmissionDates',
            N'TR_Admission_NurseAssignmentDates'
        )
        BEGIN
            SET @Definition = REPLACE(@Definition,
                N'Assigned_From', N'Nurse_Assignment_Start');
            SET @Definition = REPLACE(@Definition,
                N'Assigned_To', N'Nurse_Assignment_End');
        END
        ELSE
        BEGIN
            SET @Definition = REPLACE(@Definition,
                N'Assigned_From', N'Bed_Assignment_Start');
            SET @Definition = REPLACE(@Definition,
                N'Assigned_To', N'Bed_Assignment_End');
        END;

        EXEC sys.sp_executesql @Definition;

        SET @ObjectName = N'dbo.' + QUOTENAME(@Trigger);
        EXEC sys.sp_refreshsqlmodule @name = @ObjectName;

        -- ALTER may change trigger state; preserve the state found at the start.
        SET @Command =
            CASE WHEN @WasDisabled = 1 THEN N'DISABLE' ELSE N'ENABLE' END
            + N' TRIGGER dbo.' + QUOTENAME(@Trigger)
            + N' ON dbo.'
            + QUOTENAME(OBJECT_NAME(
                (SELECT parent_id FROM sys.triggers
                 WHERE object_id = OBJECT_ID(@ObjectName))))
            + N';';
        EXEC sys.sp_executesql @Command;

        FETCH NEXT FROM TriggerCursor
            INTO @Trigger, @Definition, @WasDisabled;
    END;

    CLOSE TriggerCursor;
    DEALLOCATE TriggerCursor;

    IF EXISTS
    (
        SELECT 1 FROM @Renames AS r
        WHERE OBJECT_ID(N'dbo.' + QUOTENAME(r.Table_Name), N'U') IS NOT NULL
          AND COL_LENGTH(N'dbo.' + QUOTENAME(r.Table_Name), r.New_Name) IS NULL
    )
        THROW 50105, 'Post-check failed. No changes were committed.', 1;

    COMMIT TRANSACTION;

    SELECT N'Column naming migration completed successfully.' AS Migration_Result;

    SELECT r.Table_Name, r.Old_Name, r.New_Name,
           CASE WHEN OBJECT_ID(N'dbo.' + QUOTENAME(r.Table_Name), N'U') IS NULL
                THEN N'TABLE NOT CREATED YET'
                ELSE N'OK'
           END AS Result
    FROM @Renames AS r
    ORDER BY r.Table_Name, r.New_Name;

    SELECT t.name AS Trigger_Name, t.is_disabled AS Is_Disabled
    FROM sys.triggers AS t
    INNER JOIN @ExpectedTriggers AS e ON e.Trigger_Name = t.name
    WHERE OBJECT_SCHEMA_NAME(t.object_id) = N'dbo'
    ORDER BY t.name;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO


