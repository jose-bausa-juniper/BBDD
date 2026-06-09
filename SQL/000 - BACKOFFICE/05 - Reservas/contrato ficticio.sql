SELECT top 100
ra.Id_Alo,r.Res_Localizador,r.Id_Res,ra.Id_CCo,ra.Id_CVe,r.Id_Ifz,r.Feccre
--COUNT(DISTINCT(r.Res_Localizador)) -- 1396749 Reservas
--COUNT(DISTINCT(ra.Id_Alo)) -- 7110 Hoteles
--COUNT(DISTINCT(lr.Id_LRe)) -- 2427358 Lineas de Reserva
FROM Tbl_Reserva r
INNER JOIN Tbl_LineaReserva lr ON lr.Id_Res=r.Id_Res
INNER JOIN Tbl_ReservaAlojamiento ra ON ra.Id_Res=r.Id_Res
INNER JOIN Tbl_Alojamiento a ON a.Id_Alo=ra.Id_Alo
WHERE 1=1
AND ra.Id_CCo IS NULL 
AND ra.Id_CVe IS NULL
AND r.Feccre>2023
--AND r.Res_Localizador='752ZPY'
--AND r.Id_Ifz='IMP'
--AND ra.Id_Alo = 30514 
GROUP BY ra.Id_Alo,r.Res_Localizador,r.Id_Res,ra.Id_CCo,ra.Id_CVe,r.Id_Ifz,r.Feccre
ORDER BY r.Feccre DESC