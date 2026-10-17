



USE BD_Estudiantes;
GO

-- ============================================
-- 1. INSERTAR 10 ESTUDIANTES
-- ============================================

INSERT INTO dbo.Estudiante
    (Nombres, Apellidos, Edad, Sexo, Curso)
SELECT
    D.Nombres,
    D.Apellidos,
    D.Edad,
    D.Sexo,
    D.Curso
FROM (VALUES
    ('Laura', 'Gomez', 16, 'Femenino', 'Decimo'),
    ('Carlos', 'Perez', 17, 'Masculino', 'Once'),
    ('Sofia', 'Ramirez', 15, 'Femenino', 'Noveno'),
    ('Andres', 'Torres', 14, 'Masculino', 'Octavo'),
    ('Valentina', 'Moreno', 16, 'Femenino', 'Decimo'),
    ('Daniel', 'Castro', 17, 'Masculino', 'Once'),
    ('Camila', 'Rojas', 15, 'Femenino', 'Noveno'),
    ('Juan', 'Martinez', 14, 'Masculino', 'Octavo'),
    ('Isabella', 'Vargas', 16, 'Femenino', 'Decimo'),
    ('Sebastian', 'Lopez', 17, 'Masculino', 'Once')
) AS D(Nombres, Apellidos, Edad, Sexo, Curso)
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Estudiante E
    WHERE E.Nombres = D.Nombres
      AND E.Apellidos = D.Apellidos
      AND E.Curso = D.Curso
);

-- ============================================
-- 2. INSERTAR 10 CALIFICACIONES
-- ============================================

INSERT INTO dbo.Calificaciones
    (EstudianteId, Materia, Periodo, Nota)
SELECT
    E.EstudianteId,
    D.Materia,
    D.Periodo,
    D.Nota
FROM (VALUES
    ('Laura', 'Gomez', 'Decimo', 'Matematicas', 1, CAST(5.00 AS DECIMAL(3,2))),
    ('Carlos', 'Perez', 'Once', 'Español', 1, CAST(4.50 AS DECIMAL(3,2))),
    ('Sofia', 'Ramirez', 'Noveno', 'Ingles', 2, CAST(3.80 AS DECIMAL(3,2))),
    ('Andres', 'Torres', 'Octavo', 'Ciencias', 1, CAST(5.00 AS DECIMAL(3,2))),
    ('Valentina', 'Moreno', 'Decimo', 'Historia', 2, CAST(4.20 AS DECIMAL(3,2))),
    ('Daniel', 'Castro', 'Once', 'Matematicas', 1, CAST(3.50 AS DECIMAL(3,2))),
    ('Camila', 'Rojas', 'Noveno', 'Español', 3, CAST(5.00 AS DECIMAL(3,2))),
    ('Juan', 'Martinez', 'Octavo', 'Ingles', 2, CAST(4.00 AS DECIMAL(3,2))),
    ('Isabella', 'Vargas', 'Decimo', 'Fisica', 1, CAST(4.70 AS DECIMAL(3,2))),
    ('Sebastian', 'Lopez', 'Once', 'Quimica', 3, CAST(5.00 AS DECIMAL(3,2)))
) AS D(Nombres, Apellidos, Curso, Materia, Periodo, Nota)
INNER JOIN dbo.Estudiante E
    ON E.Nombres = D.Nombres
   AND E.Apellidos = D.Apellidos
   AND E.Curso = D.Curso
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Calificaciones C
    WHERE C.EstudianteId = E.EstudianteId
      AND C.Materia = D.Materia
      AND C.Periodo = D.Periodo
);

-- ============================================
-- 3. VERIFICAR DATOS
-- ============================================

SELECT * FROM dbo.Estudiante;

SELECT
    E.Nombres,
    E.Apellidos,
    E.Curso,
    C.Materia,
    C.Periodo,
    C.Nota
FROM dbo.Calificaciones C
INNER JOIN dbo.Estudiante E
    ON E.EstudianteId = C.EstudianteId
ORDER BY E.Nombres;
