USE BD_Nincoming

-- SELECT Id_Res, Res_Localizador FROM tbl_reserva WHERE Id_Res = 22259221
-- SELECT Id_Res, Id_LRe FROM Tbl_LineaReserva WHERE Id_LRe = 27629124
-- SELECT TOP 1 Id_lre FROM Tbl_TarjetaVirtual where tav_Codtarjeta is not null

SELECT Id_Res FROM Tbl_ReservaAlojamiento
WHERE 
    Id_Res IN 
    (SELECT Id_Res FROM Tbl_LineaReserva
    WHERE 
        Id_LRe IN (SELECT TOP 100 Id_lre FROM Tbl_TarjetaVirtual where tav_Codtarjeta is not null) 
        AND LRe_Cancelada = 0
        AND LRe_Tipo = 'A')
ORDER BY Feccre DESC


SELECT TOP 100 Id_lre, LRe_Tipo  FROM Tbl_LineaReserva WHERE
         LRe_Cancelada = 0
        AND LRe_Tipo = 'A'

SELECT TOP 1 * FROM Tbl_ReservaAlojamiento
