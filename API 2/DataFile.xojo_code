#tag Module
Protected Module DataFile
	#tag Method, Flags = &h21
		Private Sub ConnectionCleanup()
		  // Clean up closed connections
		  if maroConnectionPool.LastIndex < 0 then return
		  
		  // Collect active session identifiers
		  var arsActiveSessions() as String
		  #if TargetWeb then
		    var iSessionMax as Integer = App.SessionCount - 1
		    for i as Integer = 0 to iSessionMax
		      var oThis as WebSession = App.SessionAt(i)
		      if oThis <> nil then
		        arsActiveSessions.Add(oThis.Identifier)
		        
		      end
		      
		    next i
		    
		  #else
		    #pragma unused arsActiveSessions
		    
		  #endif
		  
		  for i as Integer = maroConnectionPool.LastIndex downto 0
		    var oThis as TP_ActiveRecord.DatabaseConnection = maroConnectionPool(i)
		    
		    // Thread identified connection, now closed
		    if (oThis.iThreadIdentifier > 0 and oThis.oThreadWeakRef = nil) then
		      oThis.DB.Close
		      oThis.DB = nil
		      
		      // Remove the last reference
		      maroConnectionPool.RemoveAt(i)
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
		          maroConnectionPool.RemoveRowAt(i)
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
		  var oCurrent as Thread = Thread.Current
		  var iThreadID as Integer = oCurrent.ThreadID
		  var oConnection as TP_ActiveRecord.DatabaseConnection
		  
		  for i as Integer = 0 to maroConnectionPool.LastIndex
		    var oThisConnection as TP_ActiveRecord.DatabaseConnection = maroConnectionPool(i)
		    
		    // Found the connection
		    if oThisConnection.iThreadIdentifier = iThreadID then
		      oConnection = oThisConnection
		      exit for i
		      
		    end
		    
		  next i
		  
		  // Create the connection if necessary
		  if oConnection = nil then
		    var oDatabase as Database = OpenDB
		    
		    if oDatabase = nil then
		      // The database failed to connect, you should handle this.
		      break
		      return nil
		      
		    end
		    
		    // Create the connection object
		    var oNewConnection as new TP_ActiveRecord.DatabaseConnection
		    oNewConnection.iThreadIdentifier = iThreadID
		    oNewConnection.oThreadWeakRef = new WeakRef(oCurrent)
		    oNewConnection.DB = oDatabase
		    
		    oConnection = oNewConnection
		    
		    // Store it
		    maroConnectionPool.Add(oNewConnection)
		    
		  end
		  
		  // Forcibly release this
		  oCurrent = nil
		  
		  // Return the Database
		  return Database(oConnection.DB)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetDatabase() As Database
		  // Prepares a %db_type% object to connect
		  // Returns database object if successful
		  #pragma Error "Set location of your database file"
		  
		  try
		    var fDB as new FolderItem("%db_path%", FolderItem.PathModes.Native)
		    
		    var oLocalDB as new SQLiteDatabase
		    oLocalDB.DatabaseFile = fDB
		    // oLocalDB.EncryptionKey = ""
		    
		    // Return the object
		    return oLocalDB
		    
		  catch e as UnsupportedFormatException
		    // Be sure to set up the database path in GetDatabaseFile
		    
		  end try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetDatabase_Server() As Database
		  // Prepares a Database object to connect
		  // Returns database object if successful
		  var oLocalDB as new PostgreSQLDatabase
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
		  var oLocalDB as new PostgreSQLDatabase
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
		  if Thread.Current = nil then
		    // Create the connection if necessary
		    if maroConnectionPool.LastIndex < 0 then
		      var oDatabase as Database = OpenDB
		      
		      if oDatabase = nil then
		        // The database failed to connect, you should handle this.
		        break
		        return nil
		        
		      end
		      
		      // Create the connection object
		      var oConnection as new TP_ActiveRecord.DatabaseConnection
		      oConnection.DB = oDatabase
		      
		      // Store it
		      maroConnectionPool.Add(oConnection)
		      
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
		  // Connection cleanup
		  ConnectionCleanup
		  
		  // Attempt to identify by Session
		  if Session <> nil then
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
		  var oConnection as TP_ActiveRecord.DatabaseConnection
		  
		  for i as Integer = 0 to maroConnectionPool.LastIndex
		    var oThisConnection as TP_ActiveRecord.DatabaseConnection = maroConnectionPool(i)
		    
		    // Found the connection
		    if oThisConnection.sSessionIdentifier = sIdentifier then
		      oConnection = oThisConnection
		      exit for i
		      
		    end
		    
		  next i
		  
		  // Create the connection if necessary
		  if oConnection = nil then
		    var oDatabase as Database = OpenDB
		    
		    if oDatabase = nil then
		      // The database failed to connect, you should handle this.
		      break
		      return nil
		      
		    end
		    
		    // Create the connection object
		    var oNewConnection as new TP_ActiveRecord.DatabaseConnection
		    oNewConnection.DB = oDatabase
		    oNewConnection.sSessionIdentifier = sIdentifier
		    
		    oConnection = oNewConnection
		    
		    // Store it
		    maroConnectionPool.Add(oNewConnection)
		    
		  end
		  
		  // Return the Database
		  return Database(oConnection.DB)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function OpenDB() As Database
		  // Get a configured Databse object
		  var oLocalDB as Database = GetDatabase
		  
		  // Test connection
		  try
		    oLocalDB.Connect
		    
		  catch ex as DatabaseException
		    return nil
		    
		  end
		  
		  // Make any db updates here before registering
		  TP_DBUpdates.UpdateDB(oLocalDB)
		  
		  // Important to tell ActiveRecord what the connection is!
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
		  
		  // Views
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private maroConnectionPool() As TP_ActiveRecord.DatabaseConnection
	#tag EndProperty


	#tag Constant, Name = kMaxReturn, Type = Double, Dynamic = False, Default = \"50", Scope = Protected
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
