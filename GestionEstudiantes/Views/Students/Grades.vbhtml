@ModelType IEnumerable(Of GestionEstudiantes.Grade)

@Code
    ViewData("Title") = "Calificaciones"
End Code

<div class="clearfix">
    <h2 class="pull-left">Calificaciones del estudiante</h2>

    @Html.ActionLink("Agregar nota", "CreateGrade", "Students",
                    New With {.id = ViewBag.StudentId}, New With {.class = "btn btn-success pull-right",
                                       .style = "margin-top:20px;"})
</div>

<table class="table table-bordered">
    <thead>
        <tr>
            <th>Materia</th>
            <th>Período</th>
            <th>Nota</th>
        </tr>
    </thead>
    <tbody>
        @For Each grade In Model
            @<tr>
                <td>@grade.Subject</td>
                <td>@grade.Term</td>
                <td>@grade.Score</td>
            </tr>
        Next
    </tbody>
</table>

@Html.ActionLink("Volver", "Index", "Students")
