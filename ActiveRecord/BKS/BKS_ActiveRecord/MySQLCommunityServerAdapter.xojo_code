#tag Class
Protected Class MySQLCommunityServerAdapter
Inherits BKS_ActiveRecord.DatabaseAdapter
	#tag Method, Flags = &h0
		Sub Constructor(oDb as Object)
		  'If you are not connecting to MySQL and do not have the MySQLCommunityPlugin plugin delete this class (MySQLCommunityServerAdapter)
		  #if BKS_ActiveRecordConfig.kIncludeMySQLCommunityServer
		    dim db as MySQLCommunityServer = MySQLCommunityServer(oDb)
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
		  #if BKS_ActiveRecordConfig.kIncludeMySQLCommunityServer
		    return MySQLCommunityServer(m_db).GetInsertID
		  #else
		    raise new UnsupportedOperationException
		  #endif
		End Function
	#tag EndMethod


	#tag Note, Name = Note
		If you are not connecting to MySQL and 
		do not have the MySQLCommunityPlugin plugin delete this class (MySQLCommunityServerAdapter)
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
