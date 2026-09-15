USE agencias
SELECT 
	p.P_codi								AS [P_Proyecto],
    p.P_nom									AS [P_Nombre],
    CASE    p.p_estat
        WHEN 1 THEN 'Inicio'
        WHEN 2 THEN 'Diseño'
        WHEN 3 THEN 'Implantación'
        WHEN 4 THEN 'Testing'
        WHEN 5 THEN 'Preproducción'
        WHEN 6 THEN 'Producción'
        WHEN 7 THEN 'Acción comercial'
    END										AS [Estado Proyecto],    
	pm.MOD_ID								AS [PM_MOD],
    m.MOD_nombre_ES							AS [M_Nombre],
    pm.Id_PM                                AS [ID_PM],
    pm.PM_TextoAdicional					AS [PM_Nombre],
    CASE    pm.PM_estado
       WHEN 0 THEN 'Live'
       WHEN 1 THEN 'StandBy'
       WHEN 2 THEN 'Cancelado'
       WHEN 3 THEN 'UnSet'
    END										AS [Estado Módulo Proyecto],
    pa.PalNombre                            AS [PAL_Nombre_Complemento],
    CASE PA.PAlEstado
        WHEN 0 THEN 'Live'
        WHEN 1 THEN 'StandBy'
        WHEN 2 THEN 'Cancelado'
        WHEN 3 THEN 'UnSet'
    END					                AS [Estado Complemento]
FROM 

	            agencias.dbo.PROJECTE                       p	
    LEFT JOIN	agencias.dbo.PROJECTE_MODULO                pm  ON (p.p_codi = pm.P_codi AND pm.PM_cancelado = 0)
    LEFT JOIN	agencias.dbo.MODULO                         m   ON (pm.MOD_id = m.MOD_ID)
    LEFT JOIN   agencias.dbo.PROJECTE_ALTRES                pa  ON (pa.PalProyecto = p.P_codi AND pa.PalCancelado = 0 )

WHERE 
    1 = 1
    AND p.P_client = 18224 -- W2M
ORDER BY
    p.p_codi DESC