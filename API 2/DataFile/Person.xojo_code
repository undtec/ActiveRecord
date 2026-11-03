#tag Class
Protected Class Person
Inherits DataFile.ActiveRecordBase
	#tag Method, Flags = &h0
		Function FullName() As String
		  Var sName As String = FirstName + " " + LastName
		  Return sName.Trim
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function List(sCriteria as String = "", sOrder as String = "") As DataFile.Person()
		  // SQL Injection Note:
		  //   Do not pass user entered data in sCriteria or sOrder.
		  Var arsSQL() As String
		  arsSQL.Add("SELECT * FROM t_person")

		  If sCriteria.Trim <> "" Then
		    arsSQL.Add("WHERE " + sCriteria)
		  End If

		  If sOrder.Trim = "" Then
		    arsSQL.Add("ORDER BY LastName, FirstName")
		  Else
		    arsSQL.Add("ORDER BY " + sOrder)
		  End If

		  Var sSQL As String = String.FromArray(arsSQL, " ")
		  Var rs As RowSet = DataFile.DB.SelectSQL(sSQL)

		  Var aroRecords() As DataFile.Person
		  While Not rs.AfterLastRow
		    Var oRecord As New DataFile.Person
		    oRecord.ReadRecord(rs)
		    aroRecords.Add(oRecord)
		    rs.MoveToNextRow
		  Wend

		  Return aroRecords
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		DateOfBirth As DateTime
	#tag EndProperty

	#tag Property, Flags = &h0
		FirstName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		id As Int64
	#tag EndProperty

	#tag Property, Flags = &h0
		LastName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Weight As Double
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="2147483648"
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
		#tag ViewProperty
			Name="FirstName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Weight"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="id"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Int64"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
