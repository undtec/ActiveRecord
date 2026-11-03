#tag Menu
Begin Menu MenuBar1
   Begin MenuItem FileMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "&File"
      Symbol = ""
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin QuitMenuItem FileQuit
         SpecialMenu = 0
         Index = -2147483648
         Text = "#App.kFileQuit"
         Symbol = ""
         ShortcutKey = "#App.kFileQuitShortcut"
         Shortcut = "#App.kFileQuitShortcut"
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem EditMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "&Edit"
      Symbol = ""
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin MenuItem EditUndo
         SpecialMenu = 0
         Index = -2147483648
         Text = "&Undo"
         Symbol = ""
         ShortcutKey = "Z"
         Shortcut = "Cmd+Z"
         MenuModifier = True
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem UntitledMenu1
         SpecialMenu = 0
         Index = -2147483648
         Text = "-"
         Symbol = ""
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditCut
         SpecialMenu = 0
         Index = -2147483648
         Text = "Cu&t"
         Symbol = ""
         ShortcutKey = "X"
         Shortcut = "Cmd+X"
         MenuModifier = True
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditCopy
         SpecialMenu = 0
         Index = -2147483648
         Text = "&Copy"
         Symbol = ""
         ShortcutKey = "C"
         Shortcut = "Cmd+C"
         MenuModifier = True
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditPaste
         SpecialMenu = 0
         Index = -2147483648
         Text = "&Paste"
         Symbol = ""
         ShortcutKey = "V"
         Shortcut = "Cmd+V"
         MenuModifier = True
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditClear
         SpecialMenu = 0
         Index = -2147483648
         Text = "#App.kEditClear"
         Symbol = ""
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem UntitledMenu0
         SpecialMenu = 0
         Index = -2147483648
         Text = "-"
         Symbol = ""
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditSelectAll
         SpecialMenu = 0
         Index = -2147483648
         Text = "Select &All"
         Symbol = ""
         ShortcutKey = "A"
         Shortcut = "Cmd+A"
         MenuModifier = True
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem HelpMenu
      SpecialMenu = 0
      Index = -2147483648
      Text = "Help"
      Symbol = ""
      AutoEnabled = True
      AutoEnable = True
      Visible = True
      Begin MenuItem BKeeneyWebsite
         SpecialMenu = 0
         Index = -2147483648
         Text = "BKeeney Website"
         Symbol = ""
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ARHomePage
         SpecialMenu = 0
         Index = -2147483648
         Text = "ActiveRecord Home Page"
         Symbol = ""
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem ARGenHomePage
         SpecialMenu = 0
         Index = -2147483648
         Text = "ARGen Home Page"
         Symbol = ""
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
      Begin ApplicationMenuItem AboutActiveRecord
         SpecialMenu = 0
         Index = -2147483648
         Text = "About ActiveRecord"
         Symbol = ""
         AutoEnabled = True
         AutoEnable = True
         Visible = True
      End
   End
End
#tag EndMenu
