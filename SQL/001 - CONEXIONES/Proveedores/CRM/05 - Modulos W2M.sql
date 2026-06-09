SELECT 

	mm.MpM_CodigoProducto                           AS [Producto],
	pm.MOD_ID                                       AS [ID Módulo PM],
	m.MOD_nombre_ES                                 AS [Nombre Modulo M],
	p.p_codi                                        AS [ID Proyecto P],
	p.P_nom                                         AS [Nombre Proyecto],
	CASE(pm.PM_estado)
		WHEN 0 THEN 'Live'
		WHEN 1 THEN	'Standby'
		WHEN 2 THEN	'Cancelado'
		WHEN 3 THEN	'Unset'	
	END												AS [Estado]
FROM
					agencias.dbo.PROJECTE                 p
	INNER JOIN      agencias.dbo.PROJECTE_MODULO          pm     ON pm.P_codi = p.P_codi
	INNER JOIN      agencias.dbo.MODULO                   m      ON m.MOD_id = pm.MOD_id
	INNER JOIN      agencias.dbo.tbl_MapeadoModulos       mm     ON mm.MOD_id = m.MOD_id
  
WHERE 
	1 = 1
	AND p.p_client = 18224
	AND p.P_cancelado = 0
	AND pm.PM_estado IN (0,1,2,3) -- 0=Live;1=Standby;2=Cancelado;3=Unset
GROUP BY
	p.P_codi,
	p.P_nom,
	pm.MOD_ID,
	pm.PM_estado,
	m.MOD_nombre_ES,
	mm.MpM_CodigoProducto