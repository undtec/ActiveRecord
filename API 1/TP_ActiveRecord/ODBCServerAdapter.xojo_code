#tag Class
Protected Class ODBCServerAdapter
Inherits TP_ActiveRecord.DatabaseAdapter
	#tag Method, Flags = &h0
		Sub BeginTransaction()
		  if m_iTransactionCt=0 then
		    try
		      m_db.Commit 'commit the auto transaction
		    catch ex as RuntimeException
		      'ignore this one
		    end try
		  end if
		  
		  if m_iTransactionCt=0 then
		    SQLExecute( "BEGIN TRANSACTION" )
		  end if
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
		  // If you are not connecting with ODBC
		  // and do not have the ODBCDatabase Plugin
		  // then you can safely delete this class
		  #if TP_ActiveRecord.kConfigUseODBC
		    dim db as ODBCDatabase = ODBCDatabase(oDb)
		    if db=nil then
		      raise new RuntimeException
		    end if
		    m_db = db
		  #else
		    #pragma unused oDb
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
		  //Note that this WILL change depending upon the database you're connecting to via ODBC.
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
		  arsSQL.append " VALUES "
		  arsSQL.append "(" + Join(arsPlaceholder, ",") + ")"
		  
		  dim sSQL as string = Join(arsSQL, " ")
		  
		  dim stmt as PreparedSQLStatement
		  stmt = db.Prepare( sSQL )
		  
		  dictFieldValue = BindValues(stmt, oRecord, aroField)
		  
		  stmt.SQLExecute
		  if db.Error then
		    raise new TP_ActiveRecord.DatabaseException(db)
		  end if
		  
		  if oPKField.piFieldProperty.PropertyType.Name = "String" then
		    'AR for ODBC does not support text. Feel free to modifiy this method to suit your needs.
		    break 
		  end if
		  
		  dim iRecordID as Int64 = GetLastInsertID
		  dictFieldValue.Value( oTableInfo.piPrimaryKey.Name ) = iRecordID
		  
		  
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
