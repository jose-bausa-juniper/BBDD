--USE BD_Nincoming

DECLARE
@idcliente INT = 18224

SELECT
a.A_nom AS [Cliente],
a_i.Id_incidencia AS [Incidencia],
a_ti.TI_Etiqueta_Es AS [Tipo],
agencias.dbo.converthtml(a_i.I_asumpte) AS [Titulo]

FROM agencias.dbo.INCIDENCIA a_i
INNER JOIN agencias.dbo.AGENCIA a ON a.A_codi=a_i.A_codi
INNER JOIN agencias.dbo.TIPO_INCIDENCIA a_ti ON a_ti.TI_id = a_i.I_tipus
INNER JOIN agencias.dbo.PROJECTE a_p ON a_p.P_codi=a_i.P_Codi
INNER JOIN agencias.dbo.PROJECTE_MODULO a_pm ON a_pm.P_codi=a_p.P_Codi

WHERE 1=1
AND a_i.A_codi = @idcliente
AND a_i.I_data >= '2023'
AND (agencias.dbo.converthtml(a_i.I_asumpte) LIKE '%derby%' OR agencias.dbo.converthtml(a_i.I_asumpte) LIKE '%Wyndham%' OR agencias.dbo.converthtml(a_i.I_asumpte) LIKE '%DYS6%')
AND (a_ti.TI_Etiqueta_Es Like '%rror' OR a_ti.TI_Etiqueta_Es Like '%rror%' OR a_ti.TI_Etiqueta_Es Like '%sarroll%')

GROUP BY a.A_nom, a_i.Id_incidencia, a_ti.TI_Etiqueta_Es, a_i.I_asumpte

ORDER BY a_ti.TI_Etiqueta_Es, a.A_nom, a_i.Id_incidencia