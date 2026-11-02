#tag Window
Begin Window winPersonContact
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   False
   Height          =   397
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   1408456886
   MenuBarVisible  =   True
   MinHeight       =   397
   MinimizeButton  =   True
   MinWidth        =   525
   Placement       =   0
   Resizeable      =   True
   Title           =   "People"
   Visible         =   True
   Width           =   525
   Begin Listbox lbPerson
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      Bold            =   False
      Border          =   True
      ColumnCount     =   1
      ColumnsResizable=   False
      ColumnWidths    =   ""
      DefaultRowHeight=   -1
      DropIndicatorVisible=   False
      Enabled         =   True
      EnableDrag      =   False
      EnableDragReorder=   False
      GridLinesHorizontal=   0
      GridLinesVertical=   0
      HasHeading      =   True
      HeadingIndex    =   -1
      Height          =   258
      HelpTag         =   ""
      Hierarchical    =   False
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "Person"
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      RequiresSelection=   False
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollBarVertical=   True
      SelectionType   =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   91
      Transparent     =   True
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   231
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin Listbox lbContact
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      Bold            =   False
      Border          =   True
      ColumnCount     =   1
      ColumnsResizable=   False
      ColumnWidths    =   ""
      DefaultRowHeight=   -1
      DropIndicatorVisible=   False
      Enabled         =   False
      EnableDrag      =   False
      EnableDragReorder=   False
      GridLinesHorizontal=   0
      GridLinesVertical=   0
      HasHeading      =   True
      HeadingIndex    =   -1
      Height          =   190
      HelpTag         =   ""
      Hierarchical    =   False
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "Email Address"
      Italic          =   False
      Left            =   263
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   False
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollBarVertical=   True
      SelectionType   =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   159
      Transparent     =   True
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   242
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin Label StaticText1
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   263
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "First Name"
      TextAlign       =   2
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   59
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   91
   End
   Begin Label StaticText2
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   263
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Last Name"
      TextAlign       =   2
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   91
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   91
   End
   Begin TextField efFirstName
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   ""
      Enabled         =   False
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   366
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   59
      Transparent     =   True
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   139
   End
   Begin TextField efLastName
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   ""
      Enabled         =   False
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   366
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   91
      Transparent     =   True
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   139
   End
   Begin BevelButton bbPersonAdd
      AcceptFocus     =   False
      AutoDeactivate  =   True
      BackColor       =   &c00000000
      Bevel           =   0
      Bold            =   True
      ButtonType      =   0
      Caption         =   "+"
      CaptionAlign    =   3
      CaptionDelta    =   0
      CaptionPlacement=   1
      Enabled         =   True
      HasBackColor    =   False
      HasMenu         =   0
      Height          =   22
      HelpTag         =   ""
      Icon            =   0
      IconAlign       =   0
      IconDX          =   0
      IconDY          =   0
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   361
      Transparent     =   True
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   25
   End
   Begin BevelButton bbPersonDelete
      AcceptFocus     =   False
      AutoDeactivate  =   True
      BackColor       =   &c00000000
      Bevel           =   0
      Bold            =   True
      ButtonType      =   0
      Caption         =   "-"
      CaptionAlign    =   3
      CaptionDelta    =   0
      CaptionPlacement=   1
      Enabled         =   False
      HasBackColor    =   False
      HasMenu         =   0
      Height          =   22
      HelpTag         =   ""
      Icon            =   0
      IconAlign       =   0
      IconDX          =   0
      IconDY          =   0
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   57
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   361
      Transparent     =   True
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   25
   End
   Begin BevelButton bbEmailAdd
      AcceptFocus     =   False
      AutoDeactivate  =   True
      BackColor       =   &c00000000
      Bevel           =   0
      Bold            =   True
      ButtonType      =   0
      Caption         =   "+"
      CaptionAlign    =   3
      CaptionDelta    =   0
      CaptionPlacement=   1
      Enabled         =   False
      HasBackColor    =   False
      HasMenu         =   0
      Height          =   22
      HelpTag         =   ""
      Icon            =   0
      IconAlign       =   0
      IconDX          =   0
      IconDY          =   0
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   263
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   361
      Transparent     =   True
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   25
   End
   Begin BevelButton bbEmailDelete
      AcceptFocus     =   False
      AutoDeactivate  =   True
      BackColor       =   &c00000000
      Bevel           =   0
      Bold            =   True
      ButtonType      =   0
      Caption         =   "-"
      CaptionAlign    =   3
      CaptionDelta    =   0
      CaptionPlacement=   1
      Enabled         =   False
      HasBackColor    =   False
      HasMenu         =   0
      Height          =   22
      HelpTag         =   ""
      Icon            =   0
      IconAlign       =   0
      IconDX          =   0
      IconDY          =   0
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   294
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   10
      TabPanelIndex   =   0
      TabStop         =   True
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   361
      Transparent     =   True
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   25
   End
   Begin Label StaticText3
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   263
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   11
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Date of Birth"
      TextAlign       =   2
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   125
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   91
   End
   Begin TextField efDateOfBirth
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   ""
      Enabled         =   False
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   366
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   125
      Transparent     =   True
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   139
   End
   Begin PushButton pbClone
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   False
      Caption         =   "Clone"
      Default         =   False
      Enabled         =   False
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   171
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   13
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   361
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin PushButton btnFind
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   False
      Caption         =   "Find By ID"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   14
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   60
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin TextField txtFind
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   133
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   15
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   58
      Transparent     =   True
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   58
   End
   Begin PushButton btnShowBkeeney
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   False
      Caption         =   "More Examples"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   308
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   16
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   17
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   135
   End
   Begin Label Label1
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   41
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   True
      Scope           =   0
      Selectable      =   False
      TabIndex        =   17
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Want more examples?  Try out our Xojo Training videos that use ActiveRecord"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   7
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   286
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Function CancelClose(appQuitting as Boolean) As Boolean
		  #pragma unused appQuitting
		  
		  self.SetFocus
		End Function
	#tag EndEvent

	#tag Event
		Sub Open()
		  DisplayList
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Display(oPerson as Data.Person)
		  efFirstName.Enabled = ( oPerson <> nil )
		  efLastName.Enabled = ( oPerson <> nil )
		  efDateOfBirth.Enabled = (oPerson <> nil )
		  lbContact.Enabled = (oPerson <> nil )
		  
		  if oPerson = nil then
		    
		    efFirstName.Text = ""
		    efLastName.Text = ""
		    efDateOfBirth.Text = ""
		    lbContact.DeleteAllRows
		    
		  else
		    
		    efFirstName.Text = oPerson.FirstName
		    efLastName.Text = oPerson.LastName
		    if oPerson.DateOfBirth=nil then
		      efDateOfBirth.Text = ""
		    else
		      efDateOfBirth.Text = oPerson.DateOfBirth.ShortDate
		    end if
		    
		    lbContact.DeleteAllRows
		    
		    for each oContact as Data.Contact in oPerson.Contacts
		      
		      lbContact.AddRow( oContact.EmailAddress )
		      
		      lbContact.RowTag( lbContact.LastIndex ) = oContact
		      
		    next
		    
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DisplayList()
		  lbPerson.DeleteAllRows
		  
		  for each oPerson as Data.Person in Data.Person.List
		    
		    lbPerson.AddRow( oPerson.FullName )
		    
		    lbPerson.RowTag( lbPerson.LastIndex ) = oPerson
		  next
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_oPerson As Data.Person
	#tag EndProperty


