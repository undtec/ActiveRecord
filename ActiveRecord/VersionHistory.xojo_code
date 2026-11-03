#tag Module
Protected Module VersionHistory
	#tag Note, Name = Dec 2014
		Updated to include latest stuff on threading
		
		
		
	#tag EndNote

	#tag Note, Name = May 2013
		Removed dependencies to Monkeybread
	#tag EndNote

	#tag Note, Name = May 2014
		
		- Added BKS_ActiveRecordConfig to hold configuration constants.
		- It's no longer necessary to delete code for database plugins that aren't installed.
	#tag EndNote

	#tag Note, Name = Nov 2013
		Added Oracle (totally unsupported and if it doesn't work please don't ask!)
		Added CubeSQL Support
		Added more descriptions when errors occur when plugins are missing
		
		
	#tag EndNote


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
