#tag Module
Protected Module Globals
	#tag Method, Flags = &h1
		Protected Sub AddField(sTable as String, sField as String, sType as String)
		  // Make sure table exists
		  if HasTable(sTable) then
		    // Add field if it doesn't already exist in the given table
		    if HasField(sTable, sField) = false then
		      dim sSQL as String = "ALTER TABLE " + sTable + " ADD " + sField + " " + sType + ""
		      DataFile.DB.SQLExecuteRaiseOnError(sSQL)
		      
		    end
		    
		  end
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function HasField(sTable as String, sField as String) As Boolean
		  // Check the table and return true if there is a column (sField)
		  if DataFile.DB = nil then
		    // Database is not connected!
		    break
		    return false
		    
		  end
		  
		  dim rs as RecordSet = DataFile.DB.FieldSchema(sTable)
		  
		  while not rs.EOF
		    if rs.Field("ColumnName").StringValue = sField then
		      // Field exists
		      return true
		      
		    end
		    
		    rs.MoveNext
		    
		  wend
		  
		  // Table was not found
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function HasTable(sTableName as String) As Boolean
		  // Check the database and return true if the table exists
		  if DataFile.DB = nil then
		    // Database is not connected!
		    break
		    return false
		    
		  end
		  
		  dim rs as RecordSet = DataFile.DB.TableSchema
		  
		  while not rs.EOF
		    if rs.IdxField(1).StringValue = sTableName then
		      // Table exists
		      return true
		      
		    end
		    
		    rs.MoveNext
		    
		  wend
		  
		  // Table was not found
		  return false
		End Function
	#tag EndMethod


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
	#tag EndViewBehavior
End Module
#tag EndModule
