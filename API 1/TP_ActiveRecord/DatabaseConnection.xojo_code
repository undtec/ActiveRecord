#tag Class
Protected Class DatabaseConnection
	#tag Property, Flags = &h0
		DB As Database
	#tag EndProperty

	#tag Property, Flags = &h0
		iThreadIdentifier As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		oThreadWeakRef As WeakRef
	#tag EndProperty

	#tag Property, Flags = &h0
		sSessionIdentifier As String
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
			Name="iThreadIdentifier"
			Group="Behavior"
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
		#tag ViewProperty
			Name="DB"
			Group="Behavior"
			Type="Database"
		#tag EndViewProperty
		#tag ViewProperty
			Name="sSessionIdentifier"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
