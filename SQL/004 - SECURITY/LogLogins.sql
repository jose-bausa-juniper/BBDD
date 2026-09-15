USE BD_TestSuppliers
SELECT * FROM TBL_Parametro WHERE Par_Codigo LIKE '%Seguridad/ValidacionMFASegura%'


SELECT
	TOP 1000 
	* 
FROM 
				Tbl_LogLogins		LL
	LEFT JOIN	Tbl_LogLoginsAviso	LLA	ON LLA.Id_Log = LL.id_log
WHERE 
	1 = 1
	AND LL.Feccre > '2025-05-06'
	AND LL.Log_Usuario = 'AdminJoseBausa'



WITH LAST_LOG_APP AS (
	SELECT 
		DISTINCT(Log_Aplicativo) AS APP,
		Log_Tipo,
		Log_Usuario,
		Log_IdUsuario,
		MAX(id_log) AS ID_LOG1
	FROM 
		TBL_logLogins
	WHERE 
		1 = 1
		AND Log_Tipo <> 'WSA' 
		AND Log_Aplicativo IN ('JPD','EXP') 
	GROUP BY
		Log_Aplicativo,
		Log_Tipo,
		Log_Usuario,
		Log_IdUsuario
),
LAST_LOG_APP_HIS AS (
	SELECT 
		DISTINCT(Log_Aplicativo) AS APP,
		Log_Tipo,
		Log_Usuario,
		Log_IdUsuario,
		MAX(id_log) AS ID_LOG1
	FROM 
		BD_HIS.BD_Nincoming.Tbl_LogLogins	
	WHERE 
		1 = 1
		--AND Log_Tipo <> 'WSA' 
		--AND Log_Aplicativo IN ('JPD','EXP', NULL) 
		AND Feccre >= '2026-07-01'
	GROUP BY
		Log_Aplicativo,
		Log_Tipo,
		Log_Usuario,
		Log_IdUsuario
),

LOGS AS (

    SELECT LLA.*
	FROM LAST_LOG_APP LLA 
    LEFT JOIN Tbl_LogLogins LL ON LL.ID_LOG = LLA.ID_LOG1
)

SELECT * FROM LOGS