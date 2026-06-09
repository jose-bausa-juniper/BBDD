USE DW_NIncoming;
DECLARE 
@Fecha_Hoy DATETIME = GETDATE(),
@Fecha_AntesDeAyer DATETIME = DATEADD(d,-1,GETDATE())

------ LOGS -------
SELECT 
	-- @Fecha_Hoy AS [Fecha Hasta],
	-- @Fecha_AntesDeAyer AS [Fecha Desde],
	id_log,
	log_fecha,
	log_server,
	log_text AS [Log Texto]
FROM Tbl_LogEvento

WHERE 1 = 1
	AND log_fecha < @Fecha_Hoy 
	AND log_fecha > @Fecha_AntesDeAyer
	AND log_codProveedor = 'PaginaErro'
	AND log_tipo = 'ErrorHerra'
	AND (log_text LIKE '%tipo=PEAKWORK%')

ORDER BY
	log_fecha ASC 
