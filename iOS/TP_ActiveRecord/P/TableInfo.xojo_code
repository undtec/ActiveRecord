#tag Class
Protected Class TableInfo
	#tag Property, Flags = &h0
		aroField() As TP_ActiveRecord.P.FieldInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		piPrimaryKey As Introspection.PropertyInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		sPrimaryKey As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		sTableName As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		tyClass As xojo.Introspection.TypeInfo
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="2147483648"
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
			Name="sPrimaryKey"
			Group="Behavior"
			Type="Text"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="sTableName"
			Group="Behavior"
			Type="Text"
			EditorType="MultiLineEditor"
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
