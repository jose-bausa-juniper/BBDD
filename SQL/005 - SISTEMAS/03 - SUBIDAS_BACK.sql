SELECT 
	W.id_BDD																																AS [BBDD],
	W.id_WEB																																AS [WEB],
	GS.Grs_Nombre																															AS [GRUPO SERVIDOR],
	CASE 
		WHEN CHARINDEX('_', CE.his_operativa) > 0 THEN 
			LEFT(
				RIGHT(CE.his_operativa, LEN(CE.his_operativa) - CHARINDEX('_', CE.his_operativa)),
				CHARINDEX('.', RIGHT(CE.his_operativa, LEN(CE.his_operativa) - CHARINDEX('_', CE.his_operativa))) - 1
			)
		ELSE NULL
	END																																		AS [APP],
	CASE CE.his_entorno
		WHEN 'INTRANET'	THEN 'CER'
		WHEN 'CERANT' THEN 'CERANT'
	 END																																	AS [ENTORNO],
	CE.his_fechamod																															AS [FECHA],
	CE.dllversion																															AS [DLL],
	CE.his_title																															AS [OPERACION]
FROM 
					bd_mantenimiento.dbo.Tbl_ControlErroresHis	CE
	CROSS APPLY		STRING_SPLIT(CE.his_servidores, ',')		LS
	JOIN			bd_mantenimiento.dbo.Tbl_Servidores			S	ON S.ser_id = LS.value
	LEFT JOIN		bd_mantenimiento.dbo.Tbl_GrupoServidores	GS	ON GS.Id_grs = S.Id_Grs
	INNER join		BD_BookingEngine.dbo.Tbl_Web				W	ON (W.Id_grs = GS.Id_grs OR W.id_grsext = GS.Id_grs)
WHERE
	1 = 1
	AND id_BDD = 107
	--AND id_WEB = 1178
GROUP BY
	W.id_BDD,
	W.id_WEB,
	GS.Grs_Nombre,
	his_title,
	his_operativa,
	his_fechamod,
	his_entorno,
	dllversion
ORDER BY 
	--WEB DESC,
	FECHA DESC