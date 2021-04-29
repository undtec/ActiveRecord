#tag Module
Protected Module Auto_Extends
	#tag Method, Flags = &h0
		Function FindType(extends au as Auto) As Text
		  dim oTypeInfo as xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(au)
		  
		  return oTypeInfo.FullName
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsBoolean(extends au as Auto) As boolean
		  if au.IsPrimitive = false then return false
		  
		  return au.FindType = "Boolean"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsColor(extends au as Auto) As boolean
		  if au.IsPrimitive = false then return false
		  
		  return au.FindType = "Color"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsCurrency(extends au as Auto) As boolean
		  if au.IsPrimitive = false then return false
		  
		  return au.FindType = "Currency"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsDouble(extends au as Auto) As boolean
		  if au.IsPrimitive = false then return false
		  
		  return au.FindType = "Double"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsInteger(extends au as Auto) As boolean
		  if au.IsPrimitive = false then return false
		  dim sType as Text = au.FindType 
		  
		  select case sType
		  case "Integer", "Int32", "Int64"
		    Return true
		  case else
		    Return false
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsNull(extends au as Auto) As boolean
		  dim oTypeInfo as xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(au)
		  
		  return oTypeInfo.FullName = "NULL"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsPrimitive(extends au as Auto) As boolean
		  dim oTypeInfo as xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(au)
		  
		  return oTypeInfo.IsPrimitive
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsString(extends au as Auto) As boolean
		  if au.IsPrimitive = false then return false
		  
		  return au.FindType = "String"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsText(extends au as Auto) As boolean
		  if au.IsPrimitive = false then return false
		  
		  return au.FindType = "Text"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToText(extends au as Auto) As Text
		  dim sType As Text = au.FindType
		  
		  select case sType
		  case "Boolean"
		    dim b as boolean = au
		    if b then
		      return "True"
		    else
		      return "False"
		    end
		  case "Double"
		    dim d as double = au
		    return d.ToText
		  case "Int32"
		    dim i as Int32 = au
		    return i.ToText
		  case "Int64"
		    dim i as Int64 = au
		    return i.ToText
		    ' case "Color"
		    ' dim c as color = au
		    ' return c.ToText
		  case "Currency"
		    dim cu as currency = au
		    return cu.ToText
		  case "String"
		    dim s as text = au
		    return s
		  case "Text"
		    dim t as Text = au
		    return t
		  case "Xojo.Core.Date"
		    dim d as xojo.core.date = au
		    dim t as Text = d.toText(Xojo.Core.Locale.Current, Xojo.Core.Date.formatstyles.Short,   Xojo.Core.Date.formatstyles.Short)
		    return t
		  case else
		    break //This Datatype not found.  Create it!
		  end
		End Function
	#tag EndMethod


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
