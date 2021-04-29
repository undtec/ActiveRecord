#tag Class
Protected Class ActiveRecordClass
Inherits DataFile.ActiveRecordBase
	#tag Event
		Sub AfterCreate()
		  dim oAudit as TP_AuditTrail.Entry = TP_AuditTrail.Entry.AuditAdd(self)
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
		    dim oAudit as TP_AuditTrail.Entry = TP_AuditTrail.Entry.AuditDelete(self)
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
		    dim oAudit as TP_AuditTrail.Entry = TP_AuditTrail.Entry.AuditEdit(self)
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
		  dim arsSQL() as String
		  
		  arsSQL.Append("SELECT")
		  
		  if bAsCount = false then
		    arsSQL.Append("*")
		    
		  else
		    arsSQL.Append("COUNT(*) as iCount")
		    
		  end if
		  
		  arsSQL.Append("FROM t_Table")
		  
		  return Join(arsSQL, " ")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FindByID(iID as Integer) As DataFile.ActiveRecordClass
		  // Use ActiveRecord Load function to get the record
		  dim oRecord as new DataFile.ActiveRecordClass
		  if oRecord.Load(iID) then
		    return oRecord
		    
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FindByID(sID as String) As DataFile.ActiveRecordClass
		  // Use ActiveRecord Load function to get the record
		  dim oRecord as new DataFile.ActiveRecordClass
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
		  
		  // dim arsSQL() as String
		  // arsSQL.Append(t_Table.BaseSQL)
		  // arsSQL.Append("WHERE %unique_field% = ?")
		  // arsSQL.Append("AND %primary_key% <> ?")
		  // 
		  // dim sSQL as String = Join(arsSQL, " ")
		  // 
		  // dim ps as PreparedSQLStatement = DataFile.DB.Prepare(sSQL)
		  // ps.BindType(0, SQLitePreparedStatement.SQLITE_TEXT)
		  // ps.BindType(1, SQLitePreparedStatement.SQLITE_INTEGER)
		  // ps.Bind(0, sValue)
		  // ps.Bind(1, self.ID)
		  // 
		  // dim rs as RecordSet = ps.SQLSelect
		  // return (rs.Field("iCount").IntegerValue > 0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function List(stmt as PreparedSQLStatement) As DataFile.ActiveRecordClass()
		  // Take a PreparedStatement that returns data from this table
		  // and cast it to the ActiveRecord class for use
		  dim aro() as DataFile.ActiveRecordClass
		  
		  dim rs as recordset = stmt.SQLSelectRaiseOnError(db)
		  
		  while not rs.EOF
		    dim oRecord as new DataFile.ActiveRecordClass
		    oRecord.ReadRecord(rs)
		    
		    aro.Append(oRecord)
		    
		    rs.MoveNext
		    
		  wend
		  
		  return aro
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function List(sCriteria as String = "", sOrder as String = "", iOffset as Integer = -1) As DataFile.ActiveRecordClass()
		  // SQL Injection Note:
		  //   You should not use this method if your query contains user entered data.
		  //   Using this method with user entered data could expose you to SQL injection attacks.
		  dim arsSQL() as String
		  dim sBase as String = DataFile.ActiveRecordClass.BaseSQL
		  arsSQL.Append(sBase)
		  
		  // Criteria
		  if sCriteria.Trim <> "" then
		    arsSQL.Append("WHERE " + sCriteria)
		    
		  end
		  
		  // ORDER BY
		  if sOrder.Trim = "" then
		    // Set up a default order by
		    // arsSQL.Append("ORDER BY {default_orderby_field}")
		    
		  else
		    // Order by parameter passed
		    arsSQL.Append("ORDER BY " + sOrder)
		    
		  end
		  
		  // Offset
		  if iOffset > -1 then
		    arsSQL.Append("LIMIT " + str(DataFile.kMaxReturn) + " OFFSET " + str(iOffset))
		    
		  end
		  
		  // Fetch
		  dim sSQL as string = Join(arsSQL, " ")
		  dim rs as recordset = DataFile.DB.SQLSelectRaiseOnError(sSQL)
		  
		  dim aroRecords() as DataFile.ActiveRecordClass
		  while not rs.EOF
		    dim oRecord as new DataFile.ActiveRecordClass
		    oRecord.ReadRecord(rs)
		    
		    aroRecords.Append(oRecord)
		    
		    rs.MoveNext
		    
		  wend
		  
		  return aroRecords
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ListCount(stmt as PreparedSQLStatement) As Integer
		  // Take a PreparedStatement that returns the count from this table
		  dim rs as Recordset = stmt.SQLSelectRaiseOnError(db)
		  return rs.IdxField(1).IntegerValue
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ListCount(sCriteria as String = "") As Integer
		  // SQL Injection Note:
		  //   You should not use this method if your query contains user entered data.
		  //   Using this method with user entered data could expose you to SQL injection attacks.
		  dim arsSQL() as String
		  arsSQL.Append(DataFile.ActiveRecordClass.BaseSQL(true))
		  
		  // Criteria
		  if sCriteria.Trim <> "" then
		    arsSQL.Append("WHERE " + sCriteria)
		    
		  end
		  
		  // Fetch
		  dim sSQL as string = Join(arsSQL, " ")
		  dim rs as recordset = DB.SQLSelectRaiseOnError(sSQL)
		  
		  return rs.Field("iCount").IntegerValue
		  
		End Function
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="2147483648"
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
