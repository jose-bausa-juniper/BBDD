USE BD_Nincoming
SELECT
* 
FROM Tbl_AlojaSupplierPushElemento ASPE
INNER JOIN Tbl_AlojaSupplierPushPrecio ASPC  ON ASPC.Id_SPE = ASPE.Id_SPE
WHERE SPE_CodHotel = 'DAMKR' AND SPE_RatePlanCode IN ('O18FLEXBB') AND SPE_CodigoHabitacion = 'KR3' AND SPP_Mes = 308 AND SPP_PrecioBaseNoche = 358.6000
ORDER BY ASPC.FecMod

USE BD_BookingEngine
SELECT 
substring(SdT_Codigo, CHARINDEX('|',SdT_Codigo)+1, CHARINDEX('|',SdT_Codigo)+1) AS [Cod_Habitacion],
SdT_Descripcion																	AS [Descripcion_Habitacion],
substring(SdT_Codigo, 1, CHARINDEX('|',SdT_Codigo)-1)							AS [Cod_Hotel]
FROM Tbl_StaticDataTiposHabitacion WHERE SdT_Prov = 'DYS9' AND SdT_Codigo LIKE 'BAHOA|%'


SELECT raet.*
FROM TBL_ReservaAlojamientoExterno rae
INNER JOIN Tbl_ReservaAlojamientoExternoTarifa raet on raet.Id_LRE = rae.Id_LRe
WHERE RAE_tipoProducto = 'DYS9' AND RAE_AlojaID = 'BAHOA'


