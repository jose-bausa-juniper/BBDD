
DECLARE @PROV AS varchar(10); SET @PROV = 'DY18';
SELECT 
	JP.ALU_JPCode,
	CONCAT(@PROV,'|',ASPE.SPE_CodHotel) AS [CodHotel],
	ASPE.SPE_CodHotel,
	ASPE.SPE_RatePlanCode,
	ASPE.SPE_CodigoHabitacion,
	ASPPC.SPC_Codigo,
	ASPPCR.*,
	ASPPCF.*
FROM vwQlik_JP_Externos										JP
INNER JOIN Tbl_AlojaSupplierPushElemento					ASPE	ON ASPE.SPE_CodHotel = JP.AlE_Cod AND ASPE.Id_SuP = 2
INNER JOIN Tbl_AlojaSupplierPushPoliticaCancelacion			ASPPC	ON ASPPC.Id_SPE = ASPE.Id_SPE 
INNER JOIN Tbl_AlojaSupplierPushPoliticaCancelacionRegla	ASPPCR	ON ASPPCR.Id_SPC = ASPPC.Id_SPC 
INNER JOIN Tbl_AlojaSupplierPushPoliticaCancelacionFecha	ASPPCF	ON ASPPCF.Id_SPC = ASPPC.Id_SPC
WHERE 
	1 = 1
	AND JP.AlE_Prov = @PROV
	AND ASPE.SPE_CodHotel = 'MEXHA'
	AND ASPE.SPE_RatePlanCode ='IDU15'
	AND ASPE.SPE_CodigoHabitacion = 'KEXG'
	AND ASPPCR.SPR_HoraLimite IS NOT NULL
ORDER BY
	ASPE.SPE_CodHotel,
	ASPE.SPE_RatePlanCode,
	ASPE.SPE_CodigoHabitacion
