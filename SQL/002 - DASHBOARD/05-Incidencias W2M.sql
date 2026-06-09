DECLARE
	@fechacierre DATETIME = '2024-01-01 00:00:00',
	@idcliente INT = 18224

SELECT
	aj.A_nom																						AS [CLIENTE],
	i.I_BacklogPriority																				AS [BACKLOG_PRIORITY],
    i.id_incidencia																					AS [ID],
    agencias.dbo.converthtml(i.I_asumpte)															AS [Titulo],
	i.I_tipus,
    ti.TI_Etiqueta_Es																				AS [Tipo],
    CASE i.I_estat
        WHEN 'N' THEN 'Nueva'
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
	ur.U_nom																						AS [Responsable Asignado],
    tic.Tii_Nombre																					AS [TipoPropioDesglosado],
    CASE 
		WHEN tic.Id_Tii in (331,332,333) THEN 'Product'
        WHEN tic.Id_Tii in (334,335,336) THEN 'Sourcing'
        WHEN tic.Id_Tii in (337,338,339) THEN 'BO'
        WHEN tic.Id_Tii in (340,341,342) THEN 'Loading'
        WHEN tic.Id_Tii in (343,344,345) THEN 'Operaciones'
        WHEN tic.Id_Tii in (346,347,348) THEN 'Sales'
        WHEN tic.Id_Tii in (349,350,351) THEN 'Web'
        WHEN tic.Id_Tii in (352,353,354) THEN 'Finanzas'
        WHEN tic.Id_Tii in (355,356,357) THEN 'BI'
        WHEN tic.Id_Tii in (358,359,360) THEN 'IT'
        WHEN tic.Id_Tii in (361,362,363) THEN 'Integraciones'
        WHEN tic.Id_Tii in (364,365,366) THEN 'DMC'
        WHEN tic.Id_Tii IS NULL THEN NULL
        ELSE 'OLD'
    END																								AS [TipoPropio],
    STUFF(
			(
            SELECT ',' + et.Eti_Nombre
			FROM				agencias.dbo.Tbl_EtiquetaIncidencia	eti
					LEFT JOIN	agencias.dbo.Tbl_Etiqueta			et	ON et.Id_Etiqueta = eti.Id_Etiqueta 
																		AND et.Eti_Nombre LIKE 'W2M -%'
																		AND eti.Id_incidencia = i.id_incidencia
            FOR XML PATH('')
			), 1, 1, ''
		)																							AS [Etiquetas],
    CASE 
		WHEN I_porContrato = 1 AND I_porMantenimiento = 0 THEN 'Por contrato'
        WHEN I_porContrato = 1 AND I_porMantenimiento = 1 THEN 'Por mantenimiento'
        WHEN i.IncPresupuestoAceptado = 1 THEN 'Por bolsa de horas' 
        ELSE 'NO' 
	END																								AS [PresupuestoAceptado],
    CONVERT(date,i.i_fechaenviopresupuesto,103)														AS [FecEnvioPresupuesto],
    CONVERT(date,i.I_fechaAceptacionPresupuesto,103)												AS [FecAceptacionPresupuesto],
    CONVERT(date,i.I_fechaInicioPrevista,103)														AS [FecInicioPrevista],
    CONVERT(date,i.I_fechaPactadaCliente,103)														AS [FecComprometidaCliente],
    DATEFROMPARTS(YEAR(I_fechaInicioPrevista), MONTH(I_fechaInicioPrevista), 1)						AS [FInicio],
    DATEFROMPARTS(YEAR(I_fechaPactadaCliente), MONTH(I_fechaPactadaCliente), 1)						AS [FRelease]

FROM				agencias.dbo.incidencia					i
	INNER JOIN		agencias.dbo.AGENCIA					aj		ON aj.A_Codi = i.A_codi
    LEFT JOIN		agencias.dbo.HORAS						h		ON i.Id_incidencia = h.HOR_id_incidencia
    INNER JOIN		agencias.dbo.USUARI						ua		ON ua.Id_usuari = i.Id_usuari
    LEFT JOIN		agencias.dbo.USUARI						ur		ON ur.Id_usuari = i.I_responsableTicket
    LEFT JOIN		agencias.dbo.GRUPO_USUARIOS				gu		ON gu.Id_GrU = ua.Id_GrU
    INNER JOIN		agencias.dbo.TIPO_INCIDENCIA			ti		ON TI.TI_id = i.I_tipus AND TI_Activo = 1
    LEFT JOIN		agencias.dbo.Tbl_TiposIncidenciaCliente	tic		ON tic.Id_Tii = i.I_TipoIncidenciaCliente
    LEFT JOIN		agencias.dbo.Tbl_IncidenciaQA			qa		ON qa.id_Incidencia = i.Id_incidencia
    INNER JOIN		agencias.dbo.usuari						us		ON i.Id_usuari = us.Id_usuari
    LEFT JOIN		agencias.dbo.GRUPO_USUARIOS				gru		ON us.id_gru = gru.id_gru

