-- Usage: run inside the target SQL Server database to clear all user data.
-- Steps: disable foreign keys -> delete data -> reseed identity columns -> re-enable constraints.
-- This script dynamically handles all tables including the new embeddable table structure (rule_week_days).

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRAN;

DECLARE @sql NVARCHAR(MAX);

-- Disable all foreign key constraints
SELECT @sql = STRING_AGG(
        N'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + N'.' + QUOTENAME(t.name)
        + N' NOCHECK CONSTRAINT ' + QUOTENAME(fk.name) + N';',
        CHAR(10)
    )
FROM sys.foreign_keys fk
JOIN sys.tables t ON fk.parent_object_id = t.object_id
WHERE t.is_ms_shipped = 0;
IF @sql IS NOT NULL
    EXEC sp_executesql @sql;

-- Delete data from all user tables (DELETE to respect FK relationships)
DECLARE cur CURSOR FAST_FORWARD FOR
SELECT QUOTENAME(SCHEMA_NAME(t.schema_id)) + N'.' + QUOTENAME(t.name)
FROM sys.tables t
WHERE t.is_ms_shipped = 0;

DECLARE @target NVARCHAR(258);
OPEN cur;
FETCH NEXT FROM cur INTO @target;
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC (N'DELETE FROM ' + @target + N';');
    FETCH NEXT FROM cur INTO @target;
END;
CLOSE cur;
DEALLOCATE cur;

-- Reseed identity columns back to 0
SELECT @sql = STRING_AGG(
        N'DBCC CHECKIDENT ('''
        + SCHEMA_NAME(t.schema_id) + N'.' + t.name + ''', RESEED, 0);',
        CHAR(10)
    )
FROM sys.tables t
JOIN sys.columns c ON c.object_id = t.object_id
WHERE c.is_identity = 1
  AND t.is_ms_shipped = 0;
IF @sql IS NOT NULL
    EXEC sp_executesql @sql;

-- Re-enable and validate foreign key constraints
SELECT @sql = STRING_AGG(
        N'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + N'.' + QUOTENAME(t.name)
        + N' WITH CHECK CHECK CONSTRAINT ' + QUOTENAME(fk.name) + N';',
        CHAR(10)
    )
FROM sys.foreign_keys fk
JOIN sys.tables t ON fk.parent_object_id = t.object_id
WHERE t.is_ms_shipped = 0;
IF @sql IS NOT NULL
    EXEC sp_executesql @sql;

COMMIT;
