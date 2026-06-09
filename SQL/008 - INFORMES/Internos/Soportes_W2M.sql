declare
@fechacierre DateTime = '2017-01-01 00:00:00',
@idcliente int = 18224

SELECT
    i.id_incidencia AS [ID],
    agencias.dbo.converthtml(i.I_asumpte) AS [Titulo],
    ti.TI_Etiqueta_Es AS [Tipo],
    CASE i.I_estat
        WHEN 'N' THEN 'Pendiente'
        WHEN 'E' THEN 'En curso'
        WHEN 'C' THEN 'Cerrada'
        WHEN '5' THEN 'Pend Proveedor'
        WHEN '4' THEN 'Pend Juniper'
        WHEN '3' THEN 'Pend Cliente'
        ELSE i.I_estat
    END 'Estado',
    i.I_data AS [FechaCreacion],
    gru.Gru_nombre AS Asignado,
    u.U_nom,
    tic.Tii_Nombre AS [TipoPropioDesglosado],
    CASE WHEN tic.Id_Tii in (331,332,333) THEN 'Product'
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
    END AS [TipoPropio],
    i.I_prioridadPM AS [PrioridadPM]

FROM agencias.dbo.incidencia i
    INNER JOIN agencias.dbo.HORAS h ON i.Id_incidencia = h.HOR_id_incidencia
    INNER JOIN agencias.dbo.USUARI u ON u.Id_usuari = i.Id_usuari
    LEFT JOIN agencias.dbo.GRUPO_USUARIOS gu ON gu.Id_GrU = u.Id_GrU
    INNER JOIN agencias.dbo.TIPO_INCIDENCIA ti ON TI.TI_id = i.I_tipus AND TI_Activo = 1
    LEFT JOIN agencias.dbo.Tbl_TiposIncidenciaCliente tic ON tic.Id_Tii = i.I_TipoIncidenciaCliente
    LEFT JOIN agencias.dbo.Tbl_IncidenciaQA qa ON qa.id_Incidencia = i.Id_incidencia
    INNER JOIN agencias.dbo.usuari us ON i.Id_usuari = us.Id_usuari
    LEFT JOIN agencias.dbo.GRUPO_USUARIOS gru ON us.id_gru = gru.id_gru
    LEFT JOIN agencias.dbo.Tbl_EtiquetaIncidencia eti ON eti.Id_incidencia = i.Id_incidencia AND eti.id_etiqueta IN (817, 818, 819, 820, 821)

WHERE 1 = 1
    AND i.a_codi = @idcliente
    AND ti.Ti_idGrupo IN (4)
    AND ti.TI_id NOT IN (37)
    AND i.I_estat <> 'C'
	AND 
		(
		us.U_nom like '%Jose Bausá%'
		--us.U_nom like '%Ahinoam Perez Ruiz%'
		--us.U_nom like '%Iván Millán%'
		--us.U_nom like '%Eduardo Feijóo Pons%'
		--us.U_nom like '%Miquel Gayá%'
		)





group by 
i.Id_incidencia, 
I_asumpte, 
I_estat, 
gru.GrU_Nombre, 
TI_Etiqueta_ES, 
IncPresupuestoAceptado, 
IncValorMaximoPresupuestado, 
Tii_Nombre, 
I_prioridadPM, 
I_TareaGAgrupacion, 
I_TareaGDescripcion, 
I_data, 
I_fechaInicioPrevista, 
I_fechaPactadaCliente,
I_fechaAceptacionPresupuesto,
i_fechaenviopresupuesto,
i.I_HorasDesarrollo,
I_horasPM,I_porContrato,
I_porMantenimiento,
tic.Id_Tii,
u.U_nom

ORDER BY 
U_nom, Estado DESC