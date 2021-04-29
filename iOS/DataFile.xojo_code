#tag Module
Protected Module DataFile
	#tag Method, Flags = &h1
		Protected Function OpenDB() As Boolean
		  #pragma Error "Replace with your database connection"
		  dim fDB as xojo.IO.FolderItem = Xojo.IO.SpecialFolder.Documents.Child("ActiveRecordiOS.db")
		  
		  if fDB.Exists = false then
		    dim ex as new NilObjectException
		    ex.Reason = "The FolderItem passed to the database connection does not exist."
		    raise ex
		    
		  end
		  
		  DB = new iOSSQLiteDatabase
		  DB.DatabaseFile = fDB
		  // DB.EncryptionKey = ""
		  
		  if DB.Connect = false then return false
		  
		  // Make any db updates here before registering
		  TP_DBUpdates.UpdateDB(DB)
		  
		  // iOS does not support multile databases/namespaces
		  TP_ActiveRecord.Connect(DB)
		  
		  Register
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Register()
		  // Tables
		  TP_ActiveRecord.Table(DB, "t_Table", GetTypeInfo(DataFile.t_Table))
		  
		  // Views
		  TP_ActiveRecord.View(DB, "vw_View", GetTypeInfo(DataFile.vw_View))
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected DB As iOSSQLiteDatabase
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
