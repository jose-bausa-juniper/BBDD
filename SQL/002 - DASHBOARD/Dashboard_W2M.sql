USE agencias;

DECLARE
@idcliente INT = 18224

SELECT
    i.id_incidencia																					AS [ID],
    dbo.converthtml(i.I_asumpte)																	AS [Titulo],
    i.I_tipus                                                                                       AS [Id_Tipo],
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
				FROM Tbl_EtiquetaIncidencia eti
				LEFT JOIN Tbl_Etiqueta et 
					ON et.Id_Etiqueta = eti.Id_Etiqueta 
                    AND et.Eti_Nombre LIKE '%W2M -%'
					--AND eti.id_etiqueta IN (817, 818, 819, 820, 821) 
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

FROM				dbo.incidencia				i
    INNER JOIN		HORAS						h		ON i.Id_incidencia = h.HOR_id_incidencia
    INNER JOIN		USUARI						ua		ON ua.Id_usuari = i.Id_usuari
    INNER JOIN		USUARI						ur		ON ur.Id_usuari = i.I_responsableTicket
    LEFT JOIN		GRUPO_USUARIOS				gu		ON gu.Id_GrU = ua.Id_GrU
    INNER JOIN		TIPO_INCIDENCIA				ti		ON TI.TI_id = i.I_tipus AND TI_Activo = 1
    LEFT JOIN		Tbl_TiposIncidenciaCliente	tic		ON tic.Id_Tii = i.I_TipoIncidenciaCliente
    LEFT JOIN		Tbl_IncidenciaQA			qa		ON qa.id_Incidencia = i.Id_incidencia
    INNER JOIN		usuari						us		ON i.Id_usuari = us.Id_usuari
    LEFT JOIN		GRUPO_USUARIOS				gru		ON us.id_gru = gru.id_gru

WHERE 
    1 = 1
    AND i.a_codi = @idcliente
	--AND i.I_tipus NOT IN(16,24,27,29,32,35,37)    
	AND i.I_tipus = 10
    AND i.I_estat <> 'C'
	--AND gru.GrU_Nombre NOT IN ('Primary Support','PM XML Support')
GROUP BY 
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
	I_porContrato,
	I_porMantenimiento,
	IncPresupuestoAceptado,
	I_fechaEnvioPresupuesto,
	I_fechaAceptacionPresupuesto,
	I_fechaInicioPrevista,
	I_fechaPactadaCliente
ORDER BY 
	ti.Ti_idGrupo DESC,
	i.I_tipus DESC,
	i.I_estat DESC,
	gru.Gru_nombre ASC,
	i.I_data DESC