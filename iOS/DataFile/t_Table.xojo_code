#tag Class
Protected Class t_Table
Inherits DataFile.ActiveRecordBase
	#tag Method, Flags = &h0
		Shared Function BaseSQL(bAsCount as Boolean = false) As Text
		  dim arsSQL() as Text
		  
		  arsSQL.Append("SELECT")
		  
		  if bAsCount = false then
		    arsSQL.Append("*")
		    
		  else
		    arsSQL.Append("COUNT(*) as iCount")
		    
		  end if
		  
		  arsSQL.Append("FROM t_Table")
		  
		  return Text.Join(arsSQL, " ")
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
		Shared Function List(sCriteria as Text = "", sOrder as Text = "", iOffset as Integer = -1) As DataFile.t_Table()
		  // SQL Injection Note:
		  //   You should not use this method if your query contains user entered data.
		  //   Using this method with user entered data could expose you to SQL injection attacks.
		  dim arsSQL() as Text
		  dim sBase as Text = DataFile.t_Table.BaseSQL
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
		    arsSQL.Append("LIMIT " + DataFile.kMaxReturn.ToText + " OFFSET " + iOffset.ToText)
		    
		  end
		  
		  // Fetch
		  dim sSQL as Text = Text.Join(arsSQL, " ")
		  dim rs as iOSSQLiteRecordSet = DataFile.DB.SQLSelect(sSQL)
		  
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
		Shared Function List(sSQL as Text, aroValues() as Auto) As DataFile.t_Table()
		  // SQL Injection Note:
		  //   Use this method if your query contains user entered data.
		  //   Using this method will help prevent SQL injection attacks.
		  dim aro() as t_Table
		  dim rs as iOSSQLiteRecordSet = db.SQLSelectWithArray(sSQL,aroValues)
		  
		  while rs.eof = false
		    dim oRecord as new DataFile.t_Table
		    oRecord.ReadRecord(rs)
		    
		    aro.Append(oRecord)
		    
		    rs.MoveNext
		    
		  wend
		  
		  return aro
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ListCount(sCriteria as Text = "") As Integer
		  // SQL Injection Note:
		  //   You should not use this method if your query contains user entered data.
		  //   Using this method with user entered data could expose you to SQL injection attacks.
		  dim arsSQL() as Text
		  arsSQL.Append(DataFile.t_Table.BaseSQL(true))
		  
		  // Criteria
		  if sCriteria.Trim <> "" then
		    arsSQL.Append("WHERE " + sCriteria)
		    
		  end
		  
		  // Fetch
		  dim sSQL as Text = Text.Join(arsSQL, " ")
		  dim rs as iOSSQLiteRecordSet = DB.SQLSelect(sSQL)
		  
		  return rs.Field("iCount").IntegerValue
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ListCount(sSQL as Text, aroValues() as Auto) As Integer
		  // SQL Injection Note:
		  //   Use this method if your query contains user entered data
		  //   Using this method will help prevent SQL injection attacks.
		  
		  dim rs as iOSSQLiteRecordSet = DB.SQLSelectWithArray(sSQL, aroValues)
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
