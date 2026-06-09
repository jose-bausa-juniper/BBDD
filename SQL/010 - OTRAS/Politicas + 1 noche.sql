DECLARE
@INI DATETIME = '2024-01-01 00:00:00.000',
@FIN DATETIME = '2025-01-01 00:00:00.000'

SELECT 
	--COUNT(LR.Id_LRe)
	LR.Id_Res,
	LR.Id_Lre,
	LR.LRe_FechaCreacion,
	LR.LRe_PoliticaCancelacion,
	Lre_XMLpoliticaCancelacion
FROM 
	Tbl_LineaReserva  LR
WHERE 
	1 = 1
	--AND LR.LRe_FechaCreacion BETWEEN @INI AND @FIN
	AND LR.LRe_Tipo = 'HL2'
	--AND LR.Id_Res = 26597960
	AND LR.LRe_PoliticaCancelacion LIKE '%+ first night%'
ORDER BY
	LR.LRe_FechaCreacion ASC