#tag Class
Protected Class Contact
Inherits BKS_ActiveRecord.Base
	#tag Method, Flags = &h0
		Shared Sub CreateTable(db as Database)
		  #if BKS_ActiveRecordConfig.kIncludeMySQLCommunityServer
		    if db isa MySQLCommunityServer then
		      db.SQLExecuteRaiseOnError( _
		      "CREATE TABLE IF NOT EXISTS tblcontact( " + _
		      "id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, " + _
		      "idPerson INT NOT NULL," + _
		      "EmailAddress VARCHAR(255))" )
		    end if
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludePostgreSQLDatabase
		    if db isa PostgreSQLDatabase then
		      dim rs as RecordSet
		      rs = db.SQLSelectRaiseOnError( _
		      "SELECT 1 FROM pg_tables WHERE tablename = 'tblcontact'" )
		      if rs.EOF then
		        db.SQLExecuteRaiseOnError( _
		        "CREATE TABLE tblcontact( " + _
		        "id SERIAL PRIMARY KEY, " + _
		        "idPerson INTEGER NOT NULL," + _
		        "EmailAddress VARCHAR(255))" )
		      end if
		    end if
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludeREALSQLDatabase
		    if db isa REALSQLDatabase then
		      db.SQLExecuteRaiseOnError( "CREATE TABLE IF NOT EXISTS tblcontact( " + _
		      "id INTEGER PRIMARY KEY, idPerson INTEGER NOT NULL, EmailAddress TEXT )" )
		    end if
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludeSQLiteDatabase and RBVersion>=2013
		    if db isa SQLiteDatabase then
		      db.SQLExecuteRaiseOnError( "CREATE TABLE IF NOT EXISTS tblcontact( " + _
		      "id INTEGER PRIMARY KEY, idPerson INTEGER NOT NULL, EmailAddress TEXT )" )
		    end if
		    
		    db.Commit
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function List(sCriteria as string = "", sOrder as string = "") As Contact()
		  dim aro() as Contact
		  dim oRecord as Contact
		  dim ty as Introspection.TypeInfo = GetTypeInfo( Contact )
		  
		  for each oRecord in BKS_ActiveRecord.Query(ty, sCriteria, sOrder)
		    aro.Append( oRecord )
		  next
		  
		  return aro
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ListByPersonId(idPerson as integer, sOrder as string = "") As Contact()
		  #pragma unused sOrder
		  
		  return List( "idPerson = " + Str( idPerson ) )
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		EmailAddress As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private id As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		idPerson As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="EmailAddress"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="idPerson"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="2147483648"
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
End Class
#tag EndClass
