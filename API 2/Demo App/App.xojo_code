#tag Class
Protected Class App
Inherits Application
	#tag Event
		Sub Close()
		  #if TP_ActiveRecord.kConfigUseVSQLiteDatabase
		    if DataFile.db <> nil then
		      DataFile.db.Close()
		    end if
		    
		    Valentina.ShutDownClient()
		    
		  #endif
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  #if TP_ActiveRecord.kConfigUseVSQLiteDatabase
		    Valentina.InitClient()
		    
		    #if DebugBuild then
		      Valentina.DebugLevel = EVDebugLevel.kLogParams
		      
		    #else
		      Valentina.DebugLevel = EVDebugLevel.kLogNothing
		      
		    #endif
		    
		  #endif
		  
		  // Connect to the database
		  call DataFile.DB
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function AboutActiveRecord() As Boolean Handles AboutActiveRecord.Action
			MessageBox("ActiveRecord for Xojo" + EndOfLine + EndOfLine + _
			"Release " + Format(TP_ActiveRecord.kVersion, "####.00"))
			
			return true
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ARGenHomePage() As Boolean Handles ARGenHomePage.Action
			ShowURL("https://strawberrysw.com/argen")
			
			return true
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ARHomePage() As Boolean Handles ARHomePage.Action
			ShowURL("https://strawberrysw.com/activerecord")
			
			return true
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function HelpStrawberryWebsite() As Boolean Handles HelpStrawberryWebsite.Action
			ShowURL("https://strawberrysw.com")
			
			return true
			
		End Function
	#tag EndMenuHandler


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Any, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
