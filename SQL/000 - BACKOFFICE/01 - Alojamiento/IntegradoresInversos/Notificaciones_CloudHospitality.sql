USE BD_Nincoming;
GO

-- Declaración de la variable con la última ejecución desde el XML del parámetro
DECLARE @ultima_ejecucion DATETIME = (
    SELECT
        CONVERT(
            DATETIME,
            CAST(Par_Valor AS XML).value('(/ConexionObj/ultimaActualizacion)[1]', 'varchar(max)'),
            103
        )
    FROM
        Tbl_Parametro
    WHERE
        Par_Codigo = 'NotificacionReservas/CloudHospitality'
);

SET @ultima_ejecucion = '2025-12-01 00:00:00.000'

-- Consulta principal
SELECT DISTINCT
    res.id_res,
    res.res_localizador,
    lre.id_lre,
    lre.lre_cancelada,
    lre.lre_UltimaModificacion,
    lre.LRE_IdSustituyente
FROM
    tbl_contratocompraaloja cco
    INNER JOIN tbl_LineaReservaPrecioDia lpd ON cco.id_cco = lpd.LPD_IdcCo
    INNER JOIN tbl_lineareserva lre ON lre.id_lre = lpd.id_lre
    INNER JOIN tbl_reserva res ON lre.id_res = res.id_res
WHERE
    lre.Lre_UltimaModificacion > @ultima_ejecucion
    AND lre.LRE_IdSustituyente IS NOT NULL
    AND (
        cco.cco_extranet = 1
        OR cco.CCo_NotificarReservasIntegradoresExtranet = 1
    )
    AND cco.id_alo IN (
        SELECT DISTINCT uea.id_alo
        FROM Tbl_UsENAlo uea
        INNER JOIN Tbl_UsuarioExtranet uex ON uea.id_Use = uex.id_Use
        WHERE
            uex.id_int = 101
            AND uex.Use_activo = 1
    )
    AND (
        -- CON DESARROLLO
        (
            lre.lre_cupoasignado = 1
            OR lre.LRe_ConfirmarSinCupo = 1
            OR lre.LRe_Cancelada = 1
        )
        -- SIN DESARROLLO (comentado)
        -- (res.Res_Estado <> 'INI' AND res.Res_Estado <> 'PRE' AND res.Res_Estado <> 'QUO')
        AND (
            lre.lre_envioRetardadoProveedor = 0
            OR (
                lre.lre_envioRetardadoProveedor = 1
                AND lre.lre_FechaEnvioRetardadoProveedor < GETDATE()
            )
        )
    )
ORDER BY
    lre.id_lre;