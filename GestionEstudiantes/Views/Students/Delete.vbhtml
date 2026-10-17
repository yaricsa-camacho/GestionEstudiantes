@ModelType GestionEstudiantes.Student

@Code
    ViewData("Title") = "Eliminar estudiante"
End Code

<h2>Eliminar estudiante</h2>

@Html.ValidationSummary(False, "", New With {.class = "alert alert-danger"})

<div class="panel panel-default">
    <div class="panel-body">
        <p>¿Esta seguro de que desea eliminar este estudiante?</p>
        <dl class="dl-horizontal">
            <dt>Nombres</dt>
            <dd>@Model.FirstNames</dd>
            <dt>Apellidos</dt>
            <dd>@Model.LastNames</dd>
            <dt>Edad</dt>
            <dd>@Model.Age</dd>
            <dt>Curso</dt>
            <dd>@Model.Course</dd>
        </dl>

        @Using Html.BeginForm("Delete", "Students", FormMethod.Post)
            @Html.AntiForgeryToken()
            @Html.Hidden("studentId", Model.StudentId)
            @<button type="submit" class="btn btn-danger">Confirmar eliminacion</button>
            @Html.ActionLink("Cancelar", "Index", "Students", Nothing, New With {.class = "btn btn-default"})
        End Using
    </div>
</div>
