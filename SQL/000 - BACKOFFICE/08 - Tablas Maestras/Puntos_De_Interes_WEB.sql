--WEB
SELECT 
	PI.id_POI,
	--PI.POI_Code,
	--PII.id_PII,
	PII.PII_Idioma				AS [Idioma],
	PII.PII_Nombre				AS [Nombre],
	--PII.PII_Region,
	PI.POI_Latitud				AS [Latitud],
	PI.POI_Longitud				AS [Longitud],
	PI.POI_Tipo					AS [Tipo]
	--PI.POI_Activo,
	--PI.POI_Pais,
	--PI.POI_geoManual
FROM			BD_BookingEngine.dbo.Tbl_PuntosInteres					PI
	INNER JOIN	BD_BookingEngine.dbo.Tbl_PuntosInteresIdioma			PII		ON PII.id_POI = PI.id_POI
WHERE 
	1 = 1
	AND PI.POI_Activo = 1 
	--AND PII.PII_Idioma IN ('ES')
	AND PII.PII_Idioma IN ('ES','PT','EN')
	--AND (PI.POI_Latitud >= 39.503726 AND PI.POI_Latitud <=39.5522414548141)
	--AND (PI.POI_Longitud >= 2.69679164834087 AND PI.POI_Longitud <=2.75562)
ORDER BY 
	PI.id_POI