-- Select the database to verify in SSMS. Read-only.
SELECT DB_NAME() AS Database_Name,
 (SELECT COUNT(*) FROM sys.tables WHERE is_ms_shipped=0 AND name <> 'sysdiagrams') AS Tables_Count,
 (SELECT COUNT(*) FROM sys.foreign_keys) AS Foreign_Keys_Count,
 (SELECT COUNT(*) FROM sys.triggers WHERE parent_class=1 AND is_ms_shipped=0) AS Triggers_Count,
 (SELECT COUNT(*) FROM sys.views WHERE is_ms_shipped=0) AS Views_Count;
SELECT name AS FK_Needing_Review FROM sys.foreign_keys
WHERE is_disabled=1 OR is_not_trusted=1;
SELECT name AS Check_Needing_Review FROM sys.check_constraints
WHERE is_disabled=1 OR is_not_trusted=1;
SELECT name AS Disabled_Trigger FROM sys.triggers
WHERE parent_class=1 AND is_disabled=1;
