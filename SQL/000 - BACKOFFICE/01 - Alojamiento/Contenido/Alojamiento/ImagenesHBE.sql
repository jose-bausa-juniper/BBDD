USE BD_Nincoming

-----------------------IMAGENES POR ALOJAMIENTO-----------------------
SELECT 
	Id_alo,
	LEFT(ImA_Ruta,LEN(ImA_Ruta) - CHARINDEX('/',REVERSE(ImA_Ruta),1)) AS [Carpeta],
	COUNT(*) AS COUNT
FROM 
	Tbl_ImagenesAlojamiento
WHERE 
	1 = 1
GROUP BY 
	Id_alo,
	LEFT(ImA_Ruta,LEN(ImA_Ruta) - CHARINDEX('/',REVERSE(ImA_Ruta),1))
--HAVING COUNT(Id_ImA) > 1
ORDER BY 
	COUNT DESC

-----------------------DIRECTORIO FOTOS ALOJAMIENTO-----------------------
--SELECT id_alo, Alo_DirFoto, FecCre
--FROM Tbl_Alojamiento 
--WHERE 1 = 1 
--	--AND Alo_DirFoto NOT LIKE CONCAT('hotels/',Id_alo) 
--	--AND Alo_DirFoto NOT LIKE CONCAT('/hotels/',Id_alo)
--ORDER BY Alo_DirFoto ASC

-----------------------IMAGENES FUERA DEL DIRECTORIO FOTOS ALOJAMIENTO-----------------------
SELECT 
	a.FecCre AS [FecCre],
	LEFT(ImA_Ruta,LEN(ImA_Ruta) - CHARINDEX('/',REVERSE(ImA_Ruta),1)) AS [Carpeta],
	a.Id_alo AS [ID_Alojamiento],
	a.Alo_DirFoto AS [Alo_DirFoto],
	COUNT (*) AS [Numero_Imagenes_X_Directorio]
FROM 
	Tbl_ImagenesAlojamiento ia
	FULL JOIN Tbl_Alojamiento a ON ia.Id_alo=a.Id_Alo
WHERE 1 = 1
	AND LEFT(ImA_Ruta,LEN(ImA_Ruta) - CHARINDEX('/',REVERSE(ImA_Ruta),1)) <> CONCAT('/', a.Alo_DirFoto)
GROUP BY 
	a.FecCre,
	LEFT(ImA_Ruta,LEN(ImA_Ruta) - CHARINDEX('/',REVERSE(ImA_Ruta),1)),
	a.Id_alo,
	a.Alo_DirFoto
ORDER BY
	[Numero_Imagenes_X_Directorio] DESC