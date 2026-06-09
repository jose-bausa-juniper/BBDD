USE BD_Nincoming_HIS

SELECT 
	Id_His,
	CAST(
		CAST(
			DECOMPRESS (Haa_Cambios) AS XML
			) AS NVARCHAR(MAX)
		)
FROM Tbl_HistorialCambiosAlojaAccion
WHERE
	1 = 1
	AND Feccre BETWEEN '2025-09-22 11:00:00.000' AND '2025-09-22 11:05:00.000'
	AND UsrCre = 41796