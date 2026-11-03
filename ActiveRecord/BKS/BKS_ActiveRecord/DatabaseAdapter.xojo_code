#tag Class
Protected Class DatabaseAdapter
	#tag Method, Flags = &h0
		Sub BeginTransaction()
		  'The outermost call starts a real transaction. Nested calls (for example a Save
		  'inside a BKS_ActiveRecord.Transaction) create a savepoint, so an inner rollback
		  'undoes only the inner work instead of being silently ignored.
		  if m_iTransactionCt = 0 then
		    Var sBegin As String = SQLBeginTransaction
		    if sBegin <> "" then
		      SQLExecute(sBegin)
		    end if
		  else
		    Var sSavepoint As String = SavepointName(m_iTransactionCt)
		    Var sSQL As String = SQLSavepoint(sSavepoint)
		    SQLExecute(sSQL)
		  end if

		  'only count the level once the statement has succeeded
		  m_iTransactionCt = m_iTransactionCt + 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub BindId(stmt as PreparedSQLStatement, i as integer, id as Int64)
		  #if BKS_ActiveRecordConfig.kIncludeREALSQLDatabase
		    if db isa REALSQLDatabase then
		      stmt.BindType(i, REALSQLPreparedStatement.SQLITE_INT64)
		    end if
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludeSQLiteDatabase and RBVersion>=2013
		    if db isa SQLiteDatabase then
		      stmt.BindType(i, SQLitePreparedStatement.SQLITE_INT64)
		    end if
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludeMySQLCommunityServer
		    if db isa MySQLCommunityServer then
		      stmt.BindType(i, MySQLPreparedStatement.MYSQL_TYPE_LONGLONG)
		    end if
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludePostgreSQLDatabase
		    if db isa PostgreSQLDatabase then
		      //PostgreSQL doesn't do binding the same way
		    end
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludeMSSQLServer
		    if db isa MSSQLServerDatabase then
		      stmt.BindType(i, MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_INT)
		    end
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludeOracle
		    if db isa OracleDatabase then
		      stmt.BindType(i, OracleSQLPreparedStatement.SQL_TYPE_INTEGER)
		    end
		  #endif
		  
		  #If BKS_ActiveRecordConfig.kIncludeCubeDatabase
		    if db isa CubeSQLServer then
		      break
		    end
		  #endif
		  
		  stmt.Bind(i, id)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub BindNull(stmt as PreparedSQLStatement, i as integer)
		  #if BKS_ActiveRecordConfig.kIncludeMySQLCommunityServer
		    if db isa MySQLCommunityServer then
		      stmt.BindType(i, MySQLPreparedStatement.MYSQL_TYPE_NULL)
		    end if
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludeREALSQLDatabase
		    if db isa REALSQLDatabase then
		      stmt.BindType(i, REALSQLPreparedStatement.SQLITE_NULL)
		    end if
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludeSQLiteDatabase and RBVersion>=2013
		    if db isa SQLiteDatabase then
		      stmt.BindType(i, SQLitePreparedStatement.SQLITE_NULL)
		    end if
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludePostgreSQLDatabase
		    if db isa PostgreSQLDatabase then
		      //PostgreSQL doesn't do binding the same way
		    end
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludeMSSQLServer
		    if db isa MSSQLServerDatabase then
		      stmt.BindType(i, MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_NULL)
		    end
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludeOracle
		    if db isa OracleDatabase then
		      stmt.BindType(i, OracleSQLPreparedStatement.SQL_TYPE_NULL)
		    end
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BindValues(stmt as PreparedSQLStatement, oRecord as BKS_ActiveRecord.Base, aroField() as BKS_ActiveRecord.P.FieldInfo) As Dictionary
		  dim dictFieldValue as new Dictionary
		  
		  for i as integer = 0 to aroField.Ubound
		    dim oField as BKS_ActiveRecord.P.FieldInfo = aroField(i)
		    dim pi as Introspection.PropertyInfo = oField.piFieldProperty
		    dim v as Variant = pi.Value(oRecord)
		    
		    dim iDbType as integer
		    
		    select case db
		    case nil
		      'empty. This just let's it compile if someone turns off all the constants
		      
		      #if BKS_ActiveRecordConfig.kIncludeREALSQLDatabase
		    case isa REALSQLDatabase
		      select case aroField(i).enFieldType
		      case DbType.DInteger
		        iDbType = REALSQLPreparedStatement.SQLITE_INTEGER
		      case DbType.DSmallInt
		        iDbType = REALSQLPreparedStatement.SQLITE_INTEGER
		      case DbType.DDouble
		        iDbType = REALSQLPreparedStatement.SQLITE_DOUBLE
		      case DbType.DDate
		        iDbType = REALSQLPreparedStatement.SQLITE_TEXT
		      case DbType.DTime
		        iDbType = REALSQLPreparedStatement.SQLITE_TEXT
		      case DbType.DTimestamp
		        iDbType = REALSQLPreparedStatement.SQLITE_TEXT
		      case DbType.DBoolean
		        iDbType = REALSQLPreparedStatement.SQLITE_BOOLEAN
		      case DbType.DBlob
		        iDbType = REALSQLPreparedStatement.SQLITE_BLOB
		      case DbType.DText
		        iDbType = REALSQLPreparedStatement.SQLITE_TEXT
		      case DbType.DInt64
		        iDbType = REALSQLPreparedStatement.SQLITE_INT64
		      case DbType.DFloat
		        iDbType = REALSQLPreparedStatement.SQLITE_DOUBLE
		      case else
		        break 'unsupported type
		      end select
		      #endif
		      
		      #if BKS_ActiveRecordConfig.kIncludeSQLiteDatabase and RBVersion>=2013
		    case isa SQLiteDatabase
		      select case aroField(i).enFieldType
		      case DbType.DInteger
		        iDbType = SQLitePreparedStatement.SQLITE_INTEGER
		      case DbType.DSmallInt
		        iDbType = SQLitePreparedStatement.SQLITE_INTEGER
		      case DbType.DDouble
		        iDbType = SQLitePreparedStatement.SQLITE_DOUBLE
		      case DbType.DDate
		        iDbType = SQLitePreparedStatement.SQLITE_TEXT
		      case DbType.DTime
		        iDbType = SQLitePreparedStatement.SQLITE_TEXT
		      case DbType.DTimestamp
		        iDbType = SQLitePreparedStatement.SQLITE_TEXT
		      case DbType.DBoolean
		        iDbType = SQLitePreparedStatement.SQLITE_BOOLEAN
		      case DbType.DBlob
		        iDbType = SQLitePreparedStatement.SQLITE_BLOB
		      case DbType.DText
		        iDbType = SQLitePreparedStatement.SQLITE_TEXT
		      case DbType.DInt64
		        iDbType = SQLitePreparedStatement.SQLITE_INT64
		      case DbType.DFloat
		        iDbType = SQLitePreparedStatement.SQLITE_DOUBLE
		      case else
		        break 'unsupported type
		      end select
		      #endif
		      
		      #if BKS_ActiveRecordConfig.kIncludeMySQLCommunityServer
		    case isa MySQLCommunityServer
		      select case aroField(i).enFieldType
		      case DbType.DInteger
		        iDbType = MySQLPreparedStatement.MYSQL_TYPE_LONG
		      case DbType.DSmallInt
		        iDbType = MySQLPreparedStatement.MYSQL_TYPE_SHORT
		      case DbType.DDouble
		        iDbType = MySQLPreparedStatement.MYSQL_TYPE_DOUBLE
		      case DbType.DDate
		        iDbType = MySQLPreparedStatement.MYSQL_TYPE_DATE
		      case DbType.DTime
		        iDbType = MySQLPreparedStatement.MYSQL_TYPE_TIME
		      case DbType.DTimestamp
		        iDbType = MySQLPreparedStatement.MYSQL_TYPE_TIMESTAMP
		      case DbType.DBoolean
		        iDbType = MySQLPreparedStatement.MYSQL_TYPE_TINY
		      case DbType.DBlob
		        iDbType = MySQLPreparedStatement.MYSQL_TYPE_BLOB
		      case DbType.DText
		        iDbType = MySQLPreparedStatement.MYSQL_TYPE_STRING
		      case DbType.DInt64
		        iDbType = MySQLPreparedStatement.MYSQL_TYPE_LONGLONG
		      case DbType.DFloat
		        iDbType = MySQLPreparedStatement.MYSQL_TYPE_DOUBLE
		      case else
		        break 'unsupported type
		      end select
		      #endif
		      
		      //Postgres doesn't use bind types.
		      
		      #if BKS_ActiveRecordConfig.kIncludeMSSQLServer
		    case isa MSSQLServerDatabase
		      select case aroField(i).enFieldType
		      case DbType.DInteger
		        iDbType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_BIGINT
		      case DbType.DSmallInt
		        iDbType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_SMALLINT
		      case DbType.DDouble
		        iDbType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_DOUBLE
		      case DbType.DDate
		        iDbType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_DATE
		      case DbType.DTime
		        iDbType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_TIME
		      case DbType.DTimestamp
		        iDbType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_DATETIME
		      case DbType.DBoolean
		        iDbType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_TINYINT
		      case DbType.DBlob
		        iDbType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_BINARY
		      case DbType.DText
		        iDbType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_STRING
		      case DbType.DInt64
		        iDbType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_BIGINT
		      case DbType.DFloat
		        iDbType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_FLOAT
		      case else
		        break 'unsupported type
		      end select
		      #endif
		      
		      #if BKS_ActiveRecordConfig.kIncludeOracle
		    case isa OracleDatabase
		      select case aroField(i).enFieldType
		      case DbType.DInteger
		        iDbType = OracleSQLPreparedStatement.SQL_TYPE_INTEGER
		      case DbType.DSmallInt
		        iDbType = OracleSQLPreparedStatement.SQL_TYPE_INTEGER
		      case DbType.DDouble
		        iDbType = OracleSQLPreparedStatement.SQL_TYPE_FLOAT
		      case DbType.DDate
		        iDbType = OracleSQLPreparedStatement.SQL_TYPE_DATE
		      case DbType.DTime
		        iDbType = OracleSQLPreparedStatement.SQL_TYPE_STRING
		      case DbType.DTimestamp
		        iDbType = OracleSQLPreparedStatement.SQL_TYPE_DATE
		      case DbType.DBoolean
		        iDbType = OracleSQLPreparedStatement.SQL_TYPE_INTEGER
		      case DbType.DBlob
		        iDbType = OracleSQLPreparedStatement.SQL_TYPE_CLOB
		      case DbType.DText
		        iDbType = OracleSQLPreparedStatement.SQL_TYPE_STRING
		      case DbType.DInt64
		        iDbType = OracleSQLPreparedStatement.SQL_TYPE_INTEGER
		      case DbType.DFloat
		        iDbType = OracleSQLPreparedStatement.SQL_TYPE_FLOAT
		      case else
		        break 'unsupported type
		      end select
		      #endif
		      
		      #if BKS_ActiveRecordConfig.kIncludeCubeDatabase
		    case isa CubeSQLServer
		      select case aroField(i).enFieldType
		      case DbType.DInteger
		        iDbType = REALSQLPreparedStatement.SQLITE_INTEGER
		      case DbType.DSmallInt
		        iDbType = REALSQLPreparedStatement.SQLITE_INTEGER
		      case DbType.DDouble
		        iDbType = REALSQLPreparedStatement.SQLITE_DOUBLE
		      case DbType.DDate
		        iDbType = REALSQLPreparedStatement.SQLITE_TEXT
		      case DbType.DTime
		        iDbType = REALSQLPreparedStatement.SQLITE_TEXT
		      case DbType.DTimestamp
		        iDbType = REALSQLPreparedStatement.SQLITE_TEXT
		      case DbType.DBoolean
		        iDbType = REALSQLPreparedStatement.SQLITE_BOOLEAN
		      case DbType.DBlob
		        iDbType = REALSQLPreparedStatement.SQLITE_BLOB
		      case DbType.DText
		        iDbType = REALSQLPreparedStatement.SQLITE_TEXT
		      case DbType.DInt64
		        iDbType = REALSQLPreparedStatement.SQLITE_INT64
		      case DbType.DFloat
		        iDbType = REALSQLPreparedStatement.SQLITE_DOUBLE
		      case else
		        break 'unsupported type
		      end select
		      #endif
		      
		    end select
		    
		    
		    stmt.BindType(i, iDbType)
		    
		    if oField.IsKey and v.IntegerValue<=0 then
		      'if the field is a key and it's 0 or less, then set it to NULL
		      BindNull(stmt, i)
		      
		    elseif pi.PropertyType.Name="Date" or (pi.PropertyType.Name="Variant" and v.Type=Variant.TypeDate) then
		      
		      dim dt as Date = v.DateValue
		      if dt=nil then
		        BindNull(stmt, i)
		      else
		        dim dt1 as new Date
		        dt1.GMTOffset = dt.GMTOffset
		        dt1.TotalSeconds = dt.TotalSeconds
		        v = dt1 'copied for the saved value

		        'Dates are stored in local time, matching ReadRecord. Converting to GMT here
		        'shifted DATE columns back a day for anyone east of Greenwich.
		        if oField.enFieldType=BKS_ActiveRecord.DbType.DDate then
		          stmt.Bind(i, dt.SQLDate)
		        elseif oField.enFieldType=BKS_ActiveRecord.DbType.DTimestamp then
		          stmt.Bind(i, dt.SQLDateTime)
		        else
		          stmt.Bind(i, dt.SQLDateTime)
		        end if
		      end if
		      
		    elseif pi.PropertyType.Name="Double" and v.DoubleValue = BKS_ActiveRecord.kDoubleNullSentinal then
		      BindNull(stmt, i)
		    else
		      stmt.Bind(i, v)
		    end if
		    
		    dictFieldValue.Value(pi.Name) = v
		    
		  next
		  
		  return dictFieldValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CommitTransaction()
		  if m_iTransactionCt <= 0 then
		    raise new ActiveRecordException("CommitTransaction called without a matching BeginTransaction")
		  end if

		  m_iTransactionCt = m_iTransactionCt - 1

		  if m_iTransactionCt = 0 then
		    Db.Commit
		    if Db.Error then
		      dim ex as new BKS_ActiveRecord.DatabaseException(Db, "Commit")
		      Db.Rollback
		      raise ex
		    end if
		  else
		    Var sSavepoint As String = SavepointName(m_iTransactionCt)
		    Var sRelease As String = SQLReleaseSavepoint(sSavepoint)
		    if sRelease <> "" then
		      SQLExecute(sRelease)
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor()
		  'Empty
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Db() As Database
		  BKS_Debug.Assert( false, "needs to be implemented in subclass" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteRecord(oRecord as BKS_ActiveRecord.Base)
		  dim sql as string
		  dim oTableInfo as BKS_ActiveRecord.P.TableInfo
		  
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  sql = "DELETE FROM " + oTableInfo.sTableName + _
		  " WHERE " + oTableInfo.sPrimaryKey + "=?"
		  
		  dim stmt as PreparedSQLStatement
		  stmt = db.Prepare(sql)
		  BindId(stmt, 0, oRecord.ID)
		  
		  stmt.SQLExecute
		  if db.Error then
		    raise new BKS_ActiveRecord.DatabaseException(db)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetLastInsertID() As Int64
		  BKS_Debug.Assert( false, "needs to be implemented in subclass" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasTable(sTableName as String) As boolean
		  dim rs as RecordSet
		  rs = Db.TableSchema
		  while not rs.EOF
		    if rs.IdxField(1).StringValue = sTableName then
		      return true
		    end if
		    rs.MoveNext
		  wend
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function InsertRecord(oRecord as BKS_ActiveRecord.Base, byref dictSavedPropertyValue as Dictionary) As Int64
		  dim oTableInfo as BKS_ActiveRecord.P.TableInfo
		  
		  dim dictFieldValue as Dictionary
		  
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  dim arsField() as string
		  dim arsPlaceholder() as string
		  dim aroField() as BKS_ActiveRecord.P.FieldInfo
		  
		  for each oField as BKS_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		    if oField.bPrimaryKey then
		      continue
		    end if
		    arsField.Append(oField.sFieldName)
		    arsPlaceholder.Append("?")
		    aroField.Append(oField)
		  next
		  
		  dim sql as string
		  sql = "INSERT INTO " + oTableInfo.sTableName
		  sql = sql + "(" + Join(arsField, ",") + ")"
		  sql = sql + " VALUES "
		  sql = sql + "(" + Join(arsPlaceholder, ",") + ")"
		  
		  dim stmt as PreparedSQLStatement
		  stmt = db.Prepare(sql)
		  
		  dictFieldValue = BindValues(stmt, oRecord, aroField)
		  
		  stmt.SQLExecute
		  if db.Error then
		    raise new BKS_ActiveRecord.DatabaseException(db)
		  end if
		  
		  dim iRecordID as Int64 = GetLastInsertID
		  dictFieldValue.Value( oTableInfo.piPrimaryKey.Name ) = iRecordID
		  
		  'store the newly saved property values
		  dictSavedPropertyValue = dictFieldValue
		  
		  return iRecordID
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RollbackTransaction()
		  'Nothing open, for example when BeginTransaction itself failed. Ignoring this
		  'keeps the level counter from going negative.
		  if m_iTransactionCt <= 0 then
		    return
		  end if

		  m_iTransactionCt = m_iTransactionCt - 1

		  if m_iTransactionCt = 0 then
		    Db.Rollback
		  else
		    Var sSavepoint As String = SavepointName(m_iTransactionCt)
		    Var sRollback As String = SQLRollbackToSavepoint(sSavepoint)
		    SQLExecute(sRollback)
		    Var sRelease As String = SQLReleaseSavepoint(sSavepoint)
		    if sRelease <> "" then
		      SQLExecute(sRelease)
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SavepointName(iLevel as Integer) As String
		  Var sLevel As String = iLevel.ToString
		  return "bks_ar_sp" + sLevel
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SQLBeginTransaction() As String
		  'Override for databases with different syntax. Return "" if transactions start implicitly.
		  return "BEGIN"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SQLReleaseSavepoint(sName as String) As String
		  'Override for databases with different syntax. Return "" if there is no release statement.
		  return "RELEASE SAVEPOINT " + sName
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SQLRollbackToSavepoint(sName as String) As String
		  'Override for databases with different syntax.
		  return "ROLLBACK TO SAVEPOINT " + sName
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SQLSavepoint(sName as String) As String
		  'Override for databases with different syntax.
		  return "SAVEPOINT " + sName
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectList(sTable as string, sCondition as string = "", sOrder as string = "") As RecordSet
		  dim sSQL as string = "SELECT * FROM " + sTable + " "
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
		Function SelectRecord(oRecord as BKS_ActiveRecord.Base, iRecordID as integer) As RecordSet
		  dim sql as string
		  dim rs as RecordSet
		  dim oTableInfo as BKS_ActiveRecord.P.TableInfo
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  sql = "SELECT * FROM " + oTableInfo.sTableName + _
		  " WHERE " + oTableInfo.sPrimaryKey + "=?"
		  
		  dim stmt as PreparedSQLStatement
		  stmt = db.Prepare(sql)
		  BindId(stmt, 0, iRecordID)
		  
		  rs = stmt.SQLSelect
		  if db.Error then
		    raise new BKS_ActiveRecord.DatabaseException(db)
		  end if
		  
		  return rs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecute(sql as String)
		  db.SQLExecute( sql )
		  if db.Error then
		    raise new BKS_ActiveRecord.DatabaseException( db, sql )
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLSelect(sql as String) As RecordSet
		  dim rs as RecordSet = db.SQLSelect( sql )
		  if db.Error then
		    raise new BKS_ActiveRecord.DatabaseException( db, sql )
		  end if
		  return rs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateRecord(oRecord as BKS_ActiveRecord.Base, byref dictSavedPropertyValue as Dictionary)
		  dim oTableInfo as BKS_ActiveRecord.P.TableInfo
		  
		  dim dictFieldValue as Dictionary
		  
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  dim arsField() as string
		  dim aroField() as BKS_ActiveRecord.P.FieldInfo
		  dim oPrimaryKeyField as BKS_ActiveRecord.P.FieldInfo
		  
		  for each oField as BKS_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		    if oField.bPrimaryKey then
		      oPrimaryKeyField = oField
		      continue
		    end if
		    arsField.Append(oField.sFieldName + "=?")
		    aroField.Append(oField)
		  next
		  dim sql as string
		  sql = "UPDATE " + oTableInfo.sTableName + " SET "
		  sql = sql + Join(arsField, ",")
		  sql = sql + " WHERE " + oTableInfo.sPrimaryKey + "=?"
		  
		  dim stmt as PreparedSQLStatement
		  stmt = db.Prepare(sql)
		  
		  aroField.Append(oPrimaryKeyField)
		  dictFieldValue = BindValues(stmt, oRecord, aroField)
		  
		  stmt.SQLExecute
		  if db.Error then
		    raise new BKS_ActiveRecord.DatabaseException(db)
		  end if
		  
		  'store the newly saved property values
		  dictSavedPropertyValue = dictFieldValue
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_iTransactionCt As Integer
	#tag EndProperty


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
