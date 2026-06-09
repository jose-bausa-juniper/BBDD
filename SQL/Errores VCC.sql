SELECT
    R.Res_Localizador,
    R.Id_Res,
    R.Res_Estado,
    R.Res_Fecha,
    LR.LRe_Tipo,
    LR.LRe_TipoDesglosado,
    LR.LRe_MonedaCoste,
    TV.id_Ctv
FROM Tbl_Reserva R
INNER JOIN Tbl_LineaReserva LR 
LEFT JOIN Tbl_TarjetaVirtual TV ON TV.Id_lre = LR.Id_LRe
    ON LR.Id_Res = R.Id_Res
WHERE 
    R.Feccre > DATEADD(DAY, -14, GETDATE())
    AND R.Res_Estado = 'Can'
    AND EXISTS (
        SELECT 1
        FROM Tbl_Historial H
        WHERE 
            H.Id_Res = R.Id_Res
            AND H.His_Texto = '<text><es>Error Generando Tarjeta Virtual</es><en>Error Generando Tarjeta Virtual</en></text>'
            AND H.Feccre > DATEADD(DAY, -14, GETDATE())
    )
ORDER BY
    --LR.LRe_Tipo,
    R.Res_Fecha 
