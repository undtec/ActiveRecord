#tag Class
Protected Class OracleAdapter
Inherits BKS_ActiveRecord.DatabaseAdapter
	#tag Method, Flags = &h0
		Sub Constructor(oDb as Object)
		  'If you are not connecting to Oracle and do not have the OraclePlugin plugin delete this class (OracleAdapter)
		  #if BKS_ActiveRecordConfig.kIncludeOracle
		    dim db as OracleDatabase = OracleDatabase(oDb)
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
		  dim rs as RecordSet
		  rs = SQLSelect("SELECT LASTVAL();")
		  return rs.IdxField(1).Int64Value
		End Function
	#tag EndMethod


	#tag Note, Name = Note
		If you are not connecting to Oracle and do not have the OraclePlugin plugin delete this class (OracleAdapter)
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
