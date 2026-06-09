DECLARE
@idcliente INT = 18224

SELECT
p.P_codi,
p.P_nom,
pm.PM_NombreSubModulo,
pm.PM_TextoAdicional

FROM agencias.dbo.PROJECTE p
LEFT JOIN agencias.dbo.ESTATS_PROJECTE ep ON ep.EP_id=p.P_estat
LEFT JOIN agencias.dbo.PROJECTE_MODULO pm ON pm.P_codi=p.P_codi

WHERE 1=1
AND p.P_client = @idcliente
AND p.P_cancelado = 0

GROUP BY 

p.P_codi,
p.P_nom,
pm.PM_NombreSubModulo,
pm.PM_TextoAdicional

ORDER BY 
p.P_codi,
pm.PM_NombreSubModulo,
pm.PM_TextoAdicional
