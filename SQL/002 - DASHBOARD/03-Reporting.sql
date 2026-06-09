DECLARE
	@fechacierre DATETIME = '2024-01-01 00:00:00',
	@idcliente INT = 18224
SELECT
    i.id_incidencia AS [ID], 
    dbo.converthtml(i.I_asumpte) AS [Titulo],
    CONCAT(i.Id_incidencia, ' - ', dbo.converthtml(i.I_asumpte)) AS ID_TITULO,
	i.I_data  FECHA_CREACION,
	--E.Eti_Nombre as PROYECTO,
    STUFF	(
				(SELECT 
					',' + et.Eti_Nombre
				FROM 
								Tbl_EtiquetaIncidencia	eti
					LEFT JOIN	Tbl_Etiqueta			et	ON et.Id_Etiqueta = eti.Id_Etiqueta 
															AND eti.id_etiqueta IN (817,818,819,820,821,824,901,902,903,904,915,993,1002,1047,1048)
															AND eti.Id_incidencia = i.id_incidencia
				FOR XML PATH('')
				), 1, 1, ''
			)		AS PROYECTO,
	ti.TI_Etiqueta_Es AS TIPO,
    
	CASE i.I_estat
        WHEN 'N' THEN 'Pendiente'
        WHEN 'E' THEN 'En curso'
        WHEN 'C' THEN 'Cerrada'
        WHEN '5' THEN 'Pend Proveedor'
        WHEN '4' THEN 'Pend Juniper'
        WHEN '3' THEN 'Pend Cliente'
        ELSE i.I_estat
    END 'ESTADO',
	
	case when i.i_estat = '3' and gru.id_gru = 33    then 'PM W2M'
		 when i.i_estat <> '3' and gru.id_gru <> 33  then 'PM TEC'
		 when i.i_estat <> '3' and gru.id_gru = 33   then 'PM JUN'
		 else gru.Gru_nombre 
	end  ASIGANADO,

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
    END AS TIPO_PROPIO,

	 case when  I_presupuestoAnalisisAceptado = 0  and i.IncPresupuestoAceptado = 0 then 'Pendiente presupuesto'
		  when  I_presupuestoAnalisisAceptado = 1  and i.IncPresupuestoAceptado = 0 then 'Pendiente aceptación presupuesto'
		  when 	I.IncPresupuestoAceptado = 1 and  I_porContrato = 0 and I_porMantenimiento = 0    then 'Aprobado (por Bolsa Horas)'
		  when 	I.IncPresupuestoAceptado = 1 and  I_porContrato = 1 AND I_porMantenimiento = 0    then 'Aprobado (por Contrato)'
		  when 	I.IncPresupuestoAceptado = 1 and  I_porContrato = 0 AND I_porMantenimiento = 1    then 'Aprobado (por Mantenimiento)'
	end as EstadoPresupuesto,

	'-' as 'PRIORIDAD_W2M',

	case 
		  when 	IncValorMaximoPresupuestado = 0				       then '-'
		  when 	IncValorMaximoPresupuestado between 0 and 70       then 'Baja'
		  when 	IncValorMaximoPresupuestado between 71.1 and 150   then 'Media'
		  when 	IncValorMaximoPresupuestado > 150.1               then 'Alta'
	end as 'COMPLEJIDAD',
	
	convert(date,i.I_fechaInicioPrevista,103) as 'FEC_INICIO',
	convert(date,i.I_fechaPactadaCliente,103) as 'FECHA_ENTREGA',
	i.IncValorMaximoPresupuestado as 'HORAS_PRESUPUESTO',
    
	ISNULL((sum(abs(hor_horas)))-i.IncValorMaximoPresupuestado,0) 'Horas_Contabilizadas',
	ISNULL(sum(abs(hor_horas)),0) AS 'Horas_Total_Cobradas'
	
FROM dbo.incidencia i

    LEFT JOIN TIPO_INCIDENCIA ti ON TI.TI_id = i.I_tipus AND TI_Activo = 1
    LEFT JOIN Tbl_TiposIncidenciaCliente tic ON tic.Id_Tii = i.I_TipoIncidenciaCliente 
	LEFT JOIN usuari us ON i.Id_usuari = us.Id_usuari
    LEFT JOIN GRUPO_USUARIOS gru  ON us.id_gru = gru.id_gru
    LEFT JOIN Tbl_EtiquetaIncidencia eti  ON eti.Id_incidencia = i.Id_incidencia AND eti.id_etiqueta IN (817, 818, 819, 820, 821,824,901,902,903,904,915,993,1002)
	LEFT JOIN Tbl_Etiqueta           E    ON E.Id_Etiqueta = ETI.Id_Etiqueta
	LEFT JOIN HORAS					 h on i.Id_incidencia = h.HOR_id_incidencia
 
WHERE 1 = 1
    AND i.a_codi = @idcliente
    AND ti.Ti_idGrupo IN (10) --4 SOP, 10 DSR, 2 ERR
	AND (i.I_estat <> 'C' OR (i.I_estat = 'C'  AND I_fechacierre >= @fechacierre))
group by 
    i.id_incidencia, 
    i.I_asumpte,
    i.I_data,
	ti.TI_Etiqueta_Es,
    i.I_estat,
	gru.id_gru,
	gru.Gru_nombre,
	tic.Id_Tii,
	I_presupuestoAnalisisAceptado,
	i.IncPresupuestoAceptado,
	I.IncPresupuestoAceptado, 
	I_porContrato,
	I_porMantenimiento,
	IncValorMaximoPresupuestado,
	i.I_fechaInicioPrevista,
	i.I_fechaPactadaCliente,
	i.IncValorMaximoPresupuestado