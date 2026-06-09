DECLARE @DESDE			DATETIME = '2025-06-27 00:00:00.000';
DECLARE	@HASTA			DATETIME = '2025-06-28 00:00:00.000';
DECLARE @Servers		TABLE (SERVIDOR VARCHAR(100));

INSERT INTO @Servers
VALUES
	('ESPMIONOWEB100'), -- W2M
	('ESPMIONOWS330'),('ESPMIONOWS331'), -- W2MXMLBOOK
	('ESPMIONOWS243'), -- W2MNEXT
	('ESPMIONOWS242'),('ESPMIONOWS341'), -- W2MWEB
	('ESPMIONOWS244'), -- W2MWEBB2C
	('ESPMIONOWEB100'),('ESPMIONOWS330'),('ESPMIONOWS331'),('ESPMIONOWS243'),('ESPMIONOWS242'),('ESPMIONOWS341'),('ESPMIONOWS244') --W2MXML

------ LOGS -------
SELECT 
	log_server				AS [Server],
	log_tipo				AS [Tipo],
	log_codProveedor		AS [Proveedor],
	id_log					AS [Id Log],
	log_fecha				AS [Fecha],
	Key_LogGroup			AS [Key_Group],
	CONCAT('https://intranet.ejuniper.com/mantenimientoWeb/logtext.aspx?bdd_nombre=[bd_nincoming.db.jun].BD_NIncoming&bdd_log=[DW_NIncoming.db.jun].DW_NIncoming&idLog=',id_log)		AS [LOG],
	CASE 
		WHEN CHARINDEX('ERROR:', CAST(log_text AS VARCHAR(MAX))) > 0 
			THEN SUBSTRING(
				CAST(log_text AS VARCHAR(MAX)),
				CHARINDEX('ERROR:', CAST(log_text AS VARCHAR(MAX))),
				LEN(CAST(log_text AS VARCHAR(MAX))) - CHARINDEX('ERROR:', CAST(log_text AS VARCHAR(MAX))) + 1
				)
		ELSE NULL
	END			AS [ERROR],
	  SUBSTRING(
		CAST(log_text AS VARCHAR(MAX)),
		CHARINDEX('Petición:', CAST(log_text AS VARCHAR(MAX))) + LEN('Petición:'),
		CHARINDEX('IP remota:', CAST(log_text AS VARCHAR(MAX))) - (CHARINDEX('Petición:', CAST(log_text AS VARCHAR(MAX))) + LEN('Petición:'))
	  ) AS ContenidoExtraído,
	  log_contador

FROM Tbl_LogEvento
WHERE
	1 = 1
	AND log_server IN (SELECT * FROM @Servers)
	AND log_tipo = 'GenericErr'
	AND log_codProveedor = 'SupplierPu'	
	AND log_text LIKE '%502%'
ORDER BY
	log_fecha ASC
