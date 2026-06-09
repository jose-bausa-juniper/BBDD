USE BD_Nincoming

DECLARE @PROV AS varchar(10); SET @PROV = 'AVT';
DECLARE @CODHOTEL INT; SET @CODHOTEL = 337614 ;
DECLARE @SUP INT; SET @SUP = 1;
DECLARE @CodCliente varchar(10); SET @CodCliente = 'W2M'

SELECT 
	FecMod AS [LAST UPDATE],
	SPE_CodHotel,
	SPE_VersionExterna
	,*
FROM Tbl_AlojaSupplierPushElemento 
WHERE Id_SuP = @SUP
AND SPE_CodCliente = @CodCliente
AND SPE_CodHotel = @CODHOTEL
ORDER BY
	[LAST UPDATE] DESC

