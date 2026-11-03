#tag Window
Begin Window winConnect
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Composite       =   False
   Frame           =   1
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   False
   Height          =   201
   ImplicitInstance=   True
   LiveResize      =   False
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   0
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   2
   Resizeable      =   False
   Title           =   "Connect to Database"
   Visible         =   True
   Width           =   515
   Begin Canvas cvServer
      AcceptFocus     =   False
      AcceptTabs      =   False
      AutoDeactivate  =   True
      Backdrop        =   0
      DoubleBuffer    =   False
      Enabled         =   True
      EraseBackground =   True
      Height          =   169
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   25
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   13
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   273
      Transparent     =   True
      UseFocusRing    =   True
      Visible         =   False
      Width           =   405
      Begin Label lblPort
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "cvServer"
         Italic          =   False
         Left            =   30
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   1
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Port:"
         TextAlign       =   2
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   312
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   114
      End
      Begin Label Label3
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "cvServer"
         Italic          =   False
         Left            =   30
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   2
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Database Name:"
         TextAlign       =   2
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   344
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   114
      End
      Begin Label Label4
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "cvServer"
         Italic          =   False
         Left            =   30
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   3
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Username:"
         TextAlign       =   2
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   378
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   114
      End
      Begin Label Label5
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "cvServer"
         Italic          =   False
         Left            =   30
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   4
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Password:"
         TextAlign       =   2
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   412
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   114
      End
      Begin TextField efHost
         AcceptTabs      =   False
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   False
         BackColor       =   &c00000000
         Bold            =   False
         Border          =   True
         CueText         =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "cvServer"
         Italic          =   False
         Left            =   156
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
         TabIndex        =   5
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "localhost"
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   278
         Transparent     =   True
         Underline       =   False
         UseFocusRing    =   True
         Visible         =   True
         Width           =   254
      End
      Begin TextField efPort
         AcceptTabs      =   False
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   False
         BackColor       =   &c00000000
         Bold            =   False
         Border          =   True
         CueText         =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "cvServer"
         Italic          =   False
         Left            =   156
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
         TabIndex        =   6
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "3306"
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   312
         Transparent     =   True
         Underline       =   False
         UseFocusRing    =   True
         Visible         =   True
         Width           =   121
      End
      Begin TextField efDatabase
         AcceptTabs      =   False
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   False
         BackColor       =   &c00000000
         Bold            =   False
         Border          =   True
         CueText         =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "cvServer"
         Italic          =   False
         Left            =   156
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
         TabIndex        =   7
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   344
         Transparent     =   True
         Underline       =   False
         UseFocusRing    =   True
         Visible         =   True
         Width           =   254
      End
      Begin TextField efUsername
         AcceptTabs      =   False
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   False
         BackColor       =   &c00000000
         Bold            =   False
         Border          =   True
         CueText         =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "cvServer"
         Italic          =   False
         Left            =   156
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
         TabIndex        =   8
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   378
         Transparent     =   True
         Underline       =   False
         UseFocusRing    =   True
         Visible         =   True
         Width           =   121
      End
      Begin TextField efPassword
         AcceptTabs      =   False
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   False
         BackColor       =   &c00000000
         Bold            =   False
         Border          =   True
         CueText         =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "cvServer"
         Italic          =   False
         Left            =   156
         LimitText       =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Mask            =   ""
         Password        =   True
         ReadOnly        =   False
         Scope           =   0
         TabIndex        =   9
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   412
         Transparent     =   True
         Underline       =   False
         UseFocusRing    =   True
         Visible         =   True
         Width           =   121
      End
      Begin Label Label1
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "cvServer"
         Italic          =   False
         Left            =   30
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   0
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Host:"
         TextAlign       =   2
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   278
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   114
      End
   End
   Begin PopupMenu pmDatabaseType
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      Italic          =   False
      Left            =   20
      ListIndex       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   13
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   252
   End
   Begin PushButton pbConnect
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   False
      Caption         =   "Connect"
      Default         =   True
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   415
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Scope           =   0
      TabIndex        =   11
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   161
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin PushButton pbCancel
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   True
      Caption         =   "Cancel"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   323
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Scope           =   0
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   161
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin Canvas cvSqlite
      AcceptFocus     =   False
      AcceptTabs      =   False
      AutoDeactivate  =   True
      Backdrop        =   0
      DoubleBuffer    =   False
      Enabled         =   True
      EraseBackground =   True
      Height          =   35
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   25
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   16
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   94
      Transparent     =   True
      UseFocusRing    =   True
      Visible         =   True
      Width           =   470
      Begin TextField efDatabaseFile
         AcceptTabs      =   False
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   False
         BackColor       =   &c00000000
         Bold            =   False
         Border          =   True
         CueText         =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "cvSqlite"
         Italic          =   False
         Left            =   156
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
         TabIndex        =   0
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "db.rsd"
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   99
         Transparent     =   True
         Underline       =   False
         UseFocusRing    =   True
         Visible         =   True
         Width           =   230
      End
      Begin Label Label6
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "cvSqlite"
         Italic          =   False
         Left            =   25
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   1
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Database File:"
         TextAlign       =   2
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   99
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   114
      End
      Begin PushButton pbBrowse
         AutoDeactivate  =   True
         Bold            =   False
         ButtonStyle     =   0
         Cancel          =   False
         Caption         =   "Browse..."
         Default         =   False
         Enabled         =   True
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "cvSqlite"
         Italic          =   False
         Left            =   394
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         TabIndex        =   2
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   99
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   101
      End
   End
   Begin Label Label7
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   62
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   289
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
      Text            =   "To enable different types of databases, set the constants in the Data module."
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   13
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   215
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  cvCurrent = cvSqlite
		  if pmDatabaseType.ListCount>0 then
		    pmDatabaseType.ListIndex = 0
		  end if
		End Sub
	#tag EndEvent


	#tag Property, Flags = &h0
		cvCurrent As Canvas
	#tag EndProperty

	#tag Property, Flags = &h0
		db As Database
	#tag EndProperty


