#tag Class
Protected Class TableDef
	#tag Method, Flags = &h0
		Sub Constructor(sTableName as Text, sPrimaryKey as Text, aroField() as TP_ActiveRecord.FieldDef)
		  self.sTableName = sTableName
		  self.sPrimaryKey = sPrimaryKey
		  self.aroField = aroField
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		aroField() As TP_ActiveRecord.FieldDef
	#tag EndProperty

	#tag Property, Flags = &h0
		sPrimaryKey As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		sTableName As Text
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
