USE HMS_Verification;
GO

SELECT
    DB_NAME() AS Database_Name,
    (SELECT COUNT(*) FROM sys.tables
     WHERE is_ms_shipped = 0) AS Tables_Count,
    (SELECT COUNT(*) FROM sys.foreign_keys) AS Foreign_Keys_Count,
    (SELECT COUNT(*) FROM sys.triggers
     WHERE parent_class = 1 AND is_ms_shipped = 0) AS Triggers_Count,
    (SELECT COUNT(*) FROM sys.views
     WHERE is_ms_shipped = 0) AS Views_Count;

SELECT name AS Disabled_Or_Untrusted_FK
FROM sys.foreign_keys
WHERE is_disabled = 1 OR is_not_trusted = 1;

SELECT name AS Disabled_Trigger
FROM sys.triggers
WHERE parent_class = 1 AND is_disabled = 1;