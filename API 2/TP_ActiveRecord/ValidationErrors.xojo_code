#tag Class
Protected Class ValidationErrors
	#tag Method, Flags = &h0
		Sub Append(sMessage as string)
		  m_arsError.Add( sMessage )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Clear()
		  m_arsError.ResizeTo(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Error(index as Integer) As string
		  return m_arsError(index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ErrorCount() As integer
		  return m_arsError.LastIndex + 1
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_arsError() As string
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
