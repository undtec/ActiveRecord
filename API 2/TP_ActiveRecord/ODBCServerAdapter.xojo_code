#tag Class
Protected Class ODBCServerAdapter
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
		    Db.BeginTransaction
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
		  // If you are not connecting with ODBC
		  // and do not have the ODBCDatabase Plugin
		  // then you can safely delete this class
		  #if TP_ActiveRecord.kConfigUseODBC
		    Var db as ODBCDatabase = ODBCDatabase(oDb)
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
		  //Note that this WILL change depending upon the database you're connecting to via ODBC.
		  Var rs as RowSet
		  rs = SQLSelect("SELECT @@IDENTITY;")
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
		  
		  Var aroValues() As Variant
		  dictFieldValue = BindValues(oRecord, aroField, aroValues)
		  
		  db.ExecuteSQL(sSQL, aroValues)
		  
		  ' stmt.SQLExecute
		  ' if db.Error then
		  ' raise new TP_ActiveRecord.DatabaseException(db)
		  ' end if
		  
		  if oPKField.piFieldProperty.PropertyType.Name = "String" then
		    'AR for ODBC does not support text. Feel free to modifiy this method to suit your needs.
		    break 
		  end if
		  
		  Var iRecordID as Int64 = GetLastInsertID
		  dictFieldValue.Value( oTableInfo.piPrimaryKey.Name ) = iRecordID
		  
		  
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
