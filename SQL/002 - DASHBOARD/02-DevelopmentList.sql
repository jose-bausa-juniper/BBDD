DECLARE
	@fechacierre DATETIME = '2025-01-01 00:00:00',
	@idcliente INT = 18224

SELECT 
    i.id_incidencia																																																			AS [ID], 
    dbo.converthtml(i.I_asumpte)																																															AS [Titulo],
    ti.TI_Etiqueta_Es																																																		AS [Tipo],
    CASE i.I_estat
        WHEN 'N'	THEN 'Pendiente'
        WHEN 'E'	THEN 'En curso'
        WHEN 'C'	THEN 'Cerrada'
        WHEN '5'	THEN 'Pend Proveedor'
        WHEN '4'	THEN 'Pend Juniper'
        WHEN '3'	THEN 'Pend Cliente'
					ELSE i.I_estat
    END																																																						AS [Estado],
    i.I_data																																																				AS [FechaCreacion],
    gru.Gru_nombre																																																			AS Asignado,
    tic.Tii_Nombre																																																			AS [TipoPropioDesglosado],
    CASE 
		WHEN tic.Id_Tii in (331,332,333)	THEN 'Product'
        WHEN tic.Id_Tii in (334,335,336)	THEN 'Sourcing'
        WHEN tic.Id_Tii in (337,338,339)	THEN 'BO'
        WHEN tic.Id_Tii in (340,341,342)	THEN 'Loading'
        WHEN tic.Id_Tii in (343,344,345)	THEN 'Operaciones'
        WHEN tic.Id_Tii in (346,347,348)	THEN 'Sales'
        WHEN tic.Id_Tii in (349,350,351)	THEN 'Web'
        WHEN tic.Id_Tii in (352,353,354)	THEN 'Finanzas'
        WHEN tic.Id_Tii in (355,356,357)	THEN 'BI'
        WHEN tic.Id_Tii in (358,359,360)	THEN 'IT'
        WHEN tic.Id_Tii in (361,362,363)	THEN 'Integraciones'
        WHEN tic.Id_Tii in (364,365,366)	THEN 'DMC'
        WHEN tic.Id_Tii IS NULL				THEN NULL
											ELSE 'OLD'
    END																																																						AS [TipoPropio],
    i.I_prioridadPM																																																			AS [PrioridadPM],
    I_TareaGAgrupacion																																																		AS [GANTT_Agrupacion],
    I_TareaGDescripcion																																																		AS [GANTT_Descripcion],
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
			)																																																				AS Etiquetas,
    CASE 
		WHEN I_porContrato = 1 AND I_porMantenimiento = 0	THEN 'Por contrato'
        WHEN I_porContrato = 1 AND I_porMantenimiento = 1	THEN 'Por mantenimiento'
        WHEN i.IncPresupuestoAceptado = 1					THEN 'Por bolsa de horas' 
															ELSE 'NO' 
	END																																																						AS PresupuestoAceptado,
    CONVERT(DATE,i.i_fechaenviopresupuesto,103)																																												as FecEnvioPresupuesto,
    CONVERT(DATE,i.I_fechaAceptacionPresupuesto,103)																																										as FecAceptacionPresupuesto,
    CONVERT(DATE,i.I_fechaInicioPrevista,103)																																												as FecInicioPrevista,
    CONVERT(DATE,i.I_fechaPactadaCliente,103)																																												as FecComprometidaCliente,
    DATEFROMPARTS(YEAR(I_fechaInicioPrevista), MONTH(I_fechaInicioPrevista), 1)																																				AS FInicio,
	CONCAT(MONTH(I_fechaPactadaCliente),'-',YEAR(I_fechaPactadaCliente))																																					as FRelease,
	MONTH(I_fechaPactadaCliente)																																															as FReleaseMonth,
	YEAR(I_fechaPactadaCliente)																																																as FReleaseYear,

    --************************************* ESTIMACION *************************************

    -- HORAS ESTIMACION: Horas contabilizadas con concepto "pre análisis", es decir, presupuesto aceptado para la estimación
    ISNULL((select sum(abs(hor_horas))
            from horas
            where HOR_concepto like '% pre %' and HOR_id_incidencia=i.id_Incidencia),0)																																		AS Horas_Estimacion,

    -- DEDICADO ESTIMACION: Horas no contabilizadas con el bit de HOR_PREanalisis a 1
    ISNULL((select sum(abs(hor_horas_no_cont))
            from horas
            where HOR_PM = 0 and HOR_PREanalisis = 1 and HOR_analisis = 0 and HOR_presupuestada = 0 and HOR_id_incidencia=i.id_Incidencia),0)																				AS Dedicado_Estimacion,

    -- DESVIO ESTIMACION: Presupuesto aceptado para la estimación menos las horas dedicadas a ello
    ISNULL((select sum(abs(hor_horas))
            from horas
            where HOR_concepto like '% pre %' and HOR_id_incidencia=i.id_Incidencia),0) - 
    ISNULL((select sum(abs(hor_horas_no_cont))
            from horas
            where HOR_PM = 0 and HOR_PREanalisis = 1 and HOR_analisis = 0 and HOR_presupuestada = 0 and HOR_id_incidencia=i.id_Incidencia),0)																				AS Desvio_Estimación,


    --************************************* ANALISIS *************************************

    -- HORAS ANALISIS: Horas contabilizadas con conepto "análisis", es decir, presupueto aceptado para el análisis
    ISNULL((select sum(abs(hor_horas))
            from horas
            where HOR_presupuestada = 1 and HOR_concepto like '%lisis%' and HOR_concepto not like '% pre %' and HOR_id_incidencia=i.id_Incidencia),0)																		as Horas_Analisis,

    -- DEDICADO ANALISIS: Horas no contabilizadas con el bit de HOR_analisis a 1        
    ISNULL((select sum(abs(hor_horas_no_cont))
            from horas
            where HOR_PM = 0 and HOR_PREanalisis = 0 and HOR_analisis = 1 and HOR_presupuestada = 0 and HOR_id_incidencia=i.id_Incidencia),0)																				as Dedicado_Analisis,

    -- DESVIO ANALISIS: Presupuesto aceptado para el análsis menos las horas dedicadas a ello
    ISNULL	(
				(select 
					sum(abs(hor_horas))
				from 
					horas
				where 
					HOR_presupuestada = 1 
					and HOR_concepto like '%lisis%' 
					and HOR_concepto not like '% pre %' 
					and HOR_id_incidencia=i.id_Incidencia
				),0
			) 
	-       
    ISNULL	(
				(select 
					sum(abs(hor_horas_no_cont))
				from 
					horas
				where 
					HOR_PM = 0 
					and HOR_PREanalisis = 0 
					and HOR_analisis = 1 
					and HOR_presupuestada = 0 
					and HOR_id_incidencia=i.id_Incidencia
				),0
			)																																																				as Desvio_Analisis,


    --************************************* DESARROLLO *************************************
    -- SI EL PRESUPUESTO SE HA RECHAZADO SE ELIMNAN LAS HORAS APROBADAS - CASO 879667
    -- HORAS DESARROLLO: Presupuesto desarrollo, incluye el margen y el testing. En Soportes será igual al Presupuesto_Total (suma de presupuestos aceptados)
    CASE 
        WHEN 
			i.IncPresupuestoAceptado = '1' 
			AND I_porContrato = 0 
			AND I_porMantenimiento = 0  
			THEN 
				CASE 
					WHEN i.I_HorasDesarrollo > 0 
						THEN ISNULL(i.I_HorasDesarrollo,0) 
					ELSE 
						ISNULL(i.IncValorMaximoPresupuestado,0)
				END
		ELSE 0 
    END																																																						AS Horas_Desarrollo,

    -- DEDICADO DESARROLLO: Horas no contabilizadas por un desarrollador durante la fase de desarrollo
    ISNULL((select sum(abs(HOR_horas_no_cont))
            from horas
            where HOR_PM = 0 and HOR_PREanalisis = 0 and HOR_analisis = 0 and HOR_presupuestada = 0 and HOR_id_incidencia=i.id_Incidencia),0)																				as Dedicado_Desarrollo,

    -- PORCENTAJE COMPLETADO: Porcentaje de horas dedicadas en relación a las presupuestadas (solo desarrollo)
    CASE 
        WHEN i.I_HorasDesarrollo > 0 THEN
            CAST((ISNULL((select sum(abs(HOR_horas_no_cont))
                        from horas
                        where HOR_PM = 0 and HOR_PREanalisis = 0 and HOR_analisis = 0 and HOR_presupuestada = 0 and HOR_id_incidencia=i.id_Incidencia),0)*100)/i.I_HorasDesarrollo AS INT) 
        ELSE 0 
    END AS Porcentaje_Completado,

    -- DESVIACION DESARROLLO: Solamente tiene en cuenta las horas dedicadas por un desarrollador en fase de desarrollo VS el presupuesto aceptado
    ISNULL((
    (CASE WHEN i.I_HorasDesarrollo > 0 THEN i.I_HorasDesarrollo WHEN i.IncValorMaximoPresupuestado > 0 THEN i.IncValorMaximoPresupuestado ELSE 0 END) -(select sum(abs(HOR_horas_no_cont))
                    from horas
                    where HOR_PM = 0 and HOR_PREanalisis = 0 and HOR_analisis = 0 and HOR_presupuestada = 0 and HOR_id_incidencia=i.id_Incidencia)),0)  AS Horas_Desviacion_Desarrollo,


    --************************************* PROJECT MANAGER *************************************

        -- ACEPTADO PM: Presupuesto de horas de gestión PM aceptado 
            ISNULL(i.I_horasPM,0) AS Aceptado_PM,

        -- DEDICADO PM: Horas no contabilizadas con el bit HOR_PM a 1
            ISNULL((select abs(sum(HOR_horas_no_cont))
            from horas
            where HOR_PM = 1 and HOR_PREanalisis = 0 and HOR_analisis = 0 and HOR_presupuestada = 0 and HOR_id_incidencia = i.id_incidencia),0) AS Dedicado_PM,

        -- DESVIACION PM: Presupuesto aceptado de PM menos las horas no contabilizadas por el PM
            (ISNULL(i.I_horasPM,0) - ISNULL((select sum(abs(HOR_horas_no_cont))
            from horas
            where HOR_PM = 1 and HOR_PREanalisis = 0 and HOR_analisis = 0 and HOR_presupuestada = 0 and HOR_id_incidencia = i.id_incidencia),0)) AS Horas_Desviacion_PM,


    --************************************* TOTALES *************************************
        -- PRESUPUESTO TOTAL: En Desarrollos incluye margen, testing y horas PM. En Soportes incluye todos los presupuestos aceptados.
            ISNULL(i.IncValorMaximoPresupuestado,0) as Presupuesto_Total,

        -- HORAS TOTAL CONTABILIZADAS: Horas contabilizadas menos los presupuestos aceptados. Si no están los presupuestos aceptados o se ha marcado por contrato mostrará todas la contabilizadas.
            CASE WHEN i.IncPresupuestoAceptado = '1' AND I_porContrato = 0 AND I_porMantenimiento = 0  THEN 
                ISNULL((sum(abs(hor_horas)))-i.IncValorMaximoPresupuestado,0) 
            ELSE
                ISNULL((sum(abs(hor_horas)))- (SELECT (sum(abs(hor_horas))) FROM HORAS where HOR_concepto like '%presupuesto%' and HOR_id_incidencia=i.id_Incidencia),0) 
            END as Horas_Contabilizadas,

        -- HORAS TOTAL COBRADAS: Total de horas contabilizadas incluyendo los presupuestos aceptados
            ISNULL(sum(abs(hor_horas)),0) AS Horas_Total_Cobradas,

        -- HORAS TOTAL DEDICADAS: Horas contabilizadas más las horas NO conabilizadas. Si hay presupuestos aceptados, se descuentan.
            CASE WHEN i.IncPresupuestoAceptado = '1' AND I_porContrato = 0 AND I_porMantenimiento = 0 THEN 
                ISNULL(sum(abs(hor_horas_no_cont)) + ((sum(abs(hor_horas))) - i.IncValorMaximoPresupuestado),0)
            ELSE 
                ISNULL(sum(abs(hor_horas_no_cont)) + ((sum(abs(hor_horas)))) - (SELECT (sum(abs(hor_horas))) FROM HORAS where HOR_concepto like '%presupuesto%' and HOR_id_incidencia=i.id_Incidencia),0)     
            END AS Horas_Total_Dedicadas,

        -- HORAS PM: Horas dedicadas con el bit HOR_PM a 1
            ISNULL((select abs(sum(HOR_horas_no_cont) + sum(HOR_horas))
            from horas
            where HOR_PM = 1 and HOR_PREanalisis = 0 and HOR_analisis = 0 and HOR_presupuestada = 0 and HOR_id_incidencia = i.id_incidencia),0) AS Horas_Totales_PM,


        -- DESVÍO TOTAL: Sumatorio de las desviaciones (Desvío estimación + Desvío análisis + Desvío desarrollo + Desvío PM)

            -- ESTMACIÓN
                ISNULL((select sum(abs(hor_horas))
                        from horas
                        where HOR_concepto like '% pre %' and HOR_id_incidencia=i.id_Incidencia),0) - 
                ISNULL((select sum(abs(hor_horas_no_cont))
                        from horas
                        where HOR_PM = 0 and HOR_PREanalisis = 1 and HOR_analisis = 0 and HOR_presupuestada = 0 and HOR_id_incidencia=i.id_Incidencia),0)

            -- ANALISIS
                +
                ISNULL((select sum(abs(hor_horas))
                    from horas
                    where HOR_presupuestada = 1 and HOR_concepto like '%lisis%' and HOR_concepto not like '% pre %' and HOR_id_incidencia=i.id_Incidencia),0) -       
                ISNULL((select sum(abs(hor_horas_no_cont))
                    from horas
                    where HOR_PM = 0 and HOR_PREanalisis = 0 and HOR_analisis = 1 and HOR_presupuestada = 0 and HOR_id_incidencia=i.id_Incidencia),0)
            -- DESARROLLO
                +
                ISNULL((
                (CASE WHEN i.I_HorasDesarrollo > 0 THEN i.I_HorasDesarrollo WHEN i.IncValorMaximoPresupuestado > 0 THEN i.IncValorMaximoPresupuestado ELSE 0 END) -(select sum(abs(HOR_horas_no_cont))
                            from horas
                            where HOR_PM = 0 and HOR_PREanalisis = 0 and HOR_analisis = 0 and HOR_presupuestada = 0 and HOR_id_incidencia=i.id_Incidencia)),0)

            -- PM  
                +          
                (ISNULL(i.I_horasPM,0) - ISNULL((select sum(abs(HOR_horas_no_cont))
                from horas
                where HOR_PM = 1 and HOR_PREanalisis = 0 and HOR_analisis = 0 and HOR_presupuestada = 0 and HOR_id_incidencia = i.id_incidencia),0)) AS Horas_Desviacion_Total_Presupuesto,

        -- DESVÍO GENERAL: Horas cobradas menos las horas dedicadas (Horas_Total_Cobradas - Horas_Total_Dedicadas)
            
            -- HORAS TOTAL COBRADAS
                ISNULL(sum(abs(hor_horas)),0) 

            -- HORAS TOTAL DEDICADAS
                -
                CASE WHEN i.IncPresupuestoAceptado = '1' AND I_porContrato = 0 AND I_porMantenimiento = 0 THEN 
                    ISNULL(sum(abs(hor_horas_no_cont)) + ((sum(abs(hor_horas))) - i.IncValorMaximoPresupuestado),0)
                ELSE 
                    ISNULL(sum(abs(hor_horas_no_cont)) + ((sum(abs(hor_horas)))),0)     
                END
            AS Horas_Desviación_Total_General,

        -- ID y TITULO de la incidencia
            CONCAT(i.Id_incidencia, ' - ', dbo.converthtml(i.I_asumpte)) AS ID_TITULO

