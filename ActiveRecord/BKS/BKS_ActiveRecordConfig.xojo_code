#tag Module
Protected Module BKS_ActiveRecordConfig
	#tag Constant, Name = kIncludeCubeDatabase, Type = Boolean, Dynamic = False, Default = \"false", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kIncludeMSSQLServer, Type = Boolean, Dynamic = False, Default = \"false", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kIncludeMySQLCommunityServer, Type = Boolean, Dynamic = False, Default = \"false", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kIncludeOracle, Type = Boolean, Dynamic = False, Default = \"false", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kIncludePostgreSQLDatabase, Type = Boolean, Dynamic = False, Default = \"false", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kIncludeREALSQLDatabase, Type = Boolean, Dynamic = False, Default = \"false", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kIncludeSQLiteDatabase, Type = Boolean, Dynamic = False, Default = \"true", Scope = Protected
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
