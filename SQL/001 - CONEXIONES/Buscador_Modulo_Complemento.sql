DECLARE @SEARCH VARCHAR(MAX) = '%Factory%'


SELECT
	p.P_codi,
	p.P_nom,
	pm.PM_TextoAdicional
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
	pal.PalNombre
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