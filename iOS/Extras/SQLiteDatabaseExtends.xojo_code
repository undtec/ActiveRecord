#tag Module
Protected Module SQLiteDatabaseExtends
	#tag Method, Flags = &h0
		Sub Begin_Transaction(extends db as iOSSQLiteDatabase)
		  db.SQLExecute("BEGIN TRANSACTION")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Commit_Transaction(extends db as iOSSQLiteDatabase)
		  #Pragma BreakOnExceptions False
		  //Turning breaks on exceptions off because we may not have an actual transaciton happening.
		  db.SQLExecute("COMMIT")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FieldSchema(extends db as iOSSQLiteDatabase, sTable as Text) As iOSSQLiteRecordSet
		  dim sql as Text = "pragma table_info(" + sTable + ")"
		  
		  Dim rs As iOSSQLiteRecordSet = db.SQLSelect(sql)
		  
		  return rs
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMethod(o As Object, name As Text) As Introspection.MethodInfo
		  dim r as Introspection.MethodInfo
		  
		  dim ti as Introspection.TypeInfo = Introspection.GetType( o )
		  for each method as Introspection.MethodInfo in ti.Methods
		    if method.Name = name then
		      r = method
		      exit for
		    end if
		  next
		  
		  return r
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Rollback_Transaction(extends db as iOSSQLiteDatabase)
		  db.SQLExecute("ROLLBACK")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecuteWithArray(Extends db As iOSSQLiteDatabase, sql As Text, values() As Auto)
		  static method as Introspection.MethodInfo = GetMethod( db, "SQLExecute" )
		  
		  dim params() as Auto
		  params.Append sql
		  params.Append values
		  
		  method.Invoke( db, params )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLSelectWithArray(Extends db As iOSSQLiteDatabase, sql As Text, values() As Auto) As iOSSQLiteRecordSet
		  static method as Introspection.MethodInfo = GetMethod( db, "SQLSelect" )
		  
		  dim params() as Auto
		  params.Append sql
		  params.Append values
		  
		  dim result as auto = method.Invoke( db, params )
		  return iOSSQLiteRecordSet( result )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TableSchema(extends db as iOSSQLiteDatabase) As iOSSQLiteRecordSet
		  dim sql as Text = "SELECT name, type FROM my_db.sqlite_master WHERE type IN ('table', 'view');"
		  
		  Dim rs As iOSSQLiteRecordSet = db.SQLSelect(sql)
		  
		  return rs
		End Function
	#tag EndMethod


	#tag ViewBehavior
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
End Module
#tag EndModule
