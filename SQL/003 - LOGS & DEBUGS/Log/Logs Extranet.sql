USE DW_NIncoming;
DECLARE 
@Fecha_Hoy DATETIME = GETDATE(),
@Fecha_Ayer DATETIME = DATEADD(d,-1,GETDATE()),
@Fecha_Desde DATETIME = '2024-10-28 15:00:00.000',
@Fecha_Hasta DATETIME = '2024-10-28 16:00:00.000'

------ LOGS -------
SELECT 
	id_log					AS [Id Log],
	log_fecha,
	log_server,
	log_tipo				AS [Tipo],
	log_sessionID			AS [Session],
	log_codProveedor		AS [Proveedor],
	log_text				AS [Log Texto],
	log_contador			AS [Contador],
	Key_LogGroup			AS [Key_Group]
FROM Tbl_LogEvento

WHERE
	1 = 1
	--AND id_log = 122281068
	--AND Key_LogGroup = '5893AA94-29BE-4A5A-8FE7-6C3AB73538AC'
	AND log_fecha > @Fecha_Desde
	AND log_fecha < @Fecha_Hasta
	AND log_tipo = 'ErrorWSRul'
	AND log_codProveedor = 'WebService'
ORDER BY
	log_contador DESC