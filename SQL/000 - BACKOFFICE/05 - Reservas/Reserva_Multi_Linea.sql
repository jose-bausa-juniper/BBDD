USE BD_Nincoming
SELECT TOP 1 
R.Id_Res,
R.Id_Can,
R.Id_Ifz,
R.Res_Estado,
LR.LRe_Cancelada
FROM TBL_Reserva R
INNER JOIN TBL_LineaReserva LR ON LR.id_Res = R.id_Res
INNER JOIN Tbl_ReservaAlojamientoExterno
WHERE
1 = 1
AND R.id_Can = 'WPRO'
AND R.id_ifz = 'XML'
AND LR.LRe_Cancelada = 0
AND R.Res_Estado = 'PAG'

GROUP BY
R.Id_Res,
R.Id_Can,
R.Id_Ifz,
R.Res_Estado,
LR.LRe_Cancelada

HAVING COUNT (LR.Id_LRe) > 1

