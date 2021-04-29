#tag Module
Protected Module TP_AuditTrail
	#tag Method, Flags = &h1
		Protected Function CloneDictionary(tdictSource as Dictionary) As Dictionary
		  // Namespaced dictionary clone function
		  dim tdictNew as new Dictionary
		  if tdictSource = nil then return tdictNew
		  
		  for ti as Integer = (tdictSource.Count - 1) downto 0
		    // Clone the entry
		    dim tvKey as Variant = tdictSource.Key(ti)
		    tdictNew.Value(tvKey) = tdictSource.Value(tvKey)
		    
		  next ti
		  
		  return tdictNew
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateAuditTables(toLocalDB as Database)
		  try
		    #if TP_ActiveRecord.kConfigUseCubeDatabase = true then
		      if toLocalDB isa CubeSQLVM then
		        toLocalDB.SQLExecuteRaiseOnError("BEGIN TRANSACTION")
		        toLocalDB.SQLExecuteRaiseOnError(kCreateAuditTablesSQLite)
		        toLocalDB.Commit
		        
		      end
		      
		    #endif
		    
		    #if TP_ActiveRecord.kConfigUseMSSQLServer = true then
		      if toLocalDB isa MSSQLServerDatabase then
		        toLocalDB.SQLExecuteRaiseOnError("BEGIN TRANSACTION")
		        toLocalDB.SQLExecuteRaiseOnError(kCreateAuditTablesMSSQL)
		        toLocalDB.Commit
		        
		      end
		      
		    #endif
		    
		    #if TP_ActiveRecord.kConfigUseMySQLCommunityServer = true then
		      if toLocalDB isa MySQLCommunityServer then
		        toLocalDB.SQLExecuteRaiseOnError("START TRANSACTION")
		        toLocalDB.SQLExecuteRaiseOnError(kCreateAuditTablesMySQL)
		        toLocalDB.Commit
		        
		      end
		      
		    #endif
		    
		    #if TP_ActiveRecord.kConfigUseODBC = true then
		      #pragma Error "TP_AuditTrail does not support ODBC connections."
		      
		    #endif
		    
		    #if TP_ActiveRecord.kConfigUsePostgreSQLDatabase = true then
		      if toLocalDB isa PostgreSQLDatabase then
		        toLocalDB.SQLExecuteRaiseOnError("START TRANSACTION")
		        toLocalDB.SQLExecuteRaiseOnError(kCreateAuditTablesPostgres)
		        toLocalDB.Commit
		        
		      end
		      
		    #endif
		    
		    #if TP_ActiveRecord.kConfigUseSQLiteDatabase = true then
		      if toLocalDB isa SQLiteDatabase then
		        toLocalDB.SQLExecuteRaiseOnError("BEGIN TRANSACTION")
		        toLocalDB.SQLExecuteRaiseOnError(kCreateAuditTablesSQLite)
		        toLocalDB.Commit
		        
		      end
		      
		    #endif
		    
		  catch ex as TP_ActiveRecord.DatabaseException
		    toLocalDB.Rollback
		    raise ex
		    
		  end try
		  
		End Sub
	#tag EndMethod


	#tag Constant, Name = kCreateAuditTablesMSSQL, Type = String, Dynamic = False, Default = \"IF NOT EXISTS\n   (  SELECT [name] \n      FROM sys.tables\n      WHERE [name] \x3D \'t_tp_audit\' \n   )\nCREATE TABLE [t_tp_audit](\n\t[audit_id] [int] IDENTITY(1\x2C1) NOT NULL\x2C\n\t[record_id] [int] NULL\x2C\n\t[parent_id] [int] NULL\x2C\n  \t[recordtable] nText NULL\x2C\n  \t[recordaction] nText NULL\x2C\n\t[actiondate] [datetime] NULL\x2C\n  \t[user_id] [int] NULL\x2C\n  \t[recordno] nText NULL\x2C\n\t\n CONSTRAINT [PK_t_tp_audit] PRIMARY KEY CLUSTERED \n(\n\t[audit_id] ASC\n)WITH (PAD_INDEX \x3D OFF\x2C STATISTICS_NORECOMPUTE \x3D OFF\x2C IGNORE_DUP_KEY \x3D OFF\x2C ALLOW_ROW_LOCKS \x3D ON\x2C ALLOW_PAGE_LOCKS \x3D ON) ON [PRIMARY]\n) ON [PRIMARY];\nIF NOT EXISTS\n   (  SELECT [name] \n      FROM sys.tables\n      WHERE [name] \x3D \'t_tp_changelog\' \n   )\nCREATE TABLE [t_tp_changelog](\n\t[changelog_id] [int] IDENTITY(1\x2C1) NOT NULL\x2C\n\t[audit_id] [int]  NOT NULL\x2C\n  \t[fieldname] nText NULL\x2C\n  \t[oldvalue] nText NULL\x2C\n  \t[newvalue] nText NULL\x2C\t\n CONSTRAINT [PK_t_tp_changelog] PRIMARY KEY CLUSTERED \n(\n\t[changelog_id] ASC\n)WITH (PAD_INDEX \x3D OFF\x2C STATISTICS_NORECOMPUTE \x3D OFF\x2C IGNORE_DUP_KEY \x3D OFF\x2C ALLOW_ROW_LOCKS \x3D ON\x2C ALLOW_PAGE_LOCKS \x3D ON) ON [PRIMARY]\n) ON [PRIMARY];", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCreateAuditTablesMySQL, Type = String, Dynamic = False, Default = \"CREATE TABLE IF NOT EXISTS t_tp_audit (\n  audit_id int(11) NOT NULL AUTO_INCREMENT\x2C\n  record_id int(11) DEFAULT NULL\x2C\n  parent_id int(11) DEFAULT NULL\x2C\n  recordtable text\x2C\n  recordaction text\x2C\n  actiondate datetime DEFAULT NULL\x2C\n  user_id int(11) DEFAULT NULL\x2C\n  recordno text\x2C\n  PRIMARY KEY (audit_id)\n) ENGINE\x3DInnoDB AUTO_INCREMENT\x3D1 DEFAULT CHARSET\x3Dlatin1;\nCREATE TABLE IF NOT EXISTS t_tp_changelog (\n  changelog_id int(11) NOT NULL AUTO_INCREMENT\x2C\n  audit_id int(11) DEFAULT NULL\x2C\n  fieldname text\x2C\n  oldvalue text\x2C\n  newvalue text\x2C\n  PRIMARY KEY (changelog_id)\n) ENGINE\x3DInnoDB AUTO_INCREMENT\x3D1 DEFAULT CHARSET\x3Dlatin1;", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCreateAuditTablesPostgres, Type = String, Dynamic = False, Default = \"CREATE SEQUENCE IF NOT EXISTS tp_audit_sequence START WITH 1;\nCREATE TABLE IF NOT EXISTS t_tp_audit\n(\n  audit_id bigint NOT NULL DEFAULT nextval(\'tp_audit_sequence\'::regclass)\x2C\n  record_id INTEGER DEFAULT NULL\x2C\n  parent_id INTEGER DEFAULT NULL\x2C\n  recordtable text\x2C\n  recordaction text\x2C  \n  actiondate date  DEFAULT NULL\x2C\n  user_id INTEGER DEFAULT NULL\x2C\n  recordno text\x2C   \n  CONSTRAINT audit_id PRIMARY KEY (audit_id)\n);\nCREATE SEQUENCE IF NOT EXISTS tp_changelog_sequence START WITH 1;\nCREATE TABLE IF NOT EXISTS t_tp_changelog\n(\n  changelog_id bigint NOT NULL DEFAULT nextval(\'tp_changelog_sequence\'::regclass)\x2C\n  audit_id INTEGER DEFAULT NULL\x2C\n  fieldname text\x2C   \n  oldvalue text\x2C\n  newvalue text\x2C   \n  CONSTRAINT changelog_id PRIMARY KEY (changelog_id)\n);", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCreateAuditTablesSQLite, Type = String, Dynamic = False, Default = \"CREATE TABLE IF NOT EXISTS t_tp_audit (\n  audit_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT\x2C\n  record_id INTEGER\x2C\n  parent_id INTEGER\x2C\n  recordtable text\x2C\n  recordaction text\x2C\n  actiondate datetime DEFAULT NULL\x2C\n  user_id INTEGER\x2C\n  recordno text\n);\nCREATE TABLE IF NOT EXISTS t_tp_changelog (\n  changelog_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT\x2C\n  audit_id INTEGER\x2C\n  fieldname text\x2C\n  oldvalue text\x2C\n  newvalue text\n);", Scope = Private
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
	#tag EndViewBehavior
End Module
#tag EndModule
