#tag Class
Protected Class FieldOpt
	#tag Method, Flags = &h0
		Sub Constructor(sFieldName as Text)
		  m_sFieldName = sFieldName
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FieldName() As Text
		  return m_sFieldName
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ForeignKey() As TP_ActiveRecord.FieldOpt
		  m_bForeignKey = true
		  return self
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Ignored() As TP_ActiveRecord.FieldOpt
		  m_bIgnored = true
		  return self
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsForeignKey() As Boolean
		  return m_bForeignKey
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsIgnored() As Boolean
		  return m_bIgnored
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_bForeignKey As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_bIgnored As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_sFieldName As Text
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
