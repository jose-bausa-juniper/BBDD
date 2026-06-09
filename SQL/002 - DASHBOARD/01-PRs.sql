DECLARE
	@fechacierre DATETIME = '2024-01-01 00:00:00',
	@idcliente INT = 18224
SELECT
	i.id_incidencia														AS [ID],
	agencias.dbo.converthtml(i.I_asumpte)										AS [Titulo],
	i.i_nomClient														AS [Solicitado por],
	ic.ICO_PoolRequestID												AS [PR],
	ic.ico_project														AS [Proyecto],
	ic.ICO_branch														AS [Rama],
	ic.ICO_Repository													AS [Git],
	CONVERT(date, ic.FecMod, 103)										AS [Fecha_Commit],
	DAY(ic.FecMod)														AS [Día_Commit],
	MONTH(ic.FecMod)													AS [Mes_Commit],
	YEAR(ic.FecMod)														AS [Año_Commit],
	CASE ic.ICO_EstadoCompilacion
		WHEN ('4') THEN 'Desplegado'
		WHEN ('3') THEN  'Descartado'
		WHEN ('2') THEN  'Compilado'
		WHEN ('1') THEN  'Pend. compilación'
		WHEN ('0') THEN  'Creado' 
	END																	AS [EstadoPR],
	CASE i.I_estat	
		WHEN 'N' THEN 'Pendiente'
		WHEN 'E' THEN 'En curso'
		WHEN 'C' THEN 'Cerrada'
		ELSE  '-'
	END																	AS [Estado],
	CASE i.i_tipus	
		WHEN ('33') THEN 'Soporte'
		WHEN ('4')	THEN 'Soporte'
		WHEN ('37') THEN 'Soporte'
		WHEN ('35') THEN 'Desarrollo'
		WHEN ('36') THEN 'Desarrollo'
		WHEN ('10') THEN 'Desarrollo'
		WHEN ('13') THEN 'Desarrollo'
		WHEN ('15') THEN 'Desarrollo'
		WHEN ('21') THEN 'Desarrollo'
		WHEN ('23') THEN 'Desarrollo'
		WHEN ('2')  THEN 'Error'
		WHEN ('12') THEN 'Error'
		WHEN ('14') THEN 'Error'
		WHEN ('19') THEN 'Error'
		WHEN ('22') THEN 'Error'
		WHEN ('38') THEN 'Error'
		WHEN ('32') THEN 'Error'
		WHEN ('38') THEN 'Error'
		WHEN ('39') THEN 'IT'
		WHEN ('26') THEN 'IT'
		WHEN ('16') THEN 'XML'
		WHEN ('29') THEN 'HU'
		ELSE 'OTRO'
	END																	AS [TipoGenerico],
	i.I_TareaGDescripcion												AS [Gantt Descrpicion],
	i.I_TareaGAgrupacion												AS [Gantt Agrupacion],
	gu.GrU_Nombre														AS [Departamento],
	tic.tii_nombre														AS [Tipo incidencia cliente],
	ti.TI_Etiqueta_Es													AS [Tipo],
	U.U_nom																AS [RecursoAsignado],
	CONVERT(VARCHAR(11),i.I_fechaPactadaCliente,3)						AS [FechaEntregaComprometidaCliente],
	CONCAT(i.Id_incidencia, ' - ', agencias.dbo.converthtml(i.I_asumpte))		AS [ID_TITULO]
		
FROM	
					agencias.dbo.incidencia				i
	INNER JOIN		agencias.dbo.USUARI						u	ON u.Id_usuari=i.Id_usuari
	LEFT JOIN		agencias.dbo.GRUPO_USUARIOS				gu	ON gu.Id_GrU=u.Id_GrU
	INNER JOIN		agencias.dbo.TIPO_INCIDENCIA				ti	ON TI.TI_id=i.I_tipus
	LEFT JOIN		agencias.dbo.Tbl_TiposIncidenciaCliente	tic ON tic.Id_Tii=i.I_TipoIncidenciaCliente
	RIGHT JOIN		agencias.dbo.Tbl_IncidenciaCommit		ic	ON i.Id_incidencia=ic.id_incidencia
WHERE	
	1 = 1
	--AND i.a_codi = @idcliente
	AND (i.I_estat <> 'C' OR (i.I_estat = 'C' AND I_fechacierre >= @fechacierre))
	--AND i.Id_incidencia = 967577
	AND ic.ICO_Repository = 'pro2next'
	AND ic.ICO_EstadoCompilacion IN (2,4)
ORDER BY
	ic.FecMod DESC