DECLARE 
@YEAR INT = YEAR(GETDATE()-365),
@BBDD INT = 107
SELECT 
W.Fecmod,
	W.id_WEB,
	W.id_Can,
	W.web_Tipo,
	W.web_proyectogit,
	W.web_urlproyectogit,
	W.WEB_ultimaPreCompilacion,
	W.WEB_ultimaCopiaAPrecompilacion,
	W.Web_OrigenDLLS,
	W.WEB_url,
	W.Web_Pool,
	W.Web_UrlPre,
	W.Web_PoolPre,
	W.Web_UrlTest,
	W.Web_PoolTest,
	W.web_urldesa,
	W.Web_PoolDesa,*

FROM 
			BD_BookingEngine.dbo.Tbl_Web		W
WHERE
	1 = 1
	AND	W.id_BDD = @BBDD
	AND web_actconfig = 1

--WHEN 'HER' THEN 'HERRAMIENTAS'
--WHEN 'WS'  THEN 'WEBSERVICE'
--WHEN 'EXT' THEN 'EXTRANET'
--WHEN 'WWW' THEN 'WEB'
--WHEN 'WSI' THEN 'WEBSERVICE INTRANET'
--WHEN 'INT' THEN 'INTRANET'
--WHEN 2009 THEN 'PRO2NEXT'
--WHEN 1920 THEN 'FLOWO'
--WHEN 1278 THEN 'DMC/PRO'
