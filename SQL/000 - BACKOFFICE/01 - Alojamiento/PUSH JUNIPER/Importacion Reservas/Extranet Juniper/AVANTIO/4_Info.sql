/* DECLARAMOS TABLAS INTERMEDIAS Y XMLNS */
DECLARE @XMLNS VARCHAR(MAX) = 'xmlns="http://www.juniper.es/webservice/2010/"';
DECLARE @LOCS TABLE (LOC_JET2 NVARCHAR(200), LOC_W2M NVARCHAR(100));
DECLARE @VILLAS TABLE (PROV VARCHAR(5), ID_VILLA VARCHAR (50), VILLA  VARCHAR (150));
DECLARE @DESCARGAS TABLE (LOC_W2M NVARCHAR(100), LOC_JET2 NVARCHAR(200), ID_HISRET INT, ID_ALO NVARCHAR(100), FECMOD DATETIME);
DECLARE @XMLS TABLE ([XML_ID_HDR] INT, [XMLRQ] XML, [XMLRS] XML);

/* DEFINIMOS LOS LOCALIZADORES A BUSCAR */
INSERT INTO @LOCS
VALUES
--(LOC_JET2,LOC_W2M)

('NRXKG6~58195177~20157086/S26H','1KD81L') --> OV BOK

/* EXTRAEMOS LAS VILLAS */
INSERT INTO @VILLAS
	SELECT
		AlE_Prov,
		AlE_Cod,
		AlE_Nombre
	FROM 
		BD_Nincoming.dbo.vwQlik_JP_Externos
	WHERE
		1 = 1 
		AND AlE_Prov = 'AVT'

/* EXTRAEMOS LAS DESCARGAS */
INSERT INTO @DESCARGAS
SELECT
	DRe_resLocalizador,
	DRe_codigoExt,
	MAX(DRe_IdHDRRet),
	DRe_IdAlo,
	MAX(FecMod) AS MAX_FECMOD
FROM 
	BD_Nincoming_HIS.dbo.Tbl_DescargaReserva 
WHERE 
	1 = 1
	AND DRe_CodigoSE = 57 
	AND DRe_IdAlo LIKE '%AVT|%'
GROUP BY
	DRe_resLocalizador,
	DRe_codigoExt,
	DRe_IdAlo
ORDER BY
	MAX_FECMOD DESC

/* EXTRAEMOS LOS XMLS */
INSERT INTO @XMLS
	SELECT
		HDR.id_HDR																								AS [XML_ID_HDR], 
		CAST( REPLACE(CAST((CAST(DECOMPRESS (HDR.HDR_RequestBin)AS XML)) AS NVARCHAR(MAX)), @XMLNS, '') AS XML)	AS [XMLRQ],
		CAST( REPLACE(CAST(CAST(DECOMPRESS (HDR.HDR_ResponseBin) AS XML) AS NVARCHAR(MAX)), @XMLNS, '') AS XML)	AS [XMLRS]
	FROM
		BD_Nincoming_HIS.dbo.Tbl_HistorialDescargaReserva HDR
	WHERE
		1 = 1
		AND HDR.HDR_CodigoSE = 57

-----------------------------------------------------------------------------------
-- QUERY PRINCIPAL
-----------------------------------------------------------------------------------

SELECT 
	DISTINCT
	--CASE
	--	WHEN LOCS.[LOC_W2M] IS NULL THEN 'NO IMPORTADA'
	--	WHEN LOCS.[LOC_W2M] IS NOT NULL THEN 'MAL IMPORTADA'
	--END AS 'CASO',
	INFO.*
FROM 	
				@LOCS	LOCS
	LEFT JOIN	(SELECT
					DR.LOC_W2M																				AS [LOC W2M],
					DR.LOC_JET2																				AS [FULL LOC JET2],
					DR.ID_ALO																				AS [ID Villa],
					V.VILLA																					AS [Nombre Villa],
					DR.FECMOD																				AS [Fecha Lectura],
					R.value('@Locator'												, 'VARCHAR(20)')		AS [LOC JET2],
					R.value('(Data/ReservationDate)[1]'								, 'DATETIME')			AS [ReservationDate_JET2],
					
					CAST(DATEDIFF(MINUTE, R.value('(Data/ReservationDate)[1]', 'DATETIME'), GETDATE()) / 1440 AS VARCHAR) + ' días ' +
   					CAST((DATEDIFF(MINUTE, R.value('(Data/ReservationDate)[1]', 'DATETIME'), GETDATE()) % 1440) / 60 AS VARCHAR) + ' horas ' +
   					CAST(DATEDIFF(MINUTE, R.value('(Data/ReservationDate)[1]', 'DATETIME'), GETDATE()) % 60 AS VARCHAR) + ' minutos' AS DifereceTime_CreationJET2_NOW,

					CAST(DATEDIFF(MINUTE, DR.FECMOD, GETDATE()) / 1440 AS VARCHAR) + ' días ' +
   					CAST((DATEDIFF(MINUTE, DR.FECMOD, GETDATE()) % 1440) / 60 AS VARCHAR) + ' horas ' +
   					CAST(DATEDIFF(MINUTE, DR.FECMOD, GETDATE()) % 60 AS VARCHAR) + ' minutos'				AS DifereceTime_LastRead_NOW,

					R.value('(Data/LastModificationDate)[1]'						, 'DATETIME')			AS [LastModificationDate_JET2],
					--R.value('(Data/TimeZone)[1]'									, 'VARCHAR(10)')		AS [TimeZone_JET2],
					R.value('(Elements/ServiceElement/@Id)[1]'						, 'BIGINT')				AS [ID_LRE_JET2],
					R.value('(Elements/ServiceElement/Status)[1]'					, 'VARCHAR(10)')		AS [Status_JET2],
					R.value('(Elements/ServiceElement/@Start)[1]'					, 'DATE')				AS [CheckIn],
					R.value('(Elements/ServiceElement/@End)[1]'						, 'DATE')				AS [CheckOut],
					R.value('(Elements/ServiceElement/Prices/Cost/@Amount)[1]'		, 'FLOAT')				AS [Cost_Amount]
				FROM
								@DESCARGAS															AS DR	
					LEFT JOIN	@VILLAS																AS V	ON	RIGHT(DR.ID_ALO , LEN(DR.ID_ALO)-CHARINDEX('|',DR.ID_ALO)) = V.ID_VILLA
					LEFT JOIN	@XMLS																AS XMLS	ON  DR.ID_HISRET = XMLS.XML_ID_HDR
					CROSS APPLY 
						[XMLS].[XMLRS].nodes('/ReadServiceResponseReadRS/Reservations/Reservation') AS X(R)
				WHERE
					1 = 1
					AND LEFT(DR.LOC_JET2, CHARINDEX('~', DR.LOC_JET2) - 1) = R.value('@Locator', 'VARCHAR(20)')
					AND DR.LOC_JET2 IN (SELECT LOC_JET2 FROM @LOCS)
				) 
				INFO ON INFO.[FULL LOC JET2] = LOCS.LOC_JET2
WHERE
	1 = 1
	
	AND (LOCS.[LOC_W2M] IS NULL	OR INFO.[LOC W2M] IS NOT NULL)
	--AND INFO.[Status_JET2] <> 'CN'
	AND INFO.CheckIn >= GETDATE()
	--AND INFO.[LOC W2M] IN ('58684J','YNBW6F')

	
ORDER BY
	INFO.CheckIn ASC,
	INFO.[LOC W2M],
	INFO.[ReservationDate_JET2]