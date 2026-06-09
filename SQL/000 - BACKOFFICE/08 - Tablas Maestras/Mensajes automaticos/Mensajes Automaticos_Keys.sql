DECLARE @KEYS TABLE (COD NVARCHAR(200));
INSERT INTO @KEYS
VALUES
('MailComiAge'),
('ResMultiReje'),
('ConCAviso'),
('CanMailFormatUsu'),
('CanLinMsg'),
('detAccountManager'),
('PagMailFormatUsu'),
('QuoMsg'),
('InfoReserve'),
('PReMailFormatUsu'),
('ConMailFormatUsu'),
('PReAviso'),
('MensajeLOE'),
('NewAgentNotif'),
('MensajeSTATIONCASINO'),
('MensajeHIND'),
('ModAviso'),
('MsgTarjetaVirtualResponsable'),
('MensajeCOS'),
('CanAviso'),
('PagAviso'),
('MsgPasaCon')
SELECT
	COD,
	Men_Codigo,
	Men_Asunto_ES,
	Men_Texto_ES
FROM
	@KEYS
	LEFT JOIN Tbl_Mensaje ON Men_Codigo = COD
WHERE
	1 = 1


SELECT
	Men_Codigo,
	Men_Asunto_ES,
	Men_Texto_ES
FROM 
	Tbl_Mensaje
WHERE 
	1 = 1
	AND Men_Codigo IN	('ResMultiReje',
						'MailComiAge',
						'PagMailFormatUsu',
						'ConCAviso',
						'CanLinMsg')
	AND Men_Asunto_ES IS NOT NULL
	AND Men_Texto_ES IS NOT NULL
	AND Men_Asunto_ES <> ''
	AND Men_Texto_ES <> ''