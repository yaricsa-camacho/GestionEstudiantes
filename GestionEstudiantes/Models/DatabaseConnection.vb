Imports System.Configuration
Imports System.Data.SqlClient

Public Class DatabaseConnection

    Private Shared ReadOnly connectionString As String =
        ConfigurationManager.ConnectionStrings("StudentDatabase").ConnectionString

    Public Shared Function GetConnection() As SqlConnection
        Return New SqlConnection(connectionString)
    End Function

End Class

