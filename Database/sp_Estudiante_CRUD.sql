
USE BD_Estudiantes;
GO

/*
=========================================================
PROYECTO: Prueba Técnica - INDRA
SCRIPT: 02_SP_Estudiante.sql
DESCRIPCIÓN: Procedimiento almacenado CRUD de Estudiante
OPERACIONES: CONSULTAR, INSERTAR, ACTUALIZAR, ELIMINAR
COMPATIBILIDAD: SQL Server 2014, 2019 y 2022
=========================================================
*/

-- Crear el procedimiento si no existe
IF OBJECT_ID('dbo.sp_Estudiante_CRUD', 'P') IS NULL
BEGIN
    EXEC('CREATE PROCEDURE dbo.sp_Estudiante_CRUD AS BEGIN SET NOCOUNT ON; END');
END;
GO

-- =============================================
-- CREAR O ACTUALIZAR LA LOGICA DEL CRUD
-- =============================================

ALTER PROCEDURE dbo.sp_Estudiante_CRUD
    @Operacion VARCHAR(20),
    @EstudianteId INT = NULL,
    @Nombres NVARCHAR(100) = NULL,
    @Apellidos NVARCHAR(100) = NULL,
    @Edad INT = NULL,
    @Sexo VARCHAR(20) = NULL,
    @Curso NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NuevoEstudianteId INT;
    DECLARE @FilasAfectadas INT;

    BEGIN TRY

        -- =============================================
        -- CONSULTAR ESTUDIANTES
        -- =============================================

        IF @Operacion = 'CONSULTAR'
        BEGIN

            SELECT
                EstudianteId,
                Nombres,
                Apellidos,
                Edad,
                Sexo,
                Curso,
                FechaRegistro
            FROM dbo.Estudiante
            WHERE @EstudianteId IS NULL
               OR EstudianteId = @EstudianteId
            ORDER BY EstudianteId;

        END

        -- =============================================
        -- INSERTAR ESTUDIANTE
        -- =============================================

        ELSE IF @Operacion = 'INSERTAR'
        BEGIN

            -- Validar campos obligatorios
            IF NULLIF(LTRIM(RTRIM(@Nombres)), '') IS NULL
               OR NULLIF(LTRIM(RTRIM(@Apellidos)), '') IS NULL
               OR @Edad IS NULL
               OR NULLIF(LTRIM(RTRIM(@Curso)), '') IS NULL
            BEGIN
                THROW 50001,
                    'Debe ingresar nombres, apellidos, edad y curso.',
                    1;
            END;

            -- Validar rango de edad
            IF @Edad NOT BETWEEN 1 AND 120
            BEGIN
                THROW 50002,
                    'La edad debe estar entre 1 y 120.',
                    1;
            END;

            -- Iniciar transaccion
            BEGIN TRANSACTION;

            -- Registrar estudiante
            INSERT INTO dbo.Estudiante
            (
                Nombres,
                Apellidos,
                Edad,
                Sexo,
                Curso
            )
            VALUES
            (
                LTRIM(RTRIM(@Nombres)),
                LTRIM(RTRIM(@Apellidos)),
                @Edad,
                @Sexo,
                LTRIM(RTRIM(@Curso))
            );

            -- Validar registros insertados
            SET @FilasAfectadas = @@ROWCOUNT;

            IF @FilasAfectadas <> 1
            BEGIN
                THROW 50011,
                    'No se pudo insertar el estudiante.',
                    1;
            END;

            -- Obtener identificador generado
            SET @NuevoEstudianteId =
                CAST(SCOPE_IDENTITY() AS INT);

            -- Confirmar transaccion
            COMMIT TRANSACTION;

            PRINT CHAR(13) + CHAR(10)
                + 'COMMIT APLICADO EN: ' + DB_NAME();

            PRINT 'TRANSACCIONES ABIERTAS: '
                + CONVERT(VARCHAR(10), @@TRANCOUNT);

            SELECT
                @NuevoEstudianteId AS EstudianteId,
                'Estudiante registrado correctamente' AS Mensaje;

        END

        -- =============================================
        -- ACTUALIZAR ESTUDIANTE
        -- =============================================

        ELSE IF @Operacion = 'ACTUALIZAR'
        BEGIN

            -- Validar identificador
            IF @EstudianteId IS NULL OR @EstudianteId <= 0
            BEGIN
                THROW 50003,
                    'Debe indicar el identificador del estudiante.',
                    1;
            END;

            -- Validar existencia
            IF NOT EXISTS (
                SELECT 1
                FROM dbo.Estudiante
                WHERE EstudianteId = @EstudianteId
            )
            BEGIN
                THROW 50004,
                    'El estudiante no existe.',
                    1;
            END;

            -- Validar campos obligatorios
            IF NULLIF(LTRIM(RTRIM(@Nombres)), '') IS NULL
               OR NULLIF(LTRIM(RTRIM(@Apellidos)), '') IS NULL
               OR @Edad IS NULL
               OR NULLIF(LTRIM(RTRIM(@Curso)), '') IS NULL
            BEGIN
                THROW 50005,
                    'Debe ingresar nombres, apellidos, edad y curso.',
                    1;
            END;

            -- Validar rango de edad
            IF @Edad NOT BETWEEN 1 AND 120
            BEGIN
                THROW 50006,
                    'La edad debe estar entre 1 y 120.',
                    1;
            END;

            -- Iniciar transaccion
            BEGIN TRANSACTION;

            -- Actualizar informacion
            UPDATE dbo.Estudiante
            SET
                Nombres = LTRIM(RTRIM(@Nombres)),
                Apellidos = LTRIM(RTRIM(@Apellidos)),
                Edad = @Edad,
                Sexo = @Sexo,
                Curso = LTRIM(RTRIM(@Curso))
            WHERE EstudianteId = @EstudianteId;

            -- Validar registros actualizados
            SET @FilasAfectadas = @@ROWCOUNT;

            IF @FilasAfectadas <> 1
            BEGIN
                THROW 50012,
                    'No se actualizo ningun estudiante.',
                    1;
            END;

            -- Confirmar transaccion
            COMMIT TRANSACTION;

            PRINT CHAR(13) + CHAR(10)
                + 'COMMIT APLICADO EN: ' + DB_NAME();

            PRINT 'TRANSACCIONES ABIERTAS: '
                + CONVERT(VARCHAR(10), @@TRANCOUNT);

            SELECT
                @EstudianteId AS EstudianteId,
                'Estudiante actualizado correctamente' AS Mensaje;

        END

        -- =============================================
        -- ELIMINAR ESTUDIANTE
        -- =============================================

        ELSE IF @Operacion = 'ELIMINAR'
        BEGIN

            -- Validar identificador
            IF @EstudianteId IS NULL OR @EstudianteId <= 0
            BEGIN
                THROW 50007,
                    'Debe indicar el identificador del estudiante.',
                    1;
            END;

            -- Validar existencia
            IF NOT EXISTS (
                SELECT 1
                FROM dbo.Estudiante
                WHERE EstudianteId = @EstudianteId
            )
            BEGIN
                THROW 50008,
                    'El estudiante no existe.',
                    1;
            END;

            -- Validar calificaciones relacionadas
            IF EXISTS (
                SELECT 1
                FROM dbo.Calificaciones
                WHERE EstudianteId = @EstudianteId
            )
            BEGIN
                THROW 50009,
                    'No se puede eliminar un estudiante con calificaciones registradas.',
                    1;
            END;

            -- Iniciar transaccion
            BEGIN TRANSACTION;

            -- Eliminar estudiante
            DELETE FROM dbo.Estudiante
            WHERE EstudianteId = @EstudianteId;

            -- Validar registros eliminados
            SET @FilasAfectadas = @@ROWCOUNT;

            IF @FilasAfectadas <> 1
            BEGIN
                THROW 50013,
                    'No se elimino ningun estudiante.',
                    1;
            END;

            -- Confirmar transaccion
            COMMIT TRANSACTION;

            PRINT CHAR(13) + CHAR(10)
                + 'COMMIT APLICADO EN: ' + DB_NAME();

            PRINT 'TRANSACCIONES ABIERTAS: '
                + CONVERT(VARCHAR(10), @@TRANCOUNT);

            SELECT
                @EstudianteId AS EstudianteId,
                'Estudiante eliminado correctamente' AS Mensaje;

        END

        -- =============================================
        -- OPERACION NO VALIDA
        -- =============================================

        ELSE
        BEGIN
            THROW 50010,
                'La operacion solicitada no es valida.',
                1;
        END;

    END TRY

    -- =============================================
    -- MANEJO DE EXCEPCIONES
    -- =============================================

    BEGIN CATCH

        -- Almacenar los datos del error
        DECLARE @NumeroError INT = ERROR_NUMBER();
        DECLARE @MensajeError NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @LineaError INT = ERROR_LINE();

        -- Validar si existe una transaccion activa
        IF XACT_STATE() <> 0
        BEGIN

            -- Revertir cambios
            ROLLBACK TRANSACTION;

            PRINT CHAR(13) + CHAR(10)
                + '****** ROLLBACK APLICADO EN: '
                + DB_NAME();

        END;

        -- Registrar el error
        INSERT INTO dbo.LogErrores
        (
            Procedimiento,
            Operacion,
            NumeroError,
            MensajeError,
            LineaError
        )
        VALUES
        (
            OBJECT_NAME(@@PROCID),
            @Operacion,
            @NumeroError,
            @MensajeError,
            @LineaError
        );

        -- Propagar el error a la aplicacion
        THROW;

    END CATCH;

END;
GO
