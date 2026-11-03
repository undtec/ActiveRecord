#tag MobileScreen
Begin MobileScreen PersonScreen
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
   Title           =   "Person"
   Top             =   0
   _mTabBarVisible =   False
   _shownAsPopover =   False
   Begin MobileToolbarButton SaveButton
      Caption         =   "Save"
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
   Begin MobileToolbarButton DeleteButton
      Caption         =   "Delete"
      Enabled         =   True
      Height          =   22
      Icon            =   0
      Left            =   8
      LockedInPosition=   False
      Scope           =   2
      Top             =   32
      Type            =   1001
      Width           =   88.0
   End
   Begin MobileLabel lblFirstName
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   lblFirstName, 8, , 0, False, +1.00, 4, 1, 34, , True
      AutoLayout      =   lblFirstName, 1, <Parent>, 1, False, +1.00, 4, 1, *kStdGapCtlToViewH, , True
      AutoLayout      =   lblFirstName, 3, TopLayoutGuide, 4, False, +1.00, 4, 1, 20, , True
      AutoLayout      =   lblFirstName, 7, , 0, False, +1.00, 4, 1, 125, , True
      Alignment       =   2
      ControlCount    =   0
      Enabled         =   True
      Height          =   34
      Left            =   20
      LineBreakMode   =   0
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   "First name"
      TextColor       =   &c000000
      TextFont        =   ""
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   85
      Visible         =   True
      Width           =   125
      _ClosingFired   =   False
   End
   Begin MobileTextField tfFirstName
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   tfFirstName, 8, , 0, False, +1.00, 4, 1, 34, , True
      AutoLayout      =   tfFirstName, 1, lblFirstName, 2, False, +1.00, 4, 1, *kStdControlGapH, , True
      AutoLayout      =   tfFirstName, 10, lblFirstName, 10, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   tfFirstName, 2, <Parent>, 2, False, +1.00, 4, 1, -*kStdGapCtlToViewH, , True
      Alignment       =   0
      AllowAutoCorrection=   False
      AllowSpellChecking=   False
      AutoCapitalizationType=   0
      BorderStyle     =   3
      ControlCount    =   0
      Enabled         =   True
      Height          =   34
      Hint            =   ""
      InputType       =   0
      Left            =   153
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Password        =   False
      ReadOnly        =   False
      ReturnCaption   =   0
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   ""
      TextColor       =   &c000000
      TextFont        =   ""
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   85
      Visible         =   True
      Width           =   202
      _ClosingFired   =   False
   End
   Begin MobileLabel lblLastName
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   lblLastName, 8, , 0, False, +1.00, 4, 1, 34, , True
      AutoLayout      =   lblLastName, 1, <Parent>, 1, False, +1.00, 4, 1, *kStdGapCtlToViewH, , True
      AutoLayout      =   lblLastName, 3, lblFirstName, 4, False, +1.00, 4, 1, *kStdControlGapV, , True
      AutoLayout      =   lblLastName, 7, , 0, False, +1.00, 4, 1, 125, , True
      Alignment       =   2
      ControlCount    =   0
      Enabled         =   True
      Height          =   34
      Left            =   20
      LineBreakMode   =   0
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   "Last name"
      TextColor       =   &c000000
      TextFont        =   ""
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   127
      Visible         =   True
      Width           =   125
      _ClosingFired   =   False
   End
   Begin MobileTextField tfLastName
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   tfLastName, 8, , 0, False, +1.00, 4, 1, 34, , True
      AutoLayout      =   tfLastName, 1, lblLastName, 2, False, +1.00, 4, 1, *kStdControlGapH, , True
      AutoLayout      =   tfLastName, 10, lblLastName, 10, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   tfLastName, 2, <Parent>, 2, False, +1.00, 4, 1, -*kStdGapCtlToViewH, , True
      Alignment       =   0
      AllowAutoCorrection=   False
      AllowSpellChecking=   False
      AutoCapitalizationType=   0
      BorderStyle     =   3
      ControlCount    =   0
      Enabled         =   True
      Height          =   34
      Hint            =   ""
      InputType       =   0
      Left            =   153
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Password        =   False
      ReadOnly        =   False
      ReturnCaption   =   0
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   ""
      TextColor       =   &c000000
      TextFont        =   ""
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   127
      Visible         =   True
      Width           =   202
      _ClosingFired   =   False
   End
   Begin MobileLabel lblDateOfBirth
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   lblDateOfBirth, 8, , 0, False, +1.00, 4, 1, 34, , True
      AutoLayout      =   lblDateOfBirth, 1, <Parent>, 1, False, +1.00, 4, 1, *kStdGapCtlToViewH, , True
      AutoLayout      =   lblDateOfBirth, 3, lblLastName, 4, False, +1.00, 4, 1, *kStdControlGapV, , True
      AutoLayout      =   lblDateOfBirth, 7, , 0, False, +1.00, 4, 1, 125, , True
      Alignment       =   2
      ControlCount    =   0
      Enabled         =   True
      Height          =   34
      Left            =   20
      LineBreakMode   =   0
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   "Date of birth"
      TextColor       =   &c000000
      TextFont        =   ""
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   169
      Visible         =   True
      Width           =   125
      _ClosingFired   =   False
   End
   Begin MobileTextField tfDateOfBirth
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   tfDateOfBirth, 8, , 0, False, +1.00, 4, 1, 34, , True
      AutoLayout      =   tfDateOfBirth, 1, lblDateOfBirth, 2, False, +1.00, 4, 1, *kStdControlGapH, , True
      AutoLayout      =   tfDateOfBirth, 10, lblDateOfBirth, 10, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   tfDateOfBirth, 2, <Parent>, 2, False, +1.00, 4, 1, -*kStdGapCtlToViewH, , True
      Alignment       =   0
      AllowAutoCorrection=   False
      AllowSpellChecking=   False
      AutoCapitalizationType=   0
      BorderStyle     =   3
      ControlCount    =   0
      Enabled         =   True
      Height          =   34
      Hint            =   "YYYY-MM-DD"
      InputType       =   0
      Left            =   153
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Password        =   False
      ReadOnly        =   False
      ReturnCaption   =   0
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   ""
      TextColor       =   &c000000
      TextFont        =   ""
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   169
      Visible         =   True
      Width           =   202
      _ClosingFired   =   False
   End
   Begin MobileLabel lblWeight
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   lblWeight, 8, , 0, False, +1.00, 4, 1, 34, , True
      AutoLayout      =   lblWeight, 1, <Parent>, 1, False, +1.00, 4, 1, *kStdGapCtlToViewH, , True
      AutoLayout      =   lblWeight, 3, lblDateOfBirth, 4, False, +1.00, 4, 1, *kStdControlGapV, , True
      AutoLayout      =   lblWeight, 7, , 0, False, +1.00, 4, 1, 125, , True
      Alignment       =   2
      ControlCount    =   0
      Enabled         =   True
      Height          =   34
      Left            =   20
      LineBreakMode   =   0
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   "Weight (kg)"
      TextColor       =   &c000000
      TextFont        =   ""
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   211
      Visible         =   True
      Width           =   125
      _ClosingFired   =   False
   End
   Begin MobileTextField tfWeight
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      AutoLayout      =   tfWeight, 8, , 0, False, +1.00, 4, 1, 34, , True
      AutoLayout      =   tfWeight, 1, lblWeight, 2, False, +1.00, 4, 1, *kStdControlGapH, , True
      AutoLayout      =   tfWeight, 10, lblWeight, 10, False, +1.00, 4, 1, 0, , True
      AutoLayout      =   tfWeight, 2, <Parent>, 2, False, +1.00, 4, 1, -*kStdGapCtlToViewH, , True
      Alignment       =   0
      AllowAutoCorrection=   False
      AllowSpellChecking=   False
      AutoCapitalizationType=   0
      BorderStyle     =   3
      ControlCount    =   0
      Enabled         =   True
      Height          =   34
      Hint            =   "Blank for none"
      InputType       =   0
      Left            =   153
      LockedInPosition=   False
      MaximumCharactersAllowed=   0
      Password        =   False
      ReadOnly        =   False
      ReturnCaption   =   0
      Scope           =   2
      SelectedText    =   ""
      SelectionLength =   0
      SelectionStart  =   0
      Text            =   ""
      TextColor       =   &c000000
      TextFont        =   ""
      TextSize        =   0
      TintColor       =   &c000000
      Top             =   211
      Visible         =   True
      Width           =   202
      _ClosingFired   =   False
   End
