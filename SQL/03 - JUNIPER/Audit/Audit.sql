Declare @AuditTable varchar(100)
declare @AuditDate as varchar(20);
Set @AuditDate = '2025-06-05';
declare @query nvarchar(max);
declare @querycount nvarchar(max);
declare @RowsAudit int;
DECLARE AuditTables_Cursor cursor
for select [name] from sys.tables where [name] like '%audit'
 
 
OPEN AuditTables_Cursor;
 
 
FETCH NEXT FROM AuditTables_Cursor INTO
@AuditTable;
 
 
WHILE @@FETCH_STATUS = 0
BEGIN
set @querycount = 'Select @pRowsAudit=count(*) from ' + @AuditTable + ' where Aud_Feccre >'''+@AuditDate+''''
EXECUTE sp_executesql @querycount, N'@pRowsAudit INT OUTPUT',@pRowsAudit = @RowsAudit OUTPUT;
if (@RowsAudit > 0)
BEGIN
set @query = 'Select '''+@AuditTable +''' as AuditTable, * from ' + @AuditTable + ' where Aud_Feccre >'''+@AuditDate+'''';
EXEC sp_executesql @query;
END
FETCH NEXT FROM AuditTables_Cursor INTO
@AuditTable;
END;