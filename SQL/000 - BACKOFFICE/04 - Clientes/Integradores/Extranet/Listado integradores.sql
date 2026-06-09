--bd_bookingengine.db.jun
USE agencias

SELECT 
I.Id_incidencia,
IWSb.Int_Nombre, 
IWSb.Int_Contacto, 
IWSb.Int_Mail,
WSI.WSI_Nombre,
WSI.WSI_RutaEspecificaciones
FROM INCIDENCIA I
INNER join Tbl_WSIntegraciones WSI ON I.Id_WSIntegraciones = WSI.Id_WSIntegraciones
INNER join BD_BookingEngine.dbo.Tbl_IntegradorWS IWSb ON I.Id_Int = IWSb.Id_Int
WHERE 1=1
AND I.A_codi = 18224
AND I.I_pasoLive = 1
AND I.I_estat = 'E'
AND I.I_ConexionAgencia = 0
AND I.Id_WSIntegraciones = 32
ORDER BY WSI.WSI_Nombre, IWSb.Int_Nombre

--bd_bookingengine.db.jun
USE agencias

SELECT 
I.Id_incidencia,
IWSb.Int_Nombre, 
IWSb.Int_Contacto, 
IWSb.Int_Mail,
WSI.WSI_Nombre,
WSI.WSI_RutaEspecificaciones
FROM INCIDENCIA I
INNER join Tbl_WSIntegraciones WSI ON I.Id_WSIntegraciones = WSI.Id_WSIntegraciones
INNER join BD_BookingEngine.dbo.Tbl_IntegradorWS IWSb ON I.Id_Int = IWSb.Id_Int
WHERE 1=1
AND I.A_codi = 18224
AND I.I_pasoLive = 1
AND I.I_estat = 'E'
AND I.I_ConexionAgencia = 0
AND I.Id_WSIntegraciones = 9
ORDER BY WSI.WSI_Nombre, IWSb.Int_Nombre
