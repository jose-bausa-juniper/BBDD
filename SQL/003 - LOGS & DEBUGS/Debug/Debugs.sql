USE DW_NIncoming;
DECLARE 
@Fecha_Hoy DATETIME = GETDATE(),
@Fecha_AntesDeAyer DATETIME = DATEADD(d,-2,GETDATE())

------ DEBUGS -------
SELECT
	@Fecha_Hoy AS [Fecha Hasta],
	@Fecha_AntesDeAyer AS [Fecha Desde],
	id_log,
	log_fecha,
	log_server,
	CAST(DECOMPRESS(log_bin) AS VARCHAR(MAX)) AS [Debug Texto]

FROM Tbl_LogDebug

WHERE 1 = 1
	AND log_fecha < @Fecha_Hoy 
	AND log_fecha > @Fecha_AntesDeAyer
	AND log_codProveedor = 'General'
	AND log_tipo = 'DebugAvanzado'
	AND (log_server = 'ESPMIONOWS162' OR log_server ='ESPMIONOWS163')
	AND (CAST(DECOMPRESS(log_bin) AS VARCHAR(MAX)) LIKE '%JSON TO WS%' OR CAST(DECOMPRESS(log_bin) AS VARCHAR(MAX)) LIKE '%WS RESPONSE%')

ORDER BY 
	log_fecha ASC