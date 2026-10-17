@ModelType IEnumerable(Of GestionEstudiantes.Student)

@Code
    ViewData("Title") = "Estudiantes"
End Code

<h2>Estudiantes</h2>

@If TempData("SuccessMessage") IsNot Nothing Then
    @<div class="alert alert-success" role="alert">@TempData("SuccessMessage")</div>
End If

<table class="table table-bordered">
    <thead><tr><th>Nombres</th><th>Apellidos</th><th>Curso</th><th>Acciones</th></tr></thead>
    <tbody>
        @For Each student In Model
            @<tr>
                <td>@Html.ActionLink(student.FirstNames, "Details", "Students", New With {.id = student.StudentId}, Nothing)</td>
                <td>@student.LastNames</td>
                <td>@student.Course</td>
                <td>
                    @Html.ActionLink("Ver calificaciones", "Grades", "Students", New With {.id = student.StudentId}, New With {.class = "btn btn-info btn-sm"})
                    @Html.ActionLink("Editar", "Edit", "Students", New With {.id = student.StudentId}, New With {.class = "btn btn-warning btn-sm"})
                    @Html.ActionLink("Eliminar", "Delete", "Students", New With {.id = student.StudentId}, New With {.class = "btn btn-danger btn-sm"})
                </td>
            </tr>
        Next
    </tbody>
</table>
