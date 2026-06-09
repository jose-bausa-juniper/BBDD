USE DW_NIncoming;
DECLARE 
	@Fecha_Hoy 			DATETIME = GETDATE(),
	@Fecha_AntesDeAyer 	DATETIME = DATEADD(d,-1,GETDATE())

------ DEBUGS -------

SELECT
    log_tipo 									AS [Tipo],
	CAST(DECOMPRESS(log_bin) AS VARCHAR(MAX)) 	AS [Debug Texto],
	MAX (log_fecha)  							AS [Primera vez],
	MAX (id_log) 								AS [Ultimo Log],
    COUNT(*) 									AS [Num errores]
FROM 
	Tbl_LogDebug
WHERE 1 = 1
	AND log_fecha < @Fecha_Hoy 
	AND log_fecha > @Fecha_AntesDeAyer
	AND log_tipo = 'Export EDF'
GROUP BY    
    log_tipo,
    log_bin
ORDER BY 
	log_bin ASC
