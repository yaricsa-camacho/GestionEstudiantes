@ModelType GestionEstudiantes.Grade

@Code
    ViewData("Title") = "Agregar nota"
End Code

<h2>Agregar nota</h2>

@Using Html.BeginForm("CreateGrade", "Students", FormMethod.Post, New With {.class = "form-horizontal"})
    @Html.AntiForgeryToken()
    @Html.HiddenFor(Function(model) model.StudentId)
    @Html.ValidationSummary(True, "", New With {.class = "text-danger"})

    @<div class="form-group">
        @Html.LabelFor(Function(model) model.Subject, "Materia", New With {.class = "control-label col-md-2"})
        <div class="col-md-10">
            @Html.TextBoxFor(Function(model) model.Subject, New With {.class = "form-control", .maxlength = "100"})
            @Html.ValidationMessageFor(Function(model) model.Subject, "", New With {.class = "text-danger"})
        </div>
    </div>

    @<div class="form-group">
        @Html.LabelFor(Function(model) model.Term, "Periodo", New With {.class = "control-label col-md-2"})
        <div class="col-md-10">
            @Html.DropDownListFor(Function(model) model.Term,
                         New SelectList(Enumerable.Range(1, 4), Model.Term),
                         "Seleccione un periodo", New With {.class = "form-control"})
            @Html.ValidationMessageFor(Function(model) model.Term, "", New With {.class = "text-danger"})
        </div>
    </div>

    @<div class="form-group">
        @Html.LabelFor(Function(model) model.Score, "Nota", New With {.class = "control-label col-md-2"})
        <div class="col-md-10">
            @Html.TextBoxFor(Function(model) model.Score, New With {.class = "form-control", .type = "number", .min = "0", .max = "5", .step = "0.01", .required = "required"})
            @Html.ValidationMessageFor(Function(model) model.Score, "", New With {.class = "text-danger"})
        </div>
    </div>

    @<div class="form-group">
        <div class="col-md-offset-2 col-md-10">
            <button type="submit" class="btn btn-success">Guardar</button>
            @Html.ActionLink("Volver a las calificaciones", "Grades", "Students", New With {.id = Model.StudentId}, New With {.class = "btn btn-default"})
        </div>
    </div>
End Using
