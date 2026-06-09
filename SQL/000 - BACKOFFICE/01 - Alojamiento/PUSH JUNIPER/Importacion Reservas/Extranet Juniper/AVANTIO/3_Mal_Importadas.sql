DECLARE @LASTDATE DATETIME = '2026-01-01 00:00:00'

SELECT
	'MAL IMPORTADA'								AS [ESTADO],
	CONCAT(R.Res_Nombre,' ',R.Res_Apellidos)	AS [Holder],
	DR1.DRe_codigoExt,
	DR1.DRe_resLocalizador,
	R.Id_Res,
	R.Res_Estado,
	R.Res_Fecha,
	R.Res_FechaUltimaModificacion,
	LR.Id_LRe,
	LR.LRe_ExtLocalizador,
	LR.LRe_Cancelada,
	LR.LRe_CupoAsignado
FROM
					BD_Nincoming.dbo.Tbl_Reserva			R
	INNER JOIN		(
					SELECT
						DR.DRe_codigoExt,
						DR.DRe_resLocalizador
					FROM
									BD_Nincoming_HIS.dbo.Tbl_DescargaReserva	DR
						LEFT JOIN	BD_Nincoming.dbo.vwQlik_JP_Externos			E	ON E.AlE_Prov = 'AVT' AND RIGHT(DR.DRe_IdAlo , LEN(DR.DRe_IdAlo)-CHARINDEX('|',DR.DRe_IdAlo)) = E.AlE_Cod
					WHERE
						1 = 1
						AND DR.DRe_CodigoSE = 57
						AND DR.DRe_IdAlo LIKE 'AVT|%'
						AND DR.DRe_resLocalizador IS NOT NULL
						
					GROUP BY
						DR.DRe_codigoExt,
						DR.DRe_resLocalizador
					)					DR1 ON DR1.DRe_resLocalizador = R.Res_Localizador
	INNER JOIN		BD_Nincoming.dbo.Tbl_LineaReserva	LR	ON (LR.id_Res = R.id_Res AND DR1.DRe_codigoExt = LR.Lre_localizadorExternoCliente)
WHERE
	1 = 1
	AND R.Res_Fecha > @LASTDATE
	--AND ((R.Res_Estado = 'Pag' AND LR.LRe_CupoAsignado = 0)) --AND LR.Id_LRe NOT IN (29506355,27542554,28881130,28917958)) /*Revisadas, tienen otra linea correcta*/ -- ESTADO CHUNGO
	--AND R.Res_Estado <> 'Pag' -- CONFIRMAR ESTADO EN AVT
	--AND ((R.Res_Estado IN ('Pag','Con') AND LR.LRe_ExtLocalizador IS NULL)) AND R.Id_Res NOT IN (22281011,22179420,22870091,22870145,22281015,22519112)
	AND R.Res_Estado NOT IN ('Pag','Can','CaC')
	--AND DR1.DRe_resLocalizador NOT IN ('2MSFWH')
ORDER BY
R.Res_Fecha ASC,
R.Res_Localizador DESC