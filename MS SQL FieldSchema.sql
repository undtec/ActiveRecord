SELECT COLUMN_NAME As ColumnName,
CASE DATA_TYPE
     WHEN null THEN 0
     WHEN 'tinyint' THEN 1
     WHEN 'smallint' THEN 2
     WHEN 'int' THEN 3
     WHEN 'numeric' THEN 3
     WHEN 'char' THEN 5
     WHEN 'varchar' THEN 5
     WHEN 'varchar' THEN 5
     WHEN 'text' THEN 5
     WHEN 'nchar' THEN 5
     WHEN 'nvarchar' THEN 5
     WHEN 'ntext' THEN 5
     WHEN 'float' THEN 6
     WHEN 'real' THEN 7
     WHEN 'date' THEN 8
     WHEN 'time' THEN 9
     WHEN 'datetime' THEN 10
     WHEN 'datetime2' THEN 10
     WHEN 'timestamp' THEN 10
     WHEN 'money' THEN 11
     WHEN 'smallmoney' THEN 11
     WHEN 'bit' THEN 12
     WHEN 'decimal' THEN 13
     WHEN 'binary' THEN 14
     WHEN 'image' THEN 14
     WHEN 'varbinary' THEN 15
     WHEN 'bigint' THEN 19
     ELSE 255
END As FieldType, 
(
   SELECT COUNT(*)
     FROM sys.index_columns, sys.indexes
    WHERE 
          sys.index_columns.object_id = Object_Id(?)
      AND sys.index_columns.index_id = (SELECT DISTINCT index_id FROM sys.indexes WHERE sys.indexes.object_id = Object_Id(?) AND is_primary_key = 1)
      AND sys.indexes.object_id = sys.index_columns.object_id
      AND sys.indexes.index_id = sys.index_columns.index_id
      AND sys.index_columns.index_column_id = COLUMNS.ORDINAL_POSITION
) AS IsPrimary,
IIF(IS_NULLABLE = 'YES',1,0) as NotNull,
IsNull(CHARACTER_MAXIMUM_LENGTH,0) AS Length 
FROM INFORMATION_SCHEMA.COLUMNS AS COLUMNS
WHERE TABLE_NAME LIKE ?
ORDER BY ORDINAL_POSITION