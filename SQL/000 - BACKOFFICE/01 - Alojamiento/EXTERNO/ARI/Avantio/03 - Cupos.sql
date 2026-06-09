USE BD_Nincoming
DECLARE @PROV AS varchar(10); SET @PROV = 'AVT';
DECLARE @CODHOTEL INT; SET @CODHOTEL = 337614;
DECLARE @SUP INT; SET @SUP = 1;
DECLARE @CodCliente varchar(10); SET @CodCliente = 'W2M'

--[CUPO]--
SELECT 
    *,
    CONCAT(
        CAST(YEAR(GETDATE()) AS VARCHAR(4)),
        ' - ',
        CAST((SPC_Mes - ((YEAR(GETDATE()) - 2000) * 12)) AS VARCHAR(2))
    ) AS [MES],
    (
        SELECT STRING_AGG(CAST(pos AS VARCHAR), ',')
        FROM (
            SELECT TOP 32 
                ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS pos
            FROM sys.all_objects
        ) AS Bits
        WHERE (CAST(CONVERT(BIGINT, SPC_Dias) AS BIGINT) / POWER(CAST(2 AS BIGINT), pos)) % 2 = 0
    ) AS [DIAS]
FROM Tbl_AlojaSupplierPushCupo
WHERE 
    SPC_Mes = 309
    AND Id_SPE IN (
        SELECT Id_SPE 
        FROM Tbl_AlojaSupplierPushElemento 
        WHERE Id_SuP = @SUP
          AND SPE_CodCliente = @CodCliente
          AND SPE_CodHotel = @CODHOTEL
    )
ORDER BY 
    [MES] ASC,
    [DIAS] ASC;























SELECT 
	*,
	CONCAT(
			CAST(YEAR(GETDATE())AS VARCHAR (4)),
			' - ',
			CAST((SPC_Mes -((YEAR(GETDATE())-2000)*12)) AS VARCHAR (2))
	)                                                                                               AS [MES],
    (
        SELECT STRING_AGG(CAST(pos AS VARCHAR), ',')
        FROM (
            SELECT TOP 32 
                ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS pos
            FROM sys.all_objects
        ) AS Bits
        WHERE (CONVERT(BIGINT, SPC_Dias) & POWER(CAST(2 AS BIGINT), pos)) = 0
    )                                                                                               AS [DIAS]
FROM Tbl_AlojaSupplierPushCupo
WHERE 
	1 = 1
	AND SPC_Mes = 309
	AND Id_SPE IN 
                (
                SELECT Id_SPE 
                FROM Tbl_AlojaSupplierPushElemento 
                WHERE Id_SuP = @SUP
                AND SPE_CodCliente = @CodCliente
				AND SPE_CodHotel = @CODHOTEL
                )
ORDER BY 
    [MES] ASC,
    [DIAS] ASC