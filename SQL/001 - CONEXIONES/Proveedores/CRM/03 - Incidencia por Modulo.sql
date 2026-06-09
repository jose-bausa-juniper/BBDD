SELECT
MOD_Id,*
FROM
	agencias.dbo.INCIDENCIA
WHERE
	1 = 1
	AND	A_codi = 18224
	--AND Id_incidencia = 1100544
	--AND (I_asumpte LIKE '%sucursales%' OR I_asumpte LIKE '%sucursales%')
	AND MOD_Id = 1855
ORDER BY
	I_data ASC