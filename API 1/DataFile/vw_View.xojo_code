#tag Class
Protected Class vw_View
Inherits DataFile.ActiveRecordView
	#tag Method, Flags = &h0
		Shared Function BaseSQL(bAsCount as Boolean = false) As String
		  dim arsSQL() as String
		  
		  arsSQL.Append("SELECT")
		  
		  if bAsCount = false then
		    arsSQL.Append("*")
		    
		  else
		    arsSQL.Append("COUNT(*) as iCount")
		    
		  end if
		  
		  arsSQL.Append("FROM vw_View")
		  
		  return Join(arsSQL, " ")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function List(stmt as PreparedSQLStatement) As DataFile.vw_View()
		  // Take a PreparedStatement that returns data from this table
		  // and cast it to the ActiveRecord class for use
		  dim aro() as DataFile.vw_View
		  
		  dim rs as recordset = stmt.SQLSelectRaiseOnError(db)
		  
		  while not rs.EOF
		    dim oRecord as new DataFile.vw_View
		    oRecord.ReadRecord(rs)
		    
		    aro.Append(oRecord)
		    
		    rs.MoveNext
		    
		  wend
		  
		  return aro
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function List(sCriteria as String = "", sOrder as String = "", iOffset as Integer = -1) As DataFile.vw_View()
		  // SQL Injection Note:
		  //   You should not use this method if your query contains user entered data.
		  //   Using this method with user entered data could expose you to SQL injection attacks.
		  dim arsSQL() as String
		  dim sBase as String = DataFile.vw_View.BaseSQL
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
		  
		  dim aroRecords() as DataFile.vw_View
		  while not rs.EOF
		    dim oRecord as new DataFile.vw_View
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
		  arsSQL.Append(DataFile.vw_View.BaseSQL(true))
		  
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
