#tag Class
Protected Class DatabaseAdapter
	#tag Method, Flags = &h0
		Sub BeginTransaction()
		  break //Should be called by the Database Adapter Subclass
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BindValues(oRecord as TP_ActiveRecord.Base, aroField() as TP_ActiveRecord.P.FieldInfo, dictFieldValues as xojo.Core.Dictionary) As Auto()
		  dim aroData() as Auto
		  
		  //Iterate through the fields list.
		  for i as integer = 0 to aroField.Ubound
		    
		    //Get the field.
		    dim oField as TP_ActiveRecord.P.FieldInfo = aroField(i)
		    dim pi as Xojo.Introspection.PropertyInfo = oField.piFieldProperty
		    dim a as Auto = pi.Value(oRecord)
		    
		    dictFieldValues.value(oField.sFieldName) = a
		    
		    
		    if oField.IsKey then
		      if a.IsNull then
		        aroData.Append "null"
		      else
		        if a.IsInteger then
		          dim i32 as integer = a
		          #pragma unused i32
		          
		        end
		      end
		      
		    else
		      
		      
		      select case aroField(i).enFieldType
		      case DbType.DInteger
		        dim i32 as integer = a
		        #pragma unused i32
		        aroData.Append a
		        
		      case DbType.DSmallInt
		        dim i32 as integer = a
		        #pragma unused i32
		        aroData.Append a
		        
		      case DbType.DDouble
		        dim d as double = a
		        #pragma unused d
		        aroData.Append a
		        
		      case DbType.DDate
		        dim d as xojo.Core.Date = a
		        
		        if d <> nil then
		          dim s as text = d.ToText
		          #pragma unused s
		          aroData.Append a' s.sqlizeText
		        else
		          aroData.Append "NULL"
		        end if
		        
		      case DbType.DTime
		        dim s as Text = a
		        #pragma unused s
		        aroData.Append a's.sqlizeText
		        
		      case DbType.DTimestamp
		        dim d as xojo.Core.Date = a
		        dim s as text = d.ToText
		        #pragma unused s
		        aroData.Append a 's.sqlizeText
		        
		      case DbType.DBoolean
		        dim b as boolean = a
		        if b then
		          aroData.Append "1"
		        else
		          aroData.Append "0"
		        end
		        
		      case DbType.DBlob
		        dim s as Text = a
		        #pragma unused s
		        aroData.Append a's.sqlizeText
		        
		      case DbType.DText
		        dim s as Text = a
		        #pragma unused s
		        aroData.Append a's.sqlizeText
		        
		      case DbType.DInt64
		        dim i64 as INT64 = a
		        #pragma unused i64
		        aroData.Append a' i64.ToText
		        
		      case DbType.DFloat
		        dim d as double = a
		        #pragma unused d
		        aroData.Append a' d.ToText
		        
		      case dbType.dCurrency
		        dim c as Currency = a
		        #pragma unused c
		        aroData.Append a' c.ToText
		        
		      case else
		        break 'unsupported type
		      end select
		    end
		    
		    
		  next
		  
		  return aroData
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CommitTransaction()
		  break //Should be called by the Database Adapter Subclass
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor()
		  'Empty
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Db() As iOSSQLiteDatabase
		  TP_ActiveRecord.Assert( false, "needs to be implemented in subclass" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteRecord(oRecord as TP_ActiveRecord.Base)
		  dim sql as Text
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  sql = "DELETE FROM " + oTableInfo.sTableName + _
		  " WHERE " + oTableInfo.sPrimaryKey
		  sql = sql  + "=?1"
		  
		  if oRecord.GUID <> "" then
		    db.SQLExecute(sql, oRecord.GUID)
		  else
		    db.SQLExecute(sql, oRecord.id)
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetLastInsertID() As Int64
		  TP_ActiveRecord.Assert( false, "needs to be implemented in subclass" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasTable(sTableName as Text) As boolean
		  Dim rs As iOSSQLiteRecordSet
		  rs = Db.TableSchema
		  while not rs.EOF
		    if rs.IdxField(1).TextValue = sTableName then
		      return true
		    end if
		    rs.MoveNext
		  wend
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertRecord(oRecord as TP_ActiveRecord.Base, byref dictSavedPropertyValue as Xojo.Core.Dictionary)
		  #pragma unused dictSavedPropertyValue
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  
		  dim dictFieldValue as New Xojo.Core.Dictionary
		  
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  dim arsField() as Text
		  dim arsPlaceholder() as Text
		  dim aroField() as TP_ActiveRecord.P.FieldInfo
		  dim sPK as Text
		  dim oPKField as  TP_ActiveRecord.P.FieldInfo
		  dim iCnt as integer = 1
		  for each oField as TP_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		    if oField.bPrimaryKey then
		      sPK = oField.sFieldName
		      oPKField = oField
		      continue
		    end if
		    arsField.Append(oField.sFieldName)
		    arsPlaceholder.Append("?")
		    aroField.Append(oField)
		    iCnt = iCnt + 1
		  next
		  
		  //NOTE:  Until iOS SQLExecute can handle an array, rather than a Parameter Array we'll have to build the SQL by hand.
		  dim aroValueArray() as Auto = BindValues(oRecord, aroField, dictFieldValue) // = BindValues(oRecord, aroField)
		  
		  dim sql as Text
		  dim arsSQL() as Text
		  arsSQL.append "INSERT INTO " + oTableInfo.sTableName
		  arsSQL.append "(" + Text.Join(arsField, ",") + ")"
		  arsSQL.append " VALUES "
		  arsSQL.append "(" + Text.Join(arsPlaceholder, ",") + ")"
		  sql = Text.Join(arsSQL, " ")
		  
		  db.SQLExecuteWithArray(sql,aroValueArray)
		  
		  dim iRecordID as Int64 = GetLastInsertID
		  if oPKField.piFieldProperty.PropertyType.Name = "Text" then
		    redim arsSQL(-1)
		    arsSQL.Append "select "
		    arsSQL.Append sPK
		    arsSQL.Append "From "
		    arsSQL.Append oTableInfo.sTableName
		    arsSQL.Append "Where RowID = "
		    arsSQL.Append iRecordID.ToText
		    sql = Text.Join(arsSQL, " ")
		    dim rs as iOSSQLiteRecordSet = db.SQLSelect(sql)
		    
		    dim sRecordID as text = rs.Field(sPK).TextValue
		    dictFieldValue.Value( oTableInfo.piPrimaryKey.Name ) = sRecordID
		    oRecord.GUID = sRecordID
		  else
		    dictFieldValue.Value( oTableInfo.piPrimaryKey.Name ) = iRecordID
		    oRecord.ID = iRecordID
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RollbackTransaction()
		  break //Should be called by the Database Adapter Subclass
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectList(sTable as Text, sCondition as Text = "", sOrder as Text = "") As iOSSQLiteRecordSet
		  dim sSQL as Text = "SELECT * FROM " + sTable + " "
		  if sCondition<>"" then
		    sSQL = sSQL + "WHERE " + sCondition
		  end if
		  
		  if sOrder<>"" then
		    sSQL = sSQL + " ORDER BY " + sOrder
		  end if
		  sSQL = sSQL + ";"
		  
		  return SQLSelect(sSQL)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectRecord(oRecord as TP_ActiveRecord.Base, iRecordID as int64) As iOSSQLiteRecordSet
		  dim sql as Text
		  Dim rs As iOSSQLiteRecordSet
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  sql = "SELECT * FROM " + oTableInfo.sTableName + _
		  " WHERE " + oTableInfo.sPrimaryKey + "=?1"
		  
		  rs = db.SQLSelect(sql, iRecordID)
		  
		  
		  
		  return rs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectRecord(oRecord as TP_ActiveRecord.Base, sID as Text) As iOSSQLiteRecordSet
		  dim sql as Text
		  Dim rs As iOSSQLiteRecordSet
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  sql = "SELECT * FROM " + oTableInfo.sTableName + _
		  " WHERE " + oTableInfo.sPrimaryKey + "=?1"
		  
		  rs = db.SQLSelect(sql, sID)
		  
		  
		  
		  return rs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecute(sql as Text)
		  db.SQLExecute( sql )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLSelect(sql as Text) As iOSSQLiteRecordSet
		  Dim rs As iOSSQLiteRecordSet = db.SQLSelect( sql )
		  
		  return rs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateRecord(oRecord as TP_ActiveRecord.Base, byref dictSavedPropertyValue as Xojo.Core.Dictionary)
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  
		  dim dictFieldValue as new Xojo.Core.Dictionary
		  
		  oTableInfo = GetTableInfo( Introspection.GetType(oRecord) )
		  
		  dim arsField() as Text
		  dim aroField() as TP_ActiveRecord.P.FieldInfo
		  dim oPrimaryKeyField as TP_ActiveRecord.P.FieldInfo
		  
		  dim iCnt as integer = 1
		  for each oField as TP_ActiveRecord.P.FieldInfo in oTableInfo.aroField
		    if oField.bPrimaryKey then
		      oPrimaryKeyField = oField
		      continue
		    end if
		    arsField.Append(oField.sFieldName + "=?" + iCnt.ToText)
		    aroField.Append(oField)
		    icnt = icnt + 1
		  next
		  'icnt = icnt + 1
		  
		  'arsField.Append(oField.sFieldName + "=?" + iCnt.ToText)
		  aroField.Append(oPrimaryKeyField)
		  
		  
		  //NOTE:  Until iOS SQLExecute can handle an array, rather than a Parameter Array we'll have to build the SQL by hand.
		  dim aroValueArray() as Auto = BindValues(oRecord, aroField, dictFieldValue) // = BindValues(oRecord, aroField)
		  
		  dim sql as Text
		  sql = "UPDATE " + oTableInfo.sTableName + " SET "
		  sql = sql + Text.Join(arsField, ",")
		  
		  dim pi as Xojo.Introspection.PropertyInfo = oPrimaryKeyField.piFieldProperty
		  dim a as Auto = pi.Value(oRecord)
		  
		  if oPrimaryKeyField.piFieldProperty.PropertyType.Name = "Text" then
		    sql = sql + " WHERE " + oTableInfo.sPrimaryKey + "=" + a.ToText.SQLizeText
		  else
		    sql = sql + " WHERE " + oTableInfo.sPrimaryKey + "=" + a.ToText
		  end if
		  
		  
		  db.SQLExecuteWithArray(sql,aroValueArray)
		  
		  'store the newly saved property values
		  dictSavedPropertyValue = dictFieldValue
		End Sub
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
End Class
#tag EndClass
