#tag Class
Protected Class t_Table
Inherits DataFile.ActiveRecordBase
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
		Shared Function List(stmt as PreparedSQLStatement) As DataFile.t_Table()
		  // Take a PreparedStatement that returns data from this table
		  // and cast it to the ActiveRecord class for use
		  dim aro() as DataFile.t_Table
		  
		  dim rs as recordset = stmt.SQLSelectRaiseOnError(db)
		  
		  while not rs.EOF
		    dim oRecord as new DataFile.t_Table
		    oRecord.ReadRecord(rs)
		    
		    aro.Append(oRecord)
		    
		    rs.MoveNext
		    
		  wend
		  
		  return aro
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function List(sCriteria as String = "", sOrder as String = "", iOffset as Integer = -1) As DataFile.t_Table()
		  // SQL Injection Note:
		  //   You should not use this method if your query contains user entered data.
		  //   Using this method with user entered data could expose you to SQL injection attacks.
		  dim arsSQL() as String
		  dim sBase as String = DataFile.t_Table.BaseSQL
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
		  
		  dim aroRecords() as DataFile.t_Table
		  while not rs.EOF
		    dim oRecord as new DataFile.t_Table
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
		  arsSQL.Append(DataFile.t_Table.BaseSQL(true))
		  
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
