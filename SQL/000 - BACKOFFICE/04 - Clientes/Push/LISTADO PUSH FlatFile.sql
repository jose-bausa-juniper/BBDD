--LISTADO FlatFile--
SELECT 
C.Id_Cli ,
C.Cli_Nombre AS Cliente ,
IWS.Int_Nombre AS Integrador ,
CFFP.Cfp_HotelEncriptado AS HotelEncriptado ,
CFFP.Cfp_Compresion AS Compresion ,
CFFP.Cfp_CarpetaUnica AS CarpetaUnica ,
CFFP.Cfp_ArbolZonas AS ArbolZonas ,
CFFP.Cfp_Idiomas AS Idiomas ,
CFFC.Cfc_Hora AS Hora ,
CFFC.Cfc_Dias AS Dias


FROM Tbl_Cliente C
INNER JOIN Tbl_ClienteFlatFileConfiguracion CFFC  ON CFFC.Id_Cli = C.Id_Cli
FULL JOIN Tbl_ClienteFlatFileParametro CFFP ON CFFC.Id_Cfp = CFFP.Id_Cfp
INNER JOIN Tbl_IntegradorWS IWS ON C.id_int = IWS.id_int
WHERE C.Cli_Activa = 1
ORDER BY 
Int_Nombre ,
C.Id_Cli ,
CFFC.Cfc_Hora 
ASC
