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