#tag Class
Protected Class FieldInfo
	#tag Method, Flags = &h0
		Sub Constructor(sField as string, pi as Introspection.PropertyInfo, oTypeInfo as Introspection.TypeInfo)
		  self.sFieldName = sField
		  self.piFieldProperty = pi
		  self.moTypeInfo = oTypeInfo.BaseType
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsKey() As Boolean
		  return (bForeignKey or bPrimaryKey)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetDBType()
		  //First Get the Database Type
		  dim ctx as TP_ActiveRecord.P.Context = GetContext
		  dim adp as TP_ActiveRecord.DatabaseAdapter = ctx.ConnectionAdapter_Get(moTypeInfo)
		  
		  dim db as database = adp.Db
		  
		  select case db
		  case nil
		    'empty. This just let's it compile if someone turns off all the constants
		    #if TP_ActiveRecord.kConfigUseSQLiteDatabase and RBVersion>=2013
		  case isa SQLiteDatabase
		    select case enFieldType
		    case DBType.DInteger
		      iDBType = SQLitePreparedStatement.SQLITE_INTEGER
		    case DBType.DSmallInt
		      iDBType = SQLitePreparedStatement.SQLITE_INTEGER
		    case DBType.DDouble
		      iDBType = SQLitePreparedStatement.SQLITE_DOUBLE
		    case DBType.DDate
		      iDBType = SQLitePreparedStatement.SQLITE_TEXT
		    case DBType.DTime
		      iDBType = SQLitePreparedStatement.SQLITE_TEXT
		    case DBType.DTimestamp
		      iDBType = SQLitePreparedStatement.SQLITE_TEXT
		    case DBType.DBoolean
		      iDBType = SQLitePreparedStatement.SQLITE_BOOLEAN
		    case DBType.DBlob
		      iDBType = SQLitePreparedStatement.SQLITE_BLOB
		    case DBType.DText
		      iDBType = SQLitePreparedStatement.SQLITE_TEXT
		    case DBType.DInt64
		      iDBType = SQLitePreparedStatement.SQLITE_INT64
		    case DBType.DFloat
		      iDBType = SQLitePreparedStatement.SQLITE_DOUBLE
		    case dbType.dCurrency
		      iDBType = SQLitePreparedStatement.SQLITE_INT64
		    case else
		      break 'unsupported type
		    end select
		    #endif
		    
		    #if TP_ActiveRecord.kConfigUseMySQLCommunityServer
		  case isa MySQLCommunityServer
		    select case enFieldType
		    case DBType.DInteger
		      iDBType = MySQLPreparedStatement.MYSQL_TYPE_LONG
		    case DBType.DSmallInt
		      iDBType = MySQLPreparedStatement.MYSQL_TYPE_SHORT
		    case DBType.DDouble
		      iDBType = MySQLPreparedStatement.MYSQL_TYPE_DOUBLE
		    case DBType.DDate
		      iDBType = MySQLPreparedStatement.MYSQL_TYPE_DATE
		    case DBType.DTime
		      iDBType = MySQLPreparedStatement.MYSQL_TYPE_TIME
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
		    case dbType.dCurrency
		      iDBType = MySQLPreparedStatement.MYSQL_TYPE_DOUBLE
		    case else
		      break 'unsupported type
		    end select
		    #endif
		    
		    // Postgres doesn't use bind types.
		    
		    #if TP_ActiveRecord.kConfigUseMSSQLServer
		  case isa MSSQLServerDatabase
		    select case enFieldType
		    case DBType.DInteger
		      iDBType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_BIGINT
		    case DBType.DSmallInt
		      iDBType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_SMALLINT
		    case DBType.DDouble
		      iDBType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_DOUBLE
		    case DBType.DDate
		      iDBType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_DATE
		    case DBType.DTime
		      iDBType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_TIME
		    case DBType.DTimestamp
		      iDBType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_TIMESTAMP
		    case DBType.DBoolean
		      iDBType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_TINYINT
		    case DBType.DBlob
		      iDBType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_BINARY
		    case DBType.DText
		      iDBType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_STRING
		    case DBType.DInt64
		      iDBType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_BIGINT
		    case DBType.DFloat
		      iDBType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_FLOAT
		    case dbType.dCurrency
		      iDBType = MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_BIGINT
		    case else
		      break 'unsupported type
		    end select
		    #endif
		    
		    #if TP_ActiveRecord.kConfigUseMSSQLServerMBS then
		  case isa SQLDatabaseMBS
		    select case enFieldType
		    case DBType.DInteger
		      iDBType = SQLPreparedStatementMBS.kTypeUInt64
		    case DBType.DSmallInt
		      iDBType = SQLPreparedStatementMBS.kTypeUShort
		    case DBType.DDouble
		      iDBType = SQLPreparedStatementMBS.kTypeDouble
		    case DBType.DDate
		      iDBType = SQLPreparedStatementMBS.kTypeDateTime
		    case DBType.DTime
		      iDBType = SQLPreparedStatementMBS.kTypeDateTime
		    case DBType.DTimestamp
		      iDBType = SQLPreparedStatementMBS.kTypeUInt64
		    case DBType.DBoolean
		      iDBType = SQLPreparedStatementMBS.kTypeBool
		    case DBType.DBlob
		      iDBType = SQLPreparedStatementMBS.kTypeBlob
		    case DBType.DText
		      iDBType = SQLPreparedStatementMBS.kTypeString
		    case DBType.DInt64
		      iDBType = SQLPreparedStatementMBS.kTypeUInt64
		    case DBType.DFloat
		      iDBType = SQLPreparedStatementMBS.kTypeDouble
		    case dbType.dCurrency
		      iDBType = SQLPreparedStatementMBS.kTypeUInt64
		    case else
		      break 'unsupported type
		    end select
		    #endif
		    
		    #if TP_ActiveRecord.kConfigUseODBC
		  case isa ODBCDatabase
		    select case enFieldType
		    case DBType.DInteger
		      iDBType = ODBCPreparedStatement.ODBC_TYPE_INTEGER
		    case DBType.DSmallInt
		      iDBType = ODBCPreparedStatement.ODBC_TYPE_INTEGER
		    case DBType.DDouble
		      iDBType = ODBCPreparedStatement.ODBC_TYPE_DOUBLE
		    case DBType.DDate
		      iDBType = ODBCPreparedStatement.ODBC_TYPE_TIMESTAMP //Why Timestamp?  Testing shows that's the only thing works
		    case DBType.DTime
		      iDBType = ODBCPreparedStatement.ODBC_TYPE_STRING
		    case DBType.DTimestamp
		      iDBType = ODBCPreparedStatement.ODBC_TYPE_TIMESTAMP
		    case DBType.DBoolean
		      iDBType = ODBCPreparedStatement.ODBC_TYPE_TINYINT
		    case DBType.DBlob
		      iDBType = ODBCPreparedStatement.ODBC_TYPE_BINARY
		    case DBType.DText
		      iDBType = ODBCPreparedStatement.ODBC_TYPE_STRING
		    case DBType.DInt64
		      iDBType = ODBCPreparedStatement.ODBC_TYPE_BIGINT
		    case DBType.DFloat
		      iDBType = ODBCPreparedStatement.ODBC_TYPE_FLOAT
		    case dbType.dCurrency
		      iDBType = ODBCPreparedStatement.ODBC_TYPE_BIGINT
		    case else
		      break 'unsupported type
		    end select
		    #endif
		    
		    #if TP_ActiveRecord.kConfigUseVSQLiteDatabase
		  case isa VSQLiteDatabase
		    select case enFieldType
		    case DBType.DInteger
		      iDBType = SQLitePreparedStatement.SQLITE_INTEGER
		    case DBType.DSmallInt
		      iDBType = SQLitePreparedStatement.SQLITE_INTEGER
		    case DBType.DDouble
		      iDBType = SQLitePreparedStatement.SQLITE_DOUBLE
		    case DBType.DDate
		      iDBType = SQLitePreparedStatement.SQLITE_TEXT
		    case DBType.DTime
		      iDBType = SQLitePreparedStatement.SQLITE_TEXT
		    case DBType.DTimestamp
		      iDBType = SQLitePreparedStatement.SQLITE_TEXT
		    case DBType.DBoolean
		      iDBType = SQLitePreparedStatement.SQLITE_BOOLEAN
		    case DBType.DBlob
		      iDBType = SQLitePreparedStatement.SQLITE_BLOB
		    case DBType.DText
		      iDBType = SQLitePreparedStatement.SQLITE_TEXT
		    case DBType.DInt64
		      iDBType = SQLitePreparedStatement.SQLITE_INT64
		    case DBType.DFloat
		      iDBType = SQLitePreparedStatement.SQLITE_DOUBLE
		    case else
		      break 'unsupported type
		    end select
		    #endif
		    
		  end select
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		bForeignKey As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		bPrimaryKey As boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return menFieldType
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  menFieldType = value
			  
			  SetDBType
			End Set
		#tag EndSetter
		enFieldType As TP_ActiveRecord.DBType
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		iDBType As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private menFieldType As TP_ActiveRecord.DBType
	#tag EndProperty

	#tag Property, Flags = &h21
		Private moTypeInfo As Introspection.TypeInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		piFieldProperty As Introspection.PropertyInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		sFieldName As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="bForeignKey"
			Group="Behavior"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="bPrimaryKey"
			Group="Behavior"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="enFieldType"
			Group="Behavior"
			Type="TP_ActiveRecord.DBType"
			EditorType="Enum"
			#tag EnumValues
				"0 - DInteger"
				"1 - DSmallInt"
				"2 - DDouble"
				"3 - DDate"
				"4 - DTime"
				"5 - DTimestamp"
				"6 - DBoolean"
				"7 - DBlob"
				"8 - DText"
				"9 - DInt64"
				"10 - DFloat"
				"11 - DCurrency"
				"12 - DNotUsed"
				"13 - DDecimal"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="iDBType"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
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
			Name="sFieldName"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
