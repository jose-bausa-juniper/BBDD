USE agencias
SELECT 
    i.I_data									AS [Fecha],
    i.Id_incidencia								AS [Incidencia],
	iws.Int_Nombre								AS [Integrador],
	wsi.WSI_Nombre								AS [WebService],
	agencias.dbo.converthtml(i.I_asumpte)	    AS [Titulo],
	i.P_Codi								    AS [Proyecto]
	--i.I_ConexionAgencia							AS [Conexion],
	--i.I_estat									AS [Estado]

FROM 
				agencias.dbo.INCIDENCIA						i
	LEFT JOIN  BD_BookingEngine.dbo.Tbl_WSIntegraciones		wsi		ON wsi.Id_WSIntegraciones = i.Id_WSIntegraciones
	LEFT JOIN  BD_BookingEngine.dbo.Tbl_IntegradorWS		iws		ON iws.Id_Int = i.Id_Int

WHERE 
    1 = 1
    AND A_codi = 18224 -- W2M
	AND (P_Codi = 12772 OR P_Codi IS NULL)
	AND I_estat <> 'C' -- (E - En curso)
	AND (agencias.dbo.converthtml(I_asumpte) LIKE '%Soporte XML%' OR agencias.dbo.converthtml(I_asumpte) LIKE '%Conexi%')

	AND agencias.dbo.converthtml(I_asumpte) NOT LIKE '%Nueva petición de conexión%'
	AND Id_incidencia NOT IN (1105693,919896)
ORDER BY
    I_data DESC
