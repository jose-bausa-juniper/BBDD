USE BD_Nincoming
DECLARE @USERS_LOG_PAG TABLE (ID_AUS_LOG INT, LAST_LOG DATETIME, COUNT_LOGS INT);

INSERT INTO @USERS_LOG_PAG
SELECT DISTINCT(UsrCre), MAX(Feccre), COUNT(Id_Log) FROM Tbl_LogPagina GROUP BY UsrCre

SELECT
	A.Id_Adm				AS [Id_Adm],
	A.Adm_Login				AS [Adm_Login],
	A.Adm_Password			AS [Adm_Password],
	A.Adm_Nombre			AS [Adm_Nombre],
	A.Adm_Activo			AS [Adm_Activo],
	A.fecha_ultimo_login	AS [fecha_ultimo_login],
	MAX(LP.ID_AUS_LOG)		AS [ID_AUS_LOG],
	MAX(LP.LAST_LOG)		AS [LAST_LOG],
	MAX(LP.COUNT_LOGS)		AS [COUNT_LOGS]

FROM
				Tbl_Administrador		A
	INNER JOIN	Tbl_AuditUser			AU	ON	AU.Aus_Name LIKE CONCAT('%',A.Adm_Login)
	LEFT JOIN	@USERS_LOG_PAG			LP	ON	LP.ID_AUS_LOG = AU.Id_Aus
WHERE 
	1 = 1
	AND A.Adm_Activo = 1
	AND A.fecha_ultimo_login > '2025-01-01'
GROUP BY
	A.Id_Adm,
	A.Adm_Login,
	A.Adm_Password,
	A.Adm_Nombre,
	A.Adm_Activo,
	A.fecha_ultimo_login
--HAVING
--	MAX(LP.COUNT_LOGS) IS NULL

