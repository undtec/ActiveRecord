#tag Class
Protected Class CubeSQLDatabaseAdapter
Inherits TP_ActiveRecord.DatabaseAdapter
	#tag Method, Flags = &h0
		Sub BeginTransaction()
		  'If you are not connecting to CubeSQLServer and do not have the CubeSQLServer plugin delete this class (cubeSQLDatabaseAdapter)
		  #if TP_ActiveRecord.kConfigUseCubeDatabase
		    Var db as CubeSQLServer = CubeSQLServer(m_db)
		    if m_iTransactionCt=0 and not db.AutoCommit then
		      try
		        m_Db.CommitTransaction 'commit the auto transaction
		      catch ex as RuntimeException
		        'ignore this one
		      end try
		    end if
		    
		    if m_iTransactionCt=0 then
		      SQLExecute( "BEGIN" )
		    end if
		    m_iTransactionCt = m_iTransactionCt + 1
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BindValues(oStmt as Object, oRecord as TP_ActiveRecord.Base, aroField() as TP_ActiveRecord.P.FieldInfo) As Dictionary
		  // Overriding the parent class ...
		  #if TP_ActiveRecord.kConfigUseCubeDatabase
		    Var stmt as cubeSQLVM = cubeSQLVM(oStmt)
		    Var dictFieldValue as new Dictionary
		    
		    for i as integer = 0 to aroField.LastIndex
		      Var oField as TP_ActiveRecord.P.FieldInfo = aroField(i)
		      Var pi as Introspection.PropertyInfo = oField.piFieldProperty
		      Var v as Variant = pi.Value(oRecord)
		      
		      Var iDBType as Integer
		      select case aroField(i).enFieldType
		      case DBType.DInteger
		        iDBType = SQLitePreparedStatement.SQLITE_INTEGER
		      case DBType.DSmallInt
		        iDBType = SQLitePreparedStatement.SQLITE_INTEGER
		      case DBType.DDouble
		        iDBType = SQLitePreparedStatement.SQLITE_DOUBLE
		      case DBType.DDate
		        iDBType = SQLitePreparedStatement.SQLITE_TEXT
		      case DBType.DTime
		        iDBType = SQLitePreparedStatement.SQLITE_TEXT
		      case DBType.DTimestamp
		        iDBType = SQLitePreparedStatement.SQLITE_TEXT
		      case DBType.DBoolean
		        iDBType = SQLitePreparedStatement.SQLITE_BOOLEAN
		      case DBType.DBlob
		        iDBType = SQLitePreparedStatement.SQLITE_BLOB
		      case DBType.DText
		        iDBType = SQLitePreparedStatement.SQLITE_TEXT
		      case DBType.DInt64
		        iDBType = SQLitePreparedStatement.SQLITE_INT64
		      case DBType.DFloat
		        iDBType = SQLitePreparedStatement.SQLITE_DOUBLE
		      case dbType.dCurrency
		        iDBType = SQLitePreparedStatement.SQLITE_INT64
		      case else
		        break 'unsupported type
		      end select
		      
		      
		      if oField.IsKey and (v.IntegerValue < 1 or v.StringValue = "" or v.StringValue = "0") then
		        'if the field is a key and it's 0 or less, then set it to NULL
		        iDBType = SQLitePreparedStatement.SQLITE_NULL
		      elseif pi.PropertyType.Name="Date" or _
		        (pi.PropertyType.Name="Variant" and v.Type=Variant.TypeDate) then
		        Var dt as DateTime = v.DateTimeValue
		        if dt=nil then
		          iDBType = SQLitePreparedStatement.SQLITE_NULL
		        else
		          Var dt1 as new Date
		          dt1.GMTOffset = dt.GMTOffset
		          dt1.TotalSeconds = dt.TotalSeconds
		          v = dt1 'copied for the saved value
		          
		          Var dt2 as new Date
		          dt2.GMTOffset = dt.GMTOffset
		          dt2.TotalSeconds = dt.TotalSeconds
		          dt2.GMTOffset = 0
		          dt = dt2
		          
		          if oField.enFieldType=TP_ActiveRecord.DBType.DDate then
		            iDBType = SQLitePreparedStatement.SQLITE_TEXT
		          elseif oField.enFieldType=TP_ActiveRecord.DBType.DTimestamp then
		            iDBType = SQLitePreparedStatement.SQLITE_TEXT
		          else
		            iDBType = SQLitePreparedStatement.SQLITE_TEXT
		          end if
		        end if
		      elseif pi.PropertyType.Name="Double" and _
		        v.DoubleValue = TP_ActiveRecord.kDoubleNullSentinal then
		        iDBType = SQLitePreparedStatement.SQLITE_NULL
		      else
		        // stmt.Bind(i, v)
		      end if
		      dictFieldValue.Value(pi.Name) = v
		      
		      select case iDBType
		      case SQLitePreparedStatement.SQLITE_INTEGER
		        stmt.BindInt(i + 1, v.IntegerValue)
		        
		      case SQLitePreparedStatement.SQLITE_DOUBLE
		        stmt.BindDouble(i + 1, v.DoubleValue)
		        
		      case SQLitePreparedStatement.SQLITE_TEXT
		        stmt.BindText(i + 1, v.StringValue)
		        
		      case SQLitePreparedStatement.SQLITE_BOOLEAN
		        stmt.BindInt(i + 1, v.IntegerValue)
		        
		      case SQLitePreparedStatement.SQLITE_BLOB
		        stmt.BindBlob(i + 1, v)
		        
		      case SQLitePreparedStatement.SQLITE_INT64
		        stmt.BindInt64(i + 1, v.Int64Value)
		        
		      end select
		    next
		    
		    return dictFieldValue
		  #endif
		  
		  #pragma unused aroField
		  #pragma unused oRecord
		  #pragma unused oStmt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CommitTransaction()
		  m_iTransactionCt = m_iTransactionCt - 1
		  If m_iTransactionCt=0 Then
		    Try
		      Db.CommitTransaction
		    Catch exCaught As RuntimeException
		      Var ex As New RuntimeException
		      ex.Message = exCaught.Message
		      db.RollbackTransaction
		      Raise ex
		    end
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(oDb as Object)
		  // If you are not connecting to CubeSQL
		  // and do not have the CubeSQL Plugin
		  // then you can safely delete this class
		  #if TP_ActiveRecord.kConfigUseCubeDatabase
		    Var db as CubeSQLServer = CubeSQLServer(oDb)
		    if db=nil then
		      raise new RuntimeException
		    end if
		    m_db = db
		  #else
		    Var ex as new UnsupportedOperationException
		    ex.Message = "CubeSQL is not enabled"
		    raise ex
		  #endif
		  
		  #pragma unused oDB
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Db() As Database
		  return m_db
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteRecord(oRecord as TP_ActiveRecord.Base)
		  #if TP_ActiveRecord.kConfigUseCubeDatabase
		    Var db as CubeSQLServer = CubeSQLServer(m_db)
		    Var sql as string
		    Var oTableInfo as TP_ActiveRecord.P.TableInfo
		    
		    oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		    
		    sql = "DELETE FROM " + oTableInfo.sTableName + _
		    " WHERE " + oTableInfo.sPrimaryKey + "=?1"
		    
		    Var stmt as CubeSQLVM
		    stmt = db.VMPrepare(sql)
		    
		    if oRecord.GUID <> "" then
		      stmt.BindText(1, oRecord.GUID)
		    else
		      stmt.BindInt64(1, oRecord.ID)
		    end if
		    
		    stmt.VMExecute
		    
		  #endif
		  
		  #pragma unused oRecord
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetLastInsertID() As Int64
		  #if TP_ActiveRecord.kConfigUseCubeDatabase
		    Var db as CubeSQLServer = CubeSQLServer(m_db)
		    return db.LastRowID
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertRecord(oRecord as TP_ActiveRecord.Base, byref dictSavedPropertyValue as Dictionary)
		  // Overriding the parent class ...
		  #if TP_ActiveRecord.kConfigUseCubeDatabase
		    Var db as CubeSQLServer = CubeSQLServer(m_db)
		    Var oTableInfo as TP_ActiveRecord.P.TableInfo
		    
		    Var dictFieldValue as Dictionary
		    
		    oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		    
		    Var arsField() as string
		    Var arsPlaceholder() as string
		    Var aroField() as TP_ActiveRecord.P.FieldInfo
		    Var sPK as string
		    Var oPKField as  TP_ActiveRecord.P.FieldInfo
		    
		    Var i as integer
		    for each oField as TP_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		      if oField.bPrimaryKey then
		        sPK = oField.sFieldName
		        oPKField = oField
		        continue
		      end if
		      arsField.Add(oField.sFieldName)
		      
		      i = i + 1
		      arsPlaceholder.Add("?" + str(i))
		      aroField.Add(oField)
		    next
		    Var sql as string
		    sql = "INSERT INTO " + oTableInfo.sTableName
		    sql = sql + "(" + String.FromArray(arsField, ",") + ")"
		    sql = sql + " VALUES "
		    sql = sql + "(" + String.FromArray(arsPlaceholder, ",") + ")"
		    
		    Var stmt as CubeSQLVM
		    stmt = db.VMPrepare(sql)
		    
		    dictFieldValue = BindValues(stmt, oRecord, aroField)
		    
		    stmt.VMExecute
		    
		    Var iRowID as Int64 = GetLastInsertID
		    
		    if oPKField.piFieldProperty.PropertyType.Name = "String" then
		      Var arsSQL() as string
		      arsSQL.Add("select "
		      arsSQL.Add(sPK
		      arsSQL.Add("From "
		      arsSQL.Add(oTableInfo.sTableName
		      arsSQL.Add("Where RowID = "
		      arsSQL.Add(str(iRowID)
		      Var sSQL as string = String.FromArray(arsSQL, " ")
		      Var rs as RowSet = db.SelectSQL(sSQL)
		      
		      Var sRecordID as string = rs.Column(sPK).StringValue
		      dictFieldValue.Value( oTableInfo.piPrimaryKey.Name ) = sRecordID
		      oRecord.GUID = sRecordID
		    else
		      dictFieldValue.Value( oTableInfo.piPrimaryKey.Name ) = iRowID
		      oRecord.id = iRowID
		    end if
		    
		    'store the newly saved property values
		    dictSavedPropertyValue = dictFieldValue
		    
		    
		  #endif
		  
		  #pragma unused dictSavedPropertyValue
		  #pragma unused oRecord
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RollbackTransaction()
		  m_iTransactionCt = m_iTransactionCt - 1
		  if m_iTransactionCt=0 then
		    db.RollbackTransaction
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectRecord(oRecord as TP_ActiveRecord.Base, iRecordID as Int64) As RowSet
		  // Overriding the parent class ...
		  #if TP_ActiveRecord.kConfigUseCubeDatabase
		    Var db as CubeSQLServer = CubeSQLServer(m_db)
		    Var sql as string
		    Var rs as RowSet
		    Var oTableInfo as TP_ActiveRecord.P.TableInfo
		    oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		    
		    sql = "SELECT * FROM " + oTableInfo.sTableName + _
		    " WHERE " + oTableInfo.sPrimaryKey + "=?1"
		    
		    Var stmt as CubeSQLVM
		    stmt = db.VMPrepare(sql)
		    // stmt.BindType(0, SQLitePreparedStatement.SQLITE_INT64)
		    stmt.BindInt64(1, iRecordID)
		    
		    rs = stmt.VMSelect
		    
		    return rs
		  #endif
		  
		  #pragma unused iRecordID
		  #pragma unused oRecord
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectRecord(oRecord as TP_ActiveRecord.Base, sID as string) As RowSet
		  // Overriding the parent class ...
		  #if TP_ActiveRecord.kConfigUseCubeDatabase
		    Var db as CubeSQLServer = CubeSQLServer(m_db)
		    Var sql as string
		    Var rs as RowSet
		    Var oTableInfo as TP_ActiveRecord.P.TableInfo
		    oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		    
		    sql = "SELECT * FROM " + oTableInfo.sTableName + _
		    " WHERE " + oTableInfo.sPrimaryKey + "=?1"
		    
		    Var stmt as CubeSQLVM
		    stmt = db.VMPrepare(sql)
		    stmt.BindText(1, sID)
		    
		    rs = stmt.VMSelect
		    
		    return rs
		  #endif
		  
		  #pragma unused oRecord
		  #pragma unused sID
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateRecord(oRecord as TP_ActiveRecord.Base, byref dictSavedPropertyValue as Dictionary)
		  // Overriding the parent class ...
		  #if TP_ActiveRecord.kConfigUseCubeDatabase
		    Var db as CubeSQLServer = CubeSQLServer(m_db)
		    Var oTableInfo as TP_ActiveRecord.P.TableInfo
		    
		    Var dictFieldValue as Dictionary
		    
		    oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		    
		    Var arsField() as string
		    Var aroField() as TP_ActiveRecord.P.FieldInfo
		    Var oPrimaryKeyField as TP_ActiveRecord.P.FieldInfo
		    
		    Var i as integer
		    
		    for each oField as TP_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		      if oField.bPrimaryKey then
		        oPrimaryKeyField = oField
		        continue
		      end if
		      i = i + 1
		      arsField.Add(oField.sFieldName + "=?" + str(i))
		      aroField.Add(oField)
		      
		    next
		    Var sql as string
		    sql = "UPDATE " + oTableInfo.sTableName + " SET "
		    sql = sql + String.FromArray(arsField, ",")
		    sql = sql + " WHERE " + oTableInfo.sPrimaryKey + "=?"
		    
		    Var stmt as CubeSQLVM
		    stmt = db.VMPrepare(sql)
		    
		    aroField.Add(oPrimaryKeyField)
		    dictFieldValue = me.BindValues(stmt, oRecord, aroField)
		    
		    stmt.VMExecute
		    
		    'store the newly saved property values
		    dictSavedPropertyValue = dictFieldValue
		  #endif
		  
		  #pragma unused dictSavedPropertyValue
		  #pragma unused oRecord
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_db As Database
	#tag EndProperty

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
