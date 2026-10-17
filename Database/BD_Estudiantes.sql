/*
=========================================================
PROYECTO: Prueba Técnica - INDRA
=========================================================
*/

USE master;
GO


IF NOT EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'BD_Estudiantes'
)
BEGIN
    CREATE DATABASE BD_Estudiantes;

    PRINT 'BD_Estudiantes creada correctamente';
END
ELSE
BEGIN
    PRINT 'BD_Estudiantes ya existe';
END;
GO
--

USE BD_Estudiantes;
GO

--

IF OBJECT_ID('dbo.Estudiante', 'U') IS NULL
BEGIN

    CREATE TABLE dbo.Estudiante
    (
        EstudianteId INT IDENTITY(1,1) NOT NULL,
        Nombres NVARCHAR(100) NOT NULL,
        Apellidos NVARCHAR(100) NOT NULL,
        Edad INT NOT NULL,
        Sexo VARCHAR(20) NULL,
        Curso NVARCHAR(50) NOT NULL,

        FechaRegistro DATETIME2 NOT NULL
            DEFAULT SYSDATETIME(),


        CONSTRAINT PK_Estudiante
            PRIMARY KEY (EstudianteId),

  
        CONSTRAINT CK_Estudiante_Edad
            CHECK (Edad BETWEEN 1 AND 120)
    );

    PRINT 'Tabla Estudiante creada correctamente';

END
ELSE
BEGIN
    PRINT 'La tabla Estudiante ya existe';
END;
GO

--

IF OBJECT_ID('dbo.Calificaciones', 'U') IS NULL
BEGIN

    CREATE TABLE dbo.Calificaciones
    (
        CalificacionId INT IDENTITY(1,1) NOT NULL,
        EstudianteId INT NOT NULL,
        Materia NVARCHAR(100) NOT NULL,
        Periodo INT NOT NULL,
        Nota DECIMAL(3,2) NOT NULL,

        FechaRegistro DATETIME2 NOT NULL
            DEFAULT SYSDATETIME(),


        CONSTRAINT PK_Calificaciones
            PRIMARY KEY (CalificacionId),

 
        CONSTRAINT FK_Calificaciones_Estudiante
            FOREIGN KEY (EstudianteId)
            REFERENCES dbo.Estudiante(EstudianteId),

  
        CONSTRAINT CK_Calificaciones_Nota
            CHECK (Nota BETWEEN 0 AND 5),

      
        CONSTRAINT CK_Calificaciones_Periodo
            CHECK (Periodo BETWEEN 1 AND 4)
    );

    PRINT 'Tabla Calificaciones creada correctamente';

END
ELSE
BEGIN
    PRINT 'La tabla Calificaciones ya existe';
END;
GO

IF OBJECT_ID('dbo.LogErrores', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.LogErrores
    (
        ErrorId INT IDENTITY(1,1) PRIMARY KEY,
        Procedimiento NVARCHAR(128) NULL,
        Operacion VARCHAR(20) NULL,
        NumeroError INT NOT NULL,
        MensajeError NVARCHAR(4000) NOT NULL,
        LineaError INT NULL,
        FechaError DATETIME2 NOT NULL
            DEFAULT SYSDATETIME()
    );
END;
GO