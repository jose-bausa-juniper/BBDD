USE BD_Nincoming

DECLARE @PROV AS varchar(10); SET @PROV = 'AVT';
DECLARE @CODHOTEL INT; SET @CODHOTEL = 337637;
DECLARE @SUP INT; SET @SUP = 1;
DECLARE @CodCliente varchar(10); SET @CodCliente = 'W2M'

--[PRECIOS]--
SELECT COUNT(*) AS [PRECIOS]
FROM Tbl_AlojaSupplierPushPrecio 
WHERE Id_SPE IN 
                (
                SELECT Id_SPE
                FROM Tbl_AlojaSupplierPushElemento 
                WHERE Id_SuP = @SUP
                AND SPE_CodCliente = @CodCliente
				AND SPE_CodHotel = @CODHOTEL
                )

--[PRECIOS NIÑOS]--
SELECT COUNT(*) AS [PRECIOS NIÑOS]
FROM Tbl_AlojaSupplierPushPrecioNino 
WHERE Id_SPP IN 
                (
                SELECT Id_SPP
                FROM Tbl_AlojaSupplierPushPrecio 
				WHERE Id_SPE IN 
								(
								SELECT Id_SPE
								FROM Tbl_AlojaSupplierPushElemento 
								WHERE Id_SuP = @SUP
								AND SPE_CodCliente = @CodCliente
								AND SPE_CodHotel = @CODHOTEL
								)
                )