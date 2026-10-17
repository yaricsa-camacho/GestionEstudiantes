@ModelType GestionEstudiantes.Student

@Code
    ViewData("Title") = "Detalles"
End Code

<h2>Detalles del estudiante</h2>
<p><strong>Nombres:</strong> @Model.FirstNames</p>
<p><strong>Apellidos:</strong> @Model.LastNames</p>
<p><strong>Edad:</strong> @Model.Age</p>
<p><strong>Sexo:</strong> @Model.Gender</p>
<p><strong>Curso:</strong> @Model.Course</p>

@Html.ActionLink("Volver al listado", "Index", "Students")
