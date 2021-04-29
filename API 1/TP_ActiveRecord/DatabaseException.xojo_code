#tag Class
Protected Class DatabaseException
Inherits ActiveRecordException
	#tag Method, Flags = &h0
		Sub Constructor(db as Database, sql as string = "")
		  if db.Error then
		    ErrorCode = db.ErrorCode
		    ErrorMessage = db.ErrorMessage
		    Message = Str( ErrorCode ) + ": " + ErrorMessage
		  else
		    ErrorMessage = "Unknown error"
		  end if
		  
		  if sql <> "" then
		    Message = Message + EndOfLine + "   " + sql
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(sMessage as string, sSQL as string)
		  if sMessage <> "" then
		    me.Message = sMessage
		  end if
		  
		  if sSQL <> "" then
		    me.Message = me.Message + EndOfLine +  "      " + sSQL
		  end
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		ErrorCode As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ErrorMessage As string
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Reason"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ErrorCode"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ErrorMessage"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ErrorNumber"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
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
			Name="Message"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
