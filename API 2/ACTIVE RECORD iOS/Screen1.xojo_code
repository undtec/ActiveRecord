#tag MobileScreen
Begin MobileScreen Screen1
   BackButtonCaption=   ""
   BackgroundColor =   
   Compatibility   =   ""
   ControlCount    =   0
   Device = 7
   HasNavigationBar=   True
   LargeTitleDisplayMode=   2
   Left            =   0
   MinimizeTabBar  =   False
   NavigationBarColor=   
   NavigationBarTextColor=   
   Orientation = 0
   ScaleFactor     =   0.0
   TabBarVisible   =   True
   TabIcon         =   0
   TintColor       =   
   Title           =   "People"
   Top             =   0
   _mTabBarVisible =   False
   _shownAsPopover =   False
   Begin iOSMobileTable TablePeople
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   TablePeople, 4, <Parent>, 4, False, +1.00, 4, 1, -*kStdGapCtlToViewV, , True
      AutoLayout      =   TablePeople, 1, <Parent>, 1, False, +1.00, 4, 1, *kStdGapCtlToViewH, , True
      AutoLayout      =   TablePeople, 3, TopLayoutGuide, 3, False, +1.00, 4, 1, *kStdControlGapV, , True
      AutoLayout      =   TablePeople, 2, <Parent>, 2, False, +1.00, 4, 1, -*kStdGapCtlToViewH, , True
      AllowRefresh    =   False
      AllowSearch     =   False
      ControlCount    =   0
      EditingEnabled  =   False
      EditingEnabled  =   False
      Enabled         =   True
      EstimatedRowHeight=   -1
      Format          =   0
      Height          =   719
      Left            =   20
      LockedInPosition=   False
      Scope           =   2
      SectionCount    =   0
      TintColor       =   &c000000
      Top             =   73
      Visible         =   True
      Width           =   320
      _ClosingFired   =   False
      _OpeningCompleted=   False
   End
   Begin MobileToolbarButton AddButton
      Caption         =   "Add"
      Enabled         =   True
      Height          =   22
      Icon            =   0
      Left            =   310
      LockedInPosition=   False
      Scope           =   2
      Top             =   32
      Type            =   1001
      Width           =   88.0
   End
End
#tag EndMobileScreen

#tag WindowCode
	#tag Event
		Sub Activated()
		  // Reload every time the screen appears, including on return from PersonScreen
		  LoadPeople
		End Sub
	#tag EndEvent

	#tag Event
		Sub ToolbarButtonPressed(button As MobileToolbarButton)
		  Select Case button
		  Case AddButton
		    Var oNew As New DataFile.Person
		    ShowPerson(oNew)
		  End Select
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub LoadPeople()
		  While TablePeople.SectionCount > 0
		    TablePeople.RemoveSectionAt(0)
		  Wend
		  TablePeople.AddSection("")

		  Try
		    Var aroPeople() As DataFile.Person = DataFile.Person.List
		    For Each oPerson As DataFile.Person In aroPeople
		      Var sName As String = oPerson.FullName
		      Var sDetail As String
		      If oPerson.DateOfBirth <> Nil Then
		        sDetail = oPerson.DateOfBirth.SQLDate
		      End If

		      Var oCell As MobileTableCellData = TablePeople.CreateCell(sName, sDetail)
		      oCell.Tag = oPerson
		      TablePeople.AddRow(0, oCell)
		    Next
		  Catch e As DatabaseException
		    MessageBox(e.Message)
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ShowPerson(oPerson As DataFile.Person)
		  Var oScreen As New PersonScreen
		  oScreen.Person = oPerson
		  oScreen.Show(Self)
		End Sub
	#tag EndMethod


#tag EndWindowCode

#tag Events TablePeople
	#tag Event
		Sub SelectionChanged(section As Integer, row As Integer)
		  Var oCell As MobileTableCellData = Me.RowCellData(section, row)
		  Var oPerson As DataFile.Person = oCell.Tag
		  ShowPerson(oPerson)
		End Sub
	#tag EndEvent
#tag EndEvents
