-- ⚠️ Chạy trong đúng database. Script này:
-- - Disable FK
-- - DELETE tất cả bảng user (schema dbo)
-- - Reseed các bảng có identity
-- - Re-enable FK + validate

SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRAN;

-- Disable toàn bộ FK
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql = STRING_AGG(N'ALTER TABLE '
    + QUOTENAME(SCHEMA_NAME(t.schema_id)) + N'.' + QUOTENAME(t.name)
    + N' NOCHECK CONSTRAINT ' + QUOTENAME(fk.name) + N';', CHAR(10))
FROM sys.foreign_keys fk
         JOIN sys.tables t ON fk.parent_object_id = t.object_id;
EXEC sp_executesql @sql;

-- Xoá dữ liệu tất cả bảng user theo thứ tự phụ thuộc (reverse FK)
-- Cách đơn giản: lặp nhiều lần đến khi hết hàng (tập trung vào schema dbo)
DECLARE @tbl TABLE (FullName SYSNAME);
INSERT INTO @tbl(FullName)
SELECT QUOTENAME(SCHEMA_NAME(schema_id)) + N'.' + QUOTENAME(name)
FROM sys.tables
WHERE is_ms_shipped = 0;

-- DELETE tất cả (không dùng TRUNCATE để né FK)
DECLARE cur CURSOR FAST_FORWARD FOR SELECT FullName FROM @tbl;
DECLARE @name SYSNAME;
OPEN cur;
FETCH NEXT FROM cur INTO @name;
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC (N'DELETE FROM ' + @name + N';');
FETCH NEXT FROM cur INTO @name;
END
CLOSE cur; DEALLOCATE cur;

-- Reseed cho các bảng có identity
DECLARE @reseeds NVARCHAR(MAX) = N'';
SELECT @reseeds = STRING_AGG(
        N'DBCC CHECKIDENT ('''
            + QUOTENAME(SCHEMA_NAME(t.schema_id)) + N'.' + QUOTENAME(t.name) + ''', RESEED, 0);'
    , CHAR(10))
FROM sys.tables t
         JOIN sys.columns c ON c.object_id = t.object_id
WHERE c.is_identity = 1
  AND t.is_ms_shipped = 0;
EXEC sp_executesql @reseeds;

-- Re-enable FK + validate
SET @sql = N'';
SELECT @sql = STRING_AGG(N'ALTER TABLE '
    + QUOTENAME(SCHEMA_NAME(t.schema_id)) + N'.' + QUOTENAME(t.name)
    + N' WITH CHECK CHECK CONSTRAINT ' + QUOTENAME(fk.name) + N';', CHAR(10))
FROM sys.foreign_keys fk
         JOIN sys.tables t ON fk.parent_object_id = t.object_id;
EXEC sp_executesql @sql;

COMMIT;
