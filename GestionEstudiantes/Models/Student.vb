Imports System.Data
Imports System.Data.SqlClient

Public Class Student

    Public Property StudentId As Integer
    Public Property FirstNames As String
    Public Property LastNames As String
    Public Property Age As Integer
    Public Property Gender As String
    Public Property Course As String

    Public Shared Function GetAll() As List(Of Student)
        Dim students As New List(Of Student)

        Using connection = DatabaseConnection.GetConnection()
            Dim sql As String = "SELECT EstudianteId, Nombres, Apellidos, Edad, Sexo, Curso FROM dbo.Estudiante"

            Using command As New SqlCommand(sql, connection)
                connection.Open()

                Using reader = command.ExecuteReader()
                    While reader.Read()
                        students.Add(New Student With {
                            .StudentId = Convert.ToInt32(reader("EstudianteId")),
                            .FirstNames = reader("Nombres").ToString(),
                            .LastNames = reader("Apellidos").ToString(),
                            .Age = Convert.ToInt32(reader("Edad")),
                            .Gender = If(reader.IsDBNull(reader.GetOrdinal("Sexo")), Nothing, reader("Sexo").ToString()),
                            .Course = reader("Curso").ToString()
                        })
                    End While
                End Using
            End Using
        End Using

        Return students
    End Function

    Public Shared Function GetById(id As Integer) As Student
        Return GetAll().FirstOrDefault(Function(student) student.StudentId = id)
    End Function

    Public Shared Sub Create(student As Student)

        Using connection = DatabaseConnection.GetConnection()

            Using command As New SqlCommand("dbo.sp_Estudiante_CRUD", connection)

                command.CommandType = CommandType.StoredProcedure

                command.Parameters.Add("@Operacion", SqlDbType.VarChar, 20).Value = "INSERTAR"

                command.Parameters.Add("@Nombres", SqlDbType.NVarChar, 100).Value = student.FirstNames

                command.Parameters.Add("@Apellidos", SqlDbType.NVarChar, 100).Value = student.LastNames

                command.Parameters.Add("@Edad", SqlDbType.Int).Value = student.Age

                command.Parameters.Add("@Sexo", SqlDbType.VarChar, 20).Value =
                If(String.IsNullOrWhiteSpace(student.Gender),
                   CType(DBNull.Value, Object),
                   student.Gender)

                command.Parameters.Add("@Curso", SqlDbType.NVarChar, 50).Value = student.Course

                connection.Open()

                command.ExecuteNonQuery()

            End Using

        End Using

    End Sub

    Public Shared Sub Update(student As Student)

        Using connection = DatabaseConnection.GetConnection()

            Using command As New SqlCommand("dbo.sp_Estudiante_CRUD", connection)

                command.CommandType = CommandType.StoredProcedure

                command.Parameters.Add("@Operacion", SqlDbType.VarChar, 20).Value = "ACTUALIZAR"
                command.Parameters.Add("@EstudianteId", SqlDbType.Int).Value = student.StudentId
                command.Parameters.Add("@Nombres", SqlDbType.NVarChar, 100).Value = student.FirstNames
                command.Parameters.Add("@Apellidos", SqlDbType.NVarChar, 100).Value = student.LastNames
                command.Parameters.Add("@Edad", SqlDbType.Int).Value = student.Age

                command.Parameters.Add("@Sexo", SqlDbType.VarChar, 20).Value =
                If(String.IsNullOrWhiteSpace(student.Gender),
                   CType(DBNull.Value, Object),
                   student.Gender)

                command.Parameters.Add("@Curso", SqlDbType.NVarChar, 50).Value = student.Course

                connection.Open()
                command.ExecuteNonQuery()

            End Using

        End Using

    End Sub

    Public Shared Sub Delete(studentId As Integer)
        Using connection = DatabaseConnection.GetConnection()
            Using command As New SqlCommand("dbo.sp_Estudiante_CRUD", connection)
                command.CommandType = CommandType.StoredProcedure
                command.Parameters.Add("@Operacion", SqlDbType.VarChar, 20).Value = "ELIMINAR"
                command.Parameters.Add("@EstudianteId", SqlDbType.Int).Value = studentId

                connection.Open()
                command.ExecuteNonQuery()
            End Using
        End Using
    End Sub

End Class
