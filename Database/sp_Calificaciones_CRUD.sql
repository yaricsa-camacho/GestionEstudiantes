
USE BD_Estudiantes;
GO

/*
=========================================================
PROYECTO: Prueba Técnica - INDRA
SCRIPT: 03_SP_Calificaciones.sql
DESCRIPCIÓN: Procedimiento almacenado CRUD de Calificaciones
OPERACIONES: CONSULTAR, INSERTAR, ACTUALIZAR, ELIMINAR
COMPATIBILIDAD: SQL Server 2014, 2019 y 2022
=========================================================
*/

-- Crear el procedimiento almacenado si no existe
IF OBJECT_ID('dbo.sp_Calificaciones_CRUD', 'P') IS NULL
BEGIN
    EXEC('CREATE PROCEDURE dbo.sp_Calificaciones_CRUD AS BEGIN SET NOCOUNT ON; END');
END;
GO

-- =============================================
-- CREAR O ACTUALIZAR LA LOGICA DEL CRUD
-- =============================================

ALTER PROCEDURE dbo.sp_Calificaciones_CRUD
    @Operacion VARCHAR(20),
    @CalificacionId INT = NULL,
    @EstudianteId INT = NULL,
    @Materia NVARCHAR(100) = NULL,
    @Periodo INT = NULL,
    @Nota DECIMAL(3,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NuevaCalificacionId INT;
    DECLARE @FilasAfectadas INT;

    BEGIN TRY

        -- =============================================
        -- VALIDACIONES GENERALES
        -- =============================================

        -- Validar los campos obligatorios para
        -- insertar y actualizar calificaciones
        IF @Operacion IN ('INSERTAR', 'ACTUALIZAR')
        BEGIN

            IF @EstudianteId IS NULL
               OR @EstudianteId <= 0
               OR NULLIF(LTRIM(RTRIM(@Materia)), '') IS NULL
               OR @Periodo IS NULL
               OR @Nota IS NULL
            BEGIN
                THROW 50011,
                    'Debe ingresar estudiante, materia, periodo y nota.',
                    1;
            END;

            -- Validar existencia del estudiante
            IF NOT EXISTS (
                SELECT 1
                FROM dbo.Estudiante
                WHERE EstudianteId = @EstudianteId
            )
            BEGIN
                THROW 50012,
                    'El estudiante indicado no existe.',
                    1;
            END;

            -- Validar periodo academico
            IF @Periodo NOT BETWEEN 1 AND 4
            BEGIN
                THROW 50013,
                    'El periodo debe estar entre 1 y 4.',
                    1;
            END;

            -- Validar rango de la calificacion
            IF @Nota NOT BETWEEN 0 AND 5
            BEGIN
                THROW 50014,
                    'La nota debe estar entre 0 y 5.',
                    1;
            END;

        END;

        -- =============================================
        -- VALIDAR IDENTIFICADOR DE CALIFICACION
        -- =============================================

        IF @Operacion IN ('ACTUALIZAR', 'ELIMINAR')
        BEGIN

            IF @CalificacionId IS NULL
               OR @CalificacionId <= 0
            BEGIN
                THROW 50015,
                    'Debe indicar un identificador valido de calificacion.',
                    1;
            END;

            -- Validar existencia de la calificacion
            IF NOT EXISTS (
                SELECT 1
                FROM dbo.Calificaciones
                WHERE CalificacionId = @CalificacionId
            )
            BEGIN
                THROW 50016,
                    'La calificacion no existe.',
                    1;
            END;

        END;

        -- =============================================
        -- CONSULTAR CALIFICACIONES
        -- =============================================

        IF @Operacion = 'CONSULTAR'
        BEGIN

            SELECT
                C.CalificacionId,
                C.EstudianteId,
                E.Nombres,
                E.Apellidos,
                E.Curso,
                C.Materia,
                C.Periodo,
                C.Nota,
                C.FechaRegistro
            FROM dbo.Calificaciones C
            INNER JOIN dbo.Estudiante E
                ON C.EstudianteId = E.EstudianteId
            WHERE (@CalificacionId IS NULL
                   OR C.CalificacionId = @CalificacionId)
              AND (@EstudianteId IS NULL
                   OR C.EstudianteId = @EstudianteId)
            ORDER BY C.CalificacionId;

        END

        -- =============================================
        -- INSERTAR CALIFICACION
        -- =============================================

        ELSE IF @Operacion = 'INSERTAR'
        BEGIN

            -- Iniciar transaccion
            BEGIN TRANSACTION;

            -- Registrar calificacion
            INSERT INTO dbo.Calificaciones
            (
                EstudianteId,
                Materia,
                Periodo,
                Nota
            )
            VALUES
            (
                @EstudianteId,
                LTRIM(RTRIM(@Materia)),
                @Periodo,
                @Nota
            );

            -- Validar registros insertados
            SET @FilasAfectadas = @@ROWCOUNT;

            IF @FilasAfectadas <> 1
            BEGIN
                THROW 50020,
                    'No se pudo insertar la calificacion.',
                    1;
            END;

            -- Obtener identificador generado
            SET @NuevaCalificacionId =
                CAST(SCOPE_IDENTITY() AS INT);

            -- Confirmar transaccion
            COMMIT TRANSACTION;

            PRINT CHAR(13) + CHAR(10)
                + 'COMMIT APLICADO EN: ' + DB_NAME();

            PRINT 'TRANSACCIONES ABIERTAS: '
                + CONVERT(VARCHAR(10), @@TRANCOUNT);

            SELECT
                @NuevaCalificacionId AS CalificacionId,
                'Calificacion registrada correctamente' AS Mensaje;

        END

        -- =============================================
        -- ACTUALIZAR CALIFICACION
        -- =============================================

        ELSE IF @Operacion = 'ACTUALIZAR'
        BEGIN

            -- Iniciar transaccion
            BEGIN TRANSACTION;

            -- Actualizar calificacion
            UPDATE dbo.Calificaciones
            SET
                EstudianteId = @EstudianteId,
                Materia = LTRIM(RTRIM(@Materia)),
                Periodo = @Periodo,
                Nota = @Nota
            WHERE CalificacionId = @CalificacionId;

            -- Validar registros actualizados
            SET @FilasAfectadas = @@ROWCOUNT;

            IF @FilasAfectadas <> 1
            BEGIN
                THROW 50017,
                    'No se actualizo ninguna calificacion.',
                    1;
            END;

            -- Confirmar transaccion
            COMMIT TRANSACTION;

            PRINT CHAR(13) + CHAR(10)
                + 'COMMIT APLICADO EN: ' + DB_NAME();

            PRINT 'TRANSACCIONES ABIERTAS: '
                + CONVERT(VARCHAR(10), @@TRANCOUNT);

            SELECT
                @CalificacionId AS CalificacionId,
                'Calificacion actualizada correctamente' AS Mensaje;

        END

        -- =============================================
        -- ELIMINAR CALIFICACION
        -- =============================================

        ELSE IF @Operacion = 'ELIMINAR'
        BEGIN

            -- Iniciar transaccion
            BEGIN TRANSACTION;

            -- Eliminar calificacion
            DELETE FROM dbo.Calificaciones
            WHERE CalificacionId = @CalificacionId;

            -- Validar registros eliminados
            SET @FilasAfectadas = @@ROWCOUNT;

            IF @FilasAfectadas <> 1
            BEGIN
                THROW 50018,
                    'No se elimino ninguna calificacion.',
                    1;
            END;

            -- Confirmar transaccion
            COMMIT TRANSACTION;

            PRINT CHAR(13) + CHAR(10)
                + 'COMMIT APLICADO EN: ' + DB_NAME();

            PRINT 'TRANSACCIONES ABIERTAS: '
                + CONVERT(VARCHAR(10), @@TRANCOUNT);

            SELECT
                @CalificacionId AS CalificacionId,
                'Calificacion eliminada correctamente' AS Mensaje;

        END

        -- =============================================
        -- OPERACION NO VALIDA
        -- =============================================

        ELSE
        BEGIN
            THROW 50019,
                'La operacion solicitada no es valida.',
                1;
        END;

    END TRY

    -- =============================================
    -- MANEJO DE EXCEPCIONES
    -- =============================================

    BEGIN CATCH

        -- Almacenar informacion de la excepcion
        DECLARE @NumeroError INT = ERROR_NUMBER();
        DECLARE @MensajeError NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @LineaError INT = ERROR_LINE();

        -- Validar si existe una transaccion activa
        IF XACT_STATE() <> 0
        BEGIN

            -- Revertir los cambios
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
