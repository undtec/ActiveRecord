#tag Module
Protected Module TP_DBUpdates
	#tag Method, Flags = &h21
		Private Sub CreateVersionTable(toLocalDB as Database)
		  try
		    #if TP_ActiveRecord.kConfigUseCubeDatabase = true then
		      if toLocalDB isa CubeSQLVM then
		        toLocalDB.ExecuteSQL("BEGIN TRANSACTION")
		        toLocalDB.ExecuteSQL(kCreateVersionTableSQLite)
		        toLocalDB.CommitTransaction
		        
		      end
		      
		    #endif
		    
		    #if TP_ActiveRecord.kConfigUseMSSQLServer = true then
		      if toLocalDB isa MSSQLServerDatabase then
		        toLocalDB.ExecuteSQL("BEGIN TRANSACTION")
		        toLocalDB.ExecuteSQL(kCreateVersionTableMSSQL)
		        toLocalDB.CommitTransaction
		        
		      end
		      
		    #endif
		    
		    #if TP_ActiveRecord.kConfigUseMySQLCommunityServer = true then
		      if toLocalDB isa MySQLCommunityServer then
		        toLocalDB.ExecuteSQL("START TRANSACTION")
		        toLocalDB.ExecuteSQL(kCreateVersionTableMySQL)
		        toLocalDB.CommitTransaction
		        
		      end
		      
		    #endif
		    
		    #if TP_ActiveRecord.kConfigUseODBC = true then
		      #pragma Error "TP_AuditTrail does not support ODBC connections."
		      
		    #endif
		    
		    #if TP_ActiveRecord.kConfigUsePostgreSQLDatabase = true then
		      if toLocalDB isa PostgreSQLDatabase then
		        toLocalDB.ExecuteSQL("START TRANSACTION")
		        toLocalDB.ExecuteSQL(kCreateVersionTablePostgres)
		        toLocalDB.CommitTransaction
		        
		      end
		      
		    #endif
		    
		    #if TP_ActiveRecord.kConfigUseSQLiteDatabase = true then
		      if toLocalDB isa SQLiteDatabase then
		        toLocalDB.ExecuteSQL("BEGIN TRANSACTION")
		        toLocalDB.ExecuteSQL(kCreateVersionTableSQLite)
		        toLocalDB.CommitTransaction
		        
		      end
		      
		    #endif
		    
		  catch ex as DatabaseException
		    toLocalDB.RollbackTransaction
		    raise ex
		    
		  end try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetDBVersion(toLocalDB as Database) As Integer
		  var sSQL as String = "SELECT Max(dbversionnumber) AS CurrentVersionCode FROM t_tp_dbversion"
		  var rs as RowSet = toLocalDB.SelectSQL(sSQL)
		  
		  return rs.Column("CurrentVersionCode").IntegerValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetDBVersion(toLocalDB as Database, iVersion as Integer)
		  var sSQL as String = "INSERT INTO t_tp_dbversion(dbversionnumber) VALUES (" + Format(iVersion, "#########") + ");"
		  toLocalDB.ExecuteSQL(sSQL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateDB(toLocalDB as Database)
		  // Create the version table if necessary
		  CreateVersionTable(toLocalDB)
		  
		  var iDBVersion as Integer = GetDBVersion(toLocalDB)
		  
		  // If the version is current we're done
		  if iDBVersion >= kDBVersion then return
		  
		  toLocalDB.BeginTransaction
		  
		  try
		    // This example is the base for how this update function works
		    // Repeat this if block for each version. We recommend using
		    // a different method for each version update, this will help
		    // keep your code clean and organized.
		    if iDBVersion < 1 then UpdateVersion_001(toLocalDB)
		    
		    
		    
		    // After checking for updates, set the current version
		    SetDBVersion(toLocalDB, kDBVersion)
		    
		    toLocalDB.CommitTransaction
		    
		  catch ex as DatabaseException
		    toLocalDB.RollbackTransaction
		    raise ex
		    
		  end try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateVersion_001(toLocalDB as Database)
		  // This is an example function for updating the database
		  // Use it as a template for updates to the database
		  #pragma unused toLocalDB
		  // toLocalDB.ExecuteSQL("{SQL Statement}")
		End Sub
	#tag EndMethod


	#tag Constant, Name = kCreateVersionTableMSSQL, Type = String, Dynamic = False, Default = \"IF NOT EXISTS\n   (  SELECT [name] \n      FROM sys.tables\n      WHERE [name] \x3D \'t_tp_dbversion\' \n   )\nCREATE TABLE [t_tp_dbversion](\n\t[dbversion_id] [int] IDENTITY(1\x2C1) NOT NULL\x2C\n\t[dbdatetime] [datetime] NULL DEFAULT GETDATE()\x2C\n\t[dbversionnumber] [int] NULL\x2C\n CONSTRAINT [PK_t_tp_dbversion] PRIMARY KEY CLUSTERED \n(\n\t[dbversion_id] ASC\n)WITH (PAD_INDEX \x3D OFF\x2C STATISTICS_NORECOMPUTE \x3D OFF\x2C IGNORE_DUP_KEY \x3D OFF\x2C ALLOW_ROW_LOCKS \x3D ON\x2C ALLOW_PAGE_LOCKS \x3D ON) ON [PRIMARY]\n) ON [PRIMARY];", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCreateVersionTableMySQL, Type = String, Dynamic = False, Default = \"CREATE TABLE IF NOT EXISTS t_tp_dbversion (\n  dbversion_id int(11) NOT NULL AUTO_INCREMENT\x2C\n  dbdatetime timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP\x2C\n  dbversionnumber int(11) NOT NULL DEFAULT 0\x2C\n  PRIMARY KEY (dbversion_id)\n) ENGINE\x3DInnoDB AUTO_INCREMENT\x3D1 DEFAULT CHARSET\x3Dlatin1;", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCreateVersionTablePostgres, Type = String, Dynamic = False, Default = \"CREATE SEQUENCE  tp_dbupdate_sequence START 1;\nCREATE TABLE IF NOT EXISTS t_tp_dbversion\n(\n  dbversion_id bigint NOT NULL DEFAULT nextval(\'tp_dbupdate_sequence\'::regclass)\x2C\n  dbversionnumber integer\x2C\n  dbdatetime date DEFAULT now()\x2C\n  CONSTRAINT dbversion_id PRIMARY KEY (dbversion_id)\n); ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCreateVersionTableSQLite, Type = String, Dynamic = False, Default = \"CREATE TABLE IF NOT EXISTS  t_tp_dbversion (\n\t dbversion_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT\x2C\n\t dbdatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP\x2C\n\t dbversionnumber INTEGER\n);", Scope = Private
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
End Module
#tag EndModule
