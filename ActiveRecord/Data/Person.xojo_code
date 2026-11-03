#tag Class
Protected Class Person
Inherits BKS_ActiveRecord.Base
	#tag Event
		Sub AfterDelete()
		  for each oContact as Contact in self.Contacts
		    oContact.Delete
		  next
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Function Contacts() As Contact()
		  if self.IsNew then
		    return m_aroContact
		  else
		    if m_aroContact.Ubound < 0 then
		      m_aroContact = Contact.ListByPersonId( id )
		    end if
		    return m_aroContact
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Contacts_Create() As Contact
		  dim oContact as new Contact
		  oContact.idPerson = id
		  
		  'make sure the contacts are loaded
		  call Contacts
		  
		  m_aroContact.Append( oContact )
		  
		  return oContact
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Contacts_Delete(oContact as Contact)
		  if oContact.idPerson = id or oContact.IsNew then
		    
		    oContact.Delete
		    
		    redim m_aroContact( -1 )
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub CreateTable(db as Database)
		  #if BKS_ActiveRecordConfig.kIncludeMySQLCommunityServer
		    if db isa MySQLCommunityServer then
		      db.SQLExecuteRaiseOnError( _
		      "CREATE TABLE IF NOT EXISTS tblPerson( " + _
		      "id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, " + _
		      "FirstName VARCHAR(100), " + _
		      "LastName VARCHAR(100), " + _
		      "DateOfBirth DATETIME )" )
		    end if
		  #endif
		  
		  
		  #if BKS_ActiveRecordConfig.kIncludePostgreSQLDatabase
		    if db isa PostgreSQLDatabase then
		      dim rs as RecordSet
		      rs = db.SQLSelectRaiseOnError( _
		      "SELECT 1 FROM pg_tables WHERE tablename = 'tblperson'" )
		      if rs.EOF then
		        db.SQLExecuteRaiseOnError( _
		        "CREATE TABLE tblperson( " + _
		        "id SERIAL PRIMARY KEY, " + _
		        "FirstName VARCHAR(100), " + _
		        "LastName VARCHAR(100), " + _
		        "DateOfBirth DATE )" )
		      end if
		    end if
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludeREALSQLDatabase
		    if db isa REALSQLDatabase then
		      db.SQLExecuteRaiseOnError( "CREATE TABLE IF NOT EXISTS tblPerson( " + _
		      "id INTEGER PRIMARY KEY, FirstName TEXT, LastName TEXT, DateOfBirth TEXT )" )
		    end if
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludeSQLiteDatabase and RBVersion>=2013
		    if db isa SQLiteDatabase then
		      db.SQLExecuteRaiseOnError( "CREATE TABLE IF NOT EXISTS tblPerson( " + _
		      "id INTEGER PRIMARY KEY, FirstName TEXT, LastName TEXT, DateOfBirth TEXT )" )
		    end if
		    db.Commit
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FindByID(id as Integer) As Data.Person
		  dim sSearch as string = "id = " + str(id)
		  
		  dim aro() as Data.Person = Data.Person.List(sSearch, "")
		  if aro.Ubound = 0 then
		    return aro(0)
		  else
		    return nil
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function List(sCriteria as string = "", sOrder as string = "") As Person()
		  dim aro() as Person
		  dim oRecord as Person
		  dim ty as Introspection.TypeInfo = GetTypeInfo( Person )
		  
		  for each oRecord in BKS_ActiveRecord.Query(ty, sCriteria, sOrder)
		    aro.Append(oRecord)
		  next
		  
		  return aro
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		DateOfBirth As Date
	#tag EndProperty

	#tag Property, Flags = &h0
		FirstName As string
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return LastName + ", " + FirstName
			End Get
		#tag EndGetter
		FullName As string
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private id As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		LastName As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_aroContact() As Contact
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="FirstName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FullName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
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
			Name="LastName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
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
