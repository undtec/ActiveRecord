#tag Class
Protected Class Base
	#tag Method, Flags = &h0
		Function Clone() As Auto
		  dim ty as xojo.Introspection.TypeInfo = Introspection.GetType( self )
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo = GetTableInfo( ty )
		  
		  dim oSuperConstructor as Introspection.ConstructorInfo
		  dim oCopyConstructor as Introspection.ConstructorInfo
		  dim oDefaultConstructor as Introspection.ConstructorInfo
		  
		  'Look for three types of constructors (lowest priority first):
		  ' (1) Default constructors (i.e. no parameters)
		  ' (2) Constructors that take a parameter of which self's class is a subtype
		  ' (3) Constructors that take a parameter which matches this class type
		  '
		  'For example if there's a class call User derived like this:
		  ' TP_ActiveRecord.Base -> clsActiveRecord -> User
		  'Then the program will look for constructors like the following:
		  ' (1) Constructor()
		  ' (2) Constructor(TP_ActiveRecord.Base)
		  ' (3) Constructor(clsActiveRecord)
		  ' (4) Constructor(User)
		  'If it finds more than one it will use the one that's farthest down the list.
		  'The point of this is to give users a way of customizing how their objects
		  'get cloned, all they need to do is add the appropriate constructor
		  
		  for each o as xojo.Introspection.ConstructorInfo in ty.Constructors
		    dim aroParam() as xojo.Introspection.ParameterInfo
		    aroParam = o.Parameters
		    if aroParam.Ubound < 0 then
		      'default constructor
		      oDefaultConstructor = o
		    elseif aroParam.Ubound=0 and _
		      ty.IsSubclassOf( aroParam(0).ParameterType ) then
		      'copy constructor that takes a super class
		      if oSuperConstructor=nil then
		        oSuperConstructor = o
		      else
		        dim aroCurrentParam() as xojo.Introspection.ParameterInfo
		        aroCurrentParam = oSuperConstructor.Parameters
		        if aroParam(0).ParameterType.IsSubclassOf( aroCurrentParam(0).ParameterType ) then
		          'if the parameter type of this constructor is derived from the parameter type
		          'of the last one, then this one should have priority
		          oSuperConstructor = o
		        end if
		      end if
		    elseif aroParam.Ubound=0 and _
		      aroParam(0).ParameterType is ty then
		      'copy constructor that takes this class
		      oCopyConstructor = o
		      exit for
		    end if
		  next
		  
		  'Create an instance using the constructor we found
		  dim oClone as Base
		  dim vSelf as Auto = self
		  
		  if oCopyConstructor<>nil then
		    oClone = oCopyConstructor.Invoke( Array(vSelf) )
		  elseif oSuperConstructor<>nil then
		    oClone = oSuperConstructor.Invoke( Array(vSelf) )
		  elseif oDefaultConstructor<>nil then
		    oClone = oDefaultConstructor.Invoke
		  else
		    'we should always be able to find a default constructor
		    TP_ActiveRecord.Assert( false, _
		    "Class does not have a default constructor" )
		    return nil
		  end if
		  
		  'Copy the properties into the new instance
		  for each oField as TP_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		    dim pi as Introspection.PropertyInfo = oField.piFieldProperty
		    if not (pi is oTableInfo.piPrimaryKey) then
		      'copy every saved property except the primary key
		      pi.Value(oClone) = pi.Value(self)
		    end if
		  next
		  
		  return oClone
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  'Empty
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(rs as iOSSQLiteRecordSet)
		  ReadRecord(rs)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Db() As iOSSQLiteDatabase
		  return GetDatabaseAdapter.Db
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Delete()
		  if self.IsNew then
		    return
		  end if
		  
		  dim adp as TP_ActiveRecord.DatabaseAdapter = GetDatabaseAdapter
		  adp.BeginTransaction
		  
		  RaiseEvent BeforeDelete
		  
		  adp.DeleteRecord( self )
		  
		  RaiseEvent AfterDelete
		  
		  adp.CommitTransaction
		  
		  catch ex as RuntimeException
		    
		    adp.RollbackTransaction
		    
		    raise ex
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetDatabaseAdapter() As SQLiteDatabaseAdapter
		  dim info as xojo.Introspection.TypeInfo = xojo.Introspection.GetType(self)
		  return SQLiteDatabaseAdapter(GetContext.ConnectionAdapter_Get(info))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetTableName() As Text
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  oTableInfo = GetTableInfo( Introspection.GetType(self) )
		  Return oTableInfo.sTableName
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GUID() As Text
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  oTableInfo = GetTableInfo( Xojo.Introspection.GetType(self) )
		  
		  dim a as auto = oTableInfo.piPrimaryKey.Value(self)
		  
		  
		  //Because we need to deal with null values, we need to check for a null value.
		  if a = nil or a.IsText = false then
		    return ""
		  else
		    return a
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GUID(assigns id as Text)
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  oTableInfo = GetTableInfo( Introspection.GetType(self) )
		  oTableInfo.piPrimaryKey.Value(self) = id
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ID() As Int64
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  oTableInfo = GetTableInfo( Xojo.Introspection.GetType(self) )
		  
		  dim a as auto = oTableInfo.piPrimaryKey.Value(self)
		  
		  
		  //Because we need to deal with null values, we need to check for a null value.
		  if a = nil or a.IsInteger = false then
		    return 0
		  else
		    return a
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ID(assigns id as Int64)
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  oTableInfo = GetTableInfo( Introspection.GetType(self) )
		  oTableInfo.piPrimaryKey.Value(self) = id
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsModified() As boolean
		  return IsRecordModified
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsNew() As boolean
		  dim iID as Integer = ID
		  dim sGUID as Text = GUID
		  dim bIsNew as Boolean = true
		  
		  if iID > 0 then
		    bIsNew = false
		  end if
		  
		  if sGUID  <> "" and sGUID <> "0"  then
		    bIsNew = false
		  end if
		  
		  Return bIsNew
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsRecordModified() As boolean
		  dim bModified as boolean
		  
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  oTableInfo = GetTableInfo( Introspection.GetType(self) )
		  
		  for each oFieldInfo as TP_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		    dim pi as Introspection.PropertyInfo = oFieldInfo.piFieldProperty
		    dim vProperty as Auto = pi.Value( self )
		    
		    dim vSavedValue as Auto
		    
		    if m_dictSavedPropertyValue<>nil then
		      vSavedValue = m_dictSavedPropertyValue.Lookup(pi.Name, nil)
		    end if
		    
		    Dim info As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(vProperty)
		    
		    
		    
		    
		    if info.Name = "Text" then
		      'do a case sensitive compare for strings
		      dim sText1 as Text = vProperty
		      dim sText2 as Text = vSavedValue
		      dim iResult as integer
		      iResult = sText1.Compare(sText2, Text.CompareCaseSensitive)
		      if iResult <> 0 then
		        bModified = true
		        exit for
		      end if
		    else
		      'use the default comparison operator for everything else
		      if vProperty <> vSavedValue then
		        bModified = true
		        exit for
		      end if
		    end if
		    
		  next
		  
		  return bModified
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Load(iRecordID as Int64) As boolean
		  'Load record with the given ID. Return true if the record is found.
		  Dim rs As iOSSQLiteRecordSet
		  
		  dim ada as TP_ActiveRecord.DatabaseAdapter = GetDatabaseAdapter
		  
		  rs = ada.SelectRecord( self, iRecordID )
		  if rs.EOF then
		    return false
		  end if
		  
		  ReadRecord( rs )
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Load(sID as Text) As boolean
		  'Load record with the given ID. Return true if the record is found.
		  Dim rs As iOSSQLiteRecordSet
		  
		  dim ada as TP_ActiveRecord.DatabaseAdapter = GetDatabaseAdapter
		  
		  rs = ada.SelectRecord( self, sID )
		  if rs.EOF then
		    return false
		  end if
		  
		  ReadRecord( rs )
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(rhs as TP_ActiveRecord.Base) As integer
		  if rhs is nil then
		    return 1
		  end if
		  
		  'the two records are equal if they are actually the same object or
		  'if they're the same type and have the same ID (except if they're new).
		  if rhs is self or _
		    ( Introspection.GetType(self)=Introspection.GetType(rhs) and _
		    rhs.ID=ID and not IsNew ) then
		    return 0
		  end if
		  
		  'this ordering is arbitrary. Equality is really the case we're after.
		  if ID<rhs.ID then
		    return -1
		  else
		    return 1
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReadRecord(rs as iOSSQLiteRecordSet)
		  'Read current record out of rs into properties
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  
		  oTableInfo = GetTableInfo( Introspection.GetType(self) )
		  
		  ReadRecord( rs, oTableInfo, m_dictSavedPropertyValue )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ReadRecord(rs as iOSSQLiteRecordSet, oTableInfo as TP_ActiveRecord.P.TableInfo, byref dictSavedPropertyValue as Xojo.Core.Dictionary)
		  'Read current record out of rs into properties
		  dim dictFieldValue as new Dictionary
		  
		  for each oFieldInfo as TP_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		    Dim oField As iOSSQLiteDatabaseField = rs.Field( oFieldInfo.sFieldName )
		    
		    dim pi as Introspection.PropertyInfo = oFieldInfo.piFieldProperty
		    
		    if oField is nil then
		      TP_ActiveRecord.Assert( false, _
		      "A field needed to populate this record wasn't provided: " + _
		      oFieldInfo.sFieldName )
		      continue
		    end if
		    
		    dim vProperty as Auto
		    
		    if pi.PropertyType.Name = "Double" then
		      if oField.Value=nil then
		        vProperty = TP_ActiveRecord.kDoubleNullSentinal
		      else
		        vProperty = oField.Value
		      End If
		      
		    elseif pi.PropertyType.Name = "String" then
		      dim s as Text = oField.TextValue
		      
		      vProperty = s
		      
		    elseif pi.PropertyType.IsPrimitive then
		      vProperty = oField.Value
		      
		    elseif pi.PropertyType = Xojo.Introspection.GetType( xojo.Core.Date.Now) then // GetTypeInfo(Date) then
		      try
		        vProperty = oField.DateValue
		      Catch ex as runtimeexception
		        break
		      end try
		      
		    else
		      vProperty= oField.Value
		    end if
		    
		    pi.Value(self) = vProperty
		    dictFieldValue.Value(pi.Name) = vProperty
		    
		  next
		  
		  dictSavedPropertyValue = dictFieldValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Save()
		  dim adp as TP_ActiveRecord.DatabaseAdapter = GetDatabaseAdapter
		  adp.BeginTransaction
		  
		  RaiseEvent BeforeSave
		  
		  if IsNew then
		    RaiseEvent BeforeCreate
		    
		    adp.InsertRecord  self, m_dictSavedPropertyValue 
		    
		    RaiseEvent AfterSave
		    RaiseEvent AfterCreate
		  else
		    RaiseEvent BeforeUpdate
		    
		    if IsRecordModified then
		      adp.UpdateRecord(self, m_dictSavedPropertyValue)
		    end if
		    
		    RaiseEvent AfterSave
		    RaiseEvent AfterUpdate
		  end if
		  
		  adp.CommitTransaction
		  
		  exception ex as RuntimeException
		    
		    adp.RollbackTransaction
		    
		    raise ex
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Validate(oError as TP_ActiveRecord.ValidationErrors) As boolean
		  RaiseEvent Validate( oError )
		  return ( oError.ErrorCount = 0 )
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event AfterCreate()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event AfterDelete()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event AfterSave()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event AfterUpdate()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event BeforeCreate()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event BeforeDelete()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event BeforeSave()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event BeforeUpdate()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Validate(oErrors as TP_ActiveRecord.ValidationErrors)
	#tag EndHook


	#tag Property, Flags = &h21
		Private m_dictSavedPropertyValue As Xojo.Core.Dictionary
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="2147483648"
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
