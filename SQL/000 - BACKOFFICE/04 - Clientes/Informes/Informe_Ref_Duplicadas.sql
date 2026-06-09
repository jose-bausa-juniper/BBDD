-- Listado completo de agentes 
SELECT 
	mer.Mer_Nombre MERCADO,	gra.Id_GRA IDGRUPOAGE, gra.GRA_Nombre NOMBREGRUPO, c.id_cli ID_AGENCIA, c.Cli_Nombre NOMBRE_AGENCIA, c.cli_activa ACTIVO_AGENCIA, 
	c.Cli_ReferenciaDuplicada,
	i.id_int ID_INTEGRADOR, i.Int_Nombre NOMBRE_INTEGRADOR,
	id_cag ID_AGENTE, cag.cag_nombre NOMBRE_AGENTE, cag.cag_login LOGIN_AGENTE, cag.CAg_Activo ACTIVO_AGENTE, cag.CAg_Email EmialAgente,
   	CASE cag_accesoAPI 
		WHEN 1 THEN 'Acceso API'
    	WHEN 0 THEN 'Acceso web'
		ELSE 'ambos'
	END 'TIPO_acceso'
FROM			tbl_cliente					c
	INNER JOIN	Tbl_ClienteConfiguracion	ccl ON c.id_cli = ccl.id_cli
	INNER JOIN	tbl_clienteagente			cag ON c.id_cli   = cag.id_cli
	INNER JOIN	Tbl_GrupoAgencia			gra ON c.Id_GRA   = gra.id_gra
	INNER JOIN	Tbl_Mercado					mer ON gra.id_mer = mer.Id_Mer 
	left  JOIN	tbl_integradorws			i   ON c.id_int   = i.id_int
WHERE 
	1=1
	AND c.Cli_Activa = 1
	AND cag.CAg_Activo = 1
	AND c.Cli_borrado = 0
	AND mer.Mer_Nombre = 'PRO'
	AND c.Cli_ReferenciaDuplicada = 0