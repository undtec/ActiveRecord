#tag Class
Protected Class App
Inherits Application
	#tag Event
		Sub Open()
		  dim w as new winConnect
		  w.ShowModal
		  if w.db=nil then
		    Quit
		  end if
		  
		  Data.ConnectDatabase( w.db )
		  
		  winPersonContact.Show
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function AboutActiveRecord() As Boolean Handles AboutActiveRecord.Action
		  msgbox "ActiveRecord for Xojo" + EndOfLine + "August 2014 Release"
		  
		  Return True
		  
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ARGenHomePage() As Boolean Handles ARGenHomePage.Action
		  showurl ("http://www.bkeeney.com/allproducts/argen/")
		  Return True
		  
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ARHomePage() As Boolean Handles ARHomePage.Action
		  showurl ("http://www.bkeeney.com/rbinto/activerecord/")
		  Return True
		  
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function BKeeneyWebsite() As Boolean Handles BKeeneyWebsite.Action
		  showurl ("http://www.bkeeney.com")
		  Return True
		  
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
