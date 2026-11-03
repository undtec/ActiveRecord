#tag Class
Protected Class Transaction
	#tag Method, Flags = &h0
		Sub Commit()
		  if m_adp=nil then
		    raise new ActiveRecordException("The transaction was already completed")
		  end if
		  m_adp.CommitTransaction
		  m_adp = nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(adp as BKS_ActiveRecord.DatabaseAdapter)
		  if adp=nil then
		    raise new ActiveRecordException("Nil argument")
		  end if
		  adp.BeginTransaction
		  m_adp = adp
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  'If the user hasn't explictly committed the transaction then do a rollback
		  if m_adp<>nil then
		    m_adp.RollbackTransaction
		    m_adp = nil
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Rollback()
		  if m_adp=nil then
		    raise new ActiveRecordException("The transaction was already completed")
		  end if
		  m_adp.RollbackTransaction
		  m_adp = nil
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_adp As BKS_ActiveRecord.DatabaseAdapter
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
End Class
#tag EndClass
