#tag Class
Protected Class MSSQLServerAdapterMBS
Inherits TP_ActiveRecord.DatabaseAdapter
	#tag Method, Flags = &h0
		Sub BeginTransaction()
		  // Per Christian "You may not call BeginTransaction method in Xojo.
		  //                This would execute the "BEGIN TRANSACTION" internally,
		  //                which conflicts the auto commit as the plugin may start
		  //                a transaction and that may cause an error for starting a
		  //                transaction within a transaction."
		  // https://mbs-plugins.de/archive/2020-01-19/Transactions_in_MBS_Xojo_SQL_P/monkeybreadsoftware_blog_xojo
		  
		  // So, we do nothing
		  m_iTransactionCt = m_iTransactionCt + 1
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CommitTransaction()
		  m_iTransactionCt = m_iTransactionCt - 1
		  if m_iTransactionCt=0 then
		    Db.Commit
		    if db.Error then
		      dim ex as new TP_ActiveRecord.DatabaseException(db, "Commit")
		      db.Rollback
		      raise ex
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(oDb as Object)
		  // If you are not connecting to MS SQL Server
		  // and do not have the MBS SQL Plugin
		  // then you can safely delete this class
		  #if TP_ActiveRecord.kConfigUseMSSQLServerMBS then
		    dim db as SQLDatabaseMBS = SQLDatabaseMBS(oDb)
		    if db=nil then
		      raise new RuntimeException
		    end if
		    m_db = db
		  #else
		    #pragma unused oDB
		    raise new UnsupportedOperationException
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Db() As Database
		  return m_db
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetLastInsertID() As Int64
		  dim rs as RecordSet
		  rs = SQLSelect("SELECT @@IDENTITY;")
		  return rs.IdxField(1).Int64Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertRecord(oRecord as TP_ActiveRecord.Base, byref dictSavedPropertyValue as Dictionary)
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  
		  dim dictFieldValue as Dictionary
		  
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  dim arsField() as string
		  dim arsPlaceholder() as string
		  dim aroField() as TP_ActiveRecord.P.FieldInfo
		  dim sPK as string
		  dim oPKField as  TP_ActiveRecord.P.FieldInfo
		  for each oField as TP_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		    if oField.bPrimaryKey then
		      sPK = oField.sFieldName
		      oPKField = oField
		      continue
		    end if
		    arsField.Append(oField.sFieldName)
		    arsPlaceholder.Append("?")
		    aroField.Append(oField)
		  next
		  
		  dim arsSQL() as string
		  arsSQL.append "INSERT INTO " + oTableInfo.sTableName
		  arsSQL.append "(" + Join(arsField, ",") + ")"
		  arssql.Append "OUTPUT inserted." + sPK
		  arsSQL.append " VALUES "
		  arsSQL.append "(" + Join(arsPlaceholder, ",") + ")"
		  
		  dim sSQL as string = Join(arsSQL, " ")
		  
		  dim stmt as PreparedSQLStatement
		  stmt = db.Prepare( sSQL )
		  
		  dictFieldValue = BindValues(stmt, oRecord, aroField)
		  
		  dim rs as recordset = stmt.SQLSelect
		  if db.Error then
		    raise new TP_ActiveRecord.DatabaseException(db)
		  end if
		  
		  
		  
		  if oPKField.piFieldProperty.PropertyType.Name = "String" then
		    dim sRecordID as string = rs.Field(sPK).StringValue
		    sRecordID = sRecordID.ReplaceAll("{", "")
		    sRecordID = sRecordID.ReplaceAll("}", "")
		    dictFieldValue.Value( oTableInfo.piPrimaryKey.Name ) = sRecordID
		    oRecord.GUID = sRecordID
		  else
		    dim iRecordID as Int64 = rs.Field(sPK).Int64Value
		    dictFieldValue.Value( oTableInfo.piPrimaryKey.Name ) = iRecordID
		    oRecord.id = iRecordID
		  end if
		  
		  'store the newly saved property values
		  dictSavedPropertyValue = dictFieldValue
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RollbackTransaction()
		  m_iTransactionCt = m_iTransactionCt - 1
		  if m_iTransactionCt=0 then
		    Db.Rollback
		  end if
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_db As Database
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_iTransactionCt As Integer
	#tag EndProperty


	#tag Constant, Name = kFieldSchema, Type = String, Dynamic = False, Default = \"SELECT COLUMN_NAME As ColumnName\x2C\nCASE DATA_TYPE\n     WHEN null THEN 0\n     WHEN \'tinyint\' THEN 1\n     WHEN \'smallint\' THEN 2\n     WHEN \'int\' THEN 3\n     WHEN \'char\' THEN 5\n     WHEN \'varchar\' THEN 5\n     WHEN \'varchar\' THEN 5\n     WHEN \'text\' THEN 5\n     WHEN \'nchar\' THEN 5\n     WHEN \'nvarchar\' THEN 5\n     WHEN \'ntext\' THEN 5\n     WHEN \'float\' THEN 6\n     WHEN \'real\' THEN 7\n     WHEN \'date\' THEN 8\n     WHEN \'time\' THEN 9\n     WHEN \'datetime\' THEN 10\n     WHEN \'datetime2\' THEN 10\n     WHEN \'timestamp\' THEN 10\n     WHEN \'money\' THEN 11\n     WHEN \'smallmoney\' THEN 11\n     WHEN \'bit\' THEN 12\n     WHEN \'decimal\' THEN 13\n     WHEN \'binary\' THEN 14\n     WHEN \'image\' THEN 14\n     WHEN \'varbinary\' THEN 15\n     WHEN \'bigint\' THEN 19\n     ELSE 255\nEND As FieldType\x2C \n(\n   SELECT COUNT(*)\n     FROM sys.index_columns\x2C sys.indexes\n    WHERE \n          sys.index_columns.object_id \x3D Object_Id(\?)\n      AND sys.index_columns.index_id \x3D (SELECT DISTINCT index_id FROM sys.indexes WHERE sys.indexes.object_id \x3D Object_Id(\?) AND is_primary_key \x3D 1)\n      AND sys.indexes.object_id \x3D sys.index_columns.object_id\n      AND sys.indexes.index_id \x3D sys.index_columns.index_id\n      AND sys.index_columns.index_column_id \x3D COLUMNS.ORDINAL_POSITION\n) AS IsPrimary\x2C\nIIF(IS_NULLABLE \x3D \'YES\'\x2C1\x2C0) as NotNull\x2C\nIsNull(CHARACTER_MAXIMUM_LENGTH\x2C0) AS Length \nFROM INFORMATION_SCHEMA.COLUMNS AS COLUMNS\nWHERE TABLE_NAME LIKE \?\nORDER BY ORDINAL_POSITION", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
