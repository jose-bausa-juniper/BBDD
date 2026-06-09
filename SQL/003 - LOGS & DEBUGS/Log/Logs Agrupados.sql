USE DW_NIncoming;
DECLARE @Fecha_Desde	DATETIME = '2025-06-11 00:00:00.000';
DECLARE @Fecha_Hasta	DATETIME = '2025-06-12 00:00:00.000';
DECLARE @Servers		TABLE (SERVIDOR VARCHAR(100));

INSERT INTO @Servers
VALUES
	(NULL)
	--('BACKOFFICE'),('ESPMIONOWEB100')
	--,('W2MXMLBOOK'),('ESPMIONOWS330'),('ESPMIONOWS331') -- W2MXMLBOOK
	--,('W2MNEXT'),('ESPMIONOWS243') -- W2MNEXT
	,('W2MWEB'),('ESPMIONOWS242'),('ESPMIONOWS341') -- W2MWEB
	--,('W2MWEBB2C'),('ESPMIONOWS244') -- W2MWEBB2C
	--,('W2MXML'),('ESPMIONOWEB100'),('ESPMIONOWS330'),('ESPMIONOWS331'),('ESPMIONOWS243'),('ESPMIONOWS242'),('ESPMIONOWS341'),('ESPMIONOWS244') --W2MXML

SELECT * FROM @Servers
 
------ LOGS -------
SELECT 
	COUNT(id_log)	AS [COUNT],
	CONCAT('https://intranet.ejuniper.com/mantenimientoWeb/logtext.aspx?bdd_nombre=[bd_nincoming.db.jun].BD_NIncoming&bdd_log=[DW_NIncoming.db.jun].DW_NIncoming&idLog=',MAX(id_log))		AS [LAST_LOG],
	MIN(log_fecha)	AS [MIN_FECHA],
	MAX(log_fecha)	AS [MAX_FECHA],
	log_tipo		AS [TIPO]
FROM
	Tbl_LogEvento
WHERE 
	1 = 1
	--AND log_fecha BETWEEN @Fecha_Desde AND @Fecha_Hasta
	AND log_server IN (SELECT * FROM @Servers) -- W2M
GROUP BY
	log_tipo
ORDER BY
	[COUNT] DESC