#tag EndWindowCode

#tag Events pmDatabaseType
	#tag Event
		Sub Change()
		  dim cv as Canvas
		  select case me.text
		  case "SQLite (REALSQLDatabase)", "SQLite (SQLiteDatabase)"
		    cv = cvSqlite
		  case "MySQL"
		    cv = cvServer
		    lblPort.Visible = true
		    efPort.Visible = true
		    efPort.text = "3306"
		  case "PostgreSQL"
		    cv = cvServer
		    lblPort.Visible = true
		    efPort.Visible = true
		    efPort.text = "5432"
		  case "MSSQLServer"
		    cv = cvServer
		    lblPort.Visible = true
		    efPort.Visible = true
		    efPort.text = "8090"
		  case "Oracle"
		    cv = cvServer
		    lblPort.Visible = false
		    efPort.Visible = false
		  case "Cube Database"
		    cv = cvServer
		    lblPort.Visible = true
		    efPort.Visible = true
		    efPort.text = "4430"
		  case else
		    'unexpected type
		    break
		    return
		  end
		  
		  
		  if cv is cvCurrent then
		    return
		  end if
		  
		  self.Height = self.Height + cv.Height - cvCurrent.Height
		  cv.Top = cvCurrent.Top
		  cvCurrent.Visible = false
		  cv.Visible = true
		  cvCurrent = cv
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  #if BKS_ActiveRecordConfig.kIncludeCubeDatabase
		    me.AddRow "Cube Database"
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludeMSSQLServer
		    me.AddRow "MSSQLServer"
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludeMySQLCommunityServer
		    me.AddRow("MySQL")
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludeOracle
		    me.AddRow "Oracle"
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludePostgreSQLDatabase
		    me.AddRow("PostgreSQL")
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludeREALSQLDatabase
		    me.AddRow("SQLite (REALSQLDatabase)")
		  #endif
		  
		  #if BKS_ActiveRecordConfig.kIncludeSQLiteDatabase and RBVersion>=2013
		    me.AddRow("SQLite (SQLiteDatabase)")
		  #endif
		  
		  if me.ListCount=0 then
		    MsgBox "None of the databases are enabled. Please enable at least one database for this demo"
		    Quit
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events pbConnect
	#tag Event
		Sub Action()
		  if pmDatabaseType.Text = "SQLite (REALSQLDatabase)" then
		    #if BKS_ActiveRecordConfig.kIncludeREALSQLDatabase
		      if efDatabaseFile.Text="" or GetFolderItem(efDatabaseFile.Text)=nil then
		        MsgBox "Please enter a valid database file name"
		        efDatabaseFile.SetFocus
		        return
		      end if
		      
		      dim f as FolderItem = GetFolderItem(efDatabaseFile.Text)
		      dim db as new REALSQLDatabase
		      db.DatabaseFile = f
		      if not f.Exists then
		        if not db.CreateDatabaseFile then
		          MsgBox "Unable to create the database." + EndOfLine + _
		          db.ErrorMessage
		          return
		        end if
		      end if
		      
		      if not db.Connect then
		        MsgBox "Unable to connect to the database." + EndOfLine + _
		        db.ErrorMessage
		        return
		      end if
		      
		      self.db = db
		      Close
		    #endif
		    
		  elseif pmDatabaseType.text = "SQLite (SQLiteDatabase)" then
		    #if BKS_ActiveRecordConfig.kIncludeSQLiteDatabase and RBVersion>=2013
		      if efDatabaseFile.Text="" or GetFolderItem(efDatabaseFile.Text)=nil then
		        MsgBox "Please enter a valid database file name"
		        efDatabaseFile.SetFocus
		        return
		      end if
		      
		      dim f as FolderItem = GetFolderItem(efDatabaseFile.Text)
		      dim db as new SQLiteDatabase
		      db.DatabaseFile = f
		      if not f.Exists then
		        if not db.CreateDatabaseFile then
		          MsgBox "Unable to create the database." + EndOfLine + _
		          db.ErrorMessage
		          return
		        end if
		      end if
		      
		      if not db.Connect then
		        MsgBox "Unable to connect to the database." + EndOfLine + _
		        db.ErrorMessage
		        return
		      end if
		      
		      self.db = db
		      Close
		    #endif
		  else
		    
		    if efHost.Text="" then
		      MsgBox "Please enter a host name"
		      efHost.SetFocus
		      return
		    end if
		    
		    if pmDatabaseType.text <> "Oracle" then
		      if efPort.Text="" or not IsNumeric(efPort.Text) then
		        MsgBox "Please enter a valid numeric port"
		        efPort.SetFocus
		        return
		      end if
		    end
		    
		    if efDatabase.Text="" then
		      MsgBox "Please enter a database name"
		      efDatabase.SetFocus
		      return
		    end if
		    
		    if efUsername.Text="" then
		      MsgBox "Please enter a username"
		      efUsername.SetFocus
		      return
		    end if
		    
		    if pmDatabaseType.Text = "MySQL" then
		      #if BKS_ActiveRecordConfig.kIncludeMySQLCommunityServer
		        ' Set BKS_ActiveRecordConfig.kIncludeMySQLCommunityServer = false if you
		        ' do not need to support MySQL.
		        dim db as new MySQLCommunityServer
		        db.host=efHost.Text
		        db.port=efPort.Text.CDbl
		        db.databaseName=efDatabase.Text
		        db.userName=efUsername.Text
		        db.Password=efPassword.Text
		        if not db.Connect then
		          MsgBox "Unable to connect to the database." + EndOfLine + _
		          db.ErrorMessage
		          return
		        end if
		        
		        self.db = db
		        Close
		      #endif
		    elseif pmDatabaseType.Text = "PostgreSQL" then
		      #if BKS_ActiveRecordConfig.kIncludePostgreSQLDatabase
		        ' Set BKS_ActiveRecordConfig.kIncludePostgreSQLDatabase = false if you
		        ' do not need to support PostgreSQL.
		        dim db as new PostgreSQLDatabase
		        db.host=efHost.Text
		        db.port=efPort.Text.CDbl
		        db.databaseName=efDatabase.Text
		        db.userName=efUsername.Text
		        db.Password=efPassword.Text
		        if not db.Connect then
		          MsgBox "Unable to connect to the database." + EndOfLine + _
		          db.ErrorMessage
		          return
		        end if
		        
		        self.db = db
		        Close
		      #endif
		    elseif pmDatabaseType.Text = "MSSQLServer" then
		      #if BKS_ActiveRecordConfig.kIncludeMSSQLServer
		        ' Set BKS_ActiveRecordConfig.kIncludeMSSQLServer = false if you
		        ' do not need to support MSSQLServer.
		        dim db as new MSSQLServerDatabase
		        db.host=efHost.Text
		        db.port=efPort.Text.CDbl
		        db.databaseName=efDatabase.Text
		        db.userName=efUsername.Text
		        db.Password=efPassword.Text
		        if not db.Connect then
		          MsgBox "Unable to connect to the database." + EndOfLine + _
		          db.ErrorMessage
		          return
		        end if
		        
		        self.db = db
		        Close
		      #endif
		    elseif pmDatabaseType.text = "Oracle" then
		      #if BKS_ActiveRecordConfig.kIncludeOracle
		        ' Set BKS_ActiveRecordConfig.kIncludeOracle = false if you
		        ' do not need to support Oracle.
		        dim db as new OracleDatabase
		        db.host=efHost.Text
		        db.databaseName=efDatabase.Text
		        db.userName=efUsername.Text
		        db.Password=efPassword.Text
		        if not db.Connect then
		          MsgBox "Unable to connect to the database." + EndOfLine + _
		          db.ErrorMessage
		          return
		        end if
		        
		        self.db = db
		        Close
		      #endif
		      
		    elseif pmDatabaseType.text = "Cube Database" then
		      #if BKS_ActiveRecordConfig.kIncludeCubeDatabase
		        ' Set BKS_ActiveRecordConfig.kIncludeCubeDatabase = false if you
		        ' do not need to support CubeDatabase.
		        dim db as new CubeSQLServer
		        db.host=efHost.Text
		        db.databaseName=efDatabase.Text
		        db.userName=efUsername.Text
		        db.Password=efPassword.Text
		        if not db.Connect then
		          MsgBox "Unable to connect to the database." + EndOfLine + _
		          db.ErrorMessage
		          return
		        end if
		        
		        self.db = db
		        Close
		      #endif
		    end if
		    
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events pbCancel
	#tag Event
		Sub Action()
		  db = nil
		  Close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events pbBrowse
	#tag Event
		Sub Action()
		  // Let the user pick an existing database file instead of typing its path
		  Var dlg As New OpenFileDialog
		  dlg.Title = "Choose a database file"
		  Var f As FolderItem = dlg.ShowModal
		  If f <> Nil Then
		    efDatabaseFile.Text = f.NativePath
		  End If
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
		Name="Backdrop"
		Visible=true
		Group="Appearance"
		InitialValue=""
		Type="Picture"
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
		Name="db"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Database"
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
		Name="Height"
		Visible=true
		Group="Position"
		InitialValue="400"
		Type="Integer"
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
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
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
		Name="MenuBarVisible"
		Visible=false
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
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
		Name="Resizeable"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
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
		Name="Width"
		Visible=true
		Group="Position"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
