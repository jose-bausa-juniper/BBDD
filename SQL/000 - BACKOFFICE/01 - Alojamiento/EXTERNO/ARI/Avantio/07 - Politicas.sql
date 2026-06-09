USE BD_Nincoming

DECLARE @PROV AS varchar(10); SET @PROV = 'AVT';
DECLARE @CODHOTEL INT; SET @CODHOTEL = 337637;
DECLARE @SUP INT; SET @SUP = 1;
DECLARE @CodCliente varchar(10); SET @CodCliente = 'W2M'

--[POLITICAS]--
SELECT COUNT(*) AS [POLITICAS]
FROM Tbl_AlojaSupplierPushPoliticaCancelacion
WHERE Id_SPE IN 
				(
				SELECT Id_SPE
				FROM Tbl_AlojaSupplierPushElemento 
				WHERE Id_SuP = 1
				AND SPE_CodHotel = '336259'
				)

--[REGLAS POLITICAS]--
SELECT COUNT(*) AS [REGLAS POLITICAS]
FROM Tbl_AlojaSupplierPushPoliticaCancelacionRegla
WHERE Id_SPC IN 
                (
                SELECT Id_SPC
                FROM Tbl_AlojaSupplierPushPoliticaCancelacion
				WHERE Id_SPE IN 
								(
								SELECT Id_SPE
								FROM Tbl_AlojaSupplierPushElemento 
				WHERE Id_SuP = 1
				AND SPE_CodHotel = 336259
								)
                )
