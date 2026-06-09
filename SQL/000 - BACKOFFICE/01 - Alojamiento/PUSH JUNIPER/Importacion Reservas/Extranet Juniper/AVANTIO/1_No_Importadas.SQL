DECLARE @LASTDATE DATETIME = '2026-01-01 00:00:00'

SELECT
	'NO IMPORTADA'			AS [ESTADO],
	MIN(DR1.FecCre)			AS [Fecha_Primer_Intento],
	MAX(DR1.FecCre)			AS [Fecha_Ultimo_Intento],
	DR1.DRe_codigoExt		AS [Loc_JET2],
	DR1.DRe_resLocalizador	AS [Loc_W2M],
	DR1.DRe_IdAlo			AS [ID_Alo]
FROM 
	BD_Nincoming_HIS.dbo.Tbl_DescargaReserva DR1
WHERE 
	1 = 1
	AND	DR1.DRe_codigoExt IN
							(
							SELECT
								DR.DRe_codigoExt
							FROM
											BD_Nincoming_HIS.dbo.Tbl_DescargaReserva	DR
								LEFT JOIN	BD_Nincoming.dbo.vwQlik_JP_Externos			E	ON E.AlE_Prov = 'AVT' AND RIGHT(DR.DRe_IdAlo , LEN(DR.DRe_IdAlo)-CHARINDEX('|',DR.DRe_IdAlo)) = E.AlE_Cod
							WHERE
								1 = 1
								AND DR.DRe_CodigoSE = 57
								AND DR.DRe_IdAlo LIKE 'AVT|%'
							GROUP BY
								DR.DRe_codigoExt
							HAVING COUNT (DR.DRe_resLocalizador) = 0
							)
	AND DR1.DRe_CodigoSE = 57
	AND DR1.DRe_IdAlo <> '0'
	AND DR1.DRe_codigoExt NOT IN ('1R1T3N~58619159~20299032/S26H','1WNY3H~58565014~20281206/S26H','BB5C5F~58678982~20124577/S26H','HRLMK4~58648469~20308985/S26H','NPBG12~59365527~20546150/S26H','922B9V~59475880~20582977/S26H')
GROUP BY
	DR1.DRe_codigoExt,
	DR1.DRe_resLocalizador,
	DR1.DRe_IdAlo

HAVING
	MIN(DR1.FecCre) > @LASTDATE

	--MIN(DR1.FecCre) <> MAX(DR1.FecCre)
	--MIN(DR1.FecCre) = MAX(DR1.FecCre)

ORDER BY
	[Fecha_Primer_Intento] ASC