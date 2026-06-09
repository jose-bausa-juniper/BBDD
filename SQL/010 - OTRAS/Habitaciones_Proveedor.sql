USE BD_BookingEngine
SELECT 
substring(SdT_Codigo, CHARINDEX('|',SdT_Codigo)+1, CHARINDEX('|',SdT_Codigo)+1) AS [Cod_Habitacion],
SdT_Descripcion																	AS [Descripcion_Habitacion],
substring(SdT_Codigo, 1, CHARINDEX('|',SdT_Codigo)-1)							AS [Cod_Hotel]
FROM Tbl_StaticDataTiposHabitacion WHERE SdT_Prov = 'DYS9' AND SdT_Codigo LIKE 'DAMKR|%'