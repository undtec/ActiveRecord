#tag Class
Protected Class PostgreSQLDatabaseAdapter
Inherits BKS_ActiveRecord.DatabaseAdapter
	#tag Method, Flags = &h21
		Private Function BindValues(stmt as PreparedSQLStatement, oRecord as BKS_ActiveRecord.Base, aroField() as BKS_ActiveRecord.P.FieldInfo) As Dictionary
		  dim dictFieldValue as new Dictionary
		  
		  for i as integer = 0 to aroField.Ubound
		    dim oField as BKS_ActiveRecord.P.FieldInfo = aroField(i)
		    dim pi as Introspection.PropertyInfo = oField.piFieldProperty
		    dim v as Variant = pi.Value(oRecord)

		    'Same rules as DatabaseAdapter.BindValues, which PostgreSQL cannot use because
		    'it binds by position without type codes.
		    if oField.IsKey and v.IntegerValue<=0 then
		      'a key of 0 or less is stored as NULL so foreign key constraints are not broken
		      stmt.Bind(i, nil)

		    elseif pi.PropertyType.Name="Date" or (pi.PropertyType.Name="Variant" and v.Type=Variant.TypeDate) then
		      dim dt as Date = v.DateValue
		      if dt=nil then
		        stmt.Bind(i, nil)
		      else
		        dim dtCopy as new Date
		        dtCopy.GMTOffset = dt.GMTOffset
		        dtCopy.TotalSeconds = dt.TotalSeconds
		        v = dtCopy 'copied for the saved value

		        'local time, matching Base.ReadRecord
		        if oField.enFieldType=BKS_ActiveRecord.DbType.DDate then
		          stmt.Bind(i, dt.SQLDate)
		        else
		          stmt.Bind(i, dt.SQLDateTime)
		        end if
		      end if

		    elseif pi.PropertyType.Name="Double" and v.DoubleValue = BKS_ActiveRecord.kDoubleNullSentinal then
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
		Sub Constructor(oDb as Object)
		  'If you are not connecting to PostgreSQL and do not have the PostgreSQLPlugin plugin delete this class (PostgreSQLDatabaseAdapter)
		  #if BKS_ActiveRecordConfig.kIncludePostgreSQLDatabase
		    dim db as PostgreSQLDatabase = PostgreSQLDatabase(oDb)
		    if db=nil then
		      raise new RuntimeException
		    end if
		    m_db = db
		  #else
		    raise new UnsupportedOperationException
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Db() As Database
		  return m_db
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteRecord(oRecord as BKS_ActiveRecord.Base)
		  'Overrides the base class because PostgreSQL uses $1 placeholders, not ?
		  dim oTableInfo as BKS_ActiveRecord.P.TableInfo
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )

		  Var sql As String = "DELETE FROM " + oTableInfo.sTableName + _
		  " WHERE " + oTableInfo.sPrimaryKey + "=$1"

		  dim stmt as PreparedSQLStatement
		  stmt = db.Prepare(sql)
		  Var iID As Int64 = oRecord.ID
		  stmt.Bind(0, iID)

		  stmt.SQLExecute
		  if db.Error then
		    raise new BKS_ActiveRecord.DatabaseException(db)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetLastInsertID() As Int64
		  dim rs as RecordSet
		  rs = SQLSelect("SELECT LASTVAL();")
		  return rs.IdxField(1).Int64Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function InsertRecord(oRecord as BKS_ActiveRecord.Base, byref dictSavedPropertyValue as Dictionary) As Int64
		  dim oTableInfo as BKS_ActiveRecord.P.TableInfo
		  
		  dim dictFieldValue as Dictionary
		  
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  dim arsField() as string
		  dim arsPlaceholder() as string
		  dim aroField() as BKS_ActiveRecord.P.FieldInfo
		  
		  for each oField as BKS_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		    if oField.bPrimaryKey then
		      continue
		    end if
		    arsField.Append(oField.sFieldName)
		    arsPlaceholder.Append("$" + str(arsPlaceholder.Ubound + 2) )
		    aroField.Append(oField)
		  next
		  
		  dim sql as string
		  sql = "INSERT INTO " + oTableInfo.sTableName
		  sql = sql + "(" + Join(arsField, ",") + ")"
		  sql = sql + " VALUES "
		  sql = sql + "(" + Join(arsPlaceholder, ",") + ")"
		  
		  dim stmt as PreparedSQLStatement
		  stmt = db.Prepare(sql)
		  
		  dictFieldValue = BindValues(stmt, oRecord, aroField)
		  
		  stmt.SQLExecute
		  if db.Error then
		    raise new BKS_ActiveRecord.DatabaseException(db)
		  end if
		  
		  dim iRecordID as Int64 = GetLastInsertID
		  dictFieldValue.Value( oTableInfo.piPrimaryKey.Name ) = iRecordID
		  
		  'store the newly saved property values
		  dictSavedPropertyValue = dictFieldValue
		  
		  return iRecordID
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectRecord(oRecord as BKS_ActiveRecord.Base, iRecordID as integer) As RecordSet
		  'Overrides the base class because PostgreSQL uses $1 placeholders, not ?
		  dim oTableInfo as BKS_ActiveRecord.P.TableInfo
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )

		  Var sql As String = "SELECT * FROM " + oTableInfo.sTableName + _
		  " WHERE " + oTableInfo.sPrimaryKey + "=$1"

		  dim stmt as PreparedSQLStatement
		  stmt = db.Prepare(sql)
		  stmt.Bind(0, iRecordID)

		  dim rs as RecordSet = stmt.SQLSelect
		  if db.Error then
		    raise new BKS_ActiveRecord.DatabaseException(db)
		  end if

		  return rs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateRecord(oRecord as BKS_ActiveRecord.Base, byref dictSavedPropertyValue as Dictionary)
		  dim oTableInfo as BKS_ActiveRecord.P.TableInfo
		  
		  dim dictFieldValue as Dictionary
		  
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  dim arsField() as string
		  dim aroField() as BKS_ActiveRecord.P.FieldInfo
		  dim oPrimaryKeyField as BKS_ActiveRecord.P.FieldInfo
		  
		  for each oField as BKS_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		    if oField.bPrimaryKey then
		      oPrimaryKeyField = oField
		      continue
		    end if
		    arsField.Append(oField.sFieldName + "=$" + str(arsField.ubound + 2) )
		    aroField.Append(oField)
		  next
		  
		  dim sql as string
		  sql = "UPDATE " + oTableInfo.sTableName + " SET "
		  sql = sql + Join(arsField, ",")
		  sql = sql + " WHERE " + oTableInfo.sPrimaryKey + "=$" + str(arsField.ubound + 2)
		  
		  dim stmt as PreparedSQLStatement
		  stmt = db.Prepare(sql)
		  
		  aroField.Append(oPrimaryKeyField)
		  dictFieldValue = BindValues(stmt, oRecord, aroField)
		  
		  stmt.SQLExecute
		  if db.Error then
		    raise new BKS_ActiveRecord.DatabaseException(db)
		  end if
		  
		  'store the newly saved property values
		  dictSavedPropertyValue = dictFieldValue
		End Sub
	#tag EndMethod


	#tag Note, Name = Note
		If you are not connecting to PostgreSQL and do not have the PostgreSQLPlugin plugin delete this class (PostgreSQLDatabaseAdapter)
	#tag EndNote


	#tag Property, Flags = &h21
		Private m_db As Database
	#tag EndProperty


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
End Class
#tag EndClass
