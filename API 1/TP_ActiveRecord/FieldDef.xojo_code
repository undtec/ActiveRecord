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
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsForeignKey"
			Group="Behavior"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsPrimaryKey"
			Group="Behavior"
			Type="boolean"
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
			Name="sFieldName"
			Group="Behavior"
			Type="string"
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
		#tag ViewProperty
			Name="enFieldType"
			Group="Behavior"
			Type="BKS_ActiveRecord.DbType"
			EditorType="Enum"
			#tag EnumValues
				"0 - DInteger"
				"1 - DSmallInt"
				"2 - DDouble"
				"3 - DDate"
				"4 - DTime"
				"5 - DTimestamp"
				"6 - DBoolean"
				"7 - DBlob"
				"8 - DText"
				"9 - DInt64"
				"10 - DFloat"
				"11 - DCurrency"
				"12 - DNotUsed"
				"13 - DDecimal"
			#tag EndEnumValues
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
