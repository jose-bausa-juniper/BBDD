USE DW_NIncoming;
DECLARE @Fecha_Desde	DATETIME = '2026-01-26 00:00:00.000';
DECLARE @Fecha_Hasta	DATETIME = '2026-01-27 00:00:00.000';
DECLARE @Servers		TABLE (SERVIDOR VARCHAR(100));

INSERT INTO @Servers
VALUES
	('ESPMIONOWEB100'), -- W2M
--	('ESPMIONOWS330'),('ESPMIONOWS331'), -- W2MXMLBOOK
--	('ESPMIONOWS243'), -- W2MNEXT
--	('ESPMIONOWS242'),('ESPMIONOWS341'), -- W2MWEB
--	('ESPMIONOWS244'), -- W2MWEBB2C
--	('ESPMIONOWEB100'),('ESPMIONOWS330'),('ESPMIONOWS331'),('ESPMIONOWS243'),('ESPMIONOWS242'),('ESPMIONOWS341'),('ESPMIONOWS244'), --W2MXML
	('')
 
SELECT 
	CONCAT('https://intranet.ejuniper.com/mantenimientoWeb/logtext.aspx?bdd_nombre=[bd_nincoming.db.jun].BD_NIncoming&bdd_log=[DW_NIncoming.db.jun].DW_NIncoming&idLog=',id_log)		AS [URL],
	id_log					AS [ID],
	log_fecha				AS [FECHA],
	log_codProveedor		AS [PROVEEDOR],
	log_sessionID			AS [SESSION],
	log_tipo				AS [TIPO],
	CASE 
		WHEN CHARINDEX('ERROR:', CAST(log_text AS VARCHAR(MAX))) > 0 
			THEN SUBSTRING(
				CAST(log_text AS VARCHAR(MAX)),
				CHARINDEX('ERROR:', CAST(log_text AS VARCHAR(MAX))),
				LEN(CAST(log_text AS VARCHAR(MAX))) - CHARINDEX('ERROR:', CAST(log_text AS VARCHAR(MAX))) + 1
				)
		ELSE NULL
	END						AS [ERROR],
	SUBSTRING(
		CAST(log_text AS VARCHAR(MAX)),
		CHARINDEX('Petición:', CAST(log_text AS VARCHAR(MAX))) + LEN('Petición:'),
		CHARINDEX('IP remota:', CAST(log_text AS VARCHAR(MAX))) - (CHARINDEX('Petición:', CAST(log_text AS VARCHAR(MAX))) + LEN('Petición:'))
	)						AS [ContenidoExtraído],
	log_contador			AS [CONTADOR],  
	log_server				AS [SERVER],
	Key_LogGroup			AS [LOG_GROUP]
FROM Tbl_LogEvento
 
WHERE 
	1 = 1
	AND log_server IN (SELECT * FROM @Servers)
	AND log_fecha BETWEEN @Fecha_Desde AND @Fecha_Hasta
	AND log_tipo = 'Errmsg'
	AND log_codProveedor = 'CORE'
	--AND Key_LogGroup = 'd7794888-09bd-4033-be9a-4d4dc97de62b'
	--AND id_log = 235091232

	--AND log_text  NOT LIKE '%ResMultiReje%'					--1101
	--AND log_text  NOT LIKE '%MailComiAge%'					--383
	--AND log_text  NOT LIKE '%PagMailFormatUsu%'				--351
	--AND log_text  NOT LIKE '%ConCAviso%'						--335
	--AND log_text  NOT LIKE '%CanLinMsg%'						--168

	--AND log_text  NOT LIKE '%QuoMsg%'							--86
	--AND log_text  NOT LIKE '%PReAviso%'						--42
	--AND log_text  NOT LIKE '%MensajeLOE%'						--42
	--AND log_text  NOT LIKE '%PReMailFormatUsu%'				--40
	--AND log_text  NOT LIKE '%CanMailFormatUsu%'				--38
	--AND log_text  NOT LIKE '%detAccountManager%'				--23
	--AND log_text  NOT LIKE '%CanAviso%'						--17
	--AND log_text  NOT LIKE '%NewAgentNotif%'					--13

	--AND log_text  NOT LIKE '%ConMailFormatUsu%'				--8
	--AND log_text  NOT LIKE '%ModAviso%'						--5
	--AND log_text  NOT LIKE '%InfoReserve%'					--3
	--AND log_text  NOT LIKE '%MensajeSTATIONCASINO%'			--2
	--AND log_text  NOT LIKE '%MsgPasaCon%'						--2
	--AND log_text  NOT LIKE '%MensajeHIND%'					--1
	--AND log_text  NOT LIKE '%MsgTarjetaVirtualResponsable%'	--1
	--AND log_text  NOT LIKE '%MensajeCOS%'						--1
	--AND log_text  NOT LIKE '%PagAviso%'						--1
	
	
	
	--AND log_text  NOT LIKE '%http://backdmc.w2m.travel/intranet/PublicAccess/notificationHandler.ashx%'									--1101
	--AND log_text  LIKE '%http://staticjnp.w2m.travel/juniper/Handlers/ImportacionReservas.ashx%'
	--AND log_text  LIKE '%http://staticjnp.w2m.travel/juniper/Handlers/ImportacionReservasGenerico.ashx%'								--1040
	--AND log_text  LIKE '%http://backdmc.w2m.travel/intranet/handlers/CancelarCaducadas/xmlRequest_CancelarCaducadas.aspx%'
	--AND log_text  LIKE '%http://backdmc.w2m.travel/intranet/reserva/cambiarEstado.aspx%'
ORDER BY CONTADOR


            