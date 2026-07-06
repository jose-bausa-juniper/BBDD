DECLARE @SEARCH VARCHAR(MAX) = '%prolog%'


SELECT
	p.P_codi,
	p.P_nom,
	pm.PM_TextoAdicional,
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
    END		
FROM
				agencias.dbo.PROJECTE p
	LEFT JOIN	agencias.dbo.PROJECTE_MODULO pm ON pm.P_codi = p.P_codi
WHERE 
	1= 1
	AND p.P_client = 18224
	AND pm.PM_TextoAdicional  LIKE @SEARCH
ORDER BY
	p.p_codi DESC,
	pm.PM_TextoAdicional DESC


SELECT
	p.P_codi,
	p.P_nom,
	pal.PalNombre,
    pal.PalCancelado                         AS [PAL_Cancelado]
FROM
				agencias.dbo.PROJECTE p
	LEFT JOIN	agencias.dbo.PROJECTE_ALTRES pal ON pal.PalProyecto = p.P_codi
WHERE 
	1= 1
	AND p.P_client = 18224
	AND pal.PalNombre LIKE @SEARCH
ORDER BY
	p.p_codi DESC,
	pal.PalNombre DESC