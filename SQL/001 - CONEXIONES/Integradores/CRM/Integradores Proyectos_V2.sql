USE agencias
SELECT 
    i.Id_incidencia                         AS [I_Incidencia],
	agencias.dbo.converthtml(i.I_asumpte)	AS [I_Titulo],
	--i.P_Codi								AS [I_Proyecto],	
	p.P_codi								AS [P_Proyecto],
    p.P_nom									AS [P_Nombre],
	--i.MOD_id								AS [I_MOD],
	pm.MOD_ID								AS [PM_MOD],
	i.I_idPM								AS [I_PMOD],
    m.MOD_nombre_ES							AS [M_Nombre],
    pm.PM_TextoAdicional					AS [PM_Nombre],
    pa.PalNombre                            AS [PAL_Nombre_Complemento],
    pa.PalCancelado                         AS [PAL_Cancelado],
	iws.int_nombre							AS [IWS_Nombre],
    CASE    p.p_estat
        WHEN 1 THEN 'Inicio'
        WHEN 2 THEN 'Diseño'
        WHEN 3 THEN 'Implantación'
        WHEN 4 THEN 'Testing'
        WHEN 5 THEN 'Preproducción'
        WHEN 6 THEN 'Producción'
        WHEN 7 THEN 'Acción comercial'
    END										AS [Estado Proyecto],
    CASE    pm.PM_estado
        WHEN 0 THEN 'Live'
        WHEN 1 THEN 'StandBy'
        WHEN 2 THEN 'Cancelado'
        WHEN 3 THEN 'UnSet'
    END										AS [Estado Módulo Proyecto]
FROM 
				agencias.dbo.INCIDENCIA						i
	LEFT JOIN	agencias.dbo.TIPO_INCIDENCIA			    ti	ON ti.TI_id = i.I_tipus
	LEFT JOIN	agencias.dbo.PROJECTE                       p	ON (p.P_codi = i.P_Codi)
    LEFT JOIN	agencias.dbo.PROJECTE_MODULO                pm  ON (p.p_codi = pm.P_codi AND i.I_idPM = pm.Id_PM)
    LEFT JOIN	agencias.dbo.MODULO                         m   ON (pm.MOD_id = m.MOD_ID)
	LEFT JOIN	BD_BookingEngine.dbo.Tbl_IntegradorWS		iws ON (iws.Id_Int = i.Id_Int)
    LEFT JOIN   agencias.dbo.PROJECTE_ALTRES                pa  ON ((CONCAT('%',pa.PalNombre,'%') LIKE CONCAT('%',iws.int_nombre,'%')) AND (pa.PalProyecto = p.P_codi) AND (pa.PalCancelado = 0))

WHERE 
    1 = 1
    AND i.A_codi = 18224 -- W2M
	AND i.I_estat <> 'C' -- (E - En curso) 
	AND ti.TI_id = 16 -- (16 - Soporte XML)
	AND i.I_ConexionAgencia = 0
    --AND pm.PM_estado IN (0,1,3) -- 0=Live;1=Standby;2=Cancelado;3=Unset
    --AND p.P_estat IN (6,3) -- 3=Implantacion;6=Producción;
    AND (i.P_Codi = 12772 OR i.P_Codi IS NULL)
ORDER BY
    i.Id_incidencia DESC
