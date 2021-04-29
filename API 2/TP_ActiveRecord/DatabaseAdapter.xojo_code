#tag Class
Protected Class DatabaseAdapter
	#tag Method, Flags = &h0
		Sub BeginTransaction()
		  break //Should be called by the Database Adapter Subclass
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub BindId(stmt as PreparedSQLStatement, i as integer, id as Int64)
		  
		  #if TP_ActiveRecord.kConfigUseSQLiteDatabase and RBVersion>=2013
		    if db isa SQLiteDatabase then
		      stmt.BindType(i, SQLitePreparedStatement.SQLITE_INT64)
		    end if
		  #endif
		  
		  #if TP_ActiveRecord.kConfigUseMySQLCommunityServer
		    if db isa MySQLCommunityServer then
		      stmt.BindType(i, MySQLPreparedStatement.MYSQL_TYPE_LONGLONG)
		    end if
		  #endif
		  
		  #if TP_ActiveRecord.kConfigUsePostgreSQLDatabase
		    if db isa PostgreSQLDatabase then
		      //PostgreSQL doesn't do binding the same way
		    end
		  #endif
		  
		  #if TP_ActiveRecord.kConfigUseMSSQLServer
		    if db isa MSSQLServerDatabase then
		      stmt.BindType(i, MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_INT)
		    end
		  #endif
		  
		  #if TP_ActiveRecord.kConfigUseODBC
		    if db isa ODBCDatabase then
		      stmt.BindType(i, ODBCPreparedStatement.ODBC_TYPE_BIGINT)
		    end
		  #endif
		  
		  
		  
		  #If TP_ActiveRecord.kConfigUseCubeDatabase
		    if db isa CubeSQLServer then
		      break
		    end
		  #endif
		  
		  #if TP_ActiveRecord.kConfigUseVSQLiteDatabase
		    if db isa VSQLiteDatabase then
		      stmt.BindType(i, SQLitePreparedStatement.SQLITE_INT64)
		    end if
		  #endif
		  
		  stmt.Bind(i, id)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub BindId(stmt as PreparedSQLStatement, i as integer, sID as String)
		  
		  #if TP_ActiveRecord.kConfigUseSQLiteDatabase and RBVersion>=2013
		    if db isa SQLiteDatabase then
		      stmt.BindType(i, SQLitePreparedStatement.SQLITE_TEXT)
		    end if
		  #endif
		  
		  #if TP_ActiveRecord.kConfigUseMySQLCommunityServer
		    if db isa MySQLCommunityServer then
		      stmt.BindType(i, MySQLPreparedStatement.MYSQL_TYPE_STRING)
		    end if
		  #endif
		  
		  #if TP_ActiveRecord.kConfigUsePostgreSQLDatabase
		    if db isa PostgreSQLDatabase then
		      //PostgreSQL doesn't do binding the same way
		    end
		  #endif
		  
		  #if TP_ActiveRecord.kConfigUseMSSQLServer
		    if db isa MSSQLServerDatabase then
		      stmt.BindType(i, MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_STRING)
		    end
		  #endif
		  
		  #if TP_ActiveRecord.kConfigUseODBC
		    if db isa ODBCDatabase then
		      stmt.BindType(i, ODBCPreparedStatement.ODBC_TYPE_STRING)
		    end
		  #endif
		  
		  
		  
		  #If TP_ActiveRecord.kConfigUseCubeDatabase
		    if db isa CubeSQLServer then
		      break
		    end
		  #endif
		  
		  #if TP_ActiveRecord.kConfigUseVSQLiteDatabase
		    if db isa VSQLiteDatabase then
		      stmt.BindType(i, SQLitePreparedStatement.SQLITE_TEXT)
		    end if
		  #endif
		  
		  stmt.Bind(i, sID)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function BindValues(oRecord as TP_ActiveRecord.Base, aroField() as TP_ActiveRecord.P.FieldInfo, aroValues() as variant) As Dictionary
		  Var dictFieldValue as new Dictionary
		  
		  For i As Integer = 0 To aroField.LastIndex
		    Var oField As TP_ActiveRecord.P.FieldInfo = aroField(i)
		    
		    Var pi As Introspection.PropertyInfo = oField.piFieldProperty
		    //BKS:  This currently fails if the property is a DateTime.
		    Var v As Variant = pi.Value(oRecord)
		    
		    Select Case db
		    Case Nil
		      'empty. This just let's it compile if someone turns off all the constants
		    End Select
		    
		    
		    if oField.IsKey and (v.IntegerValue < 1 or v.StringValue = "" or v.StringValue = "0") then
		      // if the field is a key and it's 0 or less, then set it to NULL
		      // If this inserts as 0, that's Xojo's problem.
		      aroValues.Add(nil)
		      
		    Elseif pi.PropertyType.Name="Date" Or (pi.PropertyType.Name="Variant" And v.Type=Variant.TypeDate) Then
		      
		      Var dt As DateTime = v.DateTimeValue
		      If dt=Nil Then
		        aroValues.Add(Nil)
		      Else
		        Var dt1 As New DateTime(dt.SecondsFrom1970, dt.Timezone)
		        v = dt1 'copied for the saved value
		        
		        Var tz As New TimeZone(0)
		        Var dt2 As New DateTime(dt.SecondsFrom1970, tz)
		        dt = dt2
		        
		        If oField.enFieldType=TP_ActiveRecord.DBType.DDate Then
		          aroValues.Add(dt.SQLDate)
		        Elseif oField.enFieldType=TP_ActiveRecord.DBType.DTimestamp Then
		          aroValues.Add(dt.SQLDateTime)
		        Else
		          aroValues.Add(dt.SQLDateTime)
		        End If
		      End If
		      
		    Elseif pi.PropertyType.Name="Double" And v.DoubleValue = TP_ActiveRecord.kDoubleNullSentinal Then
		      aroValues.Add(nil)
		    Else
		      aroValues.Add(v)
		    End If
		    
		    dictFieldValue.Value(pi.Name) = v
		    
		  Next
		  
		  Return dictFieldValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CommitTransaction()
		  break //Should be called by the Database Adapter Subclass
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor()
		  'Empty
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Db() As Database
		  TP_ActiveRecord.Assert( false, "needs to be implemented in subclass" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteRecord(oRecord as TP_ActiveRecord.Base)
		  
		  Var sql as string
		  Var oTableInfo as TP_ActiveRecord.P.TableInfo
		  
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  sql = "DELETE FROM " + oTableInfo.sTableName + _
		  " WHERE " + oTableInfo.sPrimaryKey
		  
		  #if TP_ActiveRecord.kConfigUsePostgreSQLDatabase
		    if db isa PostgreSQLDatabase then
		      sql = sql  + "=$1"
		    else
		      sql = sql  + "=?"
		    end if
		  #else
		    sql = sql  + "=?"
		  #EndIf
		  
		  If oRecord.GUID <> "" Then
		    db.ExecuteSQL(sql, oRecord.GUID)
		  Else
		    db.ExecuteSQL(sql, oRecord.ID)
		  End If
		  
		  
		  ' Var stmt as PreparedSQLStatement
		  ' stmt = db.Prepare(sql)
		  ' if oRecord.GUID <> "" then
		  ' BindId(stmt, 0, oRecord.GUID)
		  ' else
		  ' BindId(stmt, 0, oRecord.ID)
		  ' end if
		  ' 
		  ' 
		  ' stmt.SQLExecute
		  ' If db.Error Then
		  ' Raise New TP_ActiveRecord.DatabaseException(db)
		  ' end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetLastInsertID() As Int64
		  TP_ActiveRecord.Assert( false, "needs to be implemented in subclass" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasTable(sTableName as String) As boolean
		  Var rs as RowSet
		  rs = Db.Tables
		  while not rs.AfterLastRow
		    if rs.ColumnAt(0).StringValue = sTableName then
		      return true
		    end if
		    rs.MoveToNextRow
		  wend
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertRecord(oRecord as TP_ActiveRecord.Base, byref dictSavedPropertyValue as Dictionary)
		  Var oTableInfo as TP_ActiveRecord.P.TableInfo
		  
		  Var dictFieldValue as Dictionary
		  
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  Var arsField() as string
		  Var arsPlaceholder() as string
		  Var aroField() as TP_ActiveRecord.P.FieldInfo
		  
		  for each oField as TP_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		    if oField.bPrimaryKey then
		      continue
		    end if
		    arsField.Add(oField.sFieldName)
		    arsPlaceholder.Add("?")
		    aroField.Add(oField)
		  next
		  
		  Var arsSQL() as string
		  arsSQL.Add("INSERT INTO " + oTableInfo.sTableName)
		  arsSQL.Add("(" + String.FromArray(arsField, ",") + ")")
		  arsSQL.Add(" VALUES ")
		  arsSQL.Add("(" + String.FromArray(arsPlaceholder, ",") + ")")
		  
		  Var sSQL as string = String.FromArray(arsSQL, " ")
		  
		  ' Var stmt as PreparedSQLStatement
		  ' stmt = db.Prepare( sSQL )
		  
		  var aroValues() As Variant
		  dictFieldValue = BindValues(oRecord, aroField, arovalues)
		  
		  db.ExecuteSQL(sSQL, aroValues)
		  
		  ' stmt.SQLExecute
		  ' if db.Error then
		  ' raise new TP_ActiveRecord.DatabaseException(db)
		  ' end if
		  
		  Var iRecordID as Int64 = GetLastInsertID
		  dictFieldValue.Value( oTableInfo.piPrimaryKey.Name ) = iRecordID
		  
		  'store the newly saved property values
		  dictSavedPropertyValue = dictFieldValue
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RollbackTransaction()
		  break //Should be called by the Database Adapter Subclass
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectList(sTable as string, sCondition as string = "", sOrder as string = "") As RowSet
		  Var sSQL as string = "SELECT * FROM " + sTable + " "
		  if sCondition<>"" then
		    sSQL = sSQL + "WHERE " + sCondition
		  end if
		  
		  if sOrder<>"" then
		    sSQL = sSQL + " ORDER BY " + sOrder
		  end if
		  sSQL = sSQL + ";"
		  
		  return SQLSelect(sSQL)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectRecord(oRecord as TP_ActiveRecord.Base, iRecordID as integer) As RowSet
		  Var sql as string
		  Var oTableInfo as TP_ActiveRecord.P.TableInfo
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  sql = "SELECT * FROM " + oTableInfo.sTableName + " WHERE " + oTableInfo.sPrimaryKey + "=?"
		  
		  Var rs As RowSet = DB.SelectSQL(sql, iRecordID)
		  
		  ' Var stmt as PreparedSQLStatement
		  ' stmt = db.Prepare(sql)
		  ' BindId(stmt, 0, iRecordID)
		  ' 
		  ' rs = stmt.SQLSelect
		  ' if db.Error then
		  ' raise new TP_ActiveRecord.DatabaseException(db)
		  ' end if
		  
		  return rs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectRecord(oRecord as TP_ActiveRecord.Base, sRecorID as string) As RowSet
		  Var sql as string
		  Var oTableInfo as TP_ActiveRecord.P.TableInfo
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  sql = "SELECT * FROM " + oTableInfo.sTableName + " WHERE " + oTableInfo.sPrimaryKey + "=?"
		  
		  Var rs As RowSet = DB.SelectSQL(sql, sRecorID)
		  
		  ' Var stmt as PreparedSQLStatement
		  ' stmt = db.Prepare(sql)
		  ' BindId(stmt, 0, sRecorID)
		  ' 
		  ' rs = stmt.SQLSelect
		  ' if db.Error then
		  ' raise new TP_ActiveRecord.DatabaseException(db)
		  ' end if
		  
		  return rs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecute(sql as String)
		  db.ExecuteSQL( sql )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLSelect(sql as String) As RowSet
		  Var rs As RowSet = db.SelectSQL( sql )
		  
		  return rs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateRecord(oRecord as TP_ActiveRecord.Base, byref dictSavedPropertyValue as Dictionary)
		  Var oTableInfo As TP_ActiveRecord.P.TableInfo
		  
		  Var dictFieldValue as Dictionary
		  
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  Var arsField() as string
		  Var aroField() as TP_ActiveRecord.P.FieldInfo
		  Var oPrimaryKeyField as TP_ActiveRecord.P.FieldInfo
		  
		  for each oField as TP_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		    if oField.bPrimaryKey then
		      oPrimaryKeyField = oField
		      continue
		    end if
		    arsField.Add(oField.sFieldName + "=?")
		    aroField.Add(oField)
		  next
		  Var arsSQL() as string
		  arsSQL.Add("UPDATE " + oTableInfo.sTableName + " SET ")
		  arsSQL.Add(String.FromArray(arsField, ","))
		  arsSQL.Add(" WHERE " + oTableInfo.sPrimaryKey + "=?")
		  
		  Var sSQL As String = String.FromArray(arsSQL, " ")
		  ' Var stmt As PreparedSQLStatement
		  ' stmt = db.Prepare( String.FromArray(arsSQL, " ") )
		  
		  aroField.Add(oPrimaryKeyField)
		  var aroValues() As Variant
		  dictFieldValue = BindValues(oRecord, aroField, aroValues)
		  
		  db.ExecuteSQL(sSQL, aroValues)
		  
		  ' stmt.SQLExecute
		  ' if db.Error then
		  ' raise new TP_ActiveRecord.DatabaseException(db)
		  ' end if
		  
		  'store the newly saved property values
		  dictSavedPropertyValue = dictFieldValue
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
