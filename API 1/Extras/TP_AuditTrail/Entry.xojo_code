#tag Class
Protected Class Entry
	#tag Method, Flags = &h0
		Shared Function AuditAdd(oRecord as DataFile.ActiveRecordBase) As TP_AuditTrail.Entry
		  dim oAudit as new TP_AuditTrail.Entry
		  oAudit.m_oRecord = oRecord
		  oAudit.irecord_id = oAudit.m_oRecord.ID
		  oAudit.sAction = kAuditAdd
		  
		  return oAudit
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function AuditDelete(oRecord as DataFile.ActiveRecordBase) As TP_AuditTrail.Entry
		  dim oAudit as new TP_AuditTrail.Entry
		  oAudit.m_oRecord = oRecord
		  oAudit.irecord_id = oAudit.m_oRecord.ID
		  oAudit.sAction = kAuditDelete
		  return oAudit
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function AuditEdit(oRecord as DataFile.ActiveRecordBase) As TP_AuditTrail.Entry
		  dim oAudit as new TP_AuditTrail.Entry
		  oAudit.m_oRecord = oRecord
		  oAudit.irecord_id = oAudit.m_oRecord.ID
		  oAudit.sAction = kAuditEdit
		  
		  //Build Change Log
		  for each oChange as TP_AuditTrail.ChangeLog in oAudit.m_oRecord.BuildChangeLog
		    dim bAddChange as Boolean = true
		    //Ignore modified date/user fields
		    
		    dim sField as string = oChange.sFieldName.Lowercase
		    
		    if  sField.instr("modified") > 0 then
		      bAddChange = false
		    end if
		    
		    //Add Change
		    if bAddChange = true then
		      dim oLog as new TP_AuditTrail.ChangeLog
		      oLog.sFieldName = oChange.sFieldName
		      oLog.sOldValue = oChange.sOldValue
		      oLog.sNewValue = oChange.sNewValue
		      oAudit.aroChangeLog.Append oLog
		    end if
		    
		  next
		  
		  return oAudit
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Insert()
		  Dim oAudit As New DatabaseRecord
		  oAudit.IntegerColumn("record_id") = irecord_id
		  oAudit.IntegerColumn("parent_id") = iparent_id
		  oAudit.Column("recordtable") = m_oRecord.GetTableName
		  oAudit.Column("recordaction") = saction
		  oAudit.DateColumn("actiondate") = new date
		  oAudit.IntegerColumn("user_id") = iuser_id
		  oAudit.Column("recordno") = srecordno
		  
		  'Insert Record
		  DataFile.DB.InsertRecord("t_tp_audit", oAudit)
		  
		  'Check for Error
		  if DataFile.DB.Error then
		    raise new TP_ActiveRecord.DatabaseException(DataFile.DB.ErrorMessage, "audit insert")
		    
		  end
		  
		  if saction <> kAuditEdit then Return 'Change log is only needed for edit.
		  'Get the New Record ID.
		  dim iAuditID as int64
		  iAuditID = m_oRecord.ID
		  
		  'Save Children if required
		  for each oChange as TP_AuditTrail.ChangeLog in aroChangeLog
		    Dim oChild As New DatabaseRecord
		    oChild.IntegerColumn("audit_id") = iAuditID
		    oChild.Column("fieldname") = oChange.sfieldname
		    oChild.Column("oldvalue") = oChange.soldvalue
		    oChild.Column("newvalue") = oChange.snewvalue
		    
		    'Insert Record
		    DataFile.DB.InsertRecord("t_tp_changelog", oChild)
		    
		    'Check for Error
		    if DataFile.DB.Error Then
		      raise new TP_ActiveRecord.DatabaseException(DataFile.DB.ErrorMessage, "audit change log insert")
		    End If
		    
		  next
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		aroChangeLog() As TP_AuditTrail.ChangeLog
	#tag EndProperty

	#tag Property, Flags = &h0
		dtactiondate As Date
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
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iaudit_id"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iparent_id"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="irecord_id"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iuser_id"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="saction"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="srecordno"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="srecordtable"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
