#tag Class
Protected Class SQLiteDatabaseAdapter
Inherits TP_ActiveRecord.DatabaseAdapter
	#tag Method, Flags = &h0
		Sub BeginTransaction()
		  if m_iTransactionCt=0 then
		    'try
		    'm_db.Commit_Transaction 'commit the auto transaction
		    'catch
		    ''ignore this one
		    'end try
		  end if
		  
		  if m_iTransactionCt=0 then
		    SQLExecute( "BEGIN" )
		  end if
		  m_iTransactionCt = m_iTransactionCt + 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CommitTransaction()
		  m_iTransactionCt = m_iTransactionCt - 1
		  if m_iTransactionCt=0 then
		    Db.Commit_Transaction
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(oDb as Object)
		  
		  dim db as iOSSQLiteDatabase = iOSSQLiteDatabase(oDb)
		  if db=nil then
		    raise new RuntimeException
		  end if
		  m_db = db
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Db() As iOSSQLiteDatabase
		  return m_db
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetLastInsertID() As Int64
		  return iOSSQLiteDatabase(m_db).LastRowID
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RollbackTransaction()
		  m_iTransactionCt = m_iTransactionCt - 1
		  if m_iTransactionCt=0 then
		    Db.Rollback_Transaction
		  end if
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_db As iOSSQLiteDatabase
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_iTransactionCt As Integer
	#tag EndProperty


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
End Class
#tag EndClass
