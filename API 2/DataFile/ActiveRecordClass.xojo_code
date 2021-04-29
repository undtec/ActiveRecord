#tag Class
Protected Class ActiveRecordClass
Inherits DataFile.ActiveRecordBase
	#tag Event
		Sub AfterCreate()
		  var oAudit as TP_AuditTrail.Entry = TP_AuditTrail.Entry.AuditAdd(self)
		  'Add Additional Info here.
		  'oAudit.srecordno = "your record number string Here"
		  'oAudit.iparent_id = 0 'Parent Record ID here if required
		  'oAudit.iuser_id = 0 'User ID if required.
		  oAudit.Insert
		End Sub
	#tag EndEvent

	#tag Event
		Sub AfterDelete()
		  if self.IsNew = false then
		    var oAudit as TP_AuditTrail.Entry = TP_AuditTrail.Entry.AuditDelete(self)
		    'oAudit.srecordno = "your record number string Here"
		    'oAudit.iparent_id = 0 'Parent Record ID here if required
		    'oAudit.iuser_id = 0 'User ID if required.
		    oAudit.Insert
		    
		  end
		End Sub
	#tag EndEvent

	#tag Event
		Sub AfterUpdate()
		  // If the record hasn't been modified don't add an audit trail
		  if me.IsModified = true then
		    var oAudit as TP_AuditTrail.Entry = TP_AuditTrail.Entry.AuditEdit(self)
		    'Add Additional Info here.
		    'oAudit.srecordno = "your record number string Here"
		    'oAudit.iparent_id = 0 'Parent Record ID here if required
		    'oAudit.iuser_id = 0 'User ID if required.
		    oAudit.Insert
		    
		  end
		End Sub
	#tag EndEvent

	#tag Event
		Sub Validate(oErrors as TP_ActiveRecord.ValidationErrors)
		  // Check for errors here. Use this to prevent deletion.
		  // Append to the oErrors object to cause validation to return false
		  #pragma unused oErrors
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Shared Function BaseSQL(bAsCount as Boolean = false) As String
		  var arsSQL() as String
		  
		  arsSQL.Add("SELECT")
		  
		  if bAsCount = false then
		    arsSQL.Add("*")
		    
		  else
		    arsSQL.Add("COUNT(*) as iCount")
		    
		  end if
		  
		  arsSQL.Add("FROM t_Table")
		  
		  return String.FromArray(arsSQL)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FindByID(iID as Integer) As DataFile.ActiveRecordClass
		  // Use ActiveRecord Load function to get the record
		  var oRecord as new DataFile.ActiveRecordClass
		  if oRecord.Load(iID) then
		    return oRecord
		    
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FindByID(sID as String) As DataFile.ActiveRecordClass
		  // Use ActiveRecord Load function to get the record
		  var oRecord as new DataFile.ActiveRecordClass
		  if oRecord.Load(sID) then
		    return oRecord
		    
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsDuplicate(sValue as String) As Boolean
		  // Use this Method to test for duplicate records
		  // Note: The following example is for a SQLite database and may differ for your database.
		  // For more information see http://docs.xojo.com/index.php/PreparedSQLStatement
		  break
		  
		  // var arsSQL() as String
		  // arsSQL.Add(t_Table.BaseSQL(true))
		  // arsSQL.Add("WHERE %unique_field% = ?")
		  // arsSQL.Add("AND %primary_key% <> ?")
		  // 
		  // var sSQL as String = String.FromArray(arsSQL, " ")
		  // 
		  // var rs as RowSet = DataFile.DB.SelectSQL(sSQL, sValue, self.ID)
		  // return (rs.Column("iCount").IntegerValue > 0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function List(stmt as PreparedSQLStatement) As DataFile.ActiveRecordClass()
		  // Take a PreparedStatement that returns data from this table
		  // and cast it to the ActiveRecord class for use
		  var rs as RowSet = stmt.SelectSQL
		  
		  var aroRecords() as DataFile.ActiveRecordClass
		  while not rs.AfterLastRow
		    var oRecord as new DataFile.ActiveRecordClass
		    oRecord.ReadRecord(rs)
		    
		    aroRecords.Add(oRecord)
		    
		    rs.MoveToNextRow
		    
		  wend
		  
		  return aroRecords
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function List(sCriteria as String = "", sOrder as String = "", iOffset as Integer = -1) As DataFile.ActiveRecordClass()
		  // SQL Injection Note:
		  //   You should not use this method if your query contains user entered data.
		  //   Using this method with user entered data could expose you to SQL injection attacks.
		  var arsSQL() as String
		  var sBase as String = DataFile.ActiveRecordClass.BaseSQL
		  arsSQL.Add(sBase)
		  
		  // Criteria
		  if sCriteria.Trim <> "" then
		    arsSQL.Add("WHERE " + sCriteria)
		    
		  end
		  
		  // ORDER BY
		  if sOrder.Trim = "" then
		    // Set up a default order by
		    // arsSQL.Add("ORDER BY {default_orderby_field}")
		    
		  else
		    // Order by parameter passed
		    arsSQL.Add("ORDER BY " + sOrder)
		    
		  end
		  
		  // Offset
		  if iOffset > -1 then
		    arsSQL.Add("LIMIT " + str(DataFile.kMaxReturn) + " OFFSET " + str(iOffset))
		    
		  end
		  
		  // Fetch
		  var sSQL as string = String.FromArray(arsSQL)
		  var rs as RowSet = DataFile.DB.SelectSQL(sSQL)
		  
		  var aroRecords() as DataFile.ActiveRecordClass
		  while not rs.AfterLastRow
		    var oRecord as new DataFile.ActiveRecordClass
		    oRecord.ReadRecord(rs)
		    
		    aroRecords.Add(oRecord)
		    
		    rs.MoveToNextRow
		    
		  wend
		  
		  return aroRecords
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ListCount(stmt as PreparedSQLStatement) As Integer
		  // Take a PreparedStatement that returns the count from this table
		  var rs as RowSet = stmt.SelectSQL
		  return rs.ColumnAt(0).IntegerValue
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ListCount(sCriteria as String = "") As Integer
		  // SQL Injection Note:
		  //   You should not use this method if your query contains user entered data.
		  //   Using this method with user entered data could expose you to SQL injection attacks.
		  var arsSQL() as String
		  arsSQL.Add(DataFile.ActiveRecordClass.BaseSQL(true))
		  
		  // Criteria
		  if sCriteria.Trim <> "" then
		    arsSQL.Add("WHERE " + sCriteria)
		    
		  end
		  
		  // Fetch
		  var sSQL as string = String.FromArray(arsSQL)
		  var rs as RowSet = DataFile.DB.SelectSQL(sSQL)
		  
		  return rs.Column("iCount").IntegerValue
		  
		End Function
	#tag EndMethod


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
	#tag EndViewBehavior
End Class
#tag EndClass
