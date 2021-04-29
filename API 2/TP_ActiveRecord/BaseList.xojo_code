#tag Class
Protected Class BaseList
	#tag Method, Flags = &h0
		Sub Constructor(ty as Introspection.TypeInfo, sCriteria as string = "", sOrder as string = "")
		  m_tyElement = ty
		  
		  if not ty.IsSubclassOf(GetTypeInfo(TP_ActiveRecord.Base)) then
		    Var ex as new RuntimeException
		    ex.Message = "Invalid type"
		    raise ex
		  end if
		  
		  Var adp as TP_ActiveRecord.DatabaseAdapter
		  adp = GetContext.ConnectionAdapter_Get( ty )
		  if adp=nil then
		    raise new RuntimeException
		  end if
		  
		  Var rs as RowSet
		  ' Var aro() as Variant
		  Var oTableInfo as TP_ActiveRecord.P.TableInfo = GetTableInfo( ty )
		  
		  Var sql as string = "SELECT " + oTableInfo.sPrimaryKey + _
		  " FROM " + oTableInfo.sTableName
		  if sCriteria<>"" then
		    sql = sql + " WHERE " + sCriteria
		  end if
		  
		  if sOrder<>"" then
		    sql = sql + " ORDER BY " + sOrder
		  end if
		  
		  Var arid() as Int64
		  
		  rs = adp.SQLSelect(sql)
		  
		  Var oField As DatabaseColumn = rs.ColumnAt(0)
		  do until rs.AfterLastRow
		    arid.Add(oField.Int64Value)
		    rs.MoveToNextRow
		  loop
		  
		  m_arid = arid
		  m_aro.ResizeTo(m_arid.LastIndex)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ElementType() As Introspection.TypeInfo
		  return m_tyElement
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Item(index as integer) As TP_ActiveRecord.Base
		  if m_aro(index)<>nil then
		    return m_aro(index)
		  end if
		  
		  const kBatchSize = 50
		  
		  LoadRange(index, Min(index+kBatchSize-1, m_arid.LastIndex))
		  
		  return m_aro(index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LoadRange(startIndex as integer, endIndex as integer)
		  Var sPrimaryKey as string = GetTableInfo(m_tyElement).sPrimaryKey
		  
		  Var aridix() as integer
		  Var arid() as Int64
		  
		  for i as integer = startIndex to endIndex
		    aridix.Add(i)
		    arid.Add(m_arid(i))
		  next
		  
		  arid.SortWith(aridix)
		  
		  Var arsId() as string
		  for i as integer = 0 to arid.LastIndex
		    arsId.Add(Str(arid(i)))
		  next
		  
		  Var sCriteria as string
		  sCriteria = sPrimaryKey + " IN (" + String.FromArray(arsId, ",") + ")"
		  Var arv() as Variant = TP_ActiveRecord.Query(m_tyElement, sCriteria, sPrimaryKey)
		  for i as integer = 0 to arv.LastIndex
		    Var oRecord as TP_ActiveRecord.Base = arv(i)
		    if oRecord.ID = arid(i) then
		      m_aro(aridix(i)) = oRecord
		    else
		      break
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Subscript(index as Integer) As TP_ActiveRecord.Base
		  return Item(index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Ubound() As integer
		  return m_arid.LastIndex
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_arid() As Int64
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_aro() As TP_ActiveRecord.Base
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_tyElement As Introspection.TypeInfo
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
