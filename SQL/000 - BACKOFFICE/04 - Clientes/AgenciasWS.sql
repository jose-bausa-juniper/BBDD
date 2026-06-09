SELECT 
	top 10
		c.id_cli AS [ID Cliente],
		c.Cli_Nombre AS [Nombre],
		ga.Id_GRA AS [ID Grupo Agencia],
		ga.GRA_Nombre AS [Grupo Agencia],
		p.id_pai AS [ID Pais],
		p.pai_Nombre AS [Pais],
		CASE
			WHEN c.cli_IdCentral IS NULL THEN 'FALSE' 
			ELSE 'TRUE' 
			END AS [Es Sucursal],
		c.cli_IdCentral AS [ID Central],
		CASE c.Cli_TipoPago
			WHEN 'C' THEN 'Credito' 
			WHEN 'B' THEN 'Prepago' 
			WHEN 'T' THEN 'TPV' 
			END AS [Tipo de Pago],
		c.Cli_diasMargen AS [Dias Margen Agencia],
		cc.CCl_MonedasOperacionCliente AS [Moneda Cliente],
		ga_c.Mon_Siglas AS [Moneda Grupo Agencia]
FROM			BD_Nincoming.dbo.tbl_Cliente						c
	INNER JOIN	BD_Nincoming.dbo.Tbl_ClienteConfiguracion			cc ON (cc.Id_Cli = c.Id_Cli)
	INNER JOIN	BD_Nincoming.dbo.Tbl_Paises							p ON (c.id_pai = p.id_pai)
	INNER JOIN	BD_Nincoming.dbo.Tbl_GrupoAgencia					ga ON (c.Id_GRA = ga.Id_GRA AND Id_Mer = 92)
	INNER JOIN	BD_Nincoming.dbo.Tbl_GraNCur						ga_c ON (ga.Id_GRA = ga_c.Id_GRA)
	INNER JOIN	BD_Nincoming.dbo.tbl_Mercado						m ON (ga.Id_Mer = m.Id_Mer AND Mer_Nombre = 'PRO')
	INNER JOIN	BD_Nincoming.dbo.Tbl_MerNCur						m_c ON (m.Id_Mer = m_c.Id_Mer)

WHERE 
	c.Cli_Activa = 1 
	AND cc.CCl_MonedasOperacionCliente is null