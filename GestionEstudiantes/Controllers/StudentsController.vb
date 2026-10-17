Imports System.Data.SqlClient
Imports System.Web.Mvc

Namespace Controllers
    Public Class StudentsController
        Inherits Controller

        ' GET: Students
        Function Index() As ActionResult
            Return View(Student.GetAll())
        End Function

        ' GET: Students/Details/5
        Function Details(id As Integer?) As ActionResult
            If Not id.HasValue Then Return RedirectToAction("Index")

            Dim studentUnique = Student.GetById(id.Value)
            If studentUnique Is Nothing Then Return HttpNotFound()

            Return View(studentUnique)
        End Function

        ' GET: Students/Grades/5
        Function Grades(id As Integer?) As ActionResult
            If Not id.HasValue Then Return RedirectToAction("Index")

            ViewBag.StudentId = id.Value
            Return View(Grade.GetByStudentId(id.Value))
        End Function

        ' GET: Students/CreateGrade/5
        Function CreateGrade(id As Integer?) As ActionResult
            If Not id.HasValue Then Return RedirectToAction("Index")
            If Student.GetById(id.Value) Is Nothing Then Return HttpNotFound()

            Return View(New Grade With {.StudentId = id.Value})
        End Function

        ' POST: Students/CreateGrade
        <HttpPost>
        <ValidateAntiForgeryToken>
        Function CreateGrade(ByVal grade As Grade) As ActionResult
            If grade.StudentId <= 0 OrElse Student.GetById(grade.StudentId) Is Nothing Then
                Return HttpNotFound()
            End If

            If String.IsNullOrWhiteSpace(grade.Subject) Then
                ModelState.AddModelError("Subject", "La materia es obligatoria.")
            End If
            If grade.Term < 1 OrElse grade.Term > 4 Then
                ModelState.AddModelError("Term", "El periodo debe estar entre 1 y 4.")
            End If
            If grade.Score < 0D OrElse grade.Score > 5D Then
                ModelState.AddModelError("Score", "La nota debe estar entre 0 y 5.")
            End If

            If Not ModelState.IsValid Then Return View(grade)

            Try
                Grade.Create(grade)
                Return RedirectToAction("Grades", New With {.id = grade.StudentId})
            Catch ex As SqlException
                ModelState.AddModelError("", ex.Message)
                Return View(grade)
            End Try
        End Function

        ' GET: Students/Create
        Function Create() As ActionResult
            Return View()
        End Function

        <HttpPost>
        <ValidateAntiForgeryToken>
        Function Create(ByVal student As Student) As ActionResult

            If String.IsNullOrWhiteSpace(student.FirstNames) OrElse
               String.IsNullOrWhiteSpace(student.LastNames) OrElse
               String.IsNullOrWhiteSpace(student.Course) OrElse
               student.Age < 1 OrElse student.Age > 120 Then

                ModelState.AddModelError("", "Complete los campos obligatorios correctamente.")

            End If

            If Not ModelState.IsValid Then
                Return View(student)
            End If

            Try

                Student.Create(student)

                Return RedirectToAction("Index")

            Catch ex As SqlException

                ModelState.AddModelError("", ex.Message)

                Return View(student)

            End Try

        End Function

        ' GET: Students/Edit/5
        Function Edit(id As Integer?) As ActionResult
            If Not id.HasValue Then Return RedirectToAction("Index")

            Dim studentUnique = Student.GetById(id.Value)
            If studentUnique Is Nothing Then Return HttpNotFound()

            Return View(studentUnique)
        End Function

        ' POST: Students/Edit/5
        <HttpGet>
        Function Edit(ByVal id As Integer) As ActionResult

            Dim studentUnique = Student.GetById(id)

            If studentUnique Is Nothing Then
                Return HttpNotFound()
            End If

            Return View(studentUnique)

        End Function


        <HttpPost>
        <ValidateAntiForgeryToken>
        Function Edit(ByVal student As Student) As ActionResult

            If student.StudentId <= 0 OrElse
               String.IsNullOrWhiteSpace(student.FirstNames) OrElse
               String.IsNullOrWhiteSpace(student.LastNames) OrElse
               String.IsNullOrWhiteSpace(student.Course) OrElse
               student.Age < 1 OrElse student.Age > 120 Then

                ModelState.AddModelError("", "Complete los campos correctamente.")

            End If

            If Not ModelState.IsValid Then
                Return View(student)
            End If

            Try

                Student.Update(student)

                Return RedirectToAction("Index")

            Catch ex As System.Data.SqlClient.SqlException

                ModelState.AddModelError("", ex.Message)
                Return View(student)

            End Try

        End Function

        ' GET: Students/Delete/5
        <HttpGet>
        Function Delete(id As Integer) As ActionResult
            Dim studentUnique = Student.GetById(id)
            If studentUnique Is Nothing Then Return HttpNotFound()

            Return View(studentUnique)
        End Function

        ' POST: Students/Delete/5
        <HttpPost>
        <ActionName("Delete")>
        <ValidateAntiForgeryToken>
        Function DeleteConfirmed(ByVal studentId As Integer) As ActionResult
            Dim studentUnique = Student.GetById(studentId)
            If studentUnique Is Nothing Then Return HttpNotFound()

            Try
                Student.Delete(studentId)
                TempData("SuccessMessage") = "El estudiante se eliminó correctamente."
                Return RedirectToAction("Index")
            Catch ex As SqlException
                If ex.Number = 50009 Then
                    ModelState.AddModelError("", "No se puede eliminar un estudiante con calificaciones registradas")
                Else
                    ModelState.AddModelError("", "No fue posible eliminar el estudiante. " & ex.Message)
                End If

                Return View(studentUnique)
            End Try
        End Function
    End Class
End Namespace
