Imports System.Data
Imports System.Data.SqlClient

Public Class Grade

    Public Property GradeId As Integer
    Public Property StudentId As Integer
    Public Property Subject As String
    Public Property Term As Integer
    Public Property Score As Decimal

    Public Shared Sub Create(grade As Grade)
        Using connection = DatabaseConnection.GetConnection()
            Using command As New SqlCommand("dbo.sp_Calificaciones_CRUD", connection)
                command.CommandType = CommandType.StoredProcedure
                command.Parameters.Add("@Operacion", SqlDbType.VarChar, 20).Value = "INSERTAR"
                command.Parameters.Add("@EstudianteId", SqlDbType.Int).Value = grade.StudentId
                command.Parameters.Add("@Materia", SqlDbType.NVarChar, 100).Value = grade.Subject
                command.Parameters.Add("@Periodo", SqlDbType.Int).Value = grade.Term
                command.Parameters.Add("@Nota", SqlDbType.Decimal).Value = grade.Score

                connection.Open()
                command.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Shared Function GetByStudentId(studentId As Integer) As List(Of Grade)
        Dim grades As New List(Of Grade)

        Using connection = DatabaseConnection.GetConnection()
            Dim sql As String =
                "SELECT CalificacionId, EstudianteId, Materia, Periodo, Nota " &
                "FROM dbo.Calificaciones WHERE EstudianteId = @StudentId"

            Using command As New SqlCommand(sql, connection)
                command.Parameters.Add("@StudentId", SqlDbType.Int).Value = studentId
                connection.Open()

                Using reader = command.ExecuteReader()
                    While reader.Read()
                        grades.Add(New Grade With {
                            .GradeId = Convert.ToInt32(reader("CalificacionId")),
                            .StudentId = Convert.ToInt32(reader("EstudianteId")),
                            .Subject = reader("Materia").ToString(),
                            .Term = Convert.ToInt32(reader("Periodo")),
                            .Score = Convert.ToDecimal(reader("Nota"))
                        })
                    End While
                End Using
            End Using
        End Using

        Return grades
    End Function

End Class
