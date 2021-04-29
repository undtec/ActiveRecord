#tag Module
Protected Module DataFile
	#tag Method, Flags = &h21
		Private Sub ConnectionCleanup()
		  // Clean up closed connections
		  if maroConnectionPool.Ubound < 0 then return
		  
		  // Collect active session identifiers
		  dim arsActiveSessions() as String
		  #if TargetWeb then
		    dim iSessionMax as Integer = App.SessionCount - 1
		    for i as Integer = 0 to iSessionMax
		      dim oThis as WebSession = App.SessionAtIndex(i)
		      if oThis <> nil then
		        arsActiveSessions.Append(oThis.Identifier)
		        
		      end
		      
		    next i
		    
		  #else
		    #pragma unused arsActiveSessions
		    
		  #endif
		  
		  for i as Integer = maroConnectionPool.Ubound downto 0
		    dim oThis as TP_ActiveRecord.DatabaseConnection = maroConnectionPool(i)
		    
		    // Thread identified connection, now closed
		    if (oThis.iThreadIdentifier > 0 and oThis.oThreadWeakRef = nil) then
		      oThis.DB.Close
		      oThis.DB = nil
		      
		      // Remove the last reference
		      maroConnectionPool.Remove(i)
		      continue for i
		      
		    end
		    
		    // Thread identified by session
		    #if TargetWeb then
		      if oThis.sSessionIdentifier <> "" then
		        // Check to see if the session has closed
		        if oThis.sSessionIdentifier <> "App" and _
		          arsActiveSessions.IndexOf(oThis.sSessionIdentifier) < 0 then
		          oThis.DB.Close
		          oThis.DB = nil
		          
		          // Remove the last reference
		          maroConnectionPool.Remove(i)
		          continue for i
		          
		        end
		        
		      end
		      
		    #endif
		    
		  next i
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function DB() As Database
		  // Connection cleanup
		  ConnectionCleanup
		  
		  // Begin the Sorting Hat
		  #if TargetDesktop or (TargetConsole and not TargetWeb) then
		    return GetDesktopConnection
		    
		  #elseif TargetWeb then
		    return GetWebConnection
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetConnectionByCurrentThread() As Database
		  // Find or create a connection identified by the current thread identifier
		  dim oCurrent as Thread = App.CurrentThread
		  dim iThreadID as Integer = oCurrent.ThreadID
		  dim oConnection as TP_ActiveRecord.DatabaseConnection
		  
		  for i as Integer = 0 to maroConnectionPool.Ubound
		    dim oThisConnection as TP_ActiveRecord.DatabaseConnection = maroConnectionPool(i)
		    
		    // Found the connection
		    if oThisConnection.iThreadIdentifier = iThreadID then
		      oConnection = oThisConnection
		      exit for i
		      
		    end
		    
		  next i
		  
		  // Create the connection if necessary
		  if oConnection = nil then
		    dim oDatabase as Database = OpenDB
		    
		    if oDatabase = nil then
		      // The database failed to connect, you should handle this.
		      break
		      return nil
		      
		    end
		    
		    // Create the connection object
		    dim oNewConnection as new TP_ActiveRecord.DatabaseConnection
		    oNewConnection.iThreadIdentifier = iThreadID
		    oNewConnection.oThreadWeakRef = new WeakRef(oCurrent)
		    oNewConnection.DB = oDatabase
		    
		    oConnection = oNewConnection
		    
		    // Store it
		    maroConnectionPool.Append(oNewConnection)
		    
		  end
		  
		  // Forcibly release this
		  oCurrent = nil
		  
		  // Return the Database
		  return Database(oConnection.DB)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetDatabase() As Database
		  // Prepares a SQLiteDatabase object to connect
		  // Returns database object if successful
		  #pragma Error "Set location of your database file"
		  dim fDB as FolderItem = GetFolderItem("%db_path%", FolderItem.PathTypeNative)
		  
		  if fDB = nil or fDB.Exists = false then
		    // Be sure to set up the database path in GetDatabaseFile
		    break
		    return nil
		    
		  end
		  
		  dim oLocalDB as new SQLiteDatabase
		  oLocalDB.DatabaseFile = fDB
		  // oLocalDB.EncryptionKey = ""
		  
		  // Return the object
		  return oLocalDB
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetDatabase_MSSQLMBS() As Database
		  // Used Microsoft SQL Server 2008 and run app on Windows to test this
		  // install package tdsodbc
		  #pragma Error "Supply password for the database."
		  const user = "%template_username%"
		  const pass = "" // Consider obfuscating the password String
		  const databaseName = "%template_databasename%"
		  const server = "%template_host%"
		  const Port = "%template_port%"
		  
		  #if TP_ActiveRecord.kConfigUseMSSQLServerMBS then
		    dim con as new SQLDatabaseMBS
		    dim cs as string
		    #if TargetLinux then
		      cs = "DRIVER={libtdsodbc.so};Server="+Server+";UId="+User+";PWD="+Pass+";Database="+DatabaseName+";TDS_VERSION=7.2;Port="+Port
		      con.DatabaseName = "ODBC:"+cs
		      con.Option("UseAPI") = "ODBC" 
		      
		    #elseif TargetWindows then
		      con.UserName = User
		      con.Password = Pass
		      con.Option("OLEDBProvider") = "SQLNCLI"
		      cs = Server + "@"+DatabaseName
		      con.DatabaseName = "SQLServer:"+cs
		      
		    #elseif TargetMacOS then
		      static mFrameworks as FolderItem
		      
		      if mFrameworks = nil or mFrameworks.Exists = false then
		        declare function NSClassFromString lib "AppKit" (className as CFStringRef) as Ptr
		        declare function mainBundle lib "AppKit" selector "mainBundle" (NSBundleClass as Ptr) as Ptr
		        declare function resourcePath lib "AppKit" selector "privateFrameworksPath" (NSBundleRef as Ptr) as CfStringRef
		        mFrameworks = GetFolderItem(resourcePath(mainBundle(NSClassFromString("NSBundle"))), FolderItem.PathTypeNative)
		        
		      end
		      
		      dim libtdsodbc as Folderitem = mFrameworks.Child("libtdsodbc.dylib") 
		      
		      cs = "DRIVER={FREETDS};Server="+Server+";UId="+User+";PWD="+Pass+";Database="+DatabaseName+";TDS_VERSION=7.2;Port="+Port
		      con.SetFileOption con.kOptionLibraryODBC, libtdsodbc
		      con.Option("UseAPI") = "ODBC"
		      con.DatabaseName = "ODBC:"+cs
		      
		    #else
		      #pragma Error "Platform not supported"
		      
		    #endif
		    
		    // ende compile 
		    
		    // DB Library
		    con.Option("DBPROP_INIT_TIMEOUT") = "10"
		    con.Option("DBPROP_COMMANDTIMEOUT") = "10"
		    
		    // ODBC sachen
		    con.Option("SQL_ATTR_QUERY_TIMEOUT") = "10"
		    con.Option("SQL_ATTR_CONNECTION_TIMEOUT") = "10"
		    
		    return con
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetDatabase_Server() As Database
		  // Prepares a Database object to connect
		  // Returns database object if successful
		  dim oLocalDB as new PostgreSQLDatabase
		  oLocalDB.Host = "%template_host%"
		  oLocalDB.Port = 5432
		  oLocalDB.DatabaseName = "%template_databasename%"
		  oLocalDB.UserName = "%template_username%"
		  
		  #pragma Error "Supply password for the database." // Delete this line when done.
		  oLocalDB.Password = "" // Consider obfuscating the password String
		  
		  return oLocalDB
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetDatabase_ServerSSL() As Database
		  // Prepares a PostgreSQLDatabase object to connect
		  // Returns database object if successful
		  dim oLocalDB as new PostgreSQLDatabase
		  oLocalDB.Host = "%template_host%"
		  oLocalDB.Port = 5432
		  oLocalDB.DatabaseName = "%template_databasename%"
		  oLocalDB.UserName = "%template_username%"
		  
		  #pragma Error "Supply password for the database." // Delete this line when done.
		  oLocalDB.Password = "" // Consider obfuscating the password String
		  
		  #if TP_ActiveRecord.kConfigUseMySQLCommunityServer then
		    if oLocalDB isa MySQLCommunityServer then
		      // Configure SSL
		      oLocalDB.SSLMode = true
		      
		      oLocalDB.SSLAuthority = %SSLAuthority%
		      oLocalDB.SSLAuthorityDirectory = %SSLAuthorityDirectory%
		      oLocalDB.SSLCertificate = %SSLCertificate%
		      oLocalDB.SSLKey = %SSLKey%
		      
		    end
		    
		  #elseif TP_ActiveRecord.kConfigUsePostgreSQLDatabase then
		    if oLocalDB isa PostgreSQLDatabase then
		      // Configure SSL
		      oLocalDB.SSLMode = PostgreSQLDatabase.SSLPrefer
		      
		      oLocalDB.SSLAuthority = %SSLAuthority%
		      oLocalDB.SSLCertificate = %SSLCertificate%
		      oLocalDB.SSLKey = %SSLKey%
		      
		    end
		    
		  #endif
		  
		  return oLocalDB
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private Function GetDesktopConnection() As Database
		  // Identify by thread
		  if App.CurrentThread = nil then
		    // Create the connection if necessary
		    if maroConnectionPool.Ubound < 0 then
		      dim oDatabase as Database = OpenDB
		      
		      if oDatabase = nil then
		        // The database failed to connect, you should handle this.
		        break
		        return nil
		        
		      end
		      
		      // Create the connection object
		      dim oConnection as new TP_ActiveRecord.DatabaseConnection
		      oConnection.DB = oDatabase
		      
		      // Store it
		      maroConnectionPool.Append(oConnection)
		      
		    end
		    
		    // Return the connection
		    return Database(maroConnectionPool(0).DB)
		    
		  else
		    // In a thread, find by thread ID
		    return GetConnectionByCurrentThread
		    
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetWeb and (Target32Bit or Target64Bit))
		Private Function GetWebConnection() As Database
		  // Attempt to identify by Session
		  if WebSession.Available and Session <> nil then
		    return GetWebConnectionBySession(Session.Identifier)
		    
		  else
		    // Identify by thread
		    if App.CurrentThread = nil then
		      // Main thread - use "Session" identifier: "App"
		      return GetWebConnectionBySession("App")
		      
		    else
		      // In a thread, find by thread ID
		      return GetConnectionByCurrentThread
		      
		    end
		    
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetWeb and (Target32Bit or Target64Bit))
		Private Function GetWebConnectionBySession(sIdentifier as String) As Database
		  // Find or create a connection identified by a session string
		  dim oConnection as TP_ActiveRecord.DatabaseConnection
		  
		  for i as Integer = 0 to maroConnectionPool.Ubound
		    dim oThisConnection as TP_ActiveRecord.DatabaseConnection = maroConnectionPool(i)
		    
		    // Found the connection
		    if oThisConnection.sSessionIdentifier = sIdentifier then
		      oConnection = oThisConnection
		      exit for i
		      
		    end
		    
		  next i
		  
		  // Create the connection if necessary
		  if oConnection = nil then
		    dim oDatabase as Database = OpenDB
		    
		    if oDatabase = nil then
		      // The database failed to connect, you should handle this.
		      break
		      return nil
		      
		    end
		    
		    // Create the connection object
		    dim oNewConnection as new TP_ActiveRecord.DatabaseConnection
		    oNewConnection.DB = oDatabase
		    oNewConnection.sSessionIdentifier = sIdentifier
		    
		    oConnection = oNewConnection
		    
		    // Store it
		    maroConnectionPool.Append(oNewConnection)
		    
		  end
		  
		  // Return the Database
		  return Database(oConnection.DB)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function OpenDB() As Database
		  // Get a configured Databse object
		  dim oLocalDB as Database = GetDatabase
		  
		  #if TP_ActiveRecord.kConfigUseMSSQLServerMBS then
		    // MS SQL MBS Connection
		    if oLocalDB isa SQLDatabaseMBS then
		      // Test connection
		      if SQLDatabaseMBS(oLocalDB).ConnectMT = false then return nil
		      
		      // Must allow ActiveRecord to control transactions
		      SQLDatabaseMBS(oLocalDB).AutoCommit = SQLDatabaseMBS.kAutoCommitOff
		      
		      // Disabling scrolling cursors is much faster for Microsoft SQL Server
		      SQLDatabaseMBS(oLocalDB).Scrollable = True
		      
		      // Change this if you'd rather check for error codes
		      SQLDatabaseMBS(oLocalDB).RaiseExceptions = True
		      
		    end
		    
		  #else
		    // Test connection
		    if oLocalDB.Connect = false then return nil
		    
		  #endif
		  
		  // Make any db updates here before registering
		  TP_AuditTrail.CreateAuditTables(oLocalDB)
		  TP_DBUpdates.UpdateDB(oLocalDB)
		  
		  // Tell ActiveRecord what the connection is
		  TP_ActiveRecord.Connect(GetTypeInfo(DataFile.ActiveRecordBase), oLocalDB)
		  TP_ActiveRecord.Connect(GetTypeInfo(DataFile.ActiveRecordView), oLocalDB)
		  
		  // Register the tables with ActiveRecord
		  Register(oLocalDB)
		  
		  // Return the object
		  return oLocalDB
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Register(oLocalDB as Database)
		  #pragma unused oLocalDB
		  
		  // Tables
		  TP_ActiveRecord.Table(oLocalDB, "t_Table", GetTypeInfo(DataFile.t_Table))
		  
		  // Views
		  TP_ActiveRecord.View(oLocalDB, "vw_View", GetTypeInfo(DataFile.vw_View))
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private maroConnectionPool() As TP_ActiveRecord.DatabaseConnection
	#tag EndProperty


	#tag Constant, Name = kMaxReturn, Type = Double, Dynamic = False, Default = \"50", Scope = Protected
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