#tag EndWindowCode

#tag Events lbPerson
	#tag Event
		Sub Change()
		  if me.ListIndex < 0 then
		    m_oPerson = nil
		  else
		    m_oPerson = me.RowTag( me.ListIndex )
		  end if
		  
		  Display( m_oPerson )
		  
		  bbPersonDelete.Enabled = ( m_oPerson <> nil )
		  pbClone.Enabled = ( m_oPerson <> nil )
		  bbEmailAdd.Enabled = ( m_oPerson <> nil )
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events lbContact
	#tag Event
		Sub Open()
		  me.ColumnType( 0 ) = Listbox.TypeEditable
		End Sub
	#tag EndEvent
	#tag Event
		Sub CellAction(row As Integer, column As Integer)
		  dim oContact as Data.Contact = me.RowTag( row )
		  oContact.EmailAddress = me.Cell( row, column )
		  oContact.Save
		End Sub
	#tag EndEvent
	#tag Event
		Sub Change()
		  bbEmailDelete.Enabled = ( me.ListIndex >= 0 )
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events efFirstName
	#tag Event
		Sub LostFocus()
		  if  StrComp( m_oPerson.FirstName, efFirstName.Text, 0 ) <> 0 then
		    
		    m_oPerson.FirstName = efFirstName.Text
		    m_oPerson.Save
		    
		    lbPerson.Cell( lbPerson.ListIndex, 0 ) = m_oPerson.FullName
		    
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events efLastName
	#tag Event
		Sub LostFocus()
		  if  StrComp( m_oPerson.LastName, efLastName.Text, 0 ) <> 0 then
		    
		    m_oPerson.LastName = efLastName.Text
		    if m_oPerson.IsModified then
		      m_oPerson.Save
		    end if
		    
		    lbPerson.Cell( lbPerson.ListIndex, 0 ) = m_oPerson.FullName
		    
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events bbPersonAdd
	#tag Event
		Sub Action()
		  dim oPerson as new Data.Person
		  oPerson.FirstName = "New"
		  oPerson.LastName = "Person"
		  oPerson.DateOfBirth = new Date
		  
		  lbPerson.AddRow( oPerson.FullName )
		  lbPerson.RowTag( lbPerson.LastIndex ) = oPerson
		  
		  lbPerson.ListIndex = lbPerson.LastIndex
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events bbPersonDelete
	#tag Event
		Sub Action()
		  dim oDlg as new MessageDialog
		  oDlg.Title = "Delete Person"
		  oDlg.Message = "Are you sure you want to delete the person?"
		  oDlg.CancelButton.Visible = true
		  oDlg.CancelButton.Caption = "Don't Delete"
		  oDlg.ActionButton.Visible = true
		  oDlg.ActionButton.Caption = "Delete"
		  if oDlg.ShowModalWithin( self ) is oDlg.CancelButton then
		    return
		  end if
		  
		  dim txn as BKS_ActiveRecord.Transaction = BKS_ActiveRecord.Begin
		  m_oPerson.Delete
		  txn.Commit
		  
		  lbPerson.RemoveRow( lbPerson.ListIndex )
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events bbEmailAdd
	#tag Event
		Sub Action()
		  if m_oPerson.IsNew then
		    m_oPerson.Save
		  end if
		  dim oContact as Data.Contact = m_oPerson.Contacts_Create
		  oContact.Save
		  
		  lbContact.AddRow( "" )
		  lbContact.RowTag( lbContact.LastIndex ) = oContact
		  lbContact.EditCell( lbContact.LastIndex, 0 )
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events bbEmailDelete
	#tag Event
		Sub Action()
		  if lbContact.ListIndex < 0 then
		    return
		  end if
		  
		  dim oContact as Data.Contact = lbContact.RowTag( lbContact.ListIndex )
		  m_oPerson.Contacts_Delete( oContact )
		  
		  lbContact.RemoveRow( lbContact.ListIndex )
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events efDateOfBirth
	#tag Event
		Sub LostFocus()
		  dim dt as Date
		  if not ParseDate( efDateOfBirth.Text, dt ) then
		    MsgBox( "Invalid date entry" )
		    efDateOfBirth.Text = m_oPerson.DateOfBirth.ShortDate
		  else
		    m_oPerson.DateOfBirth = dt
		    m_oPerson.Save
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events pbClone
	#tag Event
		Sub Action()
		  if m_oPerson<>nil then
		    dim oNewPerson as Data.Person = m_oPerson.Clone
		    oNewPerson.Save
		    
		    DisplayList
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnFind
	#tag Event
		Sub Action()
		  dim id as integer = txtFind.text.val
		  if id = 0 then return
		  
		  dim oPerson as Data.Person = Data.Person.FindByID(id)
		  
		  if oPerson = nil then
		    msgbox "Person Not Found"
		  else
		    for i as integer = 0 to lbPerson.ListCount-1
		      dim oListPerson as Data.Person = lbPerson.RowTag(i)
		      if oListPerson.id = oPerson.id then
		        lbPerson.ListIndex = i
		        exit
		      end
		    next
		  end
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnShowBkeeney
	#tag Event
		Sub Action()
		  showURL "http://xojo.bkeeney.com/XojoTraining/"
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="0"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="Color"
		EditorType="Color"
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
		Name="Interfaces"
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
		Name="Width"
		Visible=true
		Group="Position"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Position"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Appearance"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Appearance"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=false
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=false
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Appearance"
		InitialValue=""
		Type="MenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
