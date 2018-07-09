DECLARE @sql nvarchar(max) 
DECLARE @Name varchar(100)='databasename' 
 DECLARE c CURSOR FOR  
  SELECT      
        replace(mod.definition,pr.name,pr.name+'_new') 
FROM sys.procedures pr 
INNER JOIN sys.sql_modules mod ON pr.object_id = mod.object_id 
WHERE pr.Is_MS_Shipped = 0 AND pr.name LIKE '%P_ans_%' --proc name
AND pr.name NOT LIKE '%_new' 

OPEN c 
 
FETCH NEXT FROM c INTO @sql 
 
WHILE @@FETCH_STATUS = 0  
BEGIN 
   SET @sql = REPLACE(@sql,'''','''''') 
   SET @sql = 'USE [' + @Name + ']; EXEC(''' + @sql + ''')' 
 
   EXEC(@sql) 
 
   FETCH NEXT FROM c INTO @sql 
END              
 
CLOSE c 
DEALLOCATE c 