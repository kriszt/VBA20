VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} MainMenu 
   Caption         =   "UserForm1"
   ClientHeight    =   9885
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   14220
   OleObjectBlob   =   "MainMenu.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "MainMenu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub CancelMenu_Click()
    ' exit the meniu unloading it
    Unload Me
End Sub

Private Sub CreateTable_Click()
    ' load in memory the create table window and show it'
    CreateTableWindow.Show
End Sub

Private Sub DeleteTable_Click()
    DeleteTableWindow.Show
End Sub




Private Sub MenuFrame_Click()

End Sub
