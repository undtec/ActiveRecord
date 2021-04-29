#tag Class
Protected Class FieldDef
	#tag Method, Flags = &h0
		Sub Constructor(sFieldName as string, enFieldType as TP_ActiveRecord.DBType, bPrimaryKey as boolean, bForeignKey as boolean)
		  self.sFieldName = sFieldName
		  self.enFieldType = enFieldType
		  self.IsPrimaryKey = bPrimaryKey
		  self.IsForeignKey = bForeignKey
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		enFieldType As TP_ActiveRecord.DBType
	#tag EndProperty

	#tag Property, Flags = &h0
		IsForeignKey As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		IsPrimaryKey As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		sFieldName As string
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
			Name="IsForeignKey"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsPrimaryKey"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="boolean"
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
			Name="sFieldName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
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
		#tag ViewProperty
			Name="enFieldType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="BKS_ActiveRecord.DbType"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
