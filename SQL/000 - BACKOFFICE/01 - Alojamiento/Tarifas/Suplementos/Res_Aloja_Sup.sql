SELECT TOP 100 Res.Res_Localizador,ASu_FechaFin, * FROM Tbl_ReservaAlojaSuplemento RSu
INNER JOIN Tbl_AlojamientoSuplemento ASu ON Asu.Id_ASu=RSu.Id_ASu AND  ASu.ASu_Obligatorio = 0 AND ASu.ASu_Activo = 1
INNER JOIN Tbl_LineaReserva LRe ON LRe.Id_LRe=RSu.Id_LRe
INNER JOIN tbl_reserva Res ON Res.Id_Res=LRe.Id_Res
WHERE 1=1
AND Res.Feccre>'2023'

