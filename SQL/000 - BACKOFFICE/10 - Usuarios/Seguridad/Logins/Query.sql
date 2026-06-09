USE BD_Nincoming

SELECT
	*
FROM
	Tbl_LogLogins
WHERE
	1 = 1
	--AND Log_Usuario <> '___firma___'
	AND Log_Usuario IN ('___resetClaveAgt___','___resetClaveCli___')
	AND Log_IdUsuario IN (76380,112921,126806)
ORDER BY 1 DESC