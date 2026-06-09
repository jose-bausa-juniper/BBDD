SELECT
	CAST(DECOMPRESS (NSE_BinXmlErrores)AS XML).value('(/ErroresXML/ejecucion/errores)[1]','varchar(max)')																AS [ERRORES],
	CAST(DECOMPRESS (NSE_BinXmlErrores)AS XML).value('(/ErroresXML/ejecucion/avisos)[1]','varchar(max)')																AS [AVISOS],
	DR.DRe_resLocalizador																																				AS [Loc W2M],
	DR.DRe_codigoExt																																					AS [LOC JET2],
	DR.DRe_IdAlo																																						AS [ID Villa],
	E.AlE_Nombre																																						AS [Nombre Villa],
	DR.FecMod																																							AS [Fecha Lectura],
	XML.[XMLRS].value('(/ReadServiceResponseReadRS/Reservations/Reservation/Data/ReservationDate)[1]','datetime')														AS [ReservationDate_JET2],
	XML.[XMLRS].value('(/ReadServiceResponseReadRS/Reservations/Reservation/Data/LastModificationDate)[1]','datetime')													AS [LastModificationDate_JET2],
	XML.[XMLRS].value('(/ReadServiceResponseReadRS/Reservations/Reservation/Data/TimeZone)[1]','varchar(max)')															AS [TimeZone_JET2],
	XML.[XMLRS].value('(/ReadServiceResponseReadRS/Reservations/Reservation/Elements/ServiceElement/@Start)[1]','date')													AS [CheckIn],
	XML.[XMLRS].value('(/ReadServiceResponseReadRS/Reservations/Reservation/Elements/ServiceElement/@End)[1]','date')													AS [CheckOut]
FROM
				(SELECT
					HDR.id_HDR																																			AS [XML_ID_HDR], 
					CAST( REPLACE(CAST((CAST(DECOMPRESS (HDR.HDR_RequestBin)AS XML)) AS NVARCHAR(MAX)), 'xmlns="http://www.juniper.es/webservice/2010/"', '') AS XML)	AS [XMLRQ],
					CAST( REPLACE(CAST(CAST(DECOMPRESS (HDR.HDR_ResponseBin) AS XML) AS NVARCHAR(MAX)), 'xmlns="http://www.juniper.es/webservice/2010/"', '') AS XML)	AS [XMLRS],
					HDR.FecCre																																			AS [XML_HDR_FecCre]		
				FROM
					BD_Nincoming_HIS.dbo.Tbl_HistorialDescargaReserva HDR
				WHERE
					1 = 1
					AND HDR.HDR_CodigoSE = 57
				)																XML	
	INNER JOIN	BD_Nincoming_HIS.dbo.Tbl_DescargaReserva						DR		ON DR.DRe_IdHDRRet = XML.[XML_ID_HDR]
	LEFT JOIN	BD_Nincoming.dbo.vwQlik_JP_Externos								E		ON E.AlE_Prov = 'AVT' AND RIGHT(DR.DRe_IdAlo , LEN(DR.DRe_IdAlo)-CHARINDEX('|',DR.DRe_IdAlo)) = E.AlE_Cod
	INNER JOIN	BD_Nincoming_HIS.dbo.Tbl_NotificacionSistemaExterno				NSE		ON NSE.NSE_IdDreIdEse = DR.id_DRe		
WHERE
	1 = 1
	AND DR.DRe_CodigoSE = 57
	AND DR.DRe_IdAlo LIKE '%AVT|%'
	AND DR.DRe_codigoExt IN ('C1D4VS~52334668~18167412/S25H')
ORDER BY
	[Fecha Lectura]