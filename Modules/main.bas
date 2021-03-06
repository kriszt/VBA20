Attribute VB_Name = "main"
Option Explicit

Public Sub main()
End Sub

' errorOut

' @message - the error message
'
' Display a MsgBox in the error format specified by @message
' If the @message is empty this will be no-op
Public Sub errorOut(ByVal message As String)
    If message = "" Then
        Exit Sub
    End If
    
    MsgBox message, vbExclamation, "Application Error"
End Sub


' createTable
' @name - name of the table
'
' If the @name is empty this will ne no-op.
Public Sub CreateTable(ByVal name As String, ByRef columnNames() As String)
    If name = "" Then
        Exit Sub
    End If
    
    Dim ws As Worksheet
    With ThisWorkbook
        ' insert the new worksheet at the end of the worksheet list
        Set ws = .Sheets.Add(After:=.Sheets(.Sheets.Count))
        ws.name = name
    End With
    
    Dim i As Integer
    Dim n As Integer
    n = ArraySize(columnNames)
    For i = 1 To n
        With Cells(1, i)
            .Value = columnNames(i - 1)
            .Font.size = 14
            '.Width = 14
            .Interior.Color = RGB(188, 188, 188)
        End With
    Next i
End Sub

' DeleteTable
' @name - name of the table
'
' If the @name is empty this will be no-op
' If the table(aka sheet) is found it will delete it and return True
' If the table is not found it will return False
Public Function DeleteTable(ByVal name As String) As Boolean
    DeleteTable = False
    If name = "" Then
        Exit Function
    End If
    
    If TableExists(name) = False Then
        Exit Function
    End If
        
    ' delete Wroksheet without displaying messages
    Application.DisplayAlerts = False
    Worksheets(name).Delete
    Application.DisplayAlerts = True
    
    DeleteTable = True
End Function

' TableExists
'
' Function for veryfing if the table exists or not
'
' @TableName - name of the table
'
' If @TableName is empty it will return False
' If @TableName is found this will return True
Public Function TableExists(ByVal TableName) As Boolean
    TableExists = False
    
    If TableName = "" Then
        Exit Function
    End If
    
    Dim i As Integer
    
    ' check if the tables specified exists
    For i = 1 To ActiveWorkbook.Worksheets.Count
        If ActiveWorkbook.Worksheets(i).name = TableName Then
            TableExists = True
            Exit Function

        End If
    Next i
    
End Function

' TableByName
'
' Returns the table found as Worksheet
'
' @TableName - name of the table you want to get
'
' If @TableName is empty this will return #Nothing
' If @TableName is found this will return it as a #Worsheet Object
Public Function TableByName(ByVal TableName As String) As Worksheet
    Dim i As Integer
    Set TableByName = Nothing
    
    If TableName = "" Then
        Exit Function
    End If
    
     ' check if the tables specified exists
    For i = 1 To ActiveWorkbook.Worksheets.Count
        If ActiveWorkbook.Worksheets(i).name = TableName Then
            Set TableByName = ActiveWorkbook.Worksheets(i)
            Exit For
        End If
    Next i
End Function

' ArraySize
'
' Get the size of an array
'
' If @arr is valid this will return the size of the array
Public Function ArraySize(ByRef arr() As String) As Integer
    ArraySize = UBound(arr) - LBound(arr) + 1
End Function

' InsertTable
'
' @list - list of values to be inserted
' @table - the table in which the values will be inserted
'
' If the list values does not match the column count of the tables this will return False
' If any operation will fail this will return false
' If the values are inserted and everything went fine, this will return True
Public Function InsertTable(ByVal TableName As String, ByVal list As String) As Boolean
    InsertTable = False
    If TableName = "" Or list = "" Or IsNumeric(TableName) Then
        Exit Function
    End If
    
    If TableExists(TableName) = False Then
        Exit Function
    End If
    
    Dim expectedSize As String
    Dim i As Integer

    Dim table As Worksheet
    ' get the table by name
    Set table = TableByName(TableName)
    If table Is Nothing Then
        Exit Function
    End If
    
    
    expectedSize = 0
    i = 1
    ' count the number of column that TableName has
    Do While table.Cells(1, i).Value <> ""
        expectedSize = expectedSize + 1
        i = i + 1
    Loop

    Dim arr() As String
    Dim size As Integer
    
    ' split and get the array size
    arr = Split(list, ",")
    size = ArraySize(arr)
    
    ' check if the number expected is the same with the list one
    ' if it does not, return false and exit
    If expectedSize <> size Then
        InsertTable = False
        Exit Function
    End If
    
    ' the next step is to get the column types of the @TableName
    Dim columnTypes() As String
    GetTableTypes TableName, columnTypes
    
    Dim j As Integer
    Dim currentSheet As Worksheet
    ' insertion table logic
    For i = 1 To ActiveWorkbook.Worksheets.Count
        If TableName = ActiveWorkbook.Worksheets(i).name Then
            Set currentSheet = ActiveWorkbook.Worksheets(i)
                
            Dim emptyRow As Long
            emptyRow = currentSheet.Cells(currentSheet.Rows.Count, "A").End(xlUp).Row + 1
                
            If currentSheet.Cells(1, "A").Value = "" Then
                emptyRow = 1
            End If
                
            Dim emptyCol As Long
            For j = 0 To size - 1
                If columnTypes(j) = "Integer" And IsNumeric(arr(j)) Then
                    currentSheet.Cells(emptyRow, j + 1).Value = arr(j)
                ElseIf columnTypes(j) = "String" And Not IsNumeric(arr(j)) Then
                     currentSheet.Cells(emptyRow, j + 1).Value = arr(j)
                Else
                    errorOut ("Column value type missmatch")
                    InsertTable = False
                    Exit Function
                End If
            Next j
        End If
    Next i
    
    InsertTable = True
End Function

Sub GetTableTypes(ByVal TableName As String, ByRef columnTypes() As String)
    Dim dba_start As Worksheet
    Set dba_start = ActiveWorkbook.Worksheets("dba_start")
    Dim rw As Range
    Dim j As Integer
    j = 2
    Dim ncolumns As Long
    ncolumns = 0
    ReDim Preserve columnTypes(ncolumns)
    For Each rw In dba_start.Rows
        ' if we found the raw for the @TableName
        ' we need to take all types
        If dba_start.Cells(rw.Row, 1).Value = TableName Then
            ' for every non empty cell
            Do While dba_start.Cells(rw.Row, j) <> ""
                ReDim Preserve columnTypes(0 To ncolumns)
                columnTypes(ncolumns) = dba_start.Cells(rw.Row, j).Value ' get the type
                j = j + 1
                ncolumns = ncolumns + 1
            Loop
            ' after we've done with the type extraction just exit
            Exit For
        End If
    Next rw
End Sub




