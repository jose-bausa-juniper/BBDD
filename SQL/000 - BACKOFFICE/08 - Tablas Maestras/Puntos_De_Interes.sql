--INTRANET
DECLARE @ID_ZON AS INT;
DECLARE @ZON	AS VARCHAR(MAX);

SET @ID_ZON = 36705;
SET @ZON = 'Palma de Mallorca'

SELECT 
POI.Id_POI																							AS [ID_PuntoInteres],
POIT.PTR_Name																						AS [PuntoInteres],
PTY.PTY_Name																						AS [Tipo_PuntoInteres],
POI.Id_Zon																							AS [ID_Zona],
CONCAT(Z1.Zon_Nombre_ES,' <-',Z2.Zon_Nombre_ES,' <-',Z3.Zon_Nombre_ES,' <-',Z4.Zon_Nombre_ES)		AS [Zona],
POI.POI_Lat																							AS [Latitud],
POI.POI_Lon																							AS [Longitud]
FROM			BD_JuniperMapping.dbo.Tbl_PointOfInterest				POI
	INNER JOIN	BD_JuniperMapping.dbo.Tbl_PointOfInterest_Type			PTY		ON PTY.id_PTY = POI.id_PTY
	INNER JOIN	BD_JuniperMapping.dbo.Tbl_PointOfInterest_Translation	POIT	ON POIT.id_POI = POI.id_POI
	INNER JOIN	BD_BookingEngine.dbo.Tbl_Zona							Z1		ON Z1.Id_Zon = POI.Id_Zon
	LEFT JOIN	BD_BookingEngine.dbo.Tbl_Zona							Z2		ON Z1.id_ZonPadre = Z2.id_zon
	LEFT JOIN	BD_BookingEngine.dbo.Tbl_Zona							Z3		ON Z2.id_ZonPadre = Z3.id_zon
	LEFT JOIN	BD_BookingEngine.dbo.Tbl_Zona							Z4		ON Z3.id_ZonPadre = Z4.id_zon
WHERE 
	1 = 1
	AND PTY.id_PTY <> 11
	AND (((Z1.Zon_Nombre_ES = @ZON or Z2.Zon_Nombre_ES = @ZON) or Z3.Zon_Nombre_ES = @ZON )or Z4.Zon_Nombre_ES = @ZON )
	--AND (((Z1.id_zon = @ID_ZON or Z2.id_zon = @ID_ZON) or Z3.id_zon = @ID_ZON )or Z4.id_zon = @ID_ZON )

ORDER BY 
	Z4.Id_Zon,
	Z3.Id_Zon,
	Z2.Id_Zon,
	Z1.Id_Zon
