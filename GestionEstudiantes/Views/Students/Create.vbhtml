
@ModelType GestionEstudiantes.Student

@Code
    ViewBag.Title = "Crear estudiante"
End Code

<h2>Registrar estudiante</h2>

@Using Html.BeginForm("Create", "Students", FormMethod.Post)

    @Html.AntiForgeryToken()

    @Html.ValidationSummary(True, "", New With {.class = "text-danger"})

    @<div class="form-group">
        @Html.LabelFor(Function(m) m.FirstNames, "Nombres")
        @Html.TextBoxFor(Function(m) m.FirstNames,
                         New With {.class = "form-control", .required = "required", .maxlength = "100"})
    </div>

    @<div class="form-group">
        @Html.LabelFor(Function(m) m.LastNames, "Apellidos")
        @Html.TextBoxFor(Function(m) m.LastNames,
                         New With {.class = "form-control", .required = "required", .maxlength = "100"})
    </div>

    @<div class="form-group">
        @Html.LabelFor(Function(m) m.Age, "Edad")
        @Html.TextBoxFor(Function(m) m.Age,
                         New With {.class = "form-control", .type = "number", .min = "1", .max = "120", .required = "required"})
    </div>

    @<div class="form-group">
        @Html.LabelFor(Function(m) m.Gender, "Sexo")
        @Html.DropDownListFor(
                         Function(m) m.Gender,
                         New SelectList(New String() {"Masculino", "Femenino", "Otro"}),
                         "Seleccione...",
                         New With {.class = "form-control"})
    </div>

    @<div class="form-group">
        @Html.LabelFor(Function(m) m.Course, "Curso")
        @Html.TextBoxFor(Function(m) m.Course,
                         New With {.class = "form-control", .required = "required", .maxlength = "50"})
    </div>

    @<div class="form-group">
        <button type="submit" class="btn btn-success">
            Guardar estudiante
        </button>

        @Html.ActionLink("Cancelar", "Index", "Students",
                         Nothing, New With {.class = "btn btn-default"})
    </div>

End Using
