USE BD_Nincoming

DECLARE @PROV AS varchar(10); SET @PROV = 'AVT';
DECLARE @CODHOTEL INT; SET @CODHOTEL = 337637;
DECLARE @SUP INT; SET @SUP = 1;
DECLARE @CodCliente varchar(10); SET @CodCliente = 'W2M'

--[RESTRICCIONES]--
SELECT COUNT(*) AS [RESTRICCIONES] 
FROM Tbl_AlojaSupplierPushRestriccion
WHERE Id_SPE IN 
                (
                SELECT Id_SPE
                FROM Tbl_AlojaSupplierPushElemento 
                WHERE Id_SuP = @SUP
                AND SPE_CodCliente = @CodCliente
				AND SPE_CodHotel = @CODHOTEL
                )