#tag Class
Protected Class App
Inherits IOSApplication
	#tag CompatibilityFlags = TargetIOS
	#tag Event
		Function Open(launchOptionsHandle as Ptr) As Boolean
		  #pragma unused launchOptionsHandle
		  
		  #if XojoVersion < 2015.023 then
		    // Bug in introspection
		    // feedback://showreport?report_id=40034
		    #pragma Error "ActiveRecord requires Xojo 2015r2.3 or later"
		    
		    
		  #endif
		  
		  
		  if DataFile.OpenDB = false then
		    break
		    return false
		    
		  end
		End Function
	#tag EndEvent


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
