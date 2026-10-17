
@ModelType GestionEstudiantes.Student

@Code
    ViewBag.Title = "Editar estudiante"
End Code

<h2>Editar estudiante</h2>

@Using Html.BeginForm("Edit", "Students", FormMethod.Post)

    @Html.AntiForgeryToken()

    @Html.HiddenFor(Function(m) m.StudentId)

    @Html.ValidationSummary(True, "", New With {.class = "text-danger"})

    @<div class="form-group">
        @Html.LabelFor(Function(m) m.FirstNames, "Nombres")
        @Html.TextBoxFor(Function(m) m.FirstNames,
                         New With {.class = "form-control", .required = "required", .maxlength = "100"})
        @Html.ValidationMessageFor(Function(m) m.FirstNames, "", New With {.class = "text-danger"})
    </div>

    @<div class="form-group">
        @Html.LabelFor(Function(m) m.LastNames, "Apellidos")
        @Html.TextBoxFor(Function(m) m.LastNames,
                         New With {.class = "form-control", .required = "required", .maxlength = "100"})
        @Html.ValidationMessageFor(Function(m) m.LastNames, "", New With {.class = "text-danger"})
    </div>

    @<div class="form-group">
        @Html.LabelFor(Function(m) m.Age, "Edad")
        @Html.TextBoxFor(Function(m) m.Age,
                         New With {.class = "form-control", .type = "number", .min = "1", .max = "120", .required = "required"})
        @Html.ValidationMessageFor(Function(m) m.Age, "", New With {.class = "text-danger"})
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
        @Html.ValidationMessageFor(Function(m) m.Course, "", New With {.class = "text-danger"})
    </div>

    @<div class="form-group">
        <button type="submit" class="btn btn-primary">
            Guardar cambios
        </button>

        @Html.ActionLink("Cancelar", "Index", "Students",
                         Nothing, New With {.class = "btn btn-default"})
    </div>

End Using
