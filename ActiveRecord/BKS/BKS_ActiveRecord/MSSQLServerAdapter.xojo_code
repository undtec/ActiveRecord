#tag Class
Protected Class MSSQLServerAdapter
Inherits BKS_ActiveRecord.DatabaseAdapter
	#tag Method, Flags = &h0
		Sub Constructor(oDb as Object)
		  'If you are not connecting to MSSQLServer and do not have the MSSQLServer plugin delete this class (MSSQLServerAdapter)
		  #if BKS_ActiveRecordConfig.kIncludeMSSQLServer
		    dim db as MSSQLServerDatabase = MSSQLServerDatabase(oDb)
		    if db=nil then
		      raise new RuntimeException
		    end if
		    m_db = db
		  #else
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
		  '@@IDENTITY is used deliberately. SCOPE_IDENTITY() would return NULL here because
		  'this query runs as a separate batch after the INSERT. Caveat: if the table has a
		  'trigger that inserts into another identity table, @@IDENTITY returns that ID.
		  dim rs as RecordSet
		  rs = SQLSelect("SELECT @@IDENTITY;")
		  return rs.IdxField(1).Int64Value
		End Function
	#tag EndMethod


	#tag Method, Flags = &h1
		Protected Function SQLBeginTransaction() As String
		  'In T-SQL a plain BEGIN starts a statement block, not a transaction
		  return "BEGIN TRANSACTION"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SQLReleaseSavepoint(sName as String) As String
		  'T-SQL has no release statement for savepoints
		  #pragma unused sName
		  return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SQLRollbackToSavepoint(sName as String) As String
		  'T-SQL savepoint syntax
		  return "ROLLBACK TRANSACTION " + sName
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SQLSavepoint(sName as String) As String
		  'T-SQL savepoint syntax
		  return "SAVE TRANSACTION " + sName
		End Function
	#tag EndMethod


	#tag Note, Name = Note
		
		If you are not connecting to MSSQLServer and do not have the MSSQLServer plugin delete this class (MSSQLServerAdapter)
	#tag EndNote


	#tag Property, Flags = &h21
		Private m_db As Database
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
