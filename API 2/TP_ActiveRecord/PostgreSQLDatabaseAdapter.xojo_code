#tag Class
Protected Class PostgreSQLDatabaseAdapter
Inherits TP_ActiveRecord.DatabaseAdapter
	#tag Method, Flags = &h0
		Sub BeginTransaction()
		  if m_iTransactionCt=0 then
		    try
		      m_Db.CommitTransaction 'commit the auto transaction
		    catch ex as RuntimeException
		      'ignore this one
		    end try
		  end if
		  
		  if m_iTransactionCt=0 then
		    SQLExecute( "START TRANSACTION" )
		  end if
		  m_iTransactionCt = m_iTransactionCt + 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CommitTransaction()
		  m_iTransactionCt = m_iTransactionCt - 1
		  if m_iTransactionCt=0 then
		    Try
		      Db.CommitTransaction
		    Catch err As RuntimeException
		      db.RollbackTransaction
		      Raise Err
		    End
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(oDb as Object)
		  // If you are not connecting to PostgreSQL
		  // and do not have the PostgreSQLDatabase Plugin
		  // then you can safely delete this class
		  #if TP_ActiveRecord.kConfigUsePostgreSQLDatabase
		    Var db as PostgreSQLDatabase = PostgreSQLDatabase(oDb)
		    if db=nil then
		      raise new RuntimeException
		    end if
		    m_db = db
		  #else
		    raise new UnsupportedOperationException
		    #pragma unused oDB
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
		  Var rs as RowSet
		  rs = SQLSelect("SELECT LASTVAL();")
		  return rs.ColumnAt(0).Int64Value
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
		  Var sPK as string
		  Var oPKField as  TP_ActiveRecord.P.FieldInfo
		  
		  for each oField as TP_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		    if oField.bPrimaryKey then
		      sPK = oField.sFieldName
		      oPKField = oField
		      continue
		    end if
		    arsField.Add(oField.sFieldName)
		    arsPlaceholder.Add("$" + str(arsPlaceholder.LastIndex + 2) )
		    aroField.Add(oField)
		  next
		  
		  Var sql as string
		  Var arsSQL() as string
		  arsSQL.Add("INSERT INTO " + oTableInfo.sTableName)
		  arsSQL.Add("(" + String.FromArray(arsField, ",") + ")")
		  arsSQL.Add(" VALUES ")
		  arsSQL.Add("(" + String.FromArray(arsPlaceholder, ",") + ") RETURNING " + oTableInfo.sPrimaryKey)
		  sql = String.FromArray(arsSQL,"")
		  
		  ' Var stmt As PreparedSQLStatement
		  ' stmt = db.Prepare(sql)
		  
		  Var aroValues() As Variant
		  dictFieldValue = BindValues(oRecord, aroField, aroValues)
		  
		  Var rs As RowSet = DB.SelectSQL(sql, aroValues)
		  
		  ' Var rs As RowSet = stmt.SQLSelect
		  ' if db.Error then
		  ' raise new TP_ActiveRecord.DatabaseException(db)
		  ' end if
		  
		  if oPKField.piFieldProperty.PropertyType.Name = "String" then
		    Var sRecordID As String = rs.Column(sPK).StringValue
		    dictFieldValue.Value( oTableInfo.piPrimaryKey.Name ) = sRecordID
		    oRecord.GUID = sRecordID
		  else
		    Var iRecordID as Int64 = rs.Column(sPK).Int64Value
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
		    db.RollbackTransaction
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateRecord(oRecord as TP_ActiveRecord.Base, byref dictSavedPropertyValue as Dictionary)
		  Var oTableInfo as TP_ActiveRecord.P.TableInfo
		  
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
		    arsField.Add(oField.sFieldName + "=$" + str(arsField.LastIndex + 2) )
		    aroField.Add(oField)
		  next
		  
		  Var sql as string
		  sql = "UPDATE " + oTableInfo.sTableName + " SET "
		  sql = sql + String.FromArray(arsField, ",")
		  sql = sql + " WHERE " + oTableInfo.sPrimaryKey + "=$" + str(arsField.LastIndex + 2)
		  
		  ' Var stmt as PreparedSQLStatement
		  ' stmt = db.Prepare(sql)
		  
		  aroField.Add(oPrimaryKeyField)
		  Var aroValues() As Variant
		  dictFieldValue = BindValues(oRecord, aroField, aroValues)
		  
		  db.ExecuteSQL(sql, arovalues)
		  
		  ' stmt.SQLExecute
		  ' if db.Error then
		  ' raise new TP_ActiveRecord.DatabaseException(db)
		  ' end if
		  
		  'store the newly saved property values
		  dictSavedPropertyValue = dictFieldValue
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
