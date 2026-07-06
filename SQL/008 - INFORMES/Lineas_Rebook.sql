SELECT
R.id_Res,
R.Res_Localizador				,
R.Res_Fecha						,
LR.id_lre						,
LR.LRe_Tipo						,
LR.LRe_ExtLocalizador			,
LR.LRe_FechaCreacion			,
LR.LRe_Cancelada				,
LR.LRE_IdSustituyente			,
LRR.Id_LRe						,
LRR.LRe_Tipo					,
LRR.LRe_ExtLocalizador			,
LRR.LRe_FechaCreacion			,
LRR.LRe_Cancelada
FROM
Tbl_Reserva R
INNER JOIN Tbl_LineaReserva LR	ON LR.id_Res = R.id_Res 
INNER JOIN Tbl_LineaReserva LRR	ON LRR.id_lre = LR.LRE_IdSustituyente 

WHERE 
	1 = 1
--R.Res_Fecha > '2026'
--AND LR.LRE_IdSustituyente IS NOT NULL
AND R.Id_Res = 30258102
--AND LR.LRe_Tipo = LRR.LRe_Tipo
--AND LR.LRe_Tipo = 'DOW'
--AND LR.LRe_Cancelada = 0
ORDER BY
	LRR.LRe_FechaCreacion DESC