WHERE 1 = 1
	AND i.a_codi = @idcliente
	AND i.I_tipus NOT IN(32,35,37) -- (23. Error Resuelto ; 24. Desarrollo (entregado) ; 26. Soporte (entregado))
	AND i.I_tipus NOT IN(24,27,29) -- (14. Diseño ; 17. Disputa ; 19.Hotel Único)
	AND i.I_tipus NOT IN(16) -- (2.a Soporte XML)
	--AND i.I_tipus NOT IN (14,15) -- (pend. actualización)
	AND i.I_estat <> 'C' 
	--AND i.I_estat NOT IN  ('E','N') -- PENDIENTE OTROS
	AND i.I_estat IN  ('E','N') -- PENDIENTES
	--AND i.Id_incidencia = 1031391
	--AND i.I_estat <> 'E'
	--AND (agencias.dbo.converthtml(i.I_asumpte) NOT LIKE '%conexi%' OR agencias.dbo.converthtml(i.I_asumpte) NOT LIKE '%Conexi%')
	--AND (agencias.dbo.converthtml(i.I_asumpte) LIKE '%conexi%' OR agencias.dbo.converthtml(i.I_asumpte) LIKE '%Conexi%')
	--AND (ur.U_nom = 'Jose Bausá' OR ur.U_nom = 'Daniel Suau' OR ur.U_nom = 'Santiago Gomez' OR ur.U_nom = 'Eduardo Feijóo Pons' OR ur.U_nom = 'Miquel Gayá' OR ur.U_nom = 'Ahinoam Perez Ruiz') -- 03 - Responsable PM W2M
	--AND (ua.U_nom = 'Jose Bausá' OR ua.U_nom = 'Daniel Suau' OR ua.U_nom = 'Santiago Gomez' OR ua.U_nom = 'Eduardo Feijóo Pons' OR ua.U_nom = 'Miquel Gayá' OR ua.U_nom = 'Ahinoam Perez Ruiz') -- 03 - Asignada PM W2M
	--AND (gru.Gru_nombre NOT IN ('Primary Support','API Support'))
	--AND (ur.U_nom = 'Jose Bausá')
	--AND (ua.U_nom = 'Jose Bausá')
	--AND ((ua.U_nom = 'Jose Bausá') OR (ur.U_nom = 'Jose Bausá'))
	--AND (ur.U_nom = 'Daniel Suau')
	--AND (ua.U_nom = 'Daniel Suau')
	--AND ((ua.U_nom = 'Daniel Suau') OR (ur.U_nom = 'Daniel Suau'))
	--AND (ur.U_nom = 'Santiago Gomez')
	--AND (ua.U_nom = 'Santiago Gomez')
	--AND ((ua.U_nom = 'Santiago Gomez') OR (ur.U_nom = 'Santiago Gomez'))
	--AND (ur.U_nom = 'Eduardo Feijóo Pons')
	--AND (ua.U_nom = 'Eduardo Feijóo Pons')
	--AND ((ua.U_nom = 'Eduardo Feijóo Pons') OR (ur.U_nom = 'Eduardo Feijóo Pons'))
	--AND (ur.U_nom = 'Miquel Gayá')
	--AND (ua.U_nom = 'Miquel Gayá')
	--AND ((ua.U_nom = 'Miquel Gayá') OR (ur.U_nom = 'Miquel Gayá'))
	--AND (ur.U_nom = 'Ahinoam Perez Ruiz')
	--AND (ua.U_nom = 'Ahinoam Perez Ruiz')
	--AND ((ua.U_nom = 'Ahinoam Perez Ruiz') OR (ur.U_nom = 'Ahinoam Perez Ruiz'))
	AND (STUFF
			(
				(
				SELECT 
					',' + et.Eti_Nombre
				FROM			agencias.dbo.Tbl_EtiquetaIncidencia	eti
					LEFT JOIN	agencias.dbo.Tbl_Etiqueta			et	ON	et.Id_Etiqueta = eti.Id_Etiqueta 
																			AND eti.Id_incidencia = i.id_incidencia
				FOR XML PATH('')
				), 1, 1, ''
			)
		)IS NULL
GROUP BY 
	aj.A_nom,
	i.id_incidencia,
	i.I_asumpte,
	ti.Ti_idGrupo,
	ti.TI_Etiqueta_Es,
	i.I_tipus,
	i.I_estat,
	i.I_data,
	gru.Gru_nombre,
	ua.U_nom,
	ur.U_nom,
	tic.Tii_Nombre,
	tic.Id_Tii,
	i.I_porContrato,
	i.I_porMantenimiento,
	i.IncPresupuestoAceptado,
	i.I_fechaEnvioPresupuesto,
	i.I_fechaAceptacionPresupuesto,
	i.I_fechaInicioPrevista,
	i.I_fechaPactadaCliente,
	i.I_BacklogPriority

ORDER BY 
	i.I_BacklogPriority DESC,
	i.I_data DESC,
	ur.U_nom,
	--gru.Gru_nombre,
	--ua.U_nom,
	--ti.Ti_idGrupo DESC,
	i.I_estat DESC,
	i.I_tipus DESC