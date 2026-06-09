USE BD_Nincoming;

SELECT 
    A.Id_Alo																								AS [Id_Alo],
    ANH.id_tha																								AS [Id_THA],
	value																									AS [VALUE]
	--LEFT(value,LEN(value) - CHARINDEX('/',REVERSE(value),1))												AS [RUTA ORIGEN],
	--RIGHT(value, CHARINDEX('/', REVERSE(value)) -1) 														AS [IMG],
	--CONCAT('hotels/',A.Id_Alo,'/Rooms/',ANH.Id_THa,'/',RIGHT(value, CHARINDEX('/', REVERSE(value)) -1))		AS [RUTA DESTINO],
	--ANH.ANT_Fotos
	FROM 
                Tbl_AloNTHa     ANH
    INNER JOIN  Tbl_Alojamiento A ON ANH.Id_Alo = A.Id_Alo
	CROSS APPLY STRING_SPLIT (ANH.ANT_Fotos, '?') 
ORDER BY
	ANT_Fotos,
	Id_Alo,
	Id_THa

/*FUTURO UPDATE DE RUTAS IMAGENES HABITACION*/
--SELECT REPLACE(ImH_Ruta, CONCAT('hotels/',Id_Alo), CONCAT('hotels/',Id_Alo,'/rooms/',Id_Tha)),* FROM Tbl_ImagenHabitacion