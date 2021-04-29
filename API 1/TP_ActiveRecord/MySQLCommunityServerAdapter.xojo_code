#tag Class
Protected Class MySQLCommunityServerAdapter
Inherits TP_ActiveRecord.DatabaseAdapter
	#tag Method, Flags = &h0
		Sub BeginTransaction()
		  if m_iTransactionCt=0 then
		    try
		      m_db.Commit 'commit the auto transaction
		    catch ex as RuntimeException
		      'ignore this one
		    end try
		  end if
		  
		  if m_iTransactionCt=0 then
		    SQLExecute( "START TRANSACTION" )
		  end if
		  m_iTransactionCt = m_iTransactionCt + 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function BindValues(stmt as PreparedSQLStatement, oRecord as TP_ActiveRecord.Base, aroField() as TP_ActiveRecord.P.FieldInfo) As Dictionary
		  dim dictFieldValue as new Dictionary
		  
		  for i as integer = 0 to aroField.Ubound
		    dim oField as TP_ActiveRecord.P.FieldInfo = aroField(i)
		    
		    dim iDBType as integer = oField.iDBType
		    
		    dim pi as Introspection.PropertyInfo = oField.piFieldProperty
		    
		    dim v as Variant = pi.Value(oRecord)
		    
		    select case db
		    case nil
		      'empty. This just let's it compile if someone turns off all the constants
		      
		      #if TP_ActiveRecord.kConfigUseMySQLCommunityServer
		    case isa MySQLCommunityServer
		      select case aroField(i).enFieldType
		      case DBType.DInteger
		        iDBType = MySQLPreparedStatement.MYSQL_TYPE_LONG
		      case DBType.DSmallInt
		        iDBType = MySQLPreparedStatement.MYSQL_TYPE_SHORT
		      case DBType.DDouble
		        iDBType = MySQLPreparedStatement.MYSQL_TYPE_DOUBLE
		      case DBType.DDate
		        iDBType = MySQLPreparedStatement.MYSQL_TYPE_DATE
		      case DBType.DTimestamp
		        iDBType = MySQLPreparedStatement.MYSQL_TYPE_TIMESTAMP
		      case DBType.DBoolean
		        iDBType = MySQLPreparedStatement.MYSQL_TYPE_TINY
		      case DBType.DBlob
		        iDBType = MySQLPreparedStatement.MYSQL_TYPE_BLOB
		      case DBType.DText
		        iDBType = MySQLPreparedStatement.MYSQL_TYPE_STRING
		      case DBType.DInt64
		        iDBType = MySQLPreparedStatement.MYSQL_TYPE_LONGLONG
		      case DBType.DFloat, DBType.DDecimal
		        iDBType = MySQLPreparedStatement.MYSQL_TYPE_DOUBLE
		      case DBType.DCurrency
		        iDBType = MySQLPreparedStatement.MYSQL_TYPE_DOUBLE
		      case else
		        break 'unsupported type
		      end select
		      #endif
		      
		      
		      
		    end select
		    
		    #if TP_ActiveRecord.kConfigUseMySQLCommunityServer
		      'Xojo thinks MySQL BigInt (Int64) is a text field.
		      if oField.piFieldProperty.PropertyType.name = "Int64" AND oField.enFieldType = DBType.DText then
		        iDBType = MySQLPreparedStatement.MYSQL_TYPE_LONGLONG
		      end if
		    #Endif
		    
		    stmt.BindType(i, iDBType)
		    
		    if oField.IsKey and (v.IntegerValue < 1 or v.StringValue = "" or v.StringValue = "0") then
		      'if the field is a key and it's 0 or less, then set it to NULL
		      BindNull(stmt, i)
		      stmt.Bind(i, nil)
		    elseif pi.PropertyType.Name="Date" or (pi.PropertyType.Name="Variant" and v.Type=Variant.TypeDate) then
		      
		      dim dt as Date = v.DateValue
		      if dt=nil then
		        BindNull(stmt, i)
		        stmt.Bind(i, nil)
		      else
		        dim dt1 as new Date
		        dt1.GMTOffset = dt.GMTOffset
		        dt1.TotalSeconds = dt.TotalSeconds
		        v = dt1 'copied for the saved value
		        
		        dim dt2 as new Date
		        dt2.GMTOffset = dt.GMTOffset
		        dt2.TotalSeconds = dt.TotalSeconds
		        dt2.GMTOffset = 0
		        dt = dt2
		        
		        if oField.enFieldType=TP_ActiveRecord.DBType.DDate then
		          stmt.Bind(i, dt.SQLDate)
		        elseif oField.enFieldType=TP_ActiveRecord.DBType.DTimestamp then
		          stmt.Bind(i, dt.SQLDateTime)
		        else
		          stmt.Bind(i, dt.SQLDateTime)
		        end if
		      end if
		      
		    elseif pi.PropertyType.Name="Double" and v.DoubleValue = TP_ActiveRecord.kDoubleNullSentinal then
		      BindNull(stmt, i)
		      stmt.Bind(i, nil)
		    else
		      stmt.Bind(i, v)
		    end if
		    
		    dictFieldValue.Value(pi.Name) = v
		    
		  next
		  
		  return dictFieldValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CommitTransaction()
		  m_iTransactionCt = m_iTransactionCt - 1
		  if m_iTransactionCt=0 then
		    Db.Commit
		    if db.Error then
		      dim ex as new TP_ActiveRecord.DatabaseException(db, "Commit")
		      db.Rollback
		      raise ex
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(oDb as Object)
		  // If you are not connecting to MySQL
		  // and do not have the MySQLCommunityServer Plugin
		  // then you can safely delete this class
		  #if TP_ActiveRecord.kConfigUseMySQLCommunityServer
		    dim db as MySQLCommunityServer = MySQLCommunityServer(oDb)
		    if db=nil then
		      raise new RuntimeException
		    end if
		    m_db = db
		  #else
		    #pragma unused oDB
		    raise new UnsupportedOperationException
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Db() As Database
		  return m_db
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetLastInsertID() As Int64
		  #if TP_ActiveRecord.kConfigUseMySQLCommunityServer
		    return MySQLCommunityServer(m_db).GetInsertID
		  #else
		    raise new UnsupportedOperationException
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertRecord(oRecord as TP_ActiveRecord.Base, byref dictSavedPropertyValue as Dictionary)
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  
		  dim dictFieldValue as Dictionary
		  
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  dim arsField() as string
		  dim arsPlaceholder() as string
		  dim aroField() as TP_ActiveRecord.P.FieldInfo
		  dim sPK as string
		  dim oPKField as  TP_ActiveRecord.P.FieldInfo
		  for each oField as TP_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		    if oField.bPrimaryKey then
		      sPK = oField.sFieldName
		      oPKField = oField
		      continue
		    end if
		    arsField.Append(oField.sFieldName)
		    arsPlaceholder.Append("?")
		    aroField.Append(oField)
		  next
		  
		  dim arsSQL() as string
		  arsSQL.append "INSERT INTO " + oTableInfo.sTableName
		  arsSQL.append "(" + Join(arsField, ",") + ")"
		  arsSQL.append " VALUES "
		  arsSQL.append "(" + Join(arsPlaceholder, ",") + ")"
		  
		  dim sSQL as string = Join(arsSQL, " ")
		  
		  dim stmt as PreparedSQLStatement
		  stmt = db.Prepare( sSQL )
		  
		  dictFieldValue = BindValues(stmt, oRecord, aroField)
		  
		  stmt.SQLExecute
		  if db.Error then
		    raise new TP_ActiveRecord.DatabaseException(db)
		  end if
		  
		  
		  
		  if oPKField.piFieldProperty.PropertyType.Name = "String" then
		    dim rs as RecordSet = db.SQLSelectRaiseOnError("Select @last_uuid as guid_id")
		    dim sRecordID as string = rs.Field("guid_id").StringValue
		    dictFieldValue.Value( oTableInfo.piPrimaryKey.Name ) = sRecordID
		    oRecord.GUID = sRecordID
		  else
		    dim iRecordID as Int64 = GetLastInsertID
		    dictFieldValue.Value( oTableInfo.piPrimaryKey.Name ) = iRecordID
		    oRecord.ID = iRecordID
		  end if
		  
		  'store the newly saved property values
		  dictSavedPropertyValue = dictFieldValue
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RollbackTransaction()
		  m_iTransactionCt = m_iTransactionCt - 1
		  if m_iTransactionCt=0 then
		    Db.Rollback
		  end if
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_db As Database
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_iTransactionCt As Integer
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
