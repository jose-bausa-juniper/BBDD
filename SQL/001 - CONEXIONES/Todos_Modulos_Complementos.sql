USE agencias
SELECT 
	--i.P_Codi								AS [I_Proyecto],	
	p.P_codi								AS [P_Proyecto],
    p.P_nom									AS [P_Nombre],
	--i.MOD_id								AS [I_MOD],
	--pm.MOD_ID								AS [PM_MOD],
 --   m.MOD_nombre_ES							AS [M_Nombre],
 --   pm.PM_TextoAdicional					AS [PM_Nombre],
    pa.PalNombre                            AS [PAL_Nombre_Complemento],
    pa.PalCancelado                         AS [PAL_Cancelado],
    CASE    p.p_estat
        WHEN 1 THEN 'Inicio'
        WHEN 2 THEN 'Diseño'
        WHEN 3 THEN 'Implantación'
        WHEN 4 THEN 'Testing'
        WHEN 5 THEN 'Preproducción'
        WHEN 6 THEN 'Producción'
        WHEN 7 THEN 'Acción comercial'
    END										AS [Estado Proyecto]
    --CASE    pm.PM_estado
    --    WHEN 0 THEN 'Live'
    --    WHEN 1 THEN 'StandBy'
    --    WHEN 2 THEN 'Cancelado'
    --    WHEN 3 THEN 'UnSet'
    --END										AS [Estado Módulo Proyecto]
FROM 

	agencias.dbo.PROJECTE                                   p	
    --LEFT JOIN	agencias.dbo.PROJECTE_MODULO                pm  ON (p.p_codi = pm.P_codi AND pm.PM_cancelado = 0)
    --LEFT JOIN	agencias.dbo.MODULO                         m   ON (pm.MOD_id = m.MOD_ID)
    INNER JOIN   agencias.dbo.PROJECTE_ALTRES                pa  ON (pa.PalProyecto = p.P_codi AND pa.PalCancelado = 0 )--AND pa.PalNombre IS NOT NULL)

WHERE 
    1 = 1
    AND p.P_client = 18224 -- W2M
    --AND pm.PM_estado IN (0,1,3) -- 0=Live;1=Standby;2=Cancelado;3=Unset
    --AND p.P_estat IN (6,3) -- 3=Implantacion;6=Producción;
    --AND (i.P_Codi = 12772 OR i.P_Codi IS NULL)
ORDER BY
    p.p_codi DESC



    --430
    --479
    --4675
    --4826
    --5080
    --5724
    --5930
    --6220
    --7010
    --7137
    --7421
    --7844
    --7891

