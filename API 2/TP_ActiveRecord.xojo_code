#tag Module
Protected Module TP_ActiveRecord
	#tag Method, Flags = &h1
		Protected Sub Assert(bCondition as boolean, sMessage as string = "")
		  #if DebugBuild then
		    if not bCondition then
		      Raise new TP_ActiveRecord.AssertionFailedException(sMessage)
		    end if
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BeginTransaction()
		  //Use BeginTransaction when outside of ActiveRecord
		  
		  
		  Var ctx as TP_ActiveRecord.P.Context = GetContext
		  Var adp as TP_ActiveRecord.DatabaseAdapter = ctx.ConnectionAdapter_Get(GetTypeInfo(TP_ActiveRecord.Base))
		  
		  adp.BeginTransaction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ColumnName(rs as RowSet) As String
		  Var iIndex As Integer = -1
		  
		  For i As Integer = 0 To rs.ColumnCount-1
		    Select Case rs.columnat(i).Name
		    case "ColumnName"
		      iIndex = i
		    End Select
		  Next
		  
		  if iIndex > -1 then
		    Return rs.columnat(iIndex).StringValue
		  else
		    Return "unknown"
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CommitTransaction()
		  //Use CommitTransaction when outside of ActiveRecord
		  
		  
		  Var ctx as TP_ActiveRecord.P.Context = GetContext
		  Var adp as TP_ActiveRecord.DatabaseAdapter = ctx.ConnectionAdapter_Get(GetTypeInfo(TP_ActiveRecord.Base))
		  
		  adp.CommitTransaction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Connect(db as Database)
		  Connect(GetTypeInfo(TP_ActiveRecord.Base), db)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Connect(ty as Introspection.TypeInfo, db as Database)
		  if ty=nil or db=nil then
		    raise new NilObjectException
		  end if
		  Var adp as TP_ActiveRecord.DatabaseAdapter
		  adp = CreateDatabaseAdapter(db)
		  GetContext.ConnectionAdapter_Set(ty, adp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CreateDatabaseAdapter(db as Database) As TP_ActiveRecord.DatabaseAdapter
		  #if TP_ActiveRecord.kConfigUseSQLiteDatabase and RBVersion>=2013
		    if db isa SQLiteDatabase then
		      return new SQLiteDatabaseAdapter(db)
		    end if
		  #endif
		  
		  #if TP_ActiveRecord.kConfigUseCubeDatabase
		    if db isa CubeSQLServer then
		      return new cubeSQLDatabaseAdapter(db)
		    end if
		  #endif
		  
		  #if TP_ActiveRecord.kConfigUseMSSQLServer
		    if db isa MSSQLServerDatabase then
		      return new MSSQLServerAdapter(db)
		    end if
		  #endif
		  
		  #if TP_ActiveRecord.kConfigUseMySQLCommunityServer
		    if db isa MySQLCommunityServer then
		      return new MySQLCommunityServerAdapter(db)
		    end if
		  #endif
		  
		  #if TP_ActiveRecord.kConfigUseODBC
		    if db isa ODBCDatabase then
		      return new ODBCServerAdapter(db)
		    end
		  #Endif
		  
		  
		  
		  #if TP_ActiveRecord.kConfigUsePostgreSQLDatabase
		    if db isa PostgreSQLDatabase then
		      return new PostgreSQLDatabaseAdapter(db)
		    end if
		  #endif
		  
		  #if TP_ActiveRecord.kConfigUseVSQLiteDatabase
		    if db isa VSQLiteDatabase then
		      return new VSQLiteDatabaseAdapter(db)
		    end if
		  #endif
		  
		  Var ex as new UnsupportedOperationException
		  ex.Message = "Unsupported database type: " + Introspection.GetType(db).FullName
		  raise ex
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Disconnect()
		  'Disconnect the base active record class from the database
		  Disconnect( GetTypeInfo(TP_ActiveRecord.Base) )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Disconnect(ty as Introspection.TypeInfo)
		  'Disconnect a specific active record class from the database
		  if ty=nil then
		    raise new NilObjectException
		  end if
		  
		  Var ctx as TP_ActiveRecord.P.Context = GetContext
		  ctx.ConnectionAdapter_Remove(ty)
		  #if RBVersion >= 2011.04
		    #if TargetWeb
		      if ctx.ConnectionAdapter_Count=0 then
		        'kill the context
		        Var lck as new TP_ActiveRecord.P.ScopedLock(csCtx)
		        #pragma unused lck
		        m_dictContext.Remove(Session.Identifier)
		      end if
		    #endif
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Field(sFieldName as string) As TP_ActiveRecord.FieldOpt
		  return new FieldOpt(sFieldName)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FieldType(rs as RowSet) As Integer
		  Var iIndex as integer = -1
		  For i As Integer = 0 To rs.ColumnCount-1
		    Select Case rs.ColumnAt(i).Name
		    case "FieldType"
		      iIndex = i
		    end select
		  next
		  
		  if iIndex > -1 then
		    Return rs.ColumnAt(iIndex).IntegerValue
		  else
		    Return 0
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Field_IsPrimary(rs as RowSet) As Boolean
		  For i As Integer = 0 To rs.ColumnCount-1
		    Select Case rs.ColumnAt(i).Name
		    case "IsPrimary"
		      Return rs.ColumnAt(i).BooleanValue
		    end select
		  next
		  
		  Return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FindFieldProperty(tyClass as Introspection.TypeInfo, sField as string) As Introspection.PropertyInfo
		  Var iPrefixType as integer = 0 //Override to do prefixes and suffixes
		  
		  static arsAllowPrefix() as string //= Array(^2) //Override for your own prefixes
		  static arsAllowSuffix() as string //= Array(^3) //Override for your own suffixes
		  
		  // Match the field to a property of the class.
		  select case iPrefixType
		  case 0
		    // No prefix / suffix
		    
		    for each pi as Introspection.PropertyInfo in tyClass.GetProperties
		      
		      if pi.Name = sField then
		        return pi 'accept exact match
		      end
		    next
		    
		    return nil
		    
		  case 1
		    // Prefix
		    for each pi as Introspection.PropertyInfo in tyClass.GetProperties
		      if pi.Name.Right(sField.Length) = sField then
		        'check for a prefix match
		        Var sPrefix as string = pi.Name.Middle(0, pi.Name.Length - sField.Length)
		        if arsAllowPrefix.IndexOf(sPrefix) >-1 then
		          return pi
		        end if
		      end
		    next
		    
		    return nil
		    
		  case 2
		    // Suffix
		    for each pi as Introspection.PropertyInfo in tyClass.GetProperties
		      if pi.name.left(sField.Length) = sField then
		        'Check for suffix match
		        Var sSuffix as string = pi.Name.Right(pi.Name.Length - sField.Length)
		        if arsAllowSuffix.IndexOf(sSuffix) > -1 then
		          return pi
		        end
		      end if
		    next
		    
		    return nil
		    
		  case else
		    break
		    
		  end select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FindMatchingTable(adp as TP_ActiveRecord.DatabaseAdapter, sClassName as string) As string
		  Var sTable as string = sClassName
		  if adp.HasTable( sTable ) then
		    return sTable
		  end if
		  
		  sTable = "tbl" + sClassName
		  if adp.HasTable( sTable ) then
		    return sTable
		  end if
		  
		  'if the class is clsSomething, look for Something and tblSomething
		  'but not if the letter after cls is lowercase
		  Var sFourth As String = sClassName.Middle(4,1)
		  if sClassName.left( 3 ) = "cls" and _
		    sFourth.Compare( "A", ComparisonOptions.CaseInsensitive ) >= -1 And _
		    sFourth.Compare( "Z", ComparisonOptions.CaseInsensitive ) <= -1 Then
		    sTable = sClassName.Middle(3)
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
		  
		  #if RBVersion >= 2011.04 then
		    #if TargetWeb then
		      #if XojoVersion < 2020 then
		        if Session <> nil then
		          return m_ctxDefault
		          
		        end
		        
		      #else
		        if Session = nil then
		          return m_ctxDefault
		          
		        end
		        
		      #endif
		      
		      Var lck as new TP_ActiveRecord.P.ScopedLock(csCtx)
		      #pragma unused lck
		      
		      if m_dictContext=nil then
		        m_dictContext = new Dictionary
		      end if
		      
		      if not m_dictContext.HasKey(Session.Identifier) then
		        m_dictContext.Value(Session.Identifier) = new TP_ActiveRecord.P.Context
		      end if
		      return m_dictContext.Value(Session.Identifier)
		    #endif
		  #endif
		  
		  return m_ctxDefault
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetDatabaseAdapter() As TP_ActiveRecord.DatabaseAdapter
		  //GetDatabaseAdapter
		  //Useful if you want to get do transactions outside of the Base Class.
		  //Example:  You know you have some lengthy operations to do.
		  
		  Var ctx as TP_ActiveRecord.P.Context = GetContext
		  Var adp as TP_ActiveRecord.DatabaseAdapter = ctx.ConnectionAdapter_Get(GetTypeInfo(TP_ActiveRecord.Base))
		  
		  Return adp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetTableDefs() As TP_ActiveRecord.TableDef()
		  Var aroTableDef() as TP_ActiveRecord.TableDef
		  for each oTableInfo as TP_ActiveRecord.P.TableInfo in GetContext.TableInfo_List
		    Var aro() as TP_ActiveRecord.FieldDef
		    
		    for each oFieldInfo as TP_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		      Var o as new TP_ActiveRecord.FieldDef( oFieldInfo.sFieldName, oFieldInfo.enFieldType, oFieldInfo.bPrimaryKey, oFieldInfo.bForeignKey)
		      aro.Add(o)
		    next
		    
		    Var oTableDef as new TP_ActiveRecord.TableDef(oTableInfo.sTableName, oTableInfo.sPrimaryKey, aro)
		    aroTableDef.Add(oTableDef)
		  next
		  return aroTableDef
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTableInfo(ty as Introspection.TypeInfo) As TP_ActiveRecord.P.TableInfo
		  'check the info cache and return the mapping if it exists
		  Var oTableInfo as TP_ActiveRecord.P.TableInfo = GetContext.TableInfo_Get(ty)
		  if oTableInfo<>nil then
		    return oTableInfo
		  end if
		  
		  'try to map the class to a table by name
		  Var adp as TP_ActiveRecord.DatabaseAdapter = GetContext.ConnectionAdapter_Get( ty )
		  if adp<>nil then
		    Var sTable as string
		    sTable = FindMatchingTable( adp, ty.Name )
		    if sTable<>"" then
		      Table adp.Db, sTable, ty
		      return GetContext.TableInfo_Get(ty)
		    end if
		  end if
		  
		  'table not registered and not found by name
		  Var ex as RuntimeException
		  ex.Message = "Class does not have a table registered for it: " + ty.FullName
		  raise ex
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTypeConstructor(oTableInfo as TP_ActiveRecord.P.TableInfo) As Introspection.ConstructorInfo
		  Var oConstructor as Introspection.ConstructorInfo
		  
		  for each o as Introspection.ConstructorInfo in oTableInfo.tyClass.GetConstructors
		    Var aroParam() as Introspection.ParameterInfo = o.GetParameters
		    if aroParam.LastIndex = 0 then
		      if aroParam(0).ParameterType.FullName = "RowSet" then
		        oConstructor = o
		        exit for
		      end if
		    end if
		  next
		  
		  return oConstructor
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MapFieldInfo(tyClass as Introspection.TypeInfo, rs as RowSet, aroFieldOpt() as FieldOpt) As TP_ActiveRecord.P.FieldInfo
		  ' static arsAllowPrefix() as string = Array("m_", "m_id","i","s","dtm","dt","b","d","v","pict")
		  
		  Var sField as string = ColumnName(rs)
		  
		  'extract the field option if one was passed in for this field
		  Var oFieldOpt as FieldOpt
		  for each o as FieldOpt in aroFieldOpt
		    if o.FieldName=sField then
		      oFieldOpt = o
		    end if
		  next
		  
		  if oFieldOpt<>nil and oFieldOpt.IsIgnored then
		    return nil 'ignore this field
		  end if
		  
		  'Find the database field type
		  var enFieldType as DBType
		  var iFieldType as integer = FieldType(rs)
		  select case iFieldType
		  case 1 // MSSQL bit
		    enFieldType = DBType.DBoolean
		  case 2 'smallint
		    enFieldType = DBType.DSmallInt
		  case 3 'integer
		    enFieldType = DBType.DInteger
		  case 4 'Serial
		    enFieldType = DBType.DText
		  case 5 'text or varchar
		    enFieldType = DBType.DText
		  case 6 'float
		    enFieldType = DBType.DFloat
		  case 7 'double
		    enFieldType = DBType.DDouble
		  case 8 'date
		    enFieldType = DBType.DDate
		  case 9 'time
		    enFieldType = DBType.DTime
		  case 10 'timestamp
		    enFieldType = DBType.DTimestamp
		  case 11 'currency
		    enFieldType = DBType.DCurrency
		  case 12 'boolean
		    enFieldType = DBType.DBoolean
		  case 13 'Decimal
		    enFieldType = DBType.DDecimal
		  case 14 'binary
		    enFieldType = DBType.DBlob
		  case 15 'blob
		    enFieldType = DBType.DBlob
		  case 16 'varbinary
		    enFieldType = DBType.DBlob
		  case 18 'String
		    enFieldType = DBType.DText
		  case 19 'int64
		    enFieldType = DBType.DInt64
		  case else
		    break
		  end select
		  
		  'Match the field to a property of the class.
		  ' Properties are named with a prefix:  <prefix>FieldName = FieldName
		  var piFound as Introspection.PropertyInfo
		  piFound = FindFieldProperty(tyClass, sField)
		  
		  if piFound=nil then
		    TP_ActiveRecord.Assert( false, "No property for field " +tyclass.FullName + "." + sField )
		    return nil
		  end if
		  
		  Var oFieldInfo as new TP_ActiveRecord.P.FieldInfo(sField, piFound, tyClass)
		  oFieldInfo.enFieldType = enFieldType
		  if Field_IsPrimary(rs) then
		    oFieldInfo.bPrimaryKey = true
		  end if
		  
		  // Foreign Key Support
		  var oFieldProp as Introspection.PropertyInfo = FindFieldProperty(tyClass, sField)
		  if oFieldProp <> nil then
		    var aroAttributes() as Introspection.AttributeInfo = oFieldProp.GetAttributes
		    for each oAttrib as Introspection.AttributeInfo in aroAttributes
		      if oAttrib.Name = "ForeignKey" then
		        oFieldInfo.bForeignKey = (oAttrib.Value = "True")
		        
		      end
		      
		    next oAttrib
		    
		  end
		  
		  return oFieldInfo
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MapTableInfo(db as Database, sTable as string, tyClass as Introspection.TypeInfo, aroFieldOpt() as FieldOpt, IsView as boolean = false) As TP_ActiveRecord.P.TableInfo
		  'Map fields in the database to properties on the class and
		  'return a list of <field> : <propertyInfo> pairs.
		  
		  var oTableInfo as new TP_ActiveRecord.P.TableInfo
		  oTableInfo.tyClass = tyClass
		  
		  var rs as RowSet
		  #if TP_ActiveRecord.kConfigUsePostgreSQLDatabase then
		    'Database.FieldSchema does not work with PostgreSQL Views.
		    'It does not return field info.
		    'So we cast db to PostgreSQLDatabase
		    if db isa PostgreSQLDatabase and IsView = true then
		      var dbPostGresSQL as PostgreSQLDatabase = PostgreSQLDatabase(db)
		      rs = dbPostGresSQL.TableColumns(sTable)
		      
		    else
		      rs = Db.TableColumns(sTable)
		      
		    end
		    
		  #elseif TP_ActiveRecord.kConfigUseMSSQLServerMBS then
		    ' mbs does not support or implement FIELDSCHEMA
		    if db isa SQLDatabaseMBS then
		      var mbs_db as SQLDatabaseMBS = SQLDatabaseMBS(db)
		      ' since mbs can support many different dbs through this ssame set up 
		      ' we need to see which we have to know how to get the right filed schema query
		      if mbs_db.ServerVersionString.Left(20) = "Microsoft SQL Server" then
		        var stmt as SQLPreparedStatementMBS = mbs_db.Prepare(TP_ActiveRecord.MSSQLServerAdapterMBS.kFieldSchema)
		        
		        rs = stmt.SQLSelect(sTable, sTable, sTable)
		        
		      else
		        break
		        
		      end
		      
		    end
		    
		  #else
		    // Not a PostgreSQL database, so we don't need to workaround a Xojo bug
		    rs = Db.TableColumns(sTable)
		    
		  #endif
		  
		  TP_ActiveRecord.Assert(rs.AfterLastRow=false, "Table not found: " + sTable)
		  
		  do until rs.AfterLastRow
		    Var oFieldInfo as TP_ActiveRecord.P.FieldInfo
		    oFieldInfo = MapFieldInfo(tyClass, rs, aroFieldOpt)
		    if oFieldInfo<>nil then
		      if oFieldInfo.bPrimaryKey then
		        oTableInfo.sPrimaryKey = oFieldInfo.sFieldName
		        oTableInfo.piPrimaryKey = oFieldInfo.piFieldProperty
		      end if
		      oTableInfo.aroField.Add(oFieldInfo)
		    end if
		    
		    rs.MoveToNextRow
		  loop
		  
		  
		  
		  if IsView = false then
		    TP_ActiveRecord.Assert(oTableInfo.sPrimaryKey<>"", "The table needs to have a primary key")
		  end
		  
		  oTableInfo.sTableName = sTable
		  
		  return oTableInfo
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MapTableInfo(tyClass as Introspection.TypeInfo, oTableDef as TP_ActiveRecord.TableDef) As TP_ActiveRecord.P.TableInfo
		  'Map fields in the database to properties on the class and
		  'return a list of <field> : <propertyInfo> pairs.
		  
		  Var oTableInfo as TP_ActiveRecord.P.TableInfo
		  ' Var pi as Introspection.Propertyinfo
		  
		  oTableInfo = new TP_ActiveRecord.P.TableInfo
		  oTableInfo.sTableName = oTableDef.sTableName
		  oTableInfo.sPrimaryKey = oTableDef.sPrimaryKey
		  oTableInfo.piPrimaryKey = FindFieldProperty(tyClass, oTableInfo.sPrimaryKey)
		  if oTableInfo.piPrimaryKey=nil then
		    break
		  end if
		  oTableInfo.tyClass = tyClass
		  
		  for each oFieldDef as TP_ActiveRecord.FieldDef in oTableDef.aroField
		    Var oFieldInfo as new TP_ActiveRecord.P.FieldInfo(oFieldDef.sFieldName, FindFieldProperty(tyClass, oFieldDef.sFieldName), tyClass)
		    oFieldInfo.bPrimaryKey = oFieldDef.IsPrimaryKey
		    oFieldInfo.bForeignKey = oFieldDef.IsForeignKey
		    oFieldInfo.enFieldType = oFieldDef.enFieldType
		    if oFieldInfo.piFieldProperty=nil then
		      break
		    end if
		    oTableInfo.aroField.Add(oFieldInfo)
		  next
		  
		  return oTableInfo
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Query(ty as Introspection.TypeInfo, sCriteria as string = "", sOrder as string = "") As Variant()
		  Var adp as TP_ActiveRecord.DatabaseAdapter
		  adp = GetContext.ConnectionAdapter_Get( ty )
		  if adp=nil then
		    raise new RuntimeException
		  end if
		  
		  if not ty.IsSubclassOf( GetTypeInfo( Base ) ) then
		    Var ex as new RuntimeException
		    ex.Message = "Invalid type"
		    raise ex
		  end if
		  
		  Var aro() as Variant
		  Var oTableInfo as TP_ActiveRecord.P.TableInfo = GetTableInfo( ty )
		  
		  Var oConstructor as Introspection.ConstructorInfo
		  oConstructor = GetTypeConstructor(oTableInfo)
		  
		  Var rs as RowSet
		  rs = adp.SelectList(oTableInfo.sTableName, sCriteria, sOrder)
		  
		  do until rs.AfterLastRow
		    Var arv() as Variant
		    arv.Add(rs)
		    Var oBase as Base = oConstructor.Invoke(arv)
		    aro.Add( oBase )
		    rs.MoveToNextRow
		  loop
		  
		  return aro
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function QueryRecordset(ty as Introspection.TypeInfo, sql as String) As RowSet
		  Var adp as TP_ActiveRecord.DatabaseAdapter
		  adp = GetContext.ConnectionAdapter_Get( ty )
		  if adp=nil then
		    raise new RuntimeException
		  end if
		  
		  if not ty.IsSubclassOf( GetTypeInfo( Base ) ) then
		    Var ex as new RuntimeException
		    ex.Message = "Invalid type"
		    raise ex
		  end if
		  
		  return adp.SQLSelect(sql)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RollbackTransaction()
		  //Use RollbackTransaction when outside of ActiveRecord
		  
		  
		  Var ctx as TP_ActiveRecord.P.Context = GetContext
		  Var adp as TP_ActiveRecord.DatabaseAdapter = ctx.ConnectionAdapter_Get(GetTypeInfo(TP_ActiveRecord.Base))
		  
		  adp.RollbackTransaction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function stringFromDBType(enDBType as TP_ActiveRecord.DBType) As string
		  select case enDBType
		  case DBType.DInteger
		    return "DInteger"
		  case DBType.DSmallInt
		    return "DSmallInt"
		  case DBType.DDouble
		    return "DDouble"
		  case DBType.DDate
		    return "DDate"
		  case DBType.DTime
		    return "DTime"
		  case DBType.DTimestamp
		    return "DTimestamp"
		  case DBType.DBoolean
		    return "DBoolean"
		  case DBType.DBlob
		    return "DBlob"
		  case DBType.DText
		    return "DText"
		  case DBType.DInt64
		    return "DInt64"
		  case DBType.DFloat
		    return "DFloat"
		  case DBtype.DCurrency
		    return "DCurrency"
		  case DBType.DDecimal
		    Return "DDecimal"
		  case else
		    break
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Table(db as Database, sTable as string, tyClass as Introspection.TypeInfo, ParamArray aroFieldOpt() as FieldOpt)
		  Var oTableInfo as TP_ActiveRecord.P.TableInfo
		  
		  'Record the mapping between the type and the table.
		  oTableInfo = TP_ActiveRecord.MapTableInfo( db, sTable, tyClass, aroFieldOpt )
		  
		  GetContext.TableInfo_Set(tyClass, oTableInfo)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Table(tyClass as Introspection.TypeInfo, oTableDef as TP_ActiveRecord.TableDef)
		  Var oTableInfo as TP_ActiveRecord.P.TableInfo
		  
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
		  Var arsDBFields() as String
		  Var oInfo as TP_ActiveRecord.P.TableInfo = GetTableInfo(tyClass)
		  for i as Integer = 0 to oInfo.aroField.LastIndex
		    arsDBFields.Add(oInfo.aroField(i).sFieldName)
		    
		  next i
		  
		  // Iterate the properties
		  Var aroProperties() as Introspection.PropertyInfo = tyClass.GetProperties
		  for each oProp as Introspection.PropertyInfo in aroProperties
		    // Get the property attribtues
		    Var aroAttributes() as Introspection.AttributeInfo = oProp.GetAttributes
		    
		    // Look for the DatabaseField flag
		    Var bFlaggedAsDBField as Boolean
		    for each oAttrib as Introspection.AttributeInfo in aroAttributes
		      if oAttrib.Name = "DatabaseField" then
		        bFlaggedAsDBField = (oAttrib.Value = "True")
		        
		      end
		      
		    next oAttrib
		    
		    // If flag was not found, do not process this property
		    if bFlaggedAsDBField = false then continue for oProp
		    
		    // Iterate the tables to see if they're within this property name
		    // i.e. the lazy way to check ignoring prefix or suffix settings
		    Var bPropIsField as Boolean
		    for each sField as String in arsDBFields
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
		Private Function VerifyClassProperty(sProp as String, sField as String) As Boolean
		  Var iPrefixType as integer = 0 //Override to do prefixes and suffixes
		  
		  static arsAllowPrefix() as string //= Array(^2) //Override for your own prefixes
		  static arsAllowSuffix() as string //= Array(^3) //Override for your own suffixes
		  
		  // Match the field to a property of the class.
		  select case iPrefixType
		  case 0
		    // No prefix / suffix
		    return (sProp = sField)
		    
		  case 1
		    // Prefix
		    for each sPrefix as String in arsAllowPrefix
		      if sProp = sPrefix + sField then
		        return true
		        
		      end
		      
		    next sPrefix
		    
		  case 2
		    // Suffix
		    for each sSuffix as String in arsAllowSuffix
		      if sProp = sField + sSuffix then
		        return true
		        
		      end
		      
		    next sSuffix
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub View(db as Database, sTable as string, tyClass as Introspection.TypeInfo, ParamArray aroFieldOpt() as FieldOpt)
		  Var oTableInfo as TP_ActiveRecord.P.TableInfo
		  
		  'Record the mapping between the type and the table.
		  oTableInfo = TP_ActiveRecord.MapTableInfo( db, sTable, tyClass, aroFieldOpt, true )
		  
		  GetContext.TableInfo_Set(tyClass, oTableInfo)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub View(tyClass as Introspection.TypeInfo, oTableDef as TP_ActiveRecord.TableDef)
		  Var oTableInfo as TP_ActiveRecord.P.TableInfo
		  
		  'Record the mapping between the type and the table.
		  oTableInfo = TP_ActiveRecord.MapTableInfo(tyClass, oTableDef)
		  
		  GetContext.TableInfo_Set(tyClass, oTableInfo)
		End Sub
	#tag EndMethod


	#tag Note, Name = License
		 Copyright 2011 - 2020, BKeeney Software, Inc.
		 Copyright 2020, Underwriters Technologies
		 
		 MIT License
		 
		 Permission is hereby granted, free of charge, to any person obtaining a copy
		 of this software and associated documentation files (the "Software"), to deal
		 in the Software without restriction, including without limitation the rights
		 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		 copies of the Software, and to permit persons to whom the Software is
		 furnished to do so, subject to the following conditions:
		 
		 The above copyright notice and this permission notice shall be included in
		 all copies or substantial portions of the Software.
		 
		 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
		 THE SOFTWARE.
		
	#tag EndNote

	#tag Note, Name = Version History
		[2021.01] - April 2, 2021
		 Fixed:
		   - API 2.0 Postgres adapter array issue
		
		###
		
		[2020.05] - December 9, 2020
		 Changed:
		   - API 2.1 naming (removes 2020r1 support)
		
		###
		
		[2020.04] - October 8, 2020
		 Fixed:
		   - Date-only changes are now recognized
		   - IsRecordModified no longer has redundant cases
		   - GUID now returns the string version of the ID when not a string
		   - API 2.0 library foreign key identification
		
		###
		
		[2020.03] - August 10, 2020
		 Fixed:
		   - API 2.0 BindValues function
		
		###
		
		[2020.02] - August 4, 2020
		 New:
		  - MBS SQL DatabaseAdapter for Microsoft SQL Server
		
		Fixed:
		  - MySQL null saving
		
		Changed:
		  - Adds support for multiple MSSQL FieldSchema types
		  - Desktop now uses connection pooling for threading support
		
		###
		
		[2020.01] - June 2020
		 New:
		  - API 2.0 support
		  - Multiple database connections in one project
		  - Database field flagging with support from Propery Attributes
		    ↳ Set a property attribute named IsDatabaseField = True on database field properties
		  - Foreign key flagging with support from Property Attributes
		    ↳ Set a property attribute named IsForeignKey = True on foreign key field properties
		  - Saving a nil foreign key will INSERT / UPDATE a NULL for the record
		
		 Changed:
		  - Rebranded library name
		  - Fixed all warnings in the TP_ActiveRecord module
		  - Consolidated multiple modules in to TP_ActiveRecord
		 
		 Removed:
		  - REALSQLDatabase
		
		###
		
		[2017.01] - November 2017
		 New:
		  - GUID support
		  - Support for PostgreSQL Views
		  - Rollback Method to MSSQLServerAdapter
		  - Dictionary for ARGen Audit trail
		  - Support for currencty DB type
		
		 Fixed:
		  - Decimal type no longer missing from MySQL
		  - Corrected compiler constants for missing DB plugins
		  - PostgreSQL no longer returns the wrong ID on insert
		
		
		[2015.01] - Fall 2015
		 New Features:
		  - Added ODBC Database to the project
		  - Added SQLite Valentina to the project.  Thanks to Ruslan for providing it.
		  - Added the View Class.  As the name suggests it allows access to Database Views.
		  - Added transaction example to project.
		  - Added View (personList) to the example
		
		 Changes:
		  - Removed some old (and ineffective) Transactional processing code.
		  - Cleaned up the demo project to fit more modern BKeeney Standards
		  - Fixed a null date issue
		  - Optimized desktop version to speed inserts and updates
		  - Optimized Field definition to speed up inserts and updates
		
		 Totally Unsupported and untested
		  - Oracle
		
		 Broken in Current Xojo Implementations
		  - MS SQL Server - Prepared statements are FUBAR'ed.
		
		###
		
		[2014.01] - May 2014
		 - Added TP_ActiveRecord to hold configuration constants.
		 - It's no longer necessary to delete code for database plugins that aren't installed.
		
		###
		
		[2013.01] - Nov 2013
		 - Added Oracle (totally unsupported and if it doesn't work please don't ask!)
		 - Added CubeSQL Support
		 - Added more descriptions when errors occur when plugins are missing
		
		###
		
		[2013.01] - May 2013
		 - Removed dependencies to Monkeybread
		
		
	#tag EndNote


	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  if m_csCtx=nil then
			    'Mutexes work on Mac and Linux but not Windows.
			    'CriticalSections work on Windows but not Mac.
			    '(Verified as of 2011 R4.1)
			    #if TargetWin32
			      m_csCtx = new CriticalSection
			    #else
			      m_csCtx = new Mutex("")
			    #endif
			  end if
			  return m_csCtx
			End Get
		#tag EndGetter
		Private csCtx As CriticalSection
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private m_csCtx As CriticalSection
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_ctxDefault As TP_ActiveRecord.P.Context
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_dictContext As Dictionary
	#tag EndProperty


	#tag Constant, Name = kConfigUseCubeDatabase, Type = Boolean, Dynamic = False, Default = \"False", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kConfigUseMSSQLServer, Type = Boolean, Dynamic = False, Default = \"False", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kConfigUseMSSQLServerMBS, Type = Boolean, Dynamic = False, Default = \"False", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kConfigUseMySQLCommunityServer, Type = Boolean, Dynamic = False, Default = \"False", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kConfigUseODBC, Type = Boolean, Dynamic = False, Default = \"False", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kConfigUsePostgreSQLDatabase, Type = Boolean, Dynamic = False, Default = \"False", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kConfigUseSQLiteDatabase, Type = Boolean, Dynamic = False, Default = \"True", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kConfigUseVSQLiteDatabase, Type = Boolean, Dynamic = False, Default = \"False", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kDoubleNullSentinal, Type = Double, Dynamic = False, Default = \"1.7E+308", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = Double, Dynamic = False, Default = \"2021.01", Scope = Protected
	#tag EndConstant


	#tag Enum, Name = DBType, Type = Integer, Flags = &h1
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
		  DNotUsed
		DDecimal
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="2147483648"
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
