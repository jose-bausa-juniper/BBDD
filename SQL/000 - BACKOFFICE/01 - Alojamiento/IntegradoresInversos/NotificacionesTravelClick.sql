USE BD_Nincoming;
GO

-- Obtener la fecha de última ejecución desde el XML del parámetro
DECLARE @ultima_ejecucion DATETIME = (
    SELECT
        CONVERT(
            DATETIME,
            SUBSTRING(
                CAST(Par_Valor AS XML).value('(/Conexiones/conexion/configConexion/ultimasActualizaciones)[1]', 'varchar(max)'),
                1,
                CHARINDEX(
                    '#',
                    CAST(Par_Valor AS XML).value('(/Conexiones/conexion/configConexion/ultimasActualizaciones)[1]', 'varchar(max)')
                ) - 1
            ),
            103
        )
    FROM Tbl_Parametro
    WHERE Par_Codigo = 'NotificacionReservas'
);

--SET @ultima_ejecucion = '2026-02-17 00:00:00.000'
-- Variables de fecha
DECLARE @HOY DATE = CAST(GETDATE() AS DATE);
--DECLARE @DAYOFMONT DATETIME = '2025-05-10 00:00:00.000';
--DECLARE @FROM DATE = (SELECT DATEFROMPARTS(YEAR(@DAYOFMONT), MONTH(@DAYOFMONT), 1));
--DECLARE @TO DATE = (SELECT EOMONTH(@DAYOFMONT));
--DECLARE @FROM DATE = '2025-05-05';
--DECLARE @TO DATE = '2025-05-10';

-- Consulta principal
SELECT
    @HOY                AS [HOY],
    @ultima_ejecucion   AS [ÚLTIMA EJECUCIÓN],
    MAX(H.His_Fecha)    AS [ÚLTIMA NOTIFICACION],
    A.Id_Alo,
    R.Res_Localizador,
    R.Id_Res,
    LR.Id_LRe,
    LR.LRe_FechaCreacion,
    RA.RAl_FechaEntrada,
    RA.RAl_FechaSalida,
    R.Res_FechaUltimaModificacion,
    LR.Lre_UltimaModificacion,
    R.Res_Estado,
    LR.LRe_Cancelada,
    CCA.CCo_Extranet,
    CCA.CCo_Nombre,
    H.His_Texto
FROM
    Tbl_Reserva R
    INNER JOIN Tbl_LineaReserva LR ON LR.Id_Res = R.Id_Res
    INNER JOIN Tbl_ReservaAlojamiento RA ON RA.Id_LRe = LR.Id_LRe
    LEFT JOIN Tbl_Historial H ON H.Id_LRe = LR.Id_LRe
        AND H.His_Texto = '<text><es>Linea reserva notificada a TravelClick - OK</es><en>Booking line notified to TravelClick - OK</en></text>'
    INNER JOIN Tbl_Alojamiento A ON RA.Id_Alo = A.Id_Alo
    INNER JOIN Tbl_UsENAlo UEA ON A.Id_Alo = UEA.Id_Alo
    INNER JOIN Tbl_UsuarioExtranet UE ON UEA.Id_UsE = UE.Id_UsE
    INNER JOIN Tbl_Proveedor P ON LR.Id_Pro = P.Id_Pro
    INNER JOIN Tbl_ContratoCompraAloja CCA ON CCA.Id_CCo = RA.Id_CCo
WHERE
    1 = 1
    --AND R.Res_Localizador = '5S11TQ'
    AND UE.Id_Int IN (347)
    AND UE.UsE_Activo = 1
    AND A.Alo_borrado = 0
    --AND (
    --    (R.Res_FechaUltimaModificacion BETWEEN @FROM AND @TO)
    --    OR (LR.Lre_UltimaModificacion BETWEEN @FROM AND @TO)
    --)
    AND (
        R.Res_FechaUltimaModificacion > @ultima_ejecucion
        OR LR.Lre_UltimaModificacion > @ultima_ejecucion
    )
    AND (RA.RAl_FechaEntrada > @HOY OR RA.RAl_FechaEntrada > @ultima_ejecucion)
    AND R.Res_Estado NOT IN ('Ini', 'Quo')
    AND (P.Pro_NotPetResExt = 1 OR R.Res_Estado <> 'PRe')
    AND CCA.CCo_Extranet = 1
        -- AND LR.LRe_Cancelada = 1 -- Descomentar si se desea filtrar por canceladas
        --AND LR.Id_LRe IN (33540132,33540193)
GROUP BY
    A.Id_Alo,
    R.Res_Localizador,
    R.Id_Res,
    LR.Id_LRe,
    LR.LRe_FechaCreacion,
    RA.RAl_FechaEntrada,
    RA.RAl_FechaSalida,
    R.Res_FechaUltimaModificacion,
    LR.Lre_UltimaModificacion,
    R.Res_Estado,
    LR.LRe_Cancelada,
    CCA.CCo_Extranet,
    CCA.CCo_Nombre,
    H.His_Texto
HAVING
    (
        MAX(H.His_Fecha) < LR.Lre_UltimaModificacion
        OR MAX(H.His_Fecha) IS NULL
    )
    AND NOT (
        MAX(H.His_Fecha) IS NULL
        AND LR.LRe_Cancelada = 1
    )
ORDER BY
   R.Res_FechaUltimaModificacion DESC;