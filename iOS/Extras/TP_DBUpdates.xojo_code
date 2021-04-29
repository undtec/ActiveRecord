#tag Module
Protected Module TP_DBUpdates
	#tag Method, Flags = &h21
		Private Sub CreateVersionTable(toLocalDB as iOSSQLiteDatabase)
		  toLocalDB.Begin_Transaction
		  toLocalDB.SQLExecute(kCreateVersionTableSQLite)
		  toLocalDB.Commit_Transaction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetDBVersion(toLocalDB as iOSSQLiteDatabase) As Integer
		  dim sSQL as Text = "SELECT Max(dbversionnumber) AS CurrentVersionCode FROM t_tp_dbversion"
		  dim rs as iOSSQLiteRecordSet = toLocalDB.SQLSelect(sSQL)
		  
		  return rs.Field("CurrentVersionCode").IntegerValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetDBVersion(toLocalDB as iOSSQLiteDatabase, iVersion as Integer)
		  dim sSQL as Text = "INSERT INTO t_tp_dbversion(dbversionnumber) VALUES (" + iVersion.ToText + ");"
		  toLocalDB.SQLExecute(sSQL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateDB(toLocalDB as iOSSQLiteDatabase)
		  // Create the version table if necessary
		  CreateVersionTable(toLocalDB)
		  
		  dim iDBVersion as Integer = GetDBVersion(toLocalDB)
		  
		  // If the version is current we're done
		  if iDBVersion >= kDBVersion then return
		  
		  toLocalDB.Begin_Transaction
		  
		  // This example is the base for how this update function works
		  // Repeat this if block for each version. We recommend using
		  // a different method for each version update, this will help
		  // keep your code clean and organized.
		  if iDBVersion < 1 then UpdateVersion_001(toLocalDB)
		  
		  
		  
		  // After checking for updates, set the current version
		  SetDBVersion(toLocalDB, kDBVersion)
		  
		  toLocalDB.Commit_Transaction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateVersion_001(toLocalDB as iOSSQLiteDatabase)
		  // This is an example function for updating the database
		  // Use it as a template for updates to the database
		  #pragma unused toLocalDB
		  // toLocalDB.SQLExecuteRaiseOnError("{SQL Statement}")
		End Sub
	#tag EndMethod


	#tag Constant, Name = kCreateVersionTableSQLite, Type = Text, Dynamic = False, Default = \"CREATE TABLE IF NOT EXISTS  t_tp_dbversion (\n\t dbversion_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT\x2C\n\t dbdatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP\x2C\n\t dbversionnumber INTEGER\n);", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kDBVersion, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant


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
