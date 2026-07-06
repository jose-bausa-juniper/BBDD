SELECT
--	TOP 10
    i.id_incidencia																					AS [ID],
	a.A_Nom,
    agencias.dbo.converthtml(i.I_asumpte)															AS [Titulo],
    ti.TI_Etiqueta_Es																				AS [Tipo],
    CASE i.I_estat
        WHEN 'N' THEN 'Pendiente'
        WHEN 'E' THEN 'En curso'
        WHEN 'C' THEN 'Cerrada'
        WHEN '5' THEN 'Pend Proveedor'
        WHEN '4' THEN 'Pend Juniper'
        WHEN '3' THEN 'Pend Cliente'
        ELSE i.I_estat
    END																								AS [Estado],
    i.I_data																						AS [FechaCreacion],
    gru.Gru_nombre																					AS [Equipo Asignado],
	ua.U_nom																						AS [Usuario Asignado],
	iaws.Id_Cli

FROM			agencias.dbo.incidencia					i
	INNER JOIN	agencias.dbo.AGENCIA					a		ON a.A_Codi = i.A_codi
    INNER JOIN	agencias.dbo.USUARI						ua		ON ua.Id_usuari = i.Id_usuari
    INNER JOIN	agencias.dbo.TIPO_INCIDENCIA			ti		ON TI.TI_id = i.I_tipus
    LEFT JOIN	agencias.dbo.GRUPO_USUARIOS				gru		ON ua.id_gru = gru.id_gru
	LEFT JOIN	agencias.dbo.INCIDENCIA_INTWSAGENCIA	iaws	ON iaws.Id_incidencia = i.Id_incidencia

WHERE 1 = 1
	AND (agencias.dbo.converthtml(i.I_asumpte) LIKE '%descartada%')
	--AND iaws.Id_Cli = 81311
	--AND a.A_Nom = 'W2M (World 2 Meet)'


GROUP BY 
	i.id_incidencia,
	a.A_nom,
	i.I_asumpte,
	ti.Ti_idGrupo,
	ti.TI_Etiqueta_Es,
	i.I_tipus,
	i.I_estat,
	i.I_data,
	gru.Gru_nombre,
	ua.U_nom,
	iaws.Id_Cli

ORDER BY 
	i.Id_incidencia DESC,
	i.I_estat DESC,
	i.I_tipus DESC

