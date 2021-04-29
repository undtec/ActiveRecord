#tag Class
Protected Class Entry
	#tag Method, Flags = &h0
		Shared Function AuditAdd(oRecord as DataFile.ActiveRecordBase) As TP_AuditTrail.Entry
		  var oAudit as new TP_AuditTrail.Entry
		  oAudit.m_oRecord = oRecord
		  oAudit.irecord_id = oAudit.m_oRecord.ID
		  oAudit.sAction = kAuditAdd
		  
		  return oAudit
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function AuditDelete(oRecord as DataFile.ActiveRecordBase) As TP_AuditTrail.Entry
		  var oAudit as new TP_AuditTrail.Entry
		  oAudit.m_oRecord = oRecord
		  oAudit.irecord_id = oAudit.m_oRecord.ID
		  oAudit.sAction = kAuditDelete
		  return oAudit
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function AuditEdit(oRecord as DataFile.ActiveRecordBase) As TP_AuditTrail.Entry
		  var oAudit as new TP_AuditTrail.Entry
		  oAudit.m_oRecord = oRecord
		  oAudit.irecord_id = oAudit.m_oRecord.ID
		  oAudit.sAction = kAuditEdit
		  
		  //Build Change Log
		  for each oChange as TP_AuditTrail.ChangeLog in oAudit.m_oRecord.BuildChangeLog
		    var bAddChange as Boolean = true
		    //Ignore modified date/user fields
		    
		    var sField as string = oChange.sFieldName.Lowercase
		    
		    if sField.IndexOf("modified") > -1 then
		      bAddChange = false
		    end if
		    
		    //Add Change
		    if bAddChange = true then
		      var oLog as new TP_AuditTrail.ChangeLog
		      oLog.sFieldName = oChange.sFieldName
		      oLog.sOldValue = oChange.sOldValue
		      oLog.sNewValue = oChange.sNewValue
		      oAudit.aroChangeLog.Add(oLog)
		    end if
		    
		  next
		  
		  return oAudit
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Insert()
		  var oAudit As New DatabaseRow
		  oAudit.Column("record_id").IntegerValue = irecord_id
		  oAudit.Column("parent_id").IntegerValue = iparent_id
		  oAudit.Column("recordtable").StringValue = m_oRecord.GetTableName
		  oAudit.Column("recordaction").StringValue = saction
		  oAudit.Column("actiondate").DateTimeValue = DateTime.Now
		  oAudit.Column("user_id").IntegerValue = iuser_id
		  oAudit.Column("recordno").StringValue = srecordno
		  
		  'Insert Record
		  DataFile.DB.AddRow("t_tp_audit", oAudit)
		  
		  
		  if saction <> kAuditEdit then Return 'Change log is only needed for edit.
		  'Get the New Record ID.
		  var iAuditID as int64
		  iAuditID = m_oRecord.ID
		  
		  'Save Children if required
		  for each oChange as TP_AuditTrail.ChangeLog in aroChangeLog
		    var oChild As New DatabaseRow
		    oChild.Column("audit_id").IntegerValue = iAuditID
		    oChild.Column("fieldname").StringValue = oChange.sfieldname
		    oChild.Column("oldvalue").StringValue = oChange.soldvalue
		    oChild.Column("newvalue").StringValue = oChange.snewvalue
		    
		    'Insert Record
		    DataFile.DB.AddRow("t_tp_changelog", oChild)
		    
		  next
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		aroChangeLog() As TP_AuditTrail.ChangeLog
	#tag EndProperty

	#tag Property, Flags = &h0
		dtactiondate As DateTime
	#tag EndProperty

	#tag Property, Flags = &h0
		iaudit_id As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		iparent_id As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		irecord_id As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		iuser_id As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected m_oRecord As DataFile.ActiveRecordBase
	#tag EndProperty

	#tag Property, Flags = &h0
		saction As String
	#tag EndProperty

	#tag Property, Flags = &h0
		srecordno As String
	#tag EndProperty

	#tag Property, Flags = &h0
		srecordtable As String
	#tag EndProperty


	#tag Constant, Name = kAuditAdd, Type = String, Dynamic = False, Default = \"Add", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kAuditDelete, Type = String, Dynamic = False, Default = \"Delete", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kAuditEdit, Type = String, Dynamic = False, Default = \"Edit", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kAuditVoid, Type = String, Dynamic = False, Default = \"Void", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
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
			Name="iaudit_id"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="iparent_id"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="irecord_id"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="iuser_id"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="saction"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="srecordno"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="srecordtable"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
