#tag Class
Protected Class View
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

	#tag Method, Flags = &h1
		Protected Function GetDatabaseAdapter() As SQLiteDatabaseAdapter
		  return SQLIteDatabaseAdapter(GetContext.ConnectionAdapter_Get(Introspection.GetType(self)))
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
		Function ID() As integer
		  //PROGRAMMER NOTE!
		  //You are here because you've tried to use the ID of a VIEW
		  //There is no ID in a view in ActiveRecord (or at least one that you can do anything with).
		  //Check your stack and see where you came from.
		  break
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReadRecord(rs as iOSSQLiteRecordSet)
		  'Read current record out of rs into properties
		  dim oTableInfo as TP_ActiveRecord.P.TableInfo
		  
		  oTableInfo = GetTableInfo( Introspection.GetType(self) )
		  
		  ReadRecord( rs, oTableInfo )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ReadRecord(rs as iOSSQLiteRecordSet, oTableInfo as TP_ActiveRecord.P.TableInfo)
		  'Read current record out of rs into properties
		  Dim dictFieldValue As New Dictionary
		  
		  For Each oFieldInfo As TP_ActiveRecord.P.FieldInfo In oTableInfo.aroField
		    Dim oField As iOSSQLiteDatabaseField = rs.Field( oFieldInfo.sFieldName )
		    
		    Dim pi As Introspection.PropertyInfo = oFieldInfo.piFieldProperty
		    
		    If oField Is Nil Then
		      TP_ActiveRecord.Assert( False, _
		      "A field needed to populate this record wasn't provided: " + _
		      oFieldInfo.sFieldName )
		      Continue
		    End If
		    
		    Dim vProperty As Auto
		    
		    If pi.PropertyType.Name = "Double" Then
		      If oField.Value=Nil Then
		        vProperty = TP_ActiveRecord.kDoubleNullSentinal
		      Else
		        vProperty = oField.Value
		      End If
		      
		    Elseif pi.PropertyType.Name = "String" Then
		      Dim s As Text = oField.TextValue
		      
		      vProperty = s
		      
		    Elseif pi.PropertyType.IsPrimitive Then
		      vProperty = oField.Value
		      
		    Elseif pi.PropertyType = Xojo.Introspection.GetType( xojo.Core.Date.Now) Then // GetTypeInfo(Date) then
		      
		      vProperty= oField.Value
		      
		    Else
		      vProperty= oField.DateValue
		    End If
		    
		    pi.Value(Self) = vProperty
		    dictFieldValue.Value(pi.Name) = vProperty
		    
		  Next
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
