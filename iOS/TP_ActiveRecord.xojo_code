#tag Module
Protected Module TP_ActiveRecord
	#tag Method, Flags = &h1
		Protected Sub Assert(bCondition as boolean, sMessage as Text = "")
		  #if DebugBuild then
		    if not bCondition then
		      raise new TP_ActiveRecord.AssertFailedException(sMessage)
		    end if
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BeginTransaction()
		  //Use BeginTransaction when outside of ActiveRecord
		  
		  
		  dim ctx as TP_ActiveRecord.P.Context = GetContext
		  Dim info As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(new TP_ActiveRecord.Base)
		  dim adp as TP_ActiveRecord.DatabaseAdapter = ctx.ConnectionAdapter_Get(info)
		  
		  adp.BeginTransaction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CommitTransaction()
		  //Use CommitTransaction when outside of ActiveRecord
		  
		  
		  dim ctx as TP_ActiveRecord.P.Context = GetContext
		  Dim info As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(new TP_ActiveRecord.Base)
		  dim adp as TP_ActiveRecord.DatabaseAdapter = ctx.ConnectionAdapter_Get(info)
		  
		  adp.CommitTransaction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Connect(db as iOSSQLiteDatabase)
		  Dim info As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(new TP_ActiveRecord.Base)
		  Connect(info, db)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Connect(ty as xojo.Introspection.TypeInfo, db as iOSSQLiteDatabase)
		  if ty=nil or db=nil then
		    raise new NilObjectException
		  end if
		  dim adp as TP_ActiveRecord.DatabaseAdapter
		  adp = CreateDatabaseAdapter(db)
		  GetContext.ConnectionAdapter_Set(ty, adp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CreateDatabaseAdapter(db as iOSSQLiteDatabase) As TP_ActiveRecord.DatabaseAdapter
		  if db isa iOSSQLiteDatabase then
		    return new SQLiteDatabaseAdapter(db)
		  end if
		  
		  dim ex as new UnsupportedOperationException
		  ex.Reason = "Unsupported database type: " + Introspection.GetType(db).FullName
		  raise ex
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Disconnect()
		  'Disconnect the base active record class from the database
		  Dim info As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(new TP_ActiveRecord.Base)
		  Disconnect( info )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Disconnect(ty as xojo.Introspection.TypeInfo)
		  'Disconnect a specific active record class from the database
		  if ty=nil then
		    raise new NilObjectException
		  end if
		  
		  dim ctx as TP_ActiveRecord.P.Context = GetContext
		  ctx.ConnectionAdapter_Remove(ty)
		  #if RBVersion >= 2011.04
		    #if TargetWeb
		      if ctx.ConnectionAdapter_Count=0 then
		        'kill the context
		        dim lck as new TP_ActiveRecord.P.ScopedLock(csCtx)
		        m_dictContext.Remove(Session.Identifier)
		      end if
		    #endif
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Field(sFieldName as Text) As TP_ActiveRecord.FieldOpt
		  return new FieldOpt(sFieldName)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FindFieldProperty(tyClass as xojo.Introspection.TypeInfo, sField as Text) As xojo.Introspection.PropertyInfo
		  dim iPrefixType as integer = 0 //Override to do prefixes and suffixes
		  
		  static arsAllowPrefix() as Text //= Array(^2)  //Override for your own prefixes
		  static arsAllowSuffix() as Text //= Array(^3) //Override for your own suffixes
		  
		  'Match the field to a property of the class.
		  select case iPrefixType
		  case 0 //No prefix/Suffix
		    for each pi as xojo.Introspection.PropertyInfo in tyClass.Properties
		      
		      if pi.Name = sField then
		        return pi 'accept exact match
		      end
		    next
		    
		    return nil
		    
		  case 1 //Prefix
		    for each pi as xojo.Introspection.PropertyInfo in tyClass.Properties
		      dim sXojoProperty as Text = pi.Name.Lowercase
		      
		      if sXojoProperty.EndsWith(sField.Lowercase) then
		        'check for a prefix match
		        for each sPrefix as Text in arsAllowPrefix
		          if sXojoProperty.BeginsWith(sPrefix.Lowercase) then
		            return pi
		          end if
		        next
		      end
		    next
		    
		    return nil
		    
		  case 2 //Suffix
		    for each pi as xojo.Introspection.PropertyInfo in tyClass.Properties
		      dim sXojoProperty as Text = pi.Name.Lowercase
		      if sXojoProperty.BeginsWith(sField.Lowercase) then
		        for each sSuffix as Text in arsAllowSuffix
		          if sXojoProperty.EndsWith(sSuffix.Lowercase) then
		            return pi
		          end if
		        next
		      end if
		    next
		    return nil
		    
		  case else
		    break
		  end
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FindMatchingTable(adp as TP_ActiveRecord.DatabaseAdapter, sClassName as Text) As Text
		  dim sTable as Text = sClassName
		  if adp.HasTable( sTable ) then
		    return sTable
		  end if
		  
		  sTable = "tbl" + sClassName
		  if adp.HasTable( sTable ) then
		    return sTable
		  end if
		  
		  'if the class is clsSomething, look for Something and tblSomething
		  'but not if the letter after cls is lowercase
		  dim sFourth as Text = sClassName.Mid(4, 1)
		  if sClassName.left(3) = "cls" And _
		    sFourth.Compare("A", 0) >= 0 AND _
		    sFourth.Compare("Z", 0) >= 0 then
		    sTable = sClassName.mid(4)
		    
		    ' if Left( sClassName, 3 ) = "cls" and _
		    ' StrComp( sFourth, "A", 0 ) >= 0 and _
		    ' StrComp( sFourth, "Z", 0 ) <=0 then
		    ' sTable = sClassName.Mid(4)
		    if adp.HasTable( sTable ) then
		      return sTable
		    end if
		    
		    sTable = "tbl" + sTable
		    if adp.HasTable( sTable ) then
		      return sTable
		    end if
		  end if
		  
		  return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetContext() As TP_ActiveRecord.P.Context
		  if m_ctxDefault is nil then
		    m_ctxDefault = new TP_ActiveRecord.P.Context
		  end if
		  
		  return m_ctxDefault
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetDatabaseAdapter() As TP_ActiveRecord.DatabaseAdapter
		  //GetDatabaseAdapter
		  //Useful if you want to get do transactions outside of the Base Class.
		  //Example:  You know you have some lengthy operations to do.
		  
		  dim ctx as TP_ActiveRecord.P.Context = GetContext
		  Dim info As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(new TP_ActiveRecord.Base)
		  dim adp as TP_ActiveRecord.DatabaseAdapter = ctx.ConnectionAdapter_Get(info)
		  
		  Return adp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetTableDefs() As TP_ActiveRecord.TableDef()
		  dim aroTableDef() as TP_ActiveRecord.TableDef
		  for each oTableInfo as TP_ActiveRecord.P.TableInfo in GetContext.TableInfo_List
		    dim aro() as TP_ActiveRecord.FieldDef
		    for each oFieldInfo as TP_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		      dim o as new TP_ActiveRecord.FieldDef( _
		      oFieldInfo.sFieldName, oFieldInfo.enFieldType, _
		      oFieldInfo.bPrimaryKey, oFieldInfo.bForeignKey)
		      aro.Append(o)
		    next
		    dim oTableDef as new TP_ActiveRecord.TableDef(oTableInfo.sTableName, oTableInfo.sPrimaryKey, aro)
		    aroTableDef.Append(oTableDef)
		  next
		  return aroTableDef
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTableInfo(ty as xojo.Introspection.TypeInfo) As TP_ActiveRecord.P.TableInfo
		  'check the info cache and return the mapping if it exists
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo = GetContext.TableInfo_Get(ty)
		  if oTableInfo<>nil then
		    return oTableInfo
		  end if
		  
		  'try to map the class to a table by name
		  dim adp as TP_ActiveRecord.DatabaseAdapter = GetContext.ConnectionAdapter_Get( ty )
		  if adp<>nil then
		    dim sTable as Text
		    sTable = FindMatchingTable( adp, ty.Name )
		    if sTable<>"" then
		      Table adp.Db, sTable, ty
		      return GetContext.TableInfo_Get(ty)
		    end if
		  end if
		  
		  'table not registered and not found by name
		  dim ex as RuntimeException
		  ex.Reason = "Class does not have a table registered for it: " + ty.FullName
		  raise ex
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTypeConstructor(oTableInfo as TP_ActiveRecord.P.TableInfo) As Introspection.ConstructorInfo
		  dim oConstructor as Introspection.ConstructorInfo
		  
		  
		  for each o as xojo.Introspection.ConstructorInfo in oTableInfo.tyClass.Constructors
		    dim aroParam() as xojo.Introspection.ParameterInfo = o.Parameters
		    if aroParam.Ubound = 0 then
		      if aroParam(0).ParameterType.FullName = "RecordSet" then
		        oConstructor = o
		        exit for
		      end if
		    end if
		  next
		  
		  return oConstructor
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MapFieldInfo(tyClass as xojo.Introspection.TypeInfo, rs as iOSSQLiteRecordSet, aroFieldOpt() as FieldOpt) As TP_ActiveRecord.P.FieldInfo
		  ' static arsAllowPrefix() as Text = Array("m_", "m_id","i","s","dtm","dt","b","d","v","pict")
		  
		  dim sField as Text = rs.Field("Name").TextValue
		  
		  'extract the field option if one was passed in for this field
		  dim oFieldOpt as FieldOpt
		  for each o as FieldOpt in aroFieldOpt
		    if o.FieldName=sField then
		      oFieldOpt = o
		    end if
		  next
		  
		  if oFieldOpt<>nil and oFieldOpt.IsIgnored then
		    return nil 'ignore this field
		  end if
		  
		  'Find the database field type
		  dim enFieldType as DbType
		  dim sFieldType as Text = rs.Field("type").TextValue
		  select case sFieldType
		  case "Integer"
		    enFieldType = DbType.DInteger
		  case "Text"
		    enFieldType = DbType.DText
		  case "Double"
		    enFieldType = DbType.DDouble
		  case "Date"
		    enFieldType = DbType.DDate
		  case "DateTime"
		    enFieldType = DbType.DDate
		  Case "TimeStamp"
		    enFieldType = DbType.DDate
		  case "blob"
		    enFieldType = DbType.DBlob
		  case "Boolean"
		    enFieldType = DbType.DBoolean
		  case else
		    // Field types from the Chinook Database
		    sFieldType = sFieldType.Uppercase
		    select case true
		    case sFieldType.BeginsWith("CHAR"), _
		      sFieldType.BeginsWith("VARCHAR"), _
		      sFieldType.BeginsWith("NVARCHAR")
		      enFieldType = DbType.DText
		      
		    case sFieldType.BeginsWith("NUMERIC")
		      enFieldType = DbType.DDouble
		      
		    else
		      // Not handled
		      break
		      
		    end select
		    
		  end select
		  
		  'Match the field to a property of the class.
		  ' Properties are named with a prefix:  <prefix>FieldName = FieldName
		  dim piFound as xojo.Introspection.PropertyInfo
		  piFound = FindFieldProperty(tyClass, sField)
		  
		  if piFound=nil then
		    TP_ActiveRecord.Assert( false, "No property for field: " + sField )
		    return nil
		  end if
		  
		  dim oFieldInfo as new TP_ActiveRecord.P.FieldInfo(sField, piFound)
		  oFieldInfo.enFieldType = enFieldType
		  if rs.Field("pk").BooleanValue then
		    oFieldInfo.bPrimaryKey = true
		  end if
		  
		  return oFieldInfo
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MapTableInfo(db as iOSSQLiteDatabase, sTable as Text, tyClass as xojo.Introspection.TypeInfo, aroFieldOpt() as FieldOpt, IsView as boolean = false) As TP_ActiveRecord.P.TableInfo
		  'Map fields in the database to properties on the class and
		  'return a list of <field> : <propertyInfo> pairs.
		  
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  
		  
		  oTableInfo = new TP_ActiveRecord.P.TableInfo
		  oTableInfo.tyClass = tyClass
		  
		  Dim rs As iOSSQLiteRecordSet = Db.FieldSchema(sTable)
		  
		  TP_ActiveRecord.Assert(rs.EOF=false, "Table not found: " + sTable)
		  
		  do until rs.EOF
		    dim oFieldInfo as TP_ActiveRecord.P.FieldInfo
		    oFieldInfo = MapFieldInfo(tyClass, rs, aroFieldOpt)
		    if oFieldInfo<>nil then
		      if oFieldInfo.bPrimaryKey then
		        oTableInfo.sPrimaryKey = oFieldInfo.sFieldName
		        oTableInfo.piPrimaryKey = oFieldInfo.piFieldProperty
		      end if
		      oTableInfo.aroField.Append(oFieldInfo)
		    end if
		    
		    rs.MoveNext
		  loop
		  
		  if IsView = false then
		    TP_ActiveRecord.Assert(oTableInfo.sPrimaryKey<>"", "The table needs to have a primary key")
		  end
		  
		  oTableInfo.sTableName = sTable
		  
		  return oTableInfo
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MapTableInfo(tyClass as xojo.Introspection.TypeInfo, oTableDef as TP_ActiveRecord.TableDef) As TP_ActiveRecord.P.TableInfo
		  'Map fields in the database to properties on the class and
		  'return a list of <field> : <propertyInfo> pairs.
		  
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  ' dim pi as Introspection.Propertyinfo
		  
		  oTableInfo = new TP_ActiveRecord.P.TableInfo
		  oTableInfo.sTableName = oTableDef.sTableName
		  oTableInfo.sPrimaryKey = oTableDef.sPrimaryKey
		  oTableInfo.piPrimaryKey = FindFieldProperty(tyClass, oTableInfo.sPrimaryKey)
		  if oTableInfo.piPrimaryKey=nil then
		    break
		  end if
		  oTableInfo.tyClass = tyClass
		  
		  for each oFieldDef as TP_ActiveRecord.FieldDef in oTableDef.aroField
		    dim oFieldInfo as new TP_ActiveRecord.P.FieldInfo( _
		    oFieldDef.sFieldName, _
		    FindFieldProperty(tyClass, oFieldDef.sFieldName))
		    oFieldInfo.bPrimaryKey = oFieldDef.IsPrimaryKey
		    oFieldInfo.bForeignKey = oFieldDef.IsForeignKey
		    oFieldInfo.enFieldType = oFieldDef.enFieldType
		    if oFieldInfo.piFieldProperty=nil then
		      break
		    end if
		    oTableInfo.aroField.Append(oFieldInfo)
		  next
		  
		  return oTableInfo
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Query(ty as xojo.Introspection.TypeInfo, sCriteria as Text = "", sOrder as Text = "") As Auto()
		  dim adp as TP_ActiveRecord.DatabaseAdapter
		  adp = GetContext.ConnectionAdapter_Get( ty )
		  if adp=nil then
		    raise new RuntimeException
		  end if
		  
		  dim info as xojo.Introspection.TypeInfo = xojo.Introspection.GetType(new base)
		  if not ty.IsSubclassOf( info ) then
		    dim ex as new RuntimeException
		    ex.Reason = "Invalid type"
		    raise ex
		  end if
		  
		  dim aro() as Auto
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo = GetTableInfo( ty )
		  
		  dim oConstructor as Introspection.ConstructorInfo
		  oConstructor = GetTypeConstructor(oTableInfo)
		  
		  Dim rs As iOSSQLiteRecordSet
		  rs = adp.SelectList(oTableInfo.sTableName, sCriteria, sOrder)
		  
		  do until rs.EOF
		    dim arv() as Auto
		    arv.Append(rs)
		    dim oBase as Base = oConstructor.Invoke(arv)
		    aro.Append( oBase )
		    rs.MoveNext
		  loop
		  
		  return aro
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function QueryRecordset(ty as xojo.Introspection.TypeInfo, sql as Text) As iOSSQLiteRecordSet
		  dim adp as TP_ActiveRecord.DatabaseAdapter
		  adp = GetContext.ConnectionAdapter_Get( ty )
		  if adp=nil then
		    raise new RuntimeException
		  end if
		  
		  dim info as xojo.Introspection.TypeInfo = xojo.Introspection.GetType(new base)
		  if not ty.IsSubclassOf( info ) then
		    dim ex as new RuntimeException
		    ex.Reason = "Invalid type"
		    raise ex
		  end if
		  
		  return adp.SQLSelect(sql)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RollbackTransaction()
		  //Use RollbackTransaction when outside of ActiveRecord
		  
		  
		  dim ctx as TP_ActiveRecord.P.Context = GetContext
		  Dim info As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(new TP_ActiveRecord.Base)
		  dim adp as TP_ActiveRecord.DatabaseAdapter = ctx.ConnectionAdapter_Get(info)
		  
		  adp.RollbackTransaction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLizeText(Extends sText as Text) As Text
		  dim sReturn as Text
		  
		  ' Change all single apostrophes to double apostrophes.
		  sReturn = sText.ReplaceAll("'", "''")
		  
		  ' Return the new string with apostrophe's around it already
		  Return "'" + sReturn + "'"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function stringFromDbType(enDbType as TP_ActiveRecord.DbType) As Text
		  select case enDbType
		  case DbType.DInteger
		    return "DInteger"
		  case DbType.DSmallInt
		    return "DSmallInt"
		  case DbType.DDouble
		    return "DDouble"
		  case DbType.DDate
		    return "DDate"
		  case DbType.DTime
		    return "DTime"
		  case DbType.DTimestamp
		    return "DTimestamp"
		  case DbType.DBoolean
		    return "DBoolean"
		  case DbType.DBlob
		    return "DBlob"
		  case DbType.DText
		    return "DText"
		  case DbType.DInt64
		    return "DInt64"
		  case DbType.DFloat
		    return "DFloat"
		  case DBtype.DCurrency
		    return "DCurrency"
		  case else
		    break
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Table(db as iOSSQLiteDatabase, sTable as Text, tyClass as xojo.Introspection.TypeInfo, ParamArray aroFieldOpt() as FieldOpt)
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  
		  'Record the mapping between the type and the table.
		  oTableInfo = TP_ActiveRecord.MapTableInfo( db, sTable, tyClass, aroFieldOpt )
		  
		  GetContext.TableInfo_Set(tyClass, oTableInfo)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Table(tyClass as xojo.Introspection.TypeInfo, oTableDef as TP_ActiveRecord.TableDef)
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  
		  'Record the mapping between the type and the table.
		  oTableInfo = TP_ActiveRecord.MapTableInfo(tyClass, oTableDef)
		  
		  GetContext.TableInfo_Set(tyClass, oTableInfo)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub VerifyClass(tyClass as Introspection.TypeInfo)
		  // Verify that all the fields marked as DatabaseField
		  // are on the table, assert an exception if not.
		  
		  // Collect all of the known table fields into an array
		  dim arsDBFields() as Text
		  dim oInfo as TP_ActiveRecord.P.TableInfo = GetTableInfo(tyClass)
		  for i as Integer = 0 to oInfo.aroField.Ubound
		    arsDBFields.Append(oInfo.aroField(i).sFieldName)
		    
		  next i
		  
		  // Iterate the properties
		  dim aroProperties() as Introspection.PropertyInfo = tyClass.Properties
		  for each oProp as Introspection.PropertyInfo in aroProperties
		    // Get the property attribtues
		    dim aroAttributes() as Introspection.AttributeInfo = oProp.GetAttributes
		    
		    // Look for the DatabaseField flag
		    dim bFlaggedAsDBField as Boolean
		    for each oAttrib as Introspection.AttributeInfo in aroAttributes
		      if oAttrib.Name = "DatabaseField" then
		        bFlaggedAsDBField = (oAttrib.Value = "True")
		        
		      end
		      
		    next oAttrib
		    
		    // If flag was not found, do not process this property
		    if bFlaggedAsDBField = false then continue for oProp
		    
		    // Iterate the tables to see if they're within this property name
		    // i.e. the lazy way to check ignoring prefix or suffix settings
		    dim bPropIsField as Boolean
		    for each sField as Text in arsDBFields
		      if VerifyClassProperty(oProp.Name, sField) = true then
		        // Field was found
		        bPropIsField = true
		        exit for sField
		        
		      end
		      
		    next sField
		    
		    TP_ActiveRecord.Assert(bPropIsField, "Database column for property " + _
		    tyClass.FullName + "." + oProp.Name + " could not be Found.")
		    
		  next oProp
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function VerifyClassProperty(sProp as Text, sField as Text) As Boolean
		  dim iPrefixType as integer = 0 //Override to do prefixes and suffixes
		  
		  static arsAllowPrefix() as Text //= Array(^2)  //Override for your own prefixes
		  static arsAllowSuffix() as Text //= Array(^3) //Override for your own suffixes
		  
		  // Match the field to a property of the class.
		  select case iPrefixType
		  case 0
		    // No prefix / suffix
		    return (sProp = sField)
		    
		  case 1
		    // Prefix
		    for each sPrefix as Text in arsAllowPrefix
		      if sProp = sPrefix + sField then
		        return true
		        
		      end
		      
		    next sPrefix
		    
		  case 2
		    // Suffix
		    for each sSuffix as Text in arsAllowSuffix
		      if sProp = sField + sSuffix then
		        return true
		        
		      end
		      
		    next sSuffix
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub View(db as iOSSQLiteDatabase, sTable as Text, tyClass as xojo.Introspection.TypeInfo, ParamArray aroFieldOpt() as FieldOpt)
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  
		  'Record the mapping between the type and the table.
		  oTableInfo = TP_ActiveRecord.MapTableInfo( db, sTable, tyClass, aroFieldOpt, true )
		  
		  GetContext.TableInfo_Set(tyClass, oTableInfo)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub View(tyClass as xojo.Introspection.TypeInfo, oTableDef as TP_ActiveRecord.TableDef)
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  
		  'Record the mapping between the type and the table.
		  oTableInfo = TP_ActiveRecord.MapTableInfo(tyClass, oTableDef)
		  
		  GetContext.TableInfo_Set(tyClass, oTableInfo)
		End Sub
	#tag EndMethod


	#tag Note, Name = To-Do (from BKS)
		Convert BKS_ActiveRecord.DatabaseAdapter.InsertRecord to use Kem's Solution for PreparedStatements
		Convert BKS_ActiveRecord.DatabaseAdapter.UpdateRecord to use Kem's Solution for PreparedStatements
		
		
		Add Date Picker so we can work with dates
		     - If nil date we need to check for that.  Converting from Auto
		
		Add validation for adding/changing People
		Add validation for adding/changing Contacts for a person
		
		Need more iOS way of adding/editing contacts
		
	#tag EndNote

	#tag Note, Name = Version History
		2019.01
		Added:
		- VerifyClass function checks class properties exist as columns
		
		Changed:
		- App.Open event accepts parameters and returns boolean
		- MapFieldInfo updated for new Chinook datatypes
		
		2017-12-19
		- Fixed bug with reading records with date values
		
		2017-12-14
		- Fixed bug with GUID
	#tag EndNote


	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  if m_csCtx=nil then
			    m_csCtx = new xojo.Threading.CriticalSection
			  end if
			  return m_csCtx
			End Get
		#tag EndGetter
		Private csCtx As CriticalSection
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private m_csCtx As xojo.Threading.CriticalSection
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_ctxDefault As TP_ActiveRecord.P.Context
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_dictContext As Xojo.Core.Dictionary
	#tag EndProperty


	#tag Constant, Name = kDoubleNullSentinal, Type = Double, Dynamic = False, Default = \"1.7E+308", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = Double, Dynamic = False, Default = \"2019.01", Scope = Protected
	#tag EndConstant


	#tag Enum, Name = DbType, Type = Integer, Flags = &h1
		DInteger
		  DSmallInt
		  DDouble
		  DDate
		  DTime
		  DTimestamp
		  DBoolean
		  DBlob
		  DText
		  DInt64
		  DFloat
		DCurrency
	#tag EndEnum


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
End Module
#tag EndModule