End
#tag EndMobileScreen

#tag WindowCode
	#tag Event
		Sub Opening()
		  If Person Is Nil Then
		    Person = New DataFile.Person
		  End If

		  tfFirstName.Text = Person.FirstName
		  tfLastName.Text = Person.LastName

		  If Person.DateOfBirth Is Nil Then
		    tfDateOfBirth.Text = ""
		  Else
		    tfDateOfBirth.Text = Person.DateOfBirth.SQLDate
		  End If

		  Var dSentinel As Double = TP_ActiveRecord.kDoubleNullSentinal
		  If Person.Weight = dSentinel Then
		    tfWeight.Text = ""
		  Else
		    tfWeight.Text = Person.Weight.ToString
		  End If

		  DeleteButton.Enabled = Not Person.IsNew
		End Sub
	#tag EndEvent

	#tag Event
		Sub ToolbarButtonPressed(button As MobileToolbarButton)
		  Select Case button
		  Case SaveButton
		    SavePerson
		  Case DeleteButton
		    DeletePerson
		  End Select
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub DeletePerson()
		  If Person.IsNew Then
		    Return
		  End If

		  Try
		    Person.Delete
		  Catch e As DatabaseException
		    MessageBox(e.Message)
		    Return
		  End Try

		  Self.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ReadFields() As Boolean
		  // Copy the fields into Person. Returns False if a value is invalid.
		  Var dtBirth As DateTime
		  Var sDate As String = tfDateOfBirth.Text.Trim
		  If sDate <> "" Then
		    Try
		      dtBirth = DateTime.FromString(sDate)
		    Catch e As RuntimeException
		      MessageBox("Date of birth must be in the form YYYY-MM-DD")
		      Return False
		    End Try
		  End If

		  Var dWeight As Double = TP_ActiveRecord.kDoubleNullSentinal
		  Var sWeight As String = tfWeight.Text.Trim
		  If sWeight <> "" Then
		    dWeight = sWeight.ToDouble
		  End If

		  Person.FirstName = tfFirstName.Text.Trim
		  Person.LastName = tfLastName.Text.Trim
		  Person.DateOfBirth = dtBirth
		  Person.Weight = dWeight
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SavePerson()
		  If Not ReadFields Then
		    Return
		  End If

		  Try
		    Person.Save
		  Catch e As DatabaseException
		    MessageBox(e.Message)
		    Return
		  End Try

		  Self.Close
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Person As DataFile.Person
	#tag EndProperty


#tag EndWindowCode
