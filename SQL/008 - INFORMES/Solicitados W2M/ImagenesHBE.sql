USE BD_Nincoming

-----------------------------------------------------------------

-- SELECT 
-- 	(vjph.AlU_JPCode)
-- 	,(a.id_alo) AS HBE
-- FROM  
-- 				tbl_alojamiento						AS a  
-- 	LEFT JOIN	BD_Nincoming.dbo.vwQlik_JP_Hoteles	AS vjph	ON	vjph.AlE_Cod = CONVERT(VARCHAR(100),a.Id_Alo)
-- WHERE 1 = 1
-- 	AND vjph.AlE_Prov = 'J107'
-- ORDER BY
-- 	(vjph.AlU_JPCode) DESC

-----------------------------------------------------------------

-- SELECT MIN(Id_ImA),Id_alo, ImA_Ruta, ImA_Orden, COUNT(Id_ImA) AS COUNT
-- FROM Tbl_ImagenesAlojamiento
-- WHERE 1=1
-- GROUP BY Id_alo, ImA_Ruta, ImA_Orden
-- HAVING COUNT(Id_ImA) > 1
-- ORDER BY COUNT DESC

-----------------------------------------------------------------

-- SELECT 
-- MIN(Id_ImA) Id_ImA,
-- Id_alo,
-- ImA_Ruta,
-- ImA_Orden,
-- COUNT(Id_ImA) AS COUNT,
-- 'DELETE FROM Tbl_ImagenesAlojamiento WHERE Id_alo = '+cast(id_alo as varchar(100))+' AND ImA_Ruta = '''+ImA_Ruta+''' AND Id_ImA >'+cast(MIN(Id_ImA)as varchar(100)) AS Borrar
-- FROM Tbl_ImagenesAlojamiento
-- WHERE 1=1
-- GROUP BY Id_alo, ImA_Ruta, ImA_Orden
-- HAVING COUNT(Id_ImA) > 1
-- ORDER BY COUNT DESC

-----------------------------------------------------------------

SELECT id_alo, Alo_DirFoto, FecCre
FROM Tbl_Alojamiento 
WHERE 1 = 1 
AND Alo_DirFoto NOT LIKE CONCAT('hotels/',Id_alo)
ORDER BY Alo_DirFoto ASC

-----------------------------------------------------------------

SELECT id_alo, ImA_Ruta, FecCre
FROM Tbl_ImagenesAlojamiento 
WHERE 1 = 1 
AND ImA_Ruta NOT LIKE CONCAT('/hotels/',Id_alo,'%')
ORDER BY ImA_Ruta ASC

-----------------------------------------------------------------

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
	a.FecCre,
	a.Id_Alo