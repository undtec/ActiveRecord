#tag Module
Protected Module Data
	#tag Method, Flags = &h0
		Sub ConnectDatabase(db as Database)
		  'create the tables
		  select case db
		  case nil
		    'empty. This just let's it compile if someone turns off all the constants
		    
		    #if BKS_ActiveRecordConfig.kIncludeREALSQLDatabase
		  case isa REALSQLDatabase
		    dim dbREALSQL as REALSQLDatabase = REALSQLDatabase(db)
		    Person.CreateTable( dbREALSQL )
		    Contact.CreateTable( dbREALSQL )
		    BKS_ActiveRecord.Connect( dbREALSQL )
		    #endif
		    
		    #if BKS_ActiveRecordConfig.kIncludeSQLiteDatabase and RBVersion>=2013
		  case isa SQLiteDatabase
		    dim dbSQLite as SQLiteDatabase = SQLiteDatabase(db)
		    Person.CreateTable( dbSQLite )
		    Contact.CreateTable( dbSQLite )
		    BKS_ActiveRecord.Connect( dbSQLite )
		    #endif
		    
		    #if BKS_ActiveRecordConfig.kIncludeMySQLCommunityServer
		  case isa MySQLCommunityServer
		    dim dbMySQL as MySQLCommunityServer = MySQLCommunityServer(db)
		    Person.CreateTable( dbMySQL )
		    Contact.CreateTable( dbMySQL )
		    BKS_ActiveRecord.Connect( dbMySQL )
		    #endif
		    
		    #if BKS_ActiveRecordConfig.kIncludePostgreSQLDatabase
		  case isa PostgreSQLDatabase
		    dim dbPostgres as PostgreSQLDatabase = PostgreSQLDatabase(db)
		    Person.CreateTable( dbPostgres )
		    Contact.CreateTable( dbPostgres )
		    BKS_ActiveRecord.Connect( dbPostgres )
		    #endif
		    
		    #if BKS_ActiveRecordConfig.kIncludeMSSQLServer
		  case isa MSSQLServerDatabase
		    dim dbMSSQLServer as MSSQLServerDatabase = MSSQLServerDatabase(db)
		    Person.CreateTable( dbMSSQLServer )
		    Contact.CreateTable( dbMSSQLServer )
		    BKS_ActiveRecord.Connect( dbMSSQLServer )
		    #endif
		    
		    
		    #if BKS_ActiveRecordConfig.kIncludeOracle
		  case isa OracleDatabase
		    dim dbOracle as OracleDatabase = OracleDatabase(db)
		    Person.CreateTable( dbOracle )
		    Contact.CreateTable( dbOracle )
		    BKS_ActiveRecord.Connect( dbOracle )
		    #endif
		    
		    #if BKS_ActiveRecordConfig.kIncludeCubeDatabase
		  case isa CubeSQLServer
		    dim dbCube as CubeSQLServer = CubeSQLServer(db)
		    Person.CreateTable( dbCube )
		    Contact.CreateTable( dbCube )
		    BKS_ActiveRecord.Connect( dbCube )
		    #endif
		  end select
		  
		  Data.db = db
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected db As Database
	#tag EndProperty


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
