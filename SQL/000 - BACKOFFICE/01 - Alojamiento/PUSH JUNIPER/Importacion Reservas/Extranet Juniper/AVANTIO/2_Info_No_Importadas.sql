DECLARE @XMLNS VARCHAR(MAX); SET @XMLNS = 'xmlns="http://www.juniper.es/webservice/2010/"';
DECLARE @LASTDATE DATETIME; SET @LASTDATE = '2025-01-01 00:00:00'
DECLARE @FAILLIST TABLE (DRe_codigoExt VARCHAR(MAX))
INSERT INTO @FAILLIST
	SELECT
		DR.DRe_codigoExt
	FROM
					BD_Nincoming_HIS.dbo.Tbl_DescargaReserva	DR
		LEFT JOIN	BD_Nincoming.dbo.vwQlik_JP_Externos			E	ON E.AlE_Prov = 'AVT' AND RIGHT(DR.DRe_IdAlo , LEN(DR.DRe_IdAlo)-CHARINDEX('|',DR.DRe_IdAlo)) = E.AlE_Cod
	WHERE
		1 = 1
		AND DR.DRe_CodigoSE = 57
		AND DR.DRe_IdAlo LIKE 'AVT|%'
	GROUP BY
		DR.DRe_codigoExt
	HAVING COUNT (DR.DRe_resLocalizador) = 0 AND MIN(DR.FecCre) > @LASTDATE

SELECT
	DR.DRe_resLocalizador																																	AS [Loc W2M],
	DR.DRe_codigoExt																																		AS [LOC JET2],
	DR.DRe_IdAlo																																			AS [ID Villa],
	DR.FecMod																																				AS [Fecha Lectura],
	XML.[XMLRS].value('(/ReadServiceResponseReadRS/Reservations/Reservation/Data/ReservationDate)[1]','datetime')											AS [ReservationDate_JET2],
	CONVERT	(TIME (0), 
			(DR.FecMod - (XML.[XMLRS].value('(/ReadServiceResponseReadRS/Reservations/Reservation/Data/TimeZone)[1]','varchar(max)'))) 
			- (XML.[XMLRS].value('(/ReadServiceResponseReadRS/Reservations/Reservation/Data/ReservationDate)[1]','datetime')),0)							AS DifereceTime,
	XML.[XMLRS].value('(/ReadServiceResponseReadRS/Reservations/Reservation/Data/LastModificationDate)[1]','datetime')										AS [LastModificationDate_JET2],
	XML.[XMLRS].value('(/ReadServiceResponseReadRS/Reservations/Reservation/Data/TimeZone)[1]','varchar(max)')												AS [TimeZone_JET2],
	XML.[XMLRS].value('(/ReadServiceResponseReadRS/Reservations/Reservation/Elements/ServiceElement/@Id)[1]','int')											AS [ID_LRE_JET2],
	XML.[XMLRS].value('(/ReadServiceResponseReadRS/Reservations/Reservation/Elements/ServiceElement/@Start)[1]','date')										AS [CheckIn],
	XML.[XMLRS].value('(/ReadServiceResponseReadRS/Reservations/Reservation/Elements/ServiceElement/@End)[1]','date')										AS [CheckOut],
	CONCAT(
		XML.[XMLRS].value('(/ReadServiceResponseReadRS/Reservations/Reservation/Holder/Name)[1]','varchar(max)'), ' ',
		XML.[XMLRS].value('(/ReadServiceResponseReadRS/Reservations/Reservation/Holder/Surname)[1]','varchar(max)'))										AS [Holder_Name]
FROM
				BD_Nincoming_HIS.dbo.Tbl_DescargaReserva	DR
	INNER JOIN	(
				SELECT
					HDR.id_HDR																																AS [XML_ID_HDR], 
					CAST( REPLACE(CAST((CAST(DECOMPRESS (HDR.HDR_RequestBin)AS XML)) AS NVARCHAR(MAX)), @XMLNS, '') AS XML)									AS [XMLRQ],
					CAST( REPLACE(CAST(CAST(DECOMPRESS (HDR.HDR_ResponseBin) AS XML) AS NVARCHAR(MAX)), @XMLNS, '') AS XML)									AS [XMLRS],
					HDR.FecCre																																AS [XML_HDR_FecCre]		
				FROM
					BD_Nincoming_HIS.dbo.Tbl_HistorialDescargaReserva HDR
				WHERE
					1 = 1
					AND HDR.HDR_CodigoSE = 57
				)											XML	ON DR.DRe_IdHDRRet = XML.[XML_ID_HDR]
WHERE
	1 = 1
	AND DR.DRe_CodigoSE = 57
	AND DR.DRe_IdAlo LIKE '%AVT|%'
	AND DR.DRe_codigoExt IN	(SELECT * FROM  @FAILLIST)
	
ORDER BY
	2 DESC