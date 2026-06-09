USE BD_Nincoming

DECLARE @PROV AS varchar(10); SET @PROV = 'AVT';
DECLARE @CODHOTEL INT; SET @CODHOTEL = 337614;
DECLARE @SUP INT; SET @SUP = 1;
DECLARE @CodCliente varchar(10); SET @CodCliente = 'W2M'

--[FICHAS]--
SELECT COUNT(*) AS [FICHAS]
FROM vwQlik_JP_Externos 
WHERE AlE_Prov = @PROV
--AND AlE_Cod = @CODHOTEL

SELECT AlE_Cod, AlE_Nombre, ALU_JPCode, AlE_Latitud, AlE_Longitud
FROM vwQlik_JP_Externos 
WHERE AlE_Prov = @PROV
AND AlE_Cod = @CODHOTEL
ORDER BY AlE_Nombre