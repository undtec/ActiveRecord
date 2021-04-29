#tag Class
Protected Class Context
	#tag Method, Flags = &h0
		Function ConnectionAdapter_Count() As Integer
		  dim lck as new TP_ActiveRecord.P.ScopedLock(m_cs)
		  #pragma unused lck
		  
		  if m_dictTypeDb=nil then
		    return 0
		  end if
		  return m_dictTypeDb.Count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ConnectionAdapter_Get(ty as xojo.Introspection.TypeInfo) As TP_ActiveRecord.DatabaseAdapter
		  
		  'Start with this class and search the hash table in TP_ActiveRecord for
		  'a database to use.
		  dim lck as new TP_ActiveRecord.P.ScopedLock(m_cs)
		  #pragma unused lck
		  dim adp as TP_ActiveRecord.DatabaseAdapter
		  
		  if m_dictTypeDb=nil then
		    return nil
		  end if
		  
		  'start with the given type and walk up the inheritance chain
		  'looking for a databsae connection
		  while ty<>nil
		    adp = m_dictTypeDb.Lookup(ty.FullName, nil )
		    if adp<>nil then
		      exit while
		    end if
		    
		    ty = ty.BaseType
		  wend
		  
		  return adp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConnectionAdapter_Remove(ty as xojo.Introspection.TypeInfo)
		  'Disconnect a specific active record class from the database
		  if ty=nil then
		    raise new NilObjectException
		  end if
		  
		  dim info as xojo.Introspection.TypeInfo = xojo.Introspection.GetType(new TP_ActiveRecord.Base)
		  if not ty.IsSubclassOf( info ) then
		    raise new ActiveRecordException("Invalid type. Expected a subclass of TP_ActiveRecord.Base")
		  end if
		  
		  dim lck as new TP_ActiveRecord.P.ScopedLock(m_cs)
		  #pragma unused lck
		  if m_dictTypeDb<>nil then
		    m_dictTypeDb.Remove(ty.FullName)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConnectionAdapter_Set(ty as xojo.Introspection.TypeInfo, adp as TP_ActiveRecord.DatabaseAdapter)
		  'Connect a specific active record class and all of its subclasses to a database
		  if ty=nil or adp=nil then
		    raise new NilObjectException
		  end if
		  
		  dim info as xojo.Introspection.TypeInfo = xojo.Introspection.GetType(new TP_ActiveRecord.Base)
		  if not ty.IsSubclassOf( info ) then
		    raise new ActiveRecordException("Invalid type. Expected a subclass of TP_ActiveRecord.Base")
		  end if
		  
		  'add the database using the full type name of the type as a key
		  'Base will use this to find the appropriate adapter.
		  dim lck as new TP_ActiveRecord.P.ScopedLock(m_cs)
		  #pragma unused lck
		  if m_dictTypeDb=nil then
		    m_dictTypeDb = new Dictionary
		  end if
		  m_dictTypeDb.Value(ty.FullName) = adp
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  m_cs = new xojo.Threading.CriticalSection
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TableInfo_Get(ty as xojo.Introspection.TypeInfo) As TP_ActiveRecord.P.TableInfo
		  dim lck as new TP_ActiveRecord.P.ScopedLock(m_cs)
		  #pragma unused lck
		  
		  'check the info cache and return the mapping if it exists
		  if m_dictTypeTableInfo=nil then
		    return nil
		  end if
		  
		  return m_dictTypeTableInfo.Lookup(ty.FullName, nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TableInfo_List() As TP_ActiveRecord.P.TableInfo()
		  dim lck as new TP_ActiveRecord.P.ScopedLock(m_cs)
		  #pragma unused lck
		  
		  'check the info cache and return the mapping if it exists
		  dim aro() as TP_ActiveRecord.P.TableInfo
		  if m_dictTypeTableInfo=nil then
		    return aro
		  end if
		  
		  For Each oEntry As Xojo.Core.DictionaryEntry In m_dictTypeTableInfo
		    dim o as TP_ActiveRecord.P.TableInfo
		    o = m_dictTypeTableInfo.Value(oEntry.Key)
		    aro.Append(o)
		  Next
		  
		  return aro
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TableInfo_Set(ty as xojo.Introspection.TypeInfo, oTableInfo as TP_ActiveRecord.P.TableInfo)
		  dim lck as new TP_ActiveRecord.P.ScopedLock(m_cs)
		  #pragma unused lck
		  
		  if m_dictTypeTableInfo=nil then
		    m_dictTypeTableInfo = new Dictionary
		  end if
		  m_dictTypeTableInfo.Value(ty.FullName) = oTableInfo
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_cs As CriticalSection
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_dictTypeDb As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_dictTypeTableInfo As Xojo.Core.Dictionary
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
