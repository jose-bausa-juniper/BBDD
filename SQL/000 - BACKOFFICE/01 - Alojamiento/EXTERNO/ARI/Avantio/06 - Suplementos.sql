USE BD_Nincoming

DECLARE @PROV AS varchar(10); SET @PROV = 'AVT';
--DECLARE @CODHOTEL INT; SET @CODHOTEL = 337816;
DECLARE @SUP INT; SET @SUP = 1;
DECLARE @CodCliente varchar(10); SET @CodCliente = 'W2M'

--SELECT *
--FROM Tbl_AlojaSupplierPushSuplementoDescuentoElemento
--WHERE 	Id_SPE 	IN 
--				(
--				SELECT Id_SPE
--				FROM Tbl_AlojaSupplierPushElemento 
--				WHERE Id_SuP = @SUP
--				AND SPE_CodCliente = @CodCliente
--				AND Id_SSD IN (459087,463636,459076,480238,811213,458899,811201,486588)
--				--AND SPE_CodHotel = @CODHOTEL
--				)


--SELECT *
--FROM Tbl_AlojaSupplierPushSuplementoDescuento
--WHERE 	
--1 = 1
--AND SSD_CodigoExterno = 21071
--AND Id_SSD 	IN 
--				(
--				SELECT Id_SSD
--				FROM Tbl_AlojaSupplierPushSuplementoDescuentoElemento
--				WHERE Id_SPE IN 
--								(
--								SELECT Id_SPE
--								FROM Tbl_AlojaSupplierPushElemento 
--								WHERE Id_SuP = @SUP
--								AND SPE_CodCliente = @CodCliente
--								--AND SPE_CodHotel = @CODHOTEL
--								)
--				)

SELECT DISTINCT(SPE_CodHotel)
FROM Tbl_AlojaSupplierPushElemento

WHERE Id_SuP = 1
AND SPE_CodCliente = @CodCliente
AND Id_SPE IN (

SELECT Id_SPE
FROM Tbl_AlojaSupplierPushSuplementoDescuentoElemento
WHERE 	Id_SPE 	IN 
				(
				SELECT Id_SPE
				FROM Tbl_AlojaSupplierPushElemento 
				WHERE Id_SuP = @SUP
				AND SPE_CodCliente = @CodCliente
				AND Id_SSD IN (459087,463636,459076,480238,811213,458899,811201,486588)
				--AND SPE_CodHotel = @CODHOTEL
				))