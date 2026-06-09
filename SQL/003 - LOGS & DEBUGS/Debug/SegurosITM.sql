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
	log_text [Debug Texto],
	*

FROM Tbl_LogDebug

WHERE 1 = 1
	AND log_fecha < @Fecha_Hoy 
	AND log_fecha > @Fecha_AntesDeAyer
	AND log_codProveedor IN ('ThrErrores','Servicios')
	AND log_tipo IN ('ErrorGrave','MultiPowerSearch')
	AND (log_text LIKE '%b2dmc-w2m.juniper.es%')
	AND id_log IN (80448,80452)

