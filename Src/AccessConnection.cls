VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "AccessConnection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'@Folder("Frabasic.DataAccess")
Option Explicit

Private Const IS_CONNECTED = 1

Public Connection As ADODB.Connection
Public RecordSet As ADODB.RecordSet
Public Command As ADODB.Command
Public Sql As StringBuilder

Private Sub Class_Initialize()
    Set Connection = New ADODB.Connection
    Let Connection.CursorLocation = adUseClient
    Set Command = New ADODB.Command
    Set RecordSet = New ADODB.RecordSet
    Set Sql = New StringBuilder
End Sub

Private Sub Class_Terminate()
    Set Connection = Nothing
    Set RecordSet = Nothing
    Set Command = Nothing
    Set Sql = Nothing
End Sub

Public Function OpenConnection() As ADODB.Connection
       
    If Connection.State <> IS_CONNECTED Then
        Call Connection.Open(AppProperty.ConnectionString)
    End If
    
    Set OpenConnection = Connection
    
End Function

Public Sub CloseConnection()
    If Connection.State = IS_CONNECTED Then Connection.Close
End Sub

Public Function ExecuteNonQuery(ByVal SqlCommand As String) As Boolean
    
    Dim RecordsAffected As Integer
    
    Command.ActiveConnection = OpenConnection()
    Command.CommandType = adCmdText
    Command.CommandText = SqlCommand
    
    Call Command.Execute(RecordsAffected)
   
    ExecuteNonQuery = RecordsAffected
    
    ClearParameter
    Sql.Clear
    
End Function

Public Function ExecuteReader(ByVal SqlCommand As String) As ADODB.RecordSet
    
    Command.ActiveConnection = OpenConnection()
    Command.CommandType = adCmdText
    Command.CommandText = SqlCommand
      
    Set RecordSet = Command.Execute
    Set ExecuteReader = RecordSet
    
    ClearParameter
    Sql.Clear
    
End Function

Public Function ExecuteScalar(ByVal SqlCommand As String) As Variant
    
    Command.ActiveConnection = OpenConnection()
    Command.CommandType = adCmdText
    Command.CommandText = SqlCommand
      
    Set RecordSet = Command.Execute()
        
    If RecordSet.EOF = False Then
        ExecuteScalar = RecordSet.Fields(0).Value
    End If
    
    ClearParameter
    Sql.Clear
    
End Function

Public Sub AddParameter(ByVal Name As String, Value As Variant, Optional DataType As DataTypeEnum = adEmpty, Optional ParameterDirection As ParameterDirectionEnum = adParamInput, Optional Size As Integer = 255)
    Command.Parameters.Append Command.CreateParameter(Name, DataType, ParameterDirection, Size, Value)
End Sub

Public Sub ClearParameter()
    While Command.Parameters.Count > 0
        Call Command.Parameters.Delete(0)
        DoEvents
    Wend
End Sub

Public Property Get Field(Name As String) As Variant
    Field = RecordSet.Fields(Name).Value
End Property

