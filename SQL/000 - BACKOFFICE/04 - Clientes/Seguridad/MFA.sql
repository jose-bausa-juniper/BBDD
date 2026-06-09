SELECT 
	m.Id_Mer						AS ID_Mercado,
	m.Mer_Nombre					AS Mercado,
	c.Id_GRA						AS ID_Grupo_Agencia,
	ga.GRA_Nombre					AS Grupo_Agencia,
	c.Id_Cli						AS ID_Agencia,
	c.Cli_Nombre					AS Agencia,
	c.Cli_Activa					AS Agencia_Activa,
	CASE c.Cli_TipoPago
		WHEN 'B' THEN 'Prepago'
		WHEN 'C' THEN 'Credito'
		WHEN 'T' THEN 'TPV'
		ELSE c.Cli_TipoPago
	END								AS Tipo_Pago_Agencia,
	i.Id_Int						AS ID_Integrador,
	i.Int_Nombre					AS Integrador,
	cc.CCL_LOGINMFA					AS MFA_Cliente_Activo
FROM			Tbl_Cliente					c
	INNER JOIN	Tbl_ClienteConfiguracion	cc	ON c.Id_Cli=cc.id_cli
	LEFT JOIN	Tbl_IntegradorWS			i	ON c.id_int=i.id_int
	INNER JOIN	Tbl_GrupoAgencia			ga	ON c.Id_GRA=ga.Id_GRA
	INNER JOIN	Tbl_Mercado					m	ON ga.Id_Mer=m.Id_Mer
WHERE 
	1 = 1
	AND c.Cli_Activa=1
	AND (c.Cli_TipoPago = 'T' AND cc.CCL_LOGINMFA = 0)
ORDER BY
	m.Id_Mer,
	ga.Id_GRA,
	c.Id_Cli