FROM dbo.incidencia							i
	LEFT JOIN HORAS							h	on i.Id_incidencia = h.HOR_id_incidencia
    LEFT JOIN USUARI						u	ON u.Id_usuari = i.Id_usuari
    LEFT JOIN GRUPO_USUARIOS				gu	ON gu.Id_GrU = u.Id_GrU
    LEFT JOIN TIPO_INCIDENCIA				ti	ON TI.TI_id = i.I_tipus AND TI_Activo = 1
    LEFT JOIN Tbl_TiposIncidenciaCliente	tic	ON tic.Id_Tii = i.I_TipoIncidenciaCliente
    LEFT JOIN Tbl_IncidenciaQA				qa	ON qa.id_Incidencia = i.Id_incidencia
    LEFT JOIN usuari						us	ON i.Id_usuari = us.Id_usuari
    LEFT JOIN GRUPO_USUARIOS				gru	ON us.id_gru = gru.id_gru
    --LEFT OUTER JOIN INCIDENCIAUSUARI		iu	ON i.Id_incidencia = iu.Id_incidencia AND iu
WHERE 
	1 = 1
    AND i.a_codi = @idcliente
    AND ti.Ti_idGrupo IN (10) -- GRUPO INCIDENCIAS DESARROLLO   
    AND (i.I_estat <> 'C' OR (i.I_estat = 'C' AND I_fechacierre >= @fechacierre))
    AND (i.I_estat <> 'C')
    AND ti.TI_Etiqueta_Es	= ' 3. Desarrollo'
    AND NOT (
        (I_porContrato = 1 AND I_porMantenimiento = 0)
        OR (I_porContrato = 1 AND I_porMantenimiento = 1)
        OR(i.IncPresupuestoAceptado = 1)
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
	I_horasPM,
	I_porContrato, 
	I_porMantenimiento,
	tic.Id_Tii
ORDER BY 
	i.I_data DESC