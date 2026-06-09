SELECT
	DR1.Primer_Intento			AS [Fecha_Primer_Intento_Descarga],
	LR.Feccre					AS [Fecha_Reserva_W2M],
	DR1.Loc_W2M,
	DR1.Loc_JET2,
	R.Id_Res,
	R.Res_Estado,
	LR.Id_LRe,
	LR.LRe_ExtLocalizador,
	LR.LRe_Cancelada,
	LR.LRe_CupoAsignado
FROM
					(
					SELECT
						MIN(DR.Feccre)			AS	[Primer_Intento],
						DR.DRe_codigoExt		AS	[Loc_JET2],
						DR.DRe_resLocalizador	AS	[Loc_W2M]
					FROM
									BD_Nincoming_HIS.dbo.Tbl_DescargaReserva	DR
						LEFT JOIN	BD_Nincoming.dbo.vwQlik_JP_Externos			E	ON E.AlE_Prov = 'AVT' 
																					AND RIGHT(DR.DRe_IdAlo , LEN(DR.DRe_IdAlo)-CHARINDEX('|',DR.DRe_IdAlo)) = E.AlE_Cod
					WHERE
						1 = 1
						AND DR.DRe_CodigoSE = 57
						AND DR.DRe_IdAlo LIKE 'AVT|%'
					GROUP BY
						DR.DRe_codigoExt,
						DR.DRe_resLocalizador
					)									DR1
	LEFT JOIN		BD_Nincoming.dbo.Tbl_Reserva		R	 ON (R.Res_Localizador = DR1.Loc_W2M OR DR1.Loc_W2M IS NULL)
	INNER JOIN		BD_Nincoming.dbo.Tbl_LineaReserva	LR	ON (LR.id_Res = R.id_Res AND DR1.Loc_JET2 = LR.Lre_localizadorExternoCliente)
WHERE
	1 = 1
	AND (LR.LRe_CupoAsignado = 1 AND R.Res_Estado = 'Pag' AND LR.LRe_ExtLocalizador IS NOT NULL)
GROUP BY
	DR1.Primer_Intento,
	LR.Feccre,
	DR1.Loc_W2M,
	DR1.Loc_JET2,
	R.Id_Res,
	R.Res_Estado,
	LR.Id_LRe,
	LR.LRe_ExtLocalizador,
	LR.LRe_Cancelada,
	LR.LRe_CupoAsignado
ORDER BY	
	DR1.Primer_Intento DESC,
	DR1.Loc_W2